import 'package:drift/drift.dart';
import 'package:drift/native.dart' show NativeDatabase;

// Web builds use drift's wasm database; the stub keeps VM/test builds free
// of dart:js_interop (drift's wasm support is web-only).
// ignore: uri_does_not_exist
import 'wasm_db_stub.dart'
    if (dart.library.js_interop) 'wasm_db_web.dart' show WasmDatabaseStub;
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'database.g.dart';

// ── Tables ──────────────────────────────────────────────────────────────────

@DataClassName('MangaRow')
class Mangas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceId => text()();
  TextColumn get remoteId => text()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get artist => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  TextColumn get status => text().nullable()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get coverPath => text().nullable()();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  BoolColumn get initialized => boolean().withDefault(const Constant(false))();
  IntColumn get viewer => integer().withDefault(const Constant(-1))();
  DateTimeColumn get dateAdded => dateTime().nullable()();
  DateTimeColumn get lastUpdate => dateTime().nullable()();
  IntColumn get totalChapters => integer().withDefault(const Constant(0))();
  IntColumn get unread => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReadAt => dateTime().nullable()();
  TextColumn get lastChapterUrl => text().nullable()();
  TextColumn get extra => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
        {sourceId, remoteId},
      ];
}

@DataClassName('ChapterRow')
class Chapters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mangaId => integer().references(Mangas, #id, onDelete: KeyAction.cascade)();
  TextColumn get url => text()();
  TextColumn get name => text()();
  TextColumn get scanlator => text().nullable()();
  DateTimeColumn get dateUpload => dateTime().nullable()();
  RealColumn get number => real().withDefault(const Constant(0))();
  BoolColumn get read => boolean().withDefault(const Constant(false))();
  BoolColumn get bookmark => boolean().withDefault(const Constant(false))();
  IntColumn get lastPageRead => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReadAt => dateTime().nullable()();
  BoolColumn get downloaded => boolean().withDefault(const Constant(false))();
  TextColumn get downloadPath => text().nullable()();
  BoolColumn get fetched => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
        {mangaId, url},
      ];
}

@DataClassName('CategoryRow')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get order => integer().withDefault(const Constant(0))();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MangaCategoryRow')
class MangaCategory extends Table {
  IntColumn get mangaId => integer().references(Mangas, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {mangaId, categoryId};
}

@DataClassName('HistoryRow')
class History extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mangaId => integer().references(Mangas, #id, onDelete: KeyAction.cascade)();
  IntColumn get chapterId => integer().references(Chapters, #id, onDelete: KeyAction.cascade)();
  IntColumn get page => integer().withDefault(const Constant(0))();
  RealColumn get percent => real().withDefault(const Constant(0))();
  DateTimeColumn get readAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
        {mangaId, chapterId},
      ];
}

@DataClassName('TrackRow')
class Tracks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mangaId => integer().references(Mangas, #id, onDelete: KeyAction.cascade)();
  TextColumn get trackerId => text()();
  TextColumn get remoteId => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get status => text().nullable()();
  RealColumn get score => real().withDefault(const Constant(0))();
  RealColumn get lastChapterRead => real().withDefault(const Constant(0))();
  IntColumn get totalChapters => integer().withDefault(const Constant(0))();
  DateTimeColumn get trackedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
        {mangaId, trackerId},
      ];
}

@DataClassName('FeedRow')
class Feed extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceId => text()();
  TextColumn get remoteId => text()();
  TextColumn get title => text()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get chapterName => text().nullable()();
  TextColumn get chapterUrl => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
        {sourceId, remoteId},
      ];
}

// ── Database ────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [Mangas, Chapters, Categories, MangaCategory, History, Tracks, Feed])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  factory AppDatabase.construct() {
    if (kIsWeb) {
      return AppDatabase(DatabaseConnection.delayed(Future(() async {
        final result = await WasmDatabaseStub.open(
          databaseName: 'comicko',
          sqlite3Uri: Uri.parse('sqlite3.wasm'),
          driftWorkerUri: Uri.parse('drift_worker.js'),
        );
        return result.resolvedExecutor;
      })));
    }
    return AppDatabase(driftDatabase(name: 'comicko'));
  }

  /// In-memory database for tests.
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {},
      );
}