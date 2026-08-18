import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Typed key-value settings on top of SharedPreferences.
class SettingsService {
  SettingsService(this._prefs);

  static Future<SettingsService> load({SharedPreferences? prefs}) async =>
      SettingsService(prefs ?? await SharedPreferences.getInstance());

  final SharedPreferences _prefs;

  // ── appearance ───────────────────────────────────────────────────────────
  String get paletteId => _prefs.getString('appearance.palette') ?? 'aurora';
  set paletteId(String v) => _prefs.setString('appearance.palette', v);

  /// light | dark | system
  String get themeMode => _prefs.getString('appearance.mode') ?? 'system';
  set themeMode(String v) => _prefs.setString('appearance.mode', v);

  /// Auto-tint chrome from the entry cover.
  bool get autoTint => _prefs.getBool('appearance.autoTint') ?? true;
  set autoTint(bool v) => _prefs.setBool('appearance.autoTint', v);

  /// Grain overlay strength 0..1 (0 off).
  double get grain => _prefs.getDouble('appearance.grain') ?? 0.5;
  set grain(double v) => _prefs.setDouble('appearance.grain', v);

  // ── library ──────────────────────────────────────────────────────────────
  String get libraryLayout => _prefs.getString('library.layout') ?? 'grid'; // grid | list
  set libraryLayout(String v) => _prefs.setString('library.layout', v);

  int get librarySort => _prefs.getInt('library.sort') ?? 2; // 0 added,1 title,2 lastRead,3 lastUpdate,4 unread,5 total
  set librarySort(int v) => _prefs.setInt('library.sort', v);

  bool get librarySortAsc => _prefs.getBool('library.sortAsc') ?? false;
  set librarySortAsc(bool v) => _prefs.setBool('library.sortAsc', v);

  bool get showHidden => _prefs.getBool('library.showHidden') ?? false;
  set showHidden(bool v) => _prefs.setBool('library.showHidden', v);

  /// Filter: 0 all, 1 downloaded, 2 unread, 3 started, 4 tracked, 5 not tracked.
  int get libraryFilter => _prefs.getInt('library.filter') ?? 0;
  set libraryFilter(int v) => _prefs.setInt('library.filter', v);

  // ── reader defaults ──────────────────────────────────────────────────────
  /// 0 paged LTR, 1 paged RTL, 2 webtoon, 3 continuous vertical.
  int get readerViewer => _prefs.getInt('reader.viewer') ?? 0;
  set readerViewer(int v) => _prefs.setInt('reader.viewer', v);

  /// 0 slide, 1 cover, 2 fade, 3 depth
  int get pageTransition => _prefs.getInt('reader.transition') ?? 0;
  set pageTransition(int v) => _prefs.setInt('reader.transition', v);

  /// 0 black, 1 white, 2 gray, 3 auto-from-page
  int get readerBackground => _prefs.getInt('reader.background') ?? 0;
  set readerBackground(int v) => _prefs.setInt('reader.background', v);

  double get autoscrollSpeed => _prefs.getDouble('reader.autoscroll') ?? 1.0;
  set autoscrollSpeed(double v) => _prefs.setDouble('reader.autoscroll', v);

  bool get webtoonDetection => _prefs.getBool('reader.webtoonDetect') ?? true;
  set webtoonDetection(bool v) => _prefs.setBool('reader.webtoonDetect', v);

  bool get autoNextChapter => _prefs.getBool('reader.autoNext') ?? true;
  set autoNextChapter(bool v) => _prefs.setBool('reader.autoNext', v);

  /// 0 fit width, 1 fit screen, 2 original size
  int get imageFit => _prefs.getInt('reader.imageFit') ?? 0;
  set imageFit(int v) => _prefs.setInt('reader.imageFit', v);

  /// 0: tap zones (left prev, right next), 1: tap anywhere next
  int get tapZones => _prefs.getInt('reader.tapZones') ?? 0;
  set tapZones(int v) => _prefs.setInt('reader.tapZones', v);

  bool get keepScreenOn => _prefs.getBool('reader.keepScreenOn') ?? true;
  set keepScreenOn(bool v) => _prefs.setBool('reader.keepScreenOn', v);

  // ── downloads ────────────────────────────────────────────────────────────
  int get downloadThreads => _prefs.getInt('download.threads') ?? 2;
  set downloadThreads(int v) => _prefs.setInt('download.threads', v);

  bool get onlyOverWifi => _prefs.getBool('download.wifiOnly') ?? false;
  set onlyOverWifi(bool v) => _prefs.setBool('download.wifiOnly', v);

  // ── library updates ──────────────────────────────────────────────────────
  /// hours; 0 = disabled.
  int get updateIntervalHours => _prefs.getInt('update.intervalHours') ?? 12;
  set updateIntervalHours(int v) => _prefs.setInt('update.intervalHours', v);

  bool get updateOnlyOverWifi => _prefs.getBool('update.wifiOnly') ?? true;
  set updateOnlyOverWifi(bool v) => _prefs.setBool('update.wifiOnly', v);

  DateTime? get lastUpdateRun => _prefs.getString('update.lastRun') == null
      ? null
      : DateTime.tryParse(_prefs.getString('update.lastRun')!);
  set lastUpdateRun(DateTime? v) {
    if (v == null) {
      _prefs.remove('update.lastRun');
    } else {
      _prefs.setString('update.lastRun', v.toIso8601String());
    }
  }

  // ── trackers ─────────────────────────────────────────────────────────────
  String get anilistClientId => _prefs.getString('trackers.anilist.clientId') ?? '';
  set anilistClientId(String v) => _prefs.setString('trackers.anilist.clientId', v);

  String? get anilistToken => _prefs.getString('trackers.anilist.token');
  set anilistToken(String? v) {
    if (v == null) {
      _prefs.remove('trackers.anilist.token');
    } else {
      _prefs.setString('trackers.anilist.token', v);
    }
  }

  // ── misc ─────────────────────────────────────────────────────────────────
  bool get nsfwEnabled => _prefs.getBool('misc.nsfw') ?? true;
  set nsfwEnabled(bool v) => _prefs.setBool('misc.nsfw', v);

  /// Saved feed order: list of source ids.
  List<String> get feedOrder => _feedOrder;
  set feedOrder(List<String> v) {
    _prefs.setString('feed.order', jsonEncode(v));
  }

  List<String> get _feedOrder => _prefs.getString('feed.order') == null
      ? const []
      : (jsonDecode(_prefs.getString('feed.order')!) as List).cast<String>();

  /// Saved searches: [{query, label, sourceId}]
  List<Map<String, String>> get savedSearches {
    final raw = _prefs.getString('browse.savedSearches');
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>().map((e) => e.cast<String, String>()).toList();
  }

  set savedSearches(List<Map<String, String>> v) =>
      _prefs.setString('browse.savedSearches', jsonEncode(v));

  bool get isFirstRun => _prefs.getBool('misc.firstRun') ?? true;
  set isFirstRun(bool v) => _prefs.setBool('misc.firstRun', v);

  /// Local library root folder path.
  String? get localRoot => _prefs.getString('source.local.root');
  set localRoot(String? v) {
    if (v == null) {
      _prefs.remove('source.local.root');
    } else {
      _prefs.setString('source.local.root', v);
    }
  }

  /// Source enable state: id → enabled.
  bool isSourceEnabled(String id) => _prefs.getBool('source.$id.enabled') ?? true;
  void setSourceEnabled(String id, bool v) => _prefs.setBool('source.$id.enabled', v);

  /// Manga-level cover tint override keyed by manga key.
  Map<String, int> _coverTints = const {};
  int? coverTint(String mangaKey) {
    if (_coverTints.isEmpty && _prefs.getString('misc.coverTints') != null) {
      final raw = jsonDecode(_prefs.getString('misc.coverTints')!) as Map<String, dynamic>;
      _coverTints = raw.map((k, v) => MapEntry(k, v as int));
    }
    return _coverTints[mangaKey];
  }

  void setCoverTint(String mangaKey, int value) {
    final m = Map<String, int>.from(_coverTints)..[mangaKey] = value;
    _coverTints = m;
    _prefs.setString('misc.coverTints', jsonEncode(m));
  }

  /// Clear a settings group (used by backup import).
  Future<void> removeGroup(String prefix) async {
    for (final key in _prefs.getKeys().where((k) => k.startsWith(prefix))) {
      await _prefs.remove(key);
    }
  }

  /// Snapshot for backup.
  Map<String, dynamic> snapshot() {
    final keys = _prefs.getKeys().where((k) => !k.startsWith('source.') && !k.startsWith('misc.coverTints'));
    final map = <String, dynamic>{};
    for (final k in keys) {
      final v = _prefs.get(k);
      if (v != null) map[k] = v;
    }
    return map;
  }

  /// Bulk restore from backup (only known keys).
  Future<void> restore(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      final v = entry.value;
      if (v is String) await _prefs.setString(entry.key, v);
      if (v is bool) await _prefs.setBool(entry.key, v);
      if (v is int) await _prefs.setInt(entry.key, v);
      if (v is double) await _prefs.setDouble(entry.key, v);
    }
  }
}
