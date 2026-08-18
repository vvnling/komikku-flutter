import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/data/settings_service.dart';
import '../models/models.dart';

/// Tracker abstraction — MyAnimeList/AniList-style services. Comicko ships
/// with a fully local tracker ("Comicko") plus AniList (OAuth via the
/// AniList pin flow; the client id is user-provided in settings, matching
/// the original app's BYO-client approach for FOSS clients).
abstract class Tracker {
  String get id;
  String get name;
  int get brandColor;
  bool get isLoggedIn;
  Future<void> login();
  Future<void> logout();

  /// Search remote catalog.
  Future<List<TrackResult>> search(String query);
  /// Link this entry.
  Future<void> add(Track track);
  /// Push local state to the service.
  Future<void> update(Track track);
  /// Pull remote state.
  Future<Track?> refresh(Track track);
}

class TrackResult {
  const TrackResult({required this.remoteId, required this.title, this.coverUrl, this.status, this.score = 0, this.totalChapters = 0});
  final String remoteId;
  final String title;
  final String? coverUrl;
  final String? status;
  final double score;
  final int totalChapters;
}

/// Offline tracker — everything works with no account. This is the default.
class LocalTracker extends Tracker {
  @override
  String get id => 'comicko';
  @override
  String get name => 'Comicko';
  @override
  int get brandColor => 0xFF8B5CF6;
  @override
  bool get isLoggedIn => true;
  @override
  Future<void> login() async {}
  @override
  Future<void> logout() async {}
  @override
  Future<List<TrackResult>> search(String query) async => const [];
  @override
  Future<void> add(Track track) async {}
  @override
  Future<void> update(Track track) async {}
  @override
  Future<Track?> refresh(Track track) async => track;
}

/// AniList — GraphQL API. Anonymous search works without auth; tracking
/// write-back needs an OAuth token via the pin flow.
class AniListTracker extends Tracker {
  AniListTracker(this.settings);

  final SettingsService settings;
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://graphql.anilist.co',
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  ));

  @override
  String get id => 'anilist';
  @override
  String get name => 'AniList';
  @override
  int get brandColor => 0xFF02A9FF;

  @override
  bool get isLoggedIn => settings.anilistToken != null;

  Future<Map<String, dynamic>> _query(String query, [Map<String, dynamic>? variables]) async {
    final headers = <String, String>{};
    final token = settings.anilistToken;
    if (token != null && token.isNotEmpty) headers['Authorization'] = 'Bearer $token';
    final resp = await _dio.post('', data: jsonEncode({'query': query, 'variables': variables ?? {}}), options: Options(headers: headers));
    final data = resp.data as Map<String, dynamic>;
    if (data['errors'] != null) {
      final msgs = (data['errors'] as List).map((e) => (e as Map)['message']).join('; ');
      throw Exception('AniList: $msgs');
    }
    return data['data'] as Map<String, dynamic>;
  }

  @override
  Future<void> login() async {
    final clientId = settings.anilistClientId.trim();
    if (clientId.isEmpty) {
      throw StateError('Set your AniList client id in Settings → Trackers first.');
    }
    final url = Uri.https('anilist.co', '/api/v2/oauth/authorize', {
      'client_id': clientId,
      'response_type': 'token',
    });
    await launchUrl(url, mode: LaunchMode.externalApplication);
    // The pin flow shows the token; user pastes it in Settings → Trackers.
  }

  @override
  Future<void> logout() async => settings.anilistToken = null;

  @override
  Future<List<TrackResult>> search(String query) async {
    const q = r'''
      query($q: String) {
        Page(perPage: 12) {
          media(search: $q, type: MANGA) {
            id title { romaji english }
            coverImage { medium }
            status
            averageScore
            chapters
          }
        }
      }
    ''';
    final data = await _query(q, {'q': query});
    final page = data['Page'] as Map<String, dynamic>;
    final list = page['media'] as List? ?? const [];
    return list.map((m) {
      final t = m['title'] as Map<String, dynamic>? ?? {};
      return TrackResult(
        remoteId: m['id'].toString(),
        title: (t['english'] ?? t['romaji'] ?? 'Unknown').toString(),
        coverUrl: (m['coverImage'] as Map?)?['medium']?.toString(),
        status: _mapStatus(m['status']?.toString()),
        score: ((m['averageScore'] as num?)?.toDouble() ?? 0) / 10,
        totalChapters: (m['chapters'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }

  static String? _mapStatus(String? s) => switch (s) {
        'RELEASING' => 'Reading',
        'FINISHED' => 'Completed',
        'NOT_YET_RELEASED' => 'Planning',
        'CANCELLED' => 'Dropped',
        'HIATUS' => 'Paused',
        _ => s,
      };

  @override
  Future<void> add(Track track) async {
    final remoteId = int.tryParse(track.remoteId ?? '');
    if (remoteId == null) return;
    const q = r'''
      mutation($id: Int, $status: MediaListStatus, $score: Float, $progress: Int) {
        SaveMediaListEntry(mediaId: $id, status: $status, score: $score, progress: $progress) { id }
      }
    ''';
    await _query(q, {
      'id': remoteId,
      'status': _toRemoteStatus(track.status),
      'score': track.score,
      'progress': track.lastChapterRead.round(),
    });
  }

  static String? _toRemoteStatus(String? s) => switch (s) {
        'Reading' => 'CURRENT',
        'Completed' => 'COMPLETED',
        'Planning' => 'PLANNING',
        'Dropped' => 'DROPPED',
        'Paused' => 'PAUSED',
        'Re-reading' => 'REPEATING',
        _ => null,
      };

  @override
  Future<void> update(Track track) => add(track);

  @override
  Future<Track?> refresh(Track track) async {
    if (!isLoggedIn) return track;
    final remoteId = int.tryParse(track.remoteId ?? '');
    if (remoteId == null) return track;
    const q = r'''
      query($id: Int) {
        MediaList(mediaId: $id, type: MANGA) {
          status score progress
          media { chapters title { romaji english } }
        }
      }
    ''';
    try {
      final data = await _query(q, {'id': remoteId});
      final entry = data['MediaList'] as Map<String, dynamic>?;
      if (entry == null) return track;
      final media = entry['media'] as Map<String, dynamic>? ?? {};
      final title = media['title'] as Map<String, dynamic>? ?? {};
      return track.copyWith(
        status: _mapStatus(entry['status']?.toString()),
        score: (entry['score'] as num?)?.toDouble() ?? track.score,
        lastChapterRead: (entry['progress'] as num?)?.toDouble() ?? track.lastChapterRead,
        totalChapters: (media['chapters'] as num?)?.toInt() ?? track.totalChapters,
        title: (title['english'] ?? title['romaji'] ?? track.title).toString(),
      );
    } catch (_) {
      return track;
    }
  }
}

class TrackerRegistry {
  TrackerRegistry(this.settings) : _trackers = [LocalTracker(), AniListTracker(settings)];

  final SettingsService settings;
  final List<Tracker> _trackers;

  List<Tracker> get all => List.unmodifiable(_trackers);

  Tracker byId(String id) => _trackers.firstWhere((t) => t.id == id, orElse: () => _trackers.first);

  bool get hasRemote => _trackers.any((t) => t.isLoggedIn && t.id != 'comicko');
}
