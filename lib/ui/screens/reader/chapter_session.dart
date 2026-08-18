import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/app_scope.dart';
import '../../../data/models/models.dart';
import '../../../data/sources/demo_source.dart';
import '../../../data/sources/local_source.dart';
import '../../../data/sources/source.dart';
import '../../../data/services/download_service.dart';

/// One chapter's reading session: page list + bytes resolution with
/// download-first fallback to network/demo/local generators.
class ChapterSession extends ChangeNotifier {
  ChapterSession({required this.manga, required this.chapter}) {
    source = appScope?.sources.byId(manga.sourceId);
  }

  AppServices? appScope;
  final Manga manga;
  final Chapter chapter;
  Source? source;

  List<SourcePage> pages = const [];
  bool loading = false;
  String? error;
  bool _pagesFromDisk = false;
  List<String> _diskFiles = const [];

  int get total => pages.length;
  bool get isLoaded => pages.isNotEmpty || error != null;

  Future<void> load() async {
    if (loading || isLoaded) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      // downloaded → pages from disk, no network
      final disk = await appScope?.downloads.existingChapterDir(manga, chapter);
      if (disk != null) {
        _diskFiles = await DownloadService.pageFiles(disk);
        pages = [for (var i = 0; i < _diskFiles.length; i++) SourcePage(index: i, url: 'file://${_diskFiles[i]}', fileName: _diskFiles[i])];
        _pagesFromDisk = true;
      } else {
        final src = source ?? appScope?.sources.byId(manga.sourceId);
        if (src == null) throw SourceException('Unknown source ${manga.sourceId}');
        final fetched = await src.getPages(manga.remoteId, chapter.url);
        if (fetched.isEmpty) throw SourceException('This chapter has no pages');
        pages = fetched;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  String? fileOf(int index) => _pagesFromDisk ? _diskFiles[index] : null;

  /// Bytes for a page; resolves demo:// and local:// generators too.
  Future<Uint8List?> bytesOf(int index) async {
    if (index < 0 || index >= pages.length) return null;
    final url = pages[index].url;
    if (url.startsWith('file://')) {
      final f = File(url.substring('file://'.length));
      return f.existsSync() ? f.readAsBytes() : null;
    }
    if (url.startsWith('demo://')) {
      final path = await DemoSource.instance.resolveAsset(url);
      return path == null ? null : File(path).readAsBytes();
    }
    if (url.startsWith('local://')) {
      final resolved = await LocalSource.resolve(url);
      if (resolved?.bytes != null) return resolved!.bytes;
      if (resolved?.path != null) return File(resolved!.path!).readAsBytes();
      return null;
    }
    try {
      final resp = await _dio.get<List<int>>(url, options: Options(responseType: ResponseType.bytes));
      final bytes = resp.data;
      return bytes == null ? null : Uint8List.fromList(bytes);
    } catch (_) {
      return null;
    }
  }

  /// Width/height guess for aspect-ratio placeholders before decode.
  static const double placeholderAspect = 0.68;


  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 60),
    headers: {'User-Agent': 'Comicko/0.1'},
  ));
}

extension ChapterSessionApp on ChapterSession {
  void attach(AppServices scope) => appScope = scope;
}
