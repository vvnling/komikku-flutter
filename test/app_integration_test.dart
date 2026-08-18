import 'package:flutter/material.dart' show SizedBox;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:comicko/core/app_scope.dart';
import 'package:comicko/core/data/settings_service.dart';
import 'package:comicko/data/db/database.dart';
import 'package:comicko/data/db/repositories.dart';
import 'package:comicko/data/models/models.dart';
import 'package:comicko/data/services/backup_service.dart';
import 'package:comicko/data/services/download_service.dart';
import 'package:comicko/data/services/library_service.dart';
import 'package:comicko/data/services/trackers.dart';
import 'package:comicko/data/services/update_service.dart';
import 'package:comicko/data/sources/demo_source.dart';
import 'package:comicko/data/sources/source.dart';
import 'package:comicko/ui/screens/reader/chapter_session.dart';
import 'package:comicko/main.dart';


Future<AppServices> makeServices() async {
  SharedPreferences.setMockInitialValues({});
  return AppServices.create(
    dbOverride: AppDatabase.memory(),
    sourcesOverride: SourceManager([]),
    prefs: await SharedPreferences.getInstance(),
  );
}

void main() {
  group('LibraryService', () {
    test('add + fetch chapters + counts', () async {
      final db = AppDatabase.memory();
      final repos = Repositories(db);
      final sources = SourceManager([]);
      final service = LibraryService(repos, sources);

      final manga = await service.addToLibrary(SourceManga(
        sourceId: 'demo',
        remoteId: 'x1',
        title: 'Test Manga',
        author: 'Author',
      ));
      expect(manga.favorite, isTrue);
      expect(manga.id, isNotNull);

      final found = await repos.mangaByKey('demo', 'x1');
      expect(found, isNotNull);
      expect(found!.title, 'Test Manga');

      // remove
      await service.removeFromLibrary(manga);
      expect(await repos.mangaByKey('demo', 'x1'), isNull);
      db.close();
    });

    test('merge secondary into primary', () async {
      final db = AppDatabase.memory();
      final repos = Repositories(db);
      final service = LibraryService(repos, SourceManager([]));
      final a = await service.addToLibrary(const SourceManga(sourceId: 'demo', remoteId: 'a', title: 'A'));
      final b = await service.addToLibrary(const SourceManga(sourceId: 'demo', remoteId: 'b', title: 'B'));
      await repos.upsertChapter(Chapter(mangaId: b.id!, url: 'ch1', name: 'Ch 1'));
      await service.mergeMangas(a.id!, [b.id!]);
      final chapters = await repos.chaptersOfManga(a.id!);
      expect(chapters.length, 1);
      expect(await repos.mangaById(b.id!), isNull, reason: 'secondary removed');
      db.close();
    });

    test('hidden category excludes manga from library', () async {
      final db = AppDatabase.memory();
      final repos = Repositories(db);
      final service = LibraryService(repos, SourceManager([]));
      final cat = await repos.createCategory('Secret', hidden: true);
      final m = await service.addToLibrary(const SourceManga(sourceId: 'demo', remoteId: 'h', title: 'Hidden'));
      await repos.setMangaCategories(m.id!, [cat.id!]);
      final visible = await repos.libraryMangas(includeHiddenCategoryMangas: false);
      expect(visible, isEmpty);
      final revealed = await repos.libraryMangas(includeHiddenCategoryMangas: true);
      expect(revealed.length, 1);
      db.close();
    });
  });

  group('DownloadService', () {
    test('queue lifecycle with demo download', () async {
      final db = AppDatabase.memory();
      final repos = Repositories(db);
      final service = LibraryService(repos, SourceManager([]));
      final manga = await service.addToLibrary(const SourceManga(sourceId: 'demo', remoteId: 'starlight-runner', title: 'Starlight Runner'));
      final chapter = await repos.upsertChapter(Chapter(mangaId: manga.id!, url: 'ch3', name: 'Chapter 3', number: 3));

      final downloads = DownloadService(repos, SourceManager([DemoSource.instance]));
      await downloads.enqueue(manga, chapter);
      expect(downloads.activeCount, 1);
      // wait for the worker to finish
      for (var i = 0; i < 60 && downloads.activeCount > 0; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      expect(downloads.activeCount, 0);
      final stored = await repos.chapterByUrl(manga.id!, 'ch3');
      expect(stored!.downloaded, isTrue, reason: 'chapter marked downloaded');
      final dir = await downloads.existingChapterDir(manga, stored);
      expect(dir, isNotNull);
      final files = await DownloadService.pageFiles(dir!);
      expect(files.length, greaterThan(0));
      db.close();
    });
  });

  group('BackupService', () {
    test('export/import roundtrip', () async {
      final db = AppDatabase.memory();
      final repos = Repositories(db);
      final service = LibraryService(repos, SourceManager([]));
      final m = await service.addToLibrary(const SourceManga(sourceId: 'demo', remoteId: 'r1', title: 'Roundtrip'));
      final ch = await repos.upsertChapter(Chapter(mangaId: m.id!, url: 'c1', name: 'C1', number: 1));
      await repos.recordHistory(m.id!, ch.id!, 4, 0.5);
      await repos.createCategory('Favs');
      await repos.upsertTrack(Track(mangaId: m.id!, trackerId: 'comicko', status: 'Reading', score: 8));

      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsService.load();
      final backup = BackupService(repos, settings);
      final json = await backup.buildBackup();
      expect(json['manga'], hasLength(1));
      expect(json['history'], hasLength(1));

      // restore into a fresh database
      final db2 = AppDatabase.memory();
      final repos2 = Repositories(db2);
      final backup2 = BackupService(repos2, settings);
      final result = await backup2.restore(json);
      expect(result.imported, 1);
      final restored = await repos2.mangaByKey('demo', 'r1');
      expect(restored, isNotNull);
      expect(restored!.title, 'Roundtrip');
      final tracks = await repos2.tracksForManga(restored.id!);
      expect(tracks, hasLength(1));
      expect(tracks.first.score, 8);
      db.close();
      db2.close();
    });
  });

  group('UpdateService', () {
    test('rebuildUpdateList groups unread', () async {
      final db = AppDatabase.memory();
      final repos = Repositories(db);
      final service = LibraryService(repos, SourceManager([]));
      final m = await service.addToLibrary(const SourceManga(sourceId: 'demo', remoteId: 'u1', title: 'Updates'));
      await repos.upsertChapter(Chapter(mangaId: m.id!, url: 'c1', name: 'C1', number: 1));
      await repos.upsertChapter(Chapter(mangaId: m.id!, url: 'c2', name: 'C2', number: 2));

      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsService.load();
      final updates = UpdateService(repos, SourceManager([]), settings, service);
      await updates.rebuildUpdateList();
      expect(updates.updates.value, hasLength(1));
      expect(updates.updates.value.first.unreadCount, 2);

      // mark read → grouped list empties
      final chs = await repos.chaptersOfManga(m.id!);
      for (final c in chs) {
        await repos.setChapterRead(c, true);
      }
      await updates.rebuildUpdateList();
      expect(updates.updates.value, isEmpty);
      db.close();
    });
  });

  group('Trackers', () {
    test('local tracker stores and updates', () async {
      final db = AppDatabase.memory();
      final repos = Repositories(db);
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsService.load();
      final registry = TrackerRegistry(settings);
      expect(registry.all.length, greaterThanOrEqualTo(2));
      final local = registry.byId('comicko');
      expect(local.isLoggedIn, isTrue);
      final m = await (LibraryService(repos, SourceManager([]))).addToLibrary(
        const SourceManga(sourceId: 'demo', remoteId: 't1', title: 'Tracked'),
      );
      final track = Track(mangaId: m.id!, trackerId: 'comicko', status: 'Reading', score: 9);
      await repos.upsertTrack(track);
      final stored = await repos.tracksForManga(m.id!);
      expect(stored.first.score, 9);
      db.close();
    });
  });

  group('App boot', () {
    testWidgets('full app boots to empty library', (tester) async {
      final services = await makeServices();
      await tester.pumpWidget(ComickoApp(services: services));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(seconds: 1));
      // Library empty state shows the seed button
      expect(find.text('Your library is empty'), findsOneWidget);
      expect(find.text('Add demo entries'), findsOneWidget);
      services.updates.stop();
      // unmount in-test so drift's stream-close timer fires inside the test
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(seconds: 15));
    });

    test('demo seeding fills the library', () async {
      SharedPreferences.setMockInitialValues({});
      final services = await AppServices.create(
        dbOverride: AppDatabase.memory(),
        sourcesOverride: SourceManager([DemoSource.instance]),
        prefs: await SharedPreferences.getInstance(),
      );
      final demo = services.sources.byId('demo');
      expect(demo, isNotNull);
      final popular = await demo!.getPopular(1);
      for (final sm in popular.take(3)) {
        final m = await services.library.addToLibrary(sm);
        await services.library.refreshManga(m);
      }
      final mangas = await services.repos.allMangas(onlyFavorites: true);
      expect(mangas.length, 3);
      expect(mangas.first.totalChapters, greaterThan(0));
      services.db.close();
    });
  });

  group('ChapterSession', () {
    test('demo pages resolve to generated assets', () async {
      final db = AppDatabase.memory();
      final repos = Repositories(db);
      SharedPreferences.setMockInitialValues({});
      final services = await AppServices.create(
        dbOverride: db,
        sourcesOverride: SourceManager([DemoSource.instance]),
        prefs: await SharedPreferences.getInstance(),
      );
      final service = LibraryService(repos, SourceManager([DemoSource.instance]));
      final m = await service.addToLibrary(const SourceManga(sourceId: 'demo', remoteId: 'starlight-runner', title: 'Starlight Runner'));
      final ch = await repos.upsertChapter(Chapter(mangaId: m.id!, url: 'ch1', name: 'Chapter 1'));

      final session = ChapterSessionPublic(manga: m, chapter: ch);
      session.attach(services);
      await session.load();
      expect(session.total, greaterThan(0));
      expect(session.error, isNull);
      final bytes = await session.bytesOf(0);
      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThan(1000));
      db.close();
    });
  });
}
class ChapterSessionPublic extends ChapterSession {
  ChapterSessionPublic({required super.manga, required super.chapter});
}
