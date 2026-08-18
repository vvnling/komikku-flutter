import 'dart:async';
import 'package:flutter/foundation.dart';
import '../db/repositories.dart';
import '../models/models.dart';
import '../sources/local_source.dart';
import '../sources/source.dart';

/// Orchestrates the library: adding entries from sources, syncing chapters,
/// counts, local-source scanning.
class LibraryService {
  LibraryService(this.repos, this.sources);

  final Repositories repos;
  final SourceManager sources;

  final _libraryVersion = ValueNotifier<int>(0);
  /// Bump to tell library screens to refetch.
  ValueNotifier<int> get libraryVersion => _libraryVersion;

  /// In-progress sync signal (Komikku progress banner).
  final syncState = ValueNotifier<SyncState?>(null);

  Future<Manga> addToLibrary(SourceManga sm, {List<String>? categories}) async {
    final existing = await repos.mangaByKey(sm.sourceId, sm.remoteId);
    final now = DateTime.now();
    final manga = Manga(
      sourceId: sm.sourceId,
      remoteId: sm.remoteId,
      title: sm.title,
      author: sm.author,
      description: sm.description,
      tags: sm.tags,
      status: sm.status,
      coverUrl: sm.coverUrl,
      favorite: true,
      dateAdded: existing?.dateAdded ?? now,
      lastUpdate: existing?.lastUpdate,
      totalChapters: existing?.totalChapters ?? 0,
      unread: existing?.unread ?? 0,
      extra: sm.extra,
    );
    await repos.addToLibrary(manga, categoryNames: categories);
    _bump();
    return (await repos.mangaByKey(sm.sourceId, sm.remoteId))!;
  }

  /// Fetch full metadata + chapters from the source, upsert into DB.
  /// Returns the stored manga.
  Future<Manga> refreshManga(Manga m, {bool fetchChapters = true}) async {
    final source = sources.byId(m.sourceId);
    if (source == null) return m;
    SourceManga detail;
    try {
      detail = await source.getMangaDetail(m.remoteId);
    } catch (e) {
      detail = SourceManga(sourceId: m.sourceId, remoteId: m.remoteId, title: m.title, coverUrl: m.coverUrl);
    }
    final merged = m.copyWith(
      title: detail.title.isEmpty ? m.title : detail.title,
      author: detail.author ?? m.author,
      description: detail.description ?? m.description,
      tags: detail.tags.isNotEmpty ? detail.tags : m.tags,
      status: detail.status ?? m.status,
      coverUrl: detail.coverUrl ?? m.coverUrl,
      initialized: true,
      extra: detail.extra ?? m.extra,
    );
    await repos.updateManga(merged);
    final stored = (await repos.mangaByKey(m.sourceId, m.remoteId))!;

    if (fetchChapters && source.id == 'local') {
      // local chapters need the root path (stored in extra)
      if (stored.extra?['root'] != null) {
        (source as LocalSource).attachRoot(stored.extra!['root']!);
      }
    }
    if (fetchChapters) {
      final chapters = await fetchChaptersInto(stored, source);
      final readCount = chapters.where((c) => c.read).length;
      await repos.updateManga(stored.copyWith(
        totalChapters: chapters.length,
        unread: chapters.length - readCount,
        lastUpdate: chapters.isNotEmpty ? chapters.map((c) => c.dateUpload).whereType<DateTime>().fold<DateTime?>(null, (a, b) => a == null || b.isAfter(a) ? b : a) : stored.lastUpdate,
      ));
    }
    _bump();
    return (await repos.mangaByKey(m.sourceId, m.remoteId))!;
  }

  /// Pull chapter list from source and insert new ones (marking read state
  /// preserved). Returns all chapters.
  Future<List<Chapter>> fetchChaptersInto(Manga m, Source source) async {
    final existing = await repos.chaptersOfManga(m.id!);
    final existingByUrl = {for (final c in existing) c.url: c};
    final fetched = await source.getChapters(m.remoteId);
    final newChapters = <Chapter>[];
    for (final sc in fetched) {
      final prev = existingByUrl[sc.url];
      if (prev == null) {
        final ch = await repos.upsertChapter(Chapter(
          mangaId: m.id!,
          url: sc.url,
          name: sc.name,
          scanlator: sc.scanlator,
          dateUpload: sc.dateUpload,
          number: sc.number,
        ));
        newChapters.add(ch);
      }
    }
    _bump();
    return [...existing, ...newChapters];
  }

  Future<void> removeFromLibrary(Manga m) async {
    await repos.removeFromLibrary(m.id!);
    _bump();
  }

  Future<void> mergeMangas(int primaryId, List<int> secondaryIds) async {
    await repos.mergeMangas(primaryId, secondaryIds);
    _bump();
  }

  /// Scan the local library folder and offer add-to-library candidates.
  Future<List<SourceManga>> scanLocalRoot(String rootPath) async {
    final local = sources.byId('local') as LocalSource?;
    if (local == null) return const [];
    return local.scanRoot(rootPath);
  }

  Future<String?> pickLocalRoot() async {
    final local = sources.byId('local') as LocalSource?;
    return local?.pickLibraryFolder();
  }

  /// Add a local-storage entry with its root path attached.
  Future<Manga> addLocalEntry(SourceManga sm, {required String root}) async {
    final manga = await addToLibrary(sm.copyWith(
      extra: {...?sm.extra, 'root': root},
    ));
    return manga;
  }

  void _bump() => _libraryVersion.value++;
}

/// Snapshot of a library-wide sync (chapters check) for the progress banner.
class SyncState {
  const SyncState({required this.current, required this.total, required this.label, this.failed = const []});
  final int current;
  final int total;
  final String label;
  final List<String> failed; // manga titles that errored
}
