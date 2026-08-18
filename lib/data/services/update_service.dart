import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/data/settings_service.dart';
import '../db/repositories.dart';
import '../models/models.dart';
import '../sources/source.dart';
import 'library_service.dart';

/// Scheduled library update check (Komikku: "Schedule updating your library
/// for new chapters"). Polls sources for new chapters; groups results by
/// manga (J2K-style grouped update list) and records failures.
class UpdateService {
  UpdateService(this.repos, this.sources, this.settings, this.library);

  final Repositories repos;
  final SourceManager sources;
  final SettingsService settings;
  final LibraryService library;

  final updates = ValueNotifier<List<MangaUpdate>>(const []);
  final isChecking = ValueNotifier<bool>(false);
  final lastError = ValueNotifier<String?>(null);

  Timer? _timer;
  Timer? _bootTimer;

  /// Start the periodic scheduler (call once at boot).
  void start() {
    _timer?.cancel();
    _bootTimer?.cancel();
    final hours = settings.updateIntervalHours;
    if (hours <= 0) return;
    _timer = Timer.periodic(Duration(hours: hours), (_) => unawaited(checkAll()));
    // quick check shortly after boot (if stale)
    final last = settings.lastUpdateRun;
    if (last == null || DateTime.now().difference(last) > Duration(hours: hours)) {
      _bootTimer = Timer(const Duration(seconds: 12), () => unawaited(checkAll()));
    }
  }

  void stop() {
    _timer?.cancel();
    _bootTimer?.cancel();
    _timer = null;
    _bootTimer = null;
  }

  /// Check every library manga for new chapters.
  Future<CheckResult> checkAll({bool silent = false}) async {
    if (isChecking.value) return const CheckResult(0, 0);
    isChecking.value = true;
    lastError.value = null;
    final mangas = await repos.allMangas(onlyFavorites: true);
    var newChapters = 0;
    final failures = <String>[];

    library.syncState.value = SyncState(current: 0, total: mangas.length, label: 'Checking library');
    var i = 0;
    for (final m in mangas) {
      i++;
      library.syncState.value = SyncState(current: i, total: mangas.length, label: m.title);
      try {
        final source = sources.byId(m.sourceId);
        if (source == null) continue;
        if (m.sourceId == 'local' || m.sourceId == 'demo') continue; // offline sources
        final existing = await repos.chaptersOfManga(m.id!);
        final existingUrls = existing.map((c) => c.url).toSet();
        final remote = await source.getChapters(m.remoteId);
        final fresh = remote.where((c) => !existingUrls.contains(c.url)).toList();
        if (fresh.isNotEmpty) {
          final before = existing.length;
          final after = await library.fetchChaptersInto(m, source);
          newChapters += after.length - before;
        }
      } catch (e) {
        failures.add(m.title);
      }
    }
    library.syncState.value = null;
    isChecking.value = false;
    settings.lastUpdateRun = DateTime.now();

    if (newChapters > 0) {
      await rebuildUpdateList();
    }
    if (failures.isNotEmpty && !silent) {
      lastError.value = '${failures.length} entries failed to update';
    }
    return CheckResult(mangas.length, newChapters);
  }

  /// Group the latest chapter additions by manga, for the Updates tab.
  Future<void> rebuildUpdateList() async {
    final mangas = await repos.allMangas(onlyFavorites: true);
    final out = <MangaUpdate>[];
    for (final m in mangas) {
      final chapters = await repos.chaptersOfManga(m.id!);
      final unread = chapters.where((c) => !c.read).toList();
      if (unread.isEmpty) continue;
      final newest = unread.reduce((a, b) {
        final da = a.dateUpload ?? DateTime.fromMillisecondsSinceEpoch(0);
        final db = b.dateUpload ?? DateTime.fromMillisecondsSinceEpoch(0);
        return da.isAfter(db) ? a : b;
      });
      out.add(MangaUpdate(manga: m, unreadCount: unread.length, newestChapter: newest));
    }
    out.sort((a, b) {
      final da = a.newestChapter.dateUpload ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db = b.newestChapter.dateUpload ?? DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });
    updates.value = out;
  }
}

class CheckResult {
  const CheckResult(this.mangasChecked, this.newChapters);
  final int mangasChecked;
  final int newChapters;
}

class MangaUpdate {
  const MangaUpdate({required this.manga, required this.unreadCount, required this.newestChapter});
  final Manga manga;
  final int unreadCount;
  final Chapter newestChapter;
}

/// Trending helper for the Updates tab header.
class UpdateStats {
  const UpdateStats({required this.totalUnread, required this.totalManga});
  final int totalUnread;
  final int totalManga;

  factory UpdateStats.fromUpdates(List<MangaUpdate> list) =>
      UpdateStats(totalUnread: list.fold(0, (a, b) => a + b.unreadCount), totalManga: list.length);

  static String humanCount(int n) {
    if (n >= 1000) {
      final k = n / 1000;
      return '${k.toStringAsFixed(k >= 10 ? 0 : 1)}k';
    }
    return '$n';
  }

}
