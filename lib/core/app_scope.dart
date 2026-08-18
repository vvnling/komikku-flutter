import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/data/settings_service.dart';
import '../core/design/shaders.dart';
import '../core/theme_controller.dart';
import '../data/db/database.dart';
import '../data/db/repositories.dart';
import '../data/services/backup_service.dart';
import '../data/services/cover_cache.dart';
import '../data/services/download_service.dart';
import '../data/services/library_service.dart';
import '../data/services/trackers.dart';
import '../data/services/update_service.dart';
import '../data/sources/demo_source.dart';
import '../data/sources/local_source.dart';
import '../data/sources/mangadex_source.dart';
import '../data/sources/source.dart';

/// Root dependency container. Everything a screen needs hangs off this.
class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.scope, required super.child});

  final AppServices scope;

  static AppServices of(BuildContext context) {
    // Non-dependent lookup: AppScope is constructed once at boot and never
    // changes, so this is safe and also legal inside initState.
    final s = context.getInheritedWidgetOfExactType<AppScope>();
    assert(s != null, 'AppScope missing');
    return s!.scope;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => scope != oldWidget.scope;
}

/// Concrete services, built once at startup.
class AppServices {
  AppServices({
    required this.shaders,
    required this.settings,
    required this.theme,
    required this.db,
    required this.repos,
    required this.sources,
    required this.library,
    required this.downloads,
    required this.updates,
    required this.backups,
    required this.covers,
    required this.trackers,
  });

  final KShaders shaders;
  final SettingsService settings;
  final ThemeController theme;
  final AppDatabase db;
  final Repositories repos;
  final SourceManager sources;
  final LibraryService library;
  final DownloadService downloads;
  final UpdateService updates;
  final BackupService backups;
  final CoverCache covers;
  final TrackerRegistry trackers;

  /// Standard factory — used by main().
  static Future<AppServices> create({AppDatabase? dbOverride, SourceManager? sourcesOverride, SharedPreferences? prefs}) async {
    final shaders = await KShaders.load();
    final settings = await SettingsService.load(prefs: prefs);
    final db = dbOverride ?? AppDatabase.construct();
    final repos = Repositories(db);

    final sources = sourcesOverride ??
        SourceManager([
          DemoSource.instance,
          MangaDexSource(),
          LocalSource.instance,
        ]);

    final library = LibraryService(repos, sources);
    final downloads = DownloadService(repos, sources);
    final updates = UpdateService(repos, sources, settings, library);
    final backups = BackupService(repos, settings);
    final covers = CoverCache();
    final trackers = TrackerRegistry(settings);
    final theme = ThemeController(settings);

    return AppServices(
      shaders: shaders,
      settings: settings,
      theme: theme,
      db: db,
      repos: repos,
      sources: sources,
      library: library,
      downloads: downloads,
      updates: updates,
      backups: backups,
      covers: covers,
      trackers: trackers,
    );
  }
}

/// Convenience on BuildContext.
extension AppScopeX on BuildContext {
  AppServices get app => AppScope.of(this);
  SettingsService get settings => app.settings;
  Repositories get repos => app.repos;
  LibraryService get library => app.library;
  DownloadService get downloads => app.downloads;
  UpdateService get updates => app.updates;
  BackupService get backups => app.backups;
  CoverCache get covers => app.covers;
  SourceManager get sources => app.sources;
  TrackerRegistry get trackers => app.trackers;
  KShaders get shaders => app.shaders;
}
