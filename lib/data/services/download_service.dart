import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../db/repositories.dart';
import '../models/models.dart';
import '../sources/demo_source.dart';
import '../sources/local_source.dart';
import '../sources/source.dart';

enum DownloadStatus { queued, running, done, failed, paused }

class DownloadJob {
  const DownloadJob({
    required this.manga,
    required this.chapter,
    this.status = DownloadStatus.queued,
    this.progress = 0,
    this.total = 0,
    this.error,
    this.startTime,
    this.endTime,
  });

  final Manga manga;
  final Chapter chapter;
  final DownloadStatus status;
  final double progress; // bytes
  final double total;
  final String? error;
  final DateTime? startTime;
  final DateTime? endTime;

  double get fraction => total <= 0 ? 0 : (progress / total).clamp(0.0, 1.0);
  bool get isActive => status == DownloadStatus.queued || status == DownloadStatus.running;

  DownloadJob copyWith({DownloadStatus? status, double? progress, double? total, String? error, DateTime? startTime, DateTime? endTime}) =>
      DownloadJob(manga: manga, chapter: chapter, status: status ?? this.status, progress: progress ?? this.progress, total: total ?? this.total, error: error ?? this.error, startTime: startTime ?? this.startTime, endTime: endTime ?? this.endTime);
}

/// Queue-based downloader. Pages land in
/// {support}/downloads/{mangaKey}/{chapterUrl}/page_001.jpg.
class DownloadService {
  DownloadService(this.repos, this.sources);

  final Repositories repos;
  final SourceManager sources;

  final _jobs = ValueNotifier<List<DownloadJob>>(const []);
  ValueNotifier<List<DownloadJob>> get jobs => _jobs;

  final Map<String, CancelToken> _cancels = {};
  bool _running = false;

  Future<Directory> downloadsRoot() async {
    Directory base;
    try {
      base = await getApplicationSupportDirectory();
    } catch (_) {
      base = Directory.systemTemp; // tests / no platform channel
    }
    final dir = Directory('${base.path}/downloads');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  String _chapterDirName(Manga manga, Chapter chapter) =>
      '${manga.sourceId}_${_sanitize(manga.remoteId)}/${_sanitize(chapter.url)}';

  static String _sanitize(String s) => s.replaceAll(RegExp(r'[^\w\-.]'), '_');

  Future<Directory> chapterDir(Manga manga, Chapter chapter) async {
    final root = await downloadsRoot();
    final dir = Directory(p.join(root.path, _chapterDirName(manga, chapter)));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  /// Where the chapter's pages live on disk (null if not downloaded).
  Future<Directory?> existingChapterDir(Manga manga, Chapter chapter) async {
    final root = await downloadsRoot();
    final dir = Directory(p.join(root.path, _chapterDirName(manga, chapter)));
    if (!dir.existsSync()) return null;
    final files = dir.listSync().whereType<File>().where((f) => _isImage(f.path)).toList();
    return files.isEmpty ? null : dir;
  }

  static bool _isImage(String path) =>
      const {'.jpg', '.jpeg', '.png', '.webp', '.gif'}.contains(p.extension(path).toLowerCase());

  /// Page files on disk sorted by name (reader fallback order).
  static Future<List<String>> pageFiles(Directory dir) async {
    final files = dir.listSync().whereType<File>().where((f) => _isImage(f.path)).toList()
      ..sort((a, b) => _naturalCompare(a.path, b.path));
    return files.map((f) => f.path).toList();
  }

  static int _naturalCompare(String a, String b) {
    final ra = RegExp(r'\d+|\D+');
    final pa = ra.allMatches(a).map((m) => m.group(0)!).toList();
    final pb = ra.allMatches(b).map((m) => m.group(0)!).toList();
    final n = pa.length < pb.length ? pa.length : pb.length;
    for (int i = 0; i < n; i++) {
      final xa = int.tryParse(pa[i]);
      final xb = int.tryParse(pb[i]);
      if (xa != null && xb != null) {
        if (xa != xb) return xa - xb;
      } else if (pa[i] != pb[i]) {
        return pa[i].compareTo(pb[i]);
      }
    }
    return pa.length - pb.length;
  }

  Future<void> enqueue(Manga manga, Chapter chapter) async {
    if (_jobs.value.any((j) => j.chapter.id == chapter.id && j.isActive)) return;
    _jobs.value = [..._jobs.value, DownloadJob(manga: manga, chapter: chapter)];
    _pump();
  }

  Future<void> enqueueAll(Manga manga, List<Chapter> chapters) async {
    for (final c in chapters) {
      if (_jobs.value.any((j) => j.chapter.id == c.id && j.isActive)) continue;
      _jobs.value = [..._jobs.value, DownloadJob(manga: manga, chapter: c)];
    }
    _pump();
  }

  Future<void> cancel(Chapter chapter) async {
    _cancels.remove(chapter.id.toString())?.cancel();
    _jobs.value = _jobs.value.map((j) {
      if (j.chapter.id == chapter.id && j.isActive) {
        // partially downloaded pages stay; chapter stays not-downloaded
        return j.copyWith(status: DownloadStatus.failed, error: 'cancelled');
      }
      return j;
    }).toList();
  }

  Future<void> removeDownload(Manga manga, Chapter chapter) async {
    try {
      final root = await downloadsRoot();
      final dir = Directory(p.join(root.path, _chapterDirName(manga, chapter)));
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    } catch (_) {}
    await repos.updateChapter(chapter.copyWith(downloaded: false, downloadPath: null));
  }

  Future<void> clearAllDownloads() async {
    final root = await downloadsRoot();
    if (root.existsSync()) {
      for (final e in root.listSync()) {
        if (e is Directory) e.deleteSync(recursive: true);
      }
    }
    final chapters = await repos.allMangas().then((ms) async {
      final out = <Chapter>[];
      for (final m in ms) {
        out.addAll((await repos.chaptersOfManga(m.id!)).where((c) => c.downloaded));
      }
      return out;
    });
    for (final c in chapters) {
      await repos.updateChapter(c.copyWith(downloaded: false, downloadPath: null));
    }
  }

  void _pump() {
    if (_running) return;
    _running = true;
    unawaited(_worker());
  }

  Future<void> _worker() async {
    while (true) {
      final next = _jobs.value.where((j) => j.status == DownloadStatus.queued).firstOrNull;
      if (next == null) break;
      await _downloadOne(next);
    }
    _running = false;
  }

  Future<void> _downloadOne(DownloadJob job) async {
    final source = sources.byId(job.manga.sourceId);
    if (source == null) {
      _fail(job, 'Unknown source');
      return;
    }
    _set(job.copyWith(status: DownloadStatus.running, startTime: DateTime.now()));
    try {
      final pages = await source.getPages(job.manga.remoteId, job.chapter.url);
      final dir = await chapterDir(job.manga, job.chapter);
      final cancel = CancelToken();
      _cancels[job.chapter.id.toString()] = cancel;

      var completed = 0;
      final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 20), receiveTimeout: const Duration(seconds: 60)));

      Future<void> fetchOne(SourcePage page) async {
        if (cancel.isCancelled) return;
        final fname = page.fileName ?? 'page_${(page.index + 1).toString().padLeft(3, '0')}.jpg';
        final dest = File(p.join(dir.path, fname));
        if (dest.existsSync() && dest.lengthSync() > 0) {
          completed++;
          _set(job.copyWith(progress: completed.toDouble(), total: pages.length.toDouble()));
          return;
        }
        if (page.url.startsWith('demo://')) {
          final path = await (source as DemoSource).resolveAsset(page.url);
          if (path != null) {
            File(path).copySync(dest.path);
          }
        } else if (page.url.startsWith('local://')) {
          final resolved = await LocalSource.resolve(page.url);
          if (resolved?.bytes != null) {
            dest.writeAsBytesSync(resolved!.bytes!);
          } else if (resolved?.path != null) {
            File(resolved!.path!).copySync(dest.path);
          }
        } else {
          await dio.download(page.url, dest.path, cancelToken: cancel);
        }
        completed++;
        _set(job.copyWith(progress: completed.toDouble(), total: pages.length.toDouble()));
      }

      // limited concurrency
      final semaphore = Semaphore(2);
      await Future.wait(pages.map((page) async {
        await semaphore.acquire();
        try {
          await fetchOne(page);
        } finally {
          semaphore.release();
        }
      }));

      if (cancel.isCancelled) {
        _set(job.copyWith(status: DownloadStatus.failed, error: 'cancelled'));
        return;
      }
      _cancels.remove(job.chapter.id.toString());

      // mark downloaded
      final updated = await repos.upsertChapter(job.chapter.copyWith(downloaded: true, downloadPath: dir.path, fetched: true));
      _set(job.copyWith(status: DownloadStatus.done, progress: pages.length.toDouble(), total: pages.length.toDouble(), endTime: DateTime.now()));
      // refresh unread counts unaffected; manga counts unchanged
      await repos.updateChapter(updated);
      // toast handled by UI layer
    } catch (e) {
      _set(job.copyWith(status: DownloadStatus.failed, error: e.toString()));
    }
  }

  void _set(DownloadJob job) {
    _jobs.value = [for (final j in _jobs.value) j.chapter.id == job.chapter.id ? job : j];
  }

  void _fail(DownloadJob job, String reason) {
    _set(job.copyWith(status: DownloadStatus.failed, error: reason));
  }

  /// Remove finished/failed jobs (keep running).
  void clearFinished() {
    _jobs.value = _jobs.value.where((j) => j.isActive).toList();
  }

  int get activeCount => _jobs.value.where((j) => j.isActive).length;
}

/// Tiny async semaphore for bounded download concurrency.
class Semaphore {
  Semaphore(this.max);
  final int max;
  int _taken = 0;
  final _waiters = <Completer<void>>[];

  Future<void> acquire() {
    if (_taken < max) {
      _taken++;
      return Future.value();
    }
    final c = Completer<void>();
    _waiters.add(c);
    return c.future;
  }

  void release() {
    if (_waiters.isNotEmpty) {
      _waiters.removeAt(0).complete();
    } else {
      _taken--;
    }
  }
}
