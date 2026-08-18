import 'dart:convert';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart' show ValueNotifier;
import '../../core/data/settings_service.dart';
import '../db/repositories.dart';
import '../models/models.dart';

/// JSON backup / restore of library, categories, history, tracks, settings.
/// Format version 1 — mirrors the "Create backups" feature.
class BackupService {
  BackupService(this.repos, this.settings);

  final Repositories repos;
  final SettingsService settings;

  final busy = ValueNotifier<bool>(false);
  final message = ValueNotifier<String?>(null);

  Future<Map<String, dynamic>> buildBackup() async {
    final mangas = await repos.allMangas();
    final categories = await repos.allCategories();
    final history = await repos.recentHistory(limit: 5000);

    final mangaById = {for (final m in mangas) m.id!: m};
    final mangaCats = <Map<String, dynamic>>[];
    for (final m in mangas) {
      final cats = await repos.categoriesOfManga(m.id!);
      for (final c in cats) {
        mangaCats.add({'mangaKey': m.key, 'category': c.name});
      }
    }
    final tracks = <Map<String, dynamic>>[];
    for (final m in mangas) {
      final ts = await repos.tracksForManga(m.id!);
      for (final t in ts) {
        final j = t.toBackupJson();
        j['mangaKey'] = m.key;
        tracks.add(j);
      }
    }
    final chapters = <Map<String, dynamic>>[];
    final chapterById = <int, Chapter>{};
    for (final m in mangas) {
      final chs = await repos.chaptersOfManga(m.id!);
      for (final c in chs) {
        chapterById[c.id!] = c;
        final j = c.toBackupJson();
        j['mangaKey'] = m.key;
        chapters.add(j);
      }
    }
    _chapterById = chapterById;

    return {
      'app': 'comicko',
      'format': 1,
      'createdAt': DateTime.now().toIso8601String(),
      'settings': settings.snapshot(),
      'manga': mangas.map((m) => m.toBackupJson()).toList(),
      'chapters': chapters,
      'categories': categories.map((c) => c.toBackupJson()).toList(),
      'mangaCategory': mangaCats,
      'history': history.map((h) {
        final m = mangaById[h.mangaId];
        final ch = _chapterById[h.chapterId];
        return {
          'mangaKey': m?.key,
          'chapterUrl': ch?.url,
          'page': h.page,
          'percent': h.percent,
          'readAt': h.readAt.toIso8601String(),
        };
      }).toList(),
      'tracks': tracks,
    };
  }

  Map<int, Chapter> _chapterById = {};

  Future<void> exportToFile() async {
    busy.value = true;
    try {
      final data = await buildBackup();
      final json = const JsonEncoder.withIndent('  ').convert(data);
      final name = 'comicko_backup_${DateTime.now().toIso8601String().split('T').first}.json';
      final path = await getSaveLocation(
        suggestedName: name,
        acceptedTypeGroups: const [XTypeGroup(label: 'Comicko backup', extensions: ['json'])],
      );
      if (path != null) {
        final bytes = utf8.encode(json);
        await XFile.fromData(bytes, name: name, mimeType: 'application/json').saveTo(path.path);
        message.value = 'Backup saved';
      }
    } finally {
      busy.value = false;
    }
  }

  Future<ImportResult> importFromFile() async {
    busy.value = true;
    try {
      final files = await openFiles(acceptedTypeGroups: const [XTypeGroup(label: 'Comicko backup', extensions: ['json'])]);
      if (files.isEmpty) return const ImportResult(0, 0);
      final bytes = await files.first.readAsBytes();
      final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      if (json['app'] != 'comicko') {
        message.value = 'Not a Comicko backup';
        return const ImportResult(0, 0);
      }
      return await restore(json);
    } finally {
      busy.value = false;
    }
  }

  /// Restore, merging by manga key. Returns (imported, skipped).
  Future<ImportResult> restore(Map<String, dynamic> json) async {
    var imported = 0, skipped = 0;

    // settings (only safe keys)
    final settingsJson = json['settings'];
    if (settingsJson is Map<String, dynamic>) {
      await settings.restore(settingsJson.cast<String, dynamic>());
    }

    // categories
    final catNames = <String, Category>{};
    final cats = json['categories'] as List? ?? const [];
    for (final cj in cats.cast<Map<String, dynamic>>()) {
      final name = cj['name'] as String;
      var cat = await repos.categoryByName(name);
      cat ??= await repos.createCategory(name, hidden: cj['hidden'] as bool? ?? false);
      catNames[name] = cat;
    }

    // manga
    final mangaJson = json['manga'] as List? ?? const [];
    final keyToId = <String, int>{};
    for (final mj in mangaJson.cast<Map<String, dynamic>>()) {
      final m = Manga.fromBackupJson(mj);
      final existing = await repos.mangaByKey(m.sourceId, m.remoteId);
      if (existing != null && existing.initialized) {
        skipped++;
        keyToId[existing.key] = existing.id!;
        continue;
      }
      final stored = await repos.addToLibrary(m);
      keyToId[stored.key] = stored.id!;
      imported++;
    }

    // chapters
    final chJson = json['chapters'] as List? ?? const [];
    for (final cj in chJson.cast<Map<String, dynamic>>()) {
      final mangaKey = cj['mangaKey'] as String?;
      final mid = keyToId[mangaKey];
      if (mid == null) continue;
      final ch = Chapter(
        mangaId: mid,
        url: cj['url'] as String,
        name: cj['name'] as String,
        scanlator: cj['scanlator'] as String?,
        dateUpload: DateTime.tryParse(cj['dateUpload'] as String? ?? ''),
        number: (cj['number'] as num?)?.toDouble() ?? 0,
        read: cj['read'] as bool? ?? false,
        bookmark: cj['bookmark'] as bool? ?? false,
        lastPageRead: cj['lastPageRead'] as int? ?? 0,
        lastReadAt: DateTime.tryParse(cj['lastReadAt'] as String? ?? ''),
        fetched: cj['fetched'] as bool? ?? false,
      );
      await repos.upsertChapter(ch);
    }

    // categories per manga
    final mcJson = json['mangaCategory'] as List? ?? const [];
    for (final mc in mcJson.cast<Map<String, dynamic>>()) {
      final mid = keyToId[mc['mangaKey'] as String?];
      final cat = catNames[mc['category'] as String?];
      if (mid == null || cat?.id == null) continue;
      await repos.setMangaCategories(mid, [...(await repos.categoriesOfManga(mid)).map((c) => c.id!), cat!.id!]);
    }

    // history
    final histJson = json['history'] as List? ?? const [];
    for (final hj in histJson.cast<Map<String, dynamic>>()) {
      final mid = keyToId[hj['mangaKey'] as String?];
      if (mid == null) continue;
      final chs = await repos.chaptersOfManga(mid);
      final ch = chs.where((c) => c.url == hj['chapterUrl']).firstOrNull;
      if (ch?.id == null) continue;
      await repos.recordHistory(mid, ch!.id!, hj['page'] as int? ?? 0, (hj['percent'] as num?)?.toDouble() ?? 0);
    }

    // tracks
    final trackJson = json['tracks'] as List? ?? const [];
    for (final tj in trackJson.cast<Map<String, dynamic>>()) {
      final mid = keyToId[tj['mangaKey']];
      if (mid == null) continue;
      await repos.upsertTrack(Track(
        mangaId: mid,
        trackerId: tj['trackerId'] as String,
        remoteId: tj['remoteId'] as String?,
        title: tj['title'] as String?,
        status: tj['status'] as String?,
        score: (tj['score'] as num?)?.toDouble() ?? 0,
        lastChapterRead: (tj['lastChapterRead'] as num?)?.toDouble() ?? 0,
        totalChapters: tj['totalChapters'] as int? ?? 0,
        trackedAt: DateTime.tryParse(tj['trackedAt'] as String? ?? ''),
      ));
    }

    return ImportResult(imported, skipped);
  }
}

class ImportResult {
  const ImportResult(this.imported, this.skipped);
  final int imported;
  final int skipped;
}
