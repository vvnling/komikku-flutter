import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/drift.dart' as drift;
import '../models/models.dart';
import 'database.dart';

/// Row ↔ domain mapping and query layer. All DB access goes through here.
class Repositories {
  Repositories(this.db);

  final AppDatabase db;

  // ── Manga ────────────────────────────────────────────────────────────────

  Manga _mangaFromRow(MangaRow r) => Manga(
        id: r.id,
        sourceId: r.sourceId,
        remoteId: r.remoteId,
        title: r.title,
        author: r.author,
        artist: r.artist,
        description: r.description,
        tags: _decodeList(r.tags),
        status: r.status,
        coverUrl: r.coverUrl,
        coverPath: r.coverPath,
        favorite: r.favorite,
        initialized: r.initialized,
        viewer: r.viewer,
        dateAdded: r.dateAdded,
        lastUpdate: r.lastUpdate,
        totalChapters: r.totalChapters,
        unread: r.unread,
        lastReadAt: r.lastReadAt,
        lastChapterUrl: r.lastChapterUrl,
        extra: r.extra == null ? null : _decodeMap(r.extra!),
      );

  static List<String> _decodeList(String s) {
    try {
      return (jsonDecode(s) as List).cast<String>();
    } catch (_) {
      return const [];
    }
  }

  static Map<String, String> _decodeMap(String s) {
    try {
      return (jsonDecode(s) as Map).cast<String, String>();
    } catch (_) {
      return const {};
    }
  }

  Future<Manga?> mangaByKey(String sourceId, String remoteId) async {
    final row = await (db.select(db.mangas)
          ..where((t) => t.sourceId.equals(sourceId) & t.remoteId.equals(remoteId)))
        .getSingleOrNull();
    return row == null ? null : _mangaFromRow(row);
  }

  Future<Manga?> mangaById(int id) async {
    final row = await (db.select(db.mangas)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mangaFromRow(row);
  }

  Future<List<Manga>> allMangas({bool onlyFavorites = false}) async {
    final q = db.select(db.mangas);
    if (onlyFavorites) q.where((t) => t.favorite.equals(true));
    final rows = await q.get();
    return rows.map(_mangaFromRow).toList();
  }

  Future<List<Manga>> libraryMangas({
    Set<int>? categoryIds,
    bool? downloadedOnly,
    bool? unreadOnly,
    bool? startedOnly,
    bool? trackedOnly,
    bool? notTrackedOnly,
    String? searchTerm,
    String? sortBy, // added|title|lastRead|lastUpdate|unread|totalChapters|source
    bool ascending = false,
    bool includeHiddenCategoryMangas = false,
  }) async {
    var q = db.select(db.mangas);

    if (categoryIds != null && categoryIds.isNotEmpty) {
      final inner = db.mangaCategory;
      final sub = (db.selectOnly(inner)
            ..addColumns([inner.mangaId])
            ..where(inner.categoryId.isIn(categoryIds)));
      // manual: fetch ids then filter
      final ids = await sub.map((r) => r.read(inner.mangaId)!).get();
      if (ids.isEmpty) return [];
      q.where((t) => t.id.isIn(ids));
    }

    if (!includeHiddenCategoryMangas) {
      // Hide mangas whose categories are ALL hidden (Komikku: hidden categories).
      final hiddenIds = await (db.select(db.categories)..where((c) => c.hidden.equals(true)))
          .map((r) => r.id)
          .get();
      if (hiddenIds.isNotEmpty) {
        final pairs = await (db.select(db.mangaCategory)).get();
        final byManga = <int, List<int>>{};
        for (final p in pairs) {
          byManga.putIfAbsent(p.mangaId, () => []).add(p.categoryId);
        }
        final hiddenOnly = byManga.entries
            .where((e) => e.value.isNotEmpty && e.value.every(hiddenIds.contains))
            .map((e) => e.key)
            .toSet();
        if (hiddenOnly.isNotEmpty) q.where((t) => t.id.isNotIn(hiddenOnly));
      }
    }

    if (downloadedOnly == true) {
      final ids = await _downloadedMangaIdList();
      if (ids.isEmpty) return [];
      q.where((t) => t.id.isIn(ids));
    }
    if (unreadOnly == true) q.where((t) => t.unread.isBiggerThanValue(0));
    if (startedOnly == true) q.where((t) => t.lastReadAt.isNotNull());
    if (trackedOnly == true) {
      final ids = await _trackedMangaIdList();
      if (ids.isEmpty) return [];
      q.where((t) => t.id.isIn(ids));
    }
    if (notTrackedOnly == true) {
      final ids = await _trackedMangaIdList();
      q.where((t) => t.id.isNotIn(ids));
    }
    if (searchTerm != null && searchTerm.isNotEmpty) {
      final like = '%${searchTerm.toLowerCase()}%';
      q.where((t) => t.title.lower().like(like));
    }

    switch (sortBy) {
      case 'title':
        q.orderBy([(t) => OrderingTerm(expression: t.title.lower(), mode: ascending ? OrderingMode.asc : OrderingMode.desc)]);
      case 'lastRead':
        q.orderBy([
          (t) => OrderingTerm(expression: t.lastReadAt, mode: ascending ? OrderingMode.asc : OrderingMode.desc, nulls: NullsOrder.last),
        ]);
      case 'lastUpdate':
        q.orderBy([
          (t) => OrderingTerm(expression: t.lastUpdate, mode: ascending ? OrderingMode.asc : OrderingMode.desc, nulls: NullsOrder.last),
        ]);
      case 'unread':
        q.orderBy([(t) => OrderingTerm(expression: t.unread, mode: ascending ? OrderingMode.asc : OrderingMode.desc)]);
      case 'totalChapters':
        q.orderBy([(t) => OrderingTerm(expression: t.totalChapters, mode: ascending ? OrderingMode.asc : OrderingMode.desc)]);
      case 'source':
        q.orderBy([(t) => OrderingTerm(expression: t.sourceId, mode: ascending ? OrderingMode.asc : OrderingMode.desc)]);
      case 'added':
      default:
        q.orderBy([(t) => OrderingTerm(expression: t.dateAdded, mode: ascending ? OrderingMode.asc : OrderingMode.desc, nulls: NullsOrder.last)]);
    }

    final rows = await q.get();
    return rows.map(_mangaFromRow).toList();
  }

  Future<Set<int>> _downloadedMangaIdList() async =>
      (await (db.select(db.chapters)..where((c) => c.downloaded.equals(true))).map((c) => c.mangaId).get()).toSet();

  Future<Set<int>> _trackedMangaIdList() async =>
      (await (db.select(db.tracks)).map((t) => t.mangaId).get()).toSet();

  Future<Manga> upsertManga(Manga m) async {
    final row = _mangaRow(m);
    await db.into(db.mangas).insert(row, mode: InsertMode.insertOrReplace);
    return (await mangaByKey(m.sourceId, m.remoteId))!;
  }

  MangasCompanion _mangaRow(Manga m) => MangasCompanion(
        id: const Value.absent(),
        sourceId: Value(m.sourceId),
        remoteId: Value(m.remoteId),
        title: Value(m.title),
        author: Value(m.author),
        artist: Value(m.artist),
        description: Value(m.description),
        tags: Value(jsonEncode(m.tags)),
        status: Value(m.status),
        coverUrl: Value(m.coverUrl),
        coverPath: Value(m.coverPath),
        favorite: Value(m.favorite),
        initialized: Value(m.initialized),
        viewer: Value(m.viewer),
        dateAdded: Value(m.dateAdded),
        lastUpdate: Value(m.lastUpdate),
        totalChapters: Value(m.totalChapters),
        unread: Value(m.unread),
        lastReadAt: Value(m.lastReadAt),
        lastChapterUrl: Value(m.lastChapterUrl),
        extra: Value(m.extra == null ? null : jsonEncode(m.extra)),
      );

  /// Update only mutable library fields on an existing entry.
  Future<void> updateManga(Manga m) async {
    if (m.id == null) return;
    await (db.update(db.mangas)..where((t) => t.id.equals(m.id!))).write(MangasCompanion(
          title: Value(m.title),
          author: Value(m.author),
          artist: Value(m.artist),
          description: Value(m.description),
          tags: Value(jsonEncode(m.tags)),
          status: Value(m.status),
          coverUrl: Value(m.coverUrl),
          coverPath: Value(m.coverPath),
          favorite: Value(m.favorite),
          initialized: Value(m.initialized),
          viewer: Value(m.viewer),
          lastUpdate: Value(m.lastUpdate),
          totalChapters: Value(m.totalChapters),
          unread: Value(m.unread),
          lastReadAt: Value(m.lastReadAt),
          lastChapterUrl: Value(m.lastChapterUrl),
          dateAdded: Value(m.dateAdded),
          extra: Value(m.extra != null ? jsonEncode(m.extra) : null),
        ));
  }

  Future<Manga> addToLibrary(Manga m, {List<String>? categoryNames}) async {
    final stored = await upsertManga(m.copyWith(favorite: true, dateAdded: m.dateAdded ?? DateTime.now()));
    if (categoryNames != null && categoryNames.isNotEmpty) {
      for (final name in categoryNames) {
        final cat = await categoryByName(name);
        if (cat != null) {
          await db
              .into(db.mangaCategory)
              .insert(MangaCategoryCompanion.insert(mangaId: stored.id!, categoryId: cat.id!), mode: InsertMode.insertOrIgnore);
        }
      }
    }
    return (await mangaById(stored.id!))!;
  }

  Future<void> removeFromLibrary(int mangaId) async {
    await (db.delete(db.chapters)..where((c) => c.mangaId.equals(mangaId))).go();
    await (db.delete(db.mangaCategory)..where((mc) => mc.mangaId.equals(mangaId))).go();
    await (db.delete(db.history)..where((h) => h.mangaId.equals(mangaId))).go();
    await (db.delete(db.tracks)..where((t) => t.mangaId.equals(mangaId))).go();
    await (db.delete(db.mangas)..where((t) => t.id.equals(mangaId))).go();
  }

  /// Merge [secondaryIds] into [primaryId]: chapters, category links, history.
  Future<void> mergeMangas(int primaryId, List<int> secondaryIds) async {
    final pri = await mangaById(primaryId);
    if (pri == null) return;
    for (final sid in secondaryIds) {
      final sec = await mangaById(sid);
      if (sec == null) continue;
      // re-point chapters (skip url collisions)
      final secChapters = await chaptersOfManga(sid);
      final priUrls = (await chaptersOfManga(primaryId)).map((c) => c.url).toSet();
      for (final c in secChapters.where((c) => !priUrls.contains(c.url))) {
        await (db.update(db.chapters)..where((t) => t.id.equals(c.id!))).write(ChaptersCompanion(mangaId: Value(primaryId)));
      }
      // categories
      final cats = await categoriesOfManga(sid);
      for (final c in cats) {
        await db.into(db.mangaCategory).insert(
              MangaCategoryCompanion.insert(mangaId: primaryId, categoryId: c.id!),
              mode: InsertMode.insertOrIgnore,
            );
      }
      // history re-point
      await (db.update(db.history)..where((h) => h.mangaId.equals(sid))).write(HistoryCompanion(mangaId: Value(primaryId)));
      // tracks re-point
      await (db.update(db.tracks)..where((t) => t.mangaId.equals(sid))).write(TracksCompanion(mangaId: Value(primaryId)));
      // delete secondary
      await (db.delete(db.mangas)..where((t) => t.id.equals(sid))).go();
    }
    // refresh counts
    final chs = await chaptersOfManga(primaryId);
    await updateManga(pri.copyWith(totalChapters: chs.length, unread: chs.where((c) => !c.read).length));
  }

  // ── Watch for reactive UI ────────────────────────────────────────────────

  Stream<List<Manga>> watchLibrary({bool onlyFavorites = true}) {
    final q = db.select(db.mangas);
    if (onlyFavorites) q.where((t) => t.favorite.equals(true));
    q.orderBy([(t) => OrderingTerm(expression: t.dateAdded, mode: OrderingMode.desc)]);
    return q.watch().map((rows) => rows.map(_mangaFromRow).toList());
  }

  // ── Chapters ─────────────────────────────────────────────────────────────

  Chapter _chapterFromRow(ChapterRow r) => Chapter(
        id: r.id,
        mangaId: r.mangaId,
        url: r.url,
        name: r.name,
        scanlator: r.scanlator,
        dateUpload: r.dateUpload,
        number: r.number,
        read: r.read,
        bookmark: r.bookmark,
        lastPageRead: r.lastPageRead,
        lastReadAt: r.lastReadAt,
        downloaded: r.downloaded,
        downloadPath: r.downloadPath,
        fetched: r.fetched,
      );

  Future<List<Chapter>> chaptersOfManga(int mangaId, {bool ascending = false}) async {
    final q = db.select(db.chapters)..where((c) => c.mangaId.equals(mangaId));
    q.orderBy([
      (c) => OrderingTerm(expression: c.number, mode: ascending ? OrderingMode.asc : OrderingMode.desc),
      (c) => OrderingTerm(expression: c.dateUpload, mode: ascending ? OrderingMode.asc : OrderingMode.desc),
    ]);
    final rows = await q.get();
    return rows.map(_chapterFromRow).toList();
  }

  Stream<List<Chapter>> watchChapters(int mangaId) {
    final q = db.select(db.chapters)..where((c) => c.mangaId.equals(mangaId));
    q.orderBy([(c) => OrderingTerm(expression: c.number, mode: OrderingMode.desc)]);
    return q.watch().map((rows) => rows.map(_chapterFromRow).toList());
  }

  Future<Chapter?> chapterByUrl(int mangaId, String url) async {
    final row = await (db.select(db.chapters)
          ..where((c) => c.mangaId.equals(mangaId) & c.url.equals(url)))
        .getSingleOrNull();
    return row == null ? null : _chapterFromRow(row);
  }

  Future<Chapter> upsertChapter(Chapter c) async {
    await db.into(db.chapters).insert(
          ChaptersCompanion.insert(
            mangaId: c.mangaId,
            url: c.url,
            name: c.name,
            scanlator: Value(c.scanlator),
            dateUpload: Value(c.dateUpload),
            number: Value(c.number),
            read: Value(c.read),
            bookmark: Value(c.bookmark),
            lastPageRead: Value(c.lastPageRead),
            lastReadAt: Value(c.lastReadAt),
            downloaded: Value(c.downloaded),
            downloadPath: Value(c.downloadPath),
            fetched: Value(c.fetched),
          ),
          mode: InsertMode.insertOrReplace,
        );
    final stored = await chapterByUrl(c.mangaId, c.url);
    return stored!;
  }

  Future<void> updateChapter(Chapter c) async {
    if (c.id == null) return;
    await (db.update(db.chapters)..where((t) => t.id.equals(c.id!))).write(ChaptersCompanion(
          name: Value(c.name),
          scanlator: Value(c.scanlator),
          dateUpload: Value(c.dateUpload),
          number: Value(c.number),
          read: Value(c.read),
          bookmark: Value(c.bookmark),
          lastPageRead: Value(c.lastPageRead),
          lastReadAt: Value(c.lastReadAt),
          downloaded: Value(c.downloaded),
          downloadPath: Value(c.downloadPath),
          fetched: Value(c.fetched),
        ));
    await _refreshMangaCounts(c.mangaId);
  }

  Future<void> setChapterRead(Chapter c, bool read) async {
    await (db.update(db.chapters)..where((t) => t.id.equals(c.id!))).write(ChaptersCompanion(
          read: Value(read),
          lastReadAt: Value(read ? DateTime.now() : null),
        ));
    await _refreshMangaCounts(c.mangaId);
  }

  Future<void> _refreshMangaCounts(int mangaId) async {
    final chs = await chaptersOfManga(mangaId);
    final m = await mangaById(mangaId);
    if (m == null) return;
    await updateManga(m.copyWith(totalChapters: chs.length, unread: chs.where((c) => !c.read).length));
  }

  // ── Categories ───────────────────────────────────────────────────────────

  Future<List<Category>> allCategories() async {
    final rows = await (db.select(db.categories)..orderBy([(t) => OrderingTerm.asc(t.order)])).get();
    return rows.map((r) => Category(id: r.id, name: r.name, order: r.order, hidden: r.hidden, createdAt: r.createdAt)).toList();
  }

  Future<Category?> categoryByName(String name) async {
    final row = await (db.select(db.categories)..where((c) => c.name.equals(name))).getSingleOrNull();
    return row == null ? null : Category(id: row.id, name: row.name, order: row.order, hidden: row.hidden, createdAt: row.createdAt);
  }

  Future<Category> createCategory(String name, {bool hidden = false}) async {
    final order = await (db.select(db.categories)).map((c) => c.order).get().then((v) => v.isEmpty ? 0 : v.reduce((a, b) => a > b ? a : b) + 1);
    final id = await db.into(db.categories).insert(CategoriesCompanion.insert(name: name, order: Value(order), hidden: Value(hidden)));
    return Category(id: id, name: name, order: order, hidden: hidden, createdAt: DateTime.now());
  }

  Future<void> updateCategory(Category c) async {
    if (c.id == null) return;
    await (db.update(db.categories)..where((t) => t.id.equals(c.id!))).write(CategoriesCompanion(
          name: Value(c.name),
          order: Value(c.order),
          hidden: Value(c.hidden),
        ));
  }

  Future<void> deleteCategory(int id) async {
    await (db.delete(db.mangaCategory)..where((mc) => mc.categoryId.equals(id))).go();
    await (db.delete(db.categories)..where((c) => c.id.equals(id))).go();
  }

  Future<List<Category>> categoriesOfManga(int mangaId) async {
    final query = db.select(db.mangaCategory).join([
      innerJoin(db.categories, db.categories.id.equalsExp(db.mangaCategory.categoryId)),
    ])
      ..where(db.mangaCategory.mangaId.equals(mangaId));
    final rows = await query.get();
    rows.sort((a, b) => (a.readTable(db.categories).order).compareTo(b.readTable(db.categories).order));
    return rows.map((r) {
      final row = r.readTable(db.categories);
      return Category(id: row.id, name: row.name, order: row.order, hidden: row.hidden, createdAt: row.createdAt);
    }).toList();
  }

  Future<void> setMangaCategories(int mangaId, List<int> categoryIds) async {
    await (db.delete(db.mangaCategory)..where((mc) => mc.mangaId.equals(mangaId))).go();
    for (final cid in categoryIds) {
      await db.into(db.mangaCategory).insert(MangaCategoryCompanion.insert(mangaId: mangaId, categoryId: cid), mode: InsertMode.insertOrIgnore);
    }
  }

  // ── History ──────────────────────────────────────────────────────────────

  Future<List<HistoryEntry>> recentHistory({int limit = 60}) async {
    final q = db.select(db.history)
      ..orderBy([(h) => OrderingTerm.desc(h.readAt)])
      ..limit(limit);
    final rows = await q.get();
    return rows
        .map((r) => HistoryEntry(id: r.id, mangaId: r.mangaId, chapterId: r.chapterId, page: r.page, percent: r.percent, readAt: r.readAt))
        .toList();
  }

  Stream<List<HistoryEntry>> watchHistory({int limit = 60}) {
    final q = db.select(db.history)
      ..orderBy([(h) => OrderingTerm.desc(h.readAt)])
      ..limit(limit);
    return q.watch().map((rows) => rows
        .map((r) => HistoryEntry(id: r.id, mangaId: r.mangaId, chapterId: r.chapterId, page: r.page, percent: r.percent, readAt: r.readAt))
        .toList());
  }

  Future<HistoryEntry?> historyFor(int mangaId, int chapterId) async {
    final row = await (db.select(db.history)
          ..where((h) => h.mangaId.equals(mangaId) & h.chapterId.equals(chapterId)))
        .getSingleOrNull();
    if (row == null) return null;
    return HistoryEntry(id: row.id, mangaId: row.mangaId, chapterId: row.chapterId, page: row.page, percent: row.percent, readAt: row.readAt);
  }

  Future<void> recordHistory(int mangaId, int chapterId, int page, double percent) async {
    await db.into(db.history).insert(
          HistoryCompanion.insert(
            mangaId: mangaId,
            chapterId: chapterId,
            page: Value(page),
            percent: Value(percent),
            readAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
    // keep history table bounded
    final count = await (db.select(db.history)).map((h) => h.id).get();
    if (count.length > 400) {
      final cutoff = count.length - 400;
      final toDelete = await (db.select(db.history)..orderBy([(h) => OrderingTerm.asc(h.readAt)])..limit(cutoff)).map((h) => h.id).get();
      if (toDelete.isNotEmpty) {
        await (db.delete(db.history)..where((h) => h.id.isIn(toDelete))).go();
      }
    }
  }

  Future<void> clearHistory() async {
    await db.delete(db.history).go();
  }

  // ── Tracks ───────────────────────────────────────────────────────────────

  Future<List<Track>> tracksForManga(int mangaId) async {
    final rows = await (db.select(db.tracks)..where((t) => t.mangaId.equals(mangaId))).get();
    return rows.map(_trackFromRow).toList();
  }

  Track _trackFromRow(TrackRow r) => Track(
        id: r.id,
        mangaId: r.mangaId,
        trackerId: r.trackerId,
        remoteId: r.remoteId,
        title: r.title,
        status: r.status,
        score: r.score,
        lastChapterRead: r.lastChapterRead,
        totalChapters: r.totalChapters,
        trackedAt: r.trackedAt,
      );

  Future<void> upsertTrack(Track t) async {
    await db.into(db.tracks).insert(
          TracksCompanion.insert(
            mangaId: t.mangaId,
            trackerId: t.trackerId,
            remoteId: Value(t.remoteId),
            title: Value(t.title),
            status: Value(t.status),
            score: Value(t.score),
            lastChapterRead: Value(t.lastChapterRead),
            totalChapters: Value(t.totalChapters),
            trackedAt: Value(t.trackedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> deleteTrack(int mangaId, String trackerId) async {
    await (db.delete(db.tracks)..where((t) => t.mangaId.equals(mangaId) & t.trackerId.equals(trackerId))).go();
  }

  // ── Feed cache ───────────────────────────────────────────────────────────

  Future<List<FeedItem>> feedItems({int limit = 200}) async {
    final q = db.select(db.feed)
      ..orderBy([(f) => OrderingTerm.desc(f.updatedAt)])
      ..limit(limit);
    final rows = await q.get();
    return rows.map(_feedFromRow).toList();
  }

  FeedItem _feedFromRow(FeedRow r) => FeedItem(
        sourceId: r.sourceId,
        remoteId: r.remoteId,
        title: r.title,
        coverUrl: r.coverUrl,
        chapterName: r.chapterName,
        chapterUrl: r.chapterUrl,
        updatedAt: r.updatedAt,
      );

  Future<void> replaceFeed(List<FeedItem> items) async {
    await db.transaction(() async {
      await db.delete(db.feed).go();
      for (final item in items) {
        await db.into(db.feed).insert(FeedCompanion.insert(
              sourceId: item.sourceId,
              remoteId: item.remoteId,
              title: item.title,
              coverUrl: Value(item.coverUrl),
              chapterName: Value(item.chapterName),
              chapterUrl: Value(item.chapterUrl),
              updatedAt: Value(item.updatedAt),
            ));
      }
    });
  }
}