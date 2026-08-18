import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import 'source.dart';

/// MangaDex — the largest open manga catalog. Fully anonymous API access.
class MangaDexSource extends Source {
  MangaDexSource({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
          baseUrl: 'https://api.mangadex.org',
          headers: {'User-Agent': 'Comicko/0.1 (Flutter manga reader)'},
        ));

  final Dio _dio;

  @override
  String get id => 'mangadex';
  @override
  String get name => 'MangaDex';
  @override
  String get lang => 'en';
  @override
  String? get baseUrl => 'https://mangadex.org';
  @override
  IconSpec get icon => const IconSpec('source.mangadex', color: 0xFF22356F);
  @override
  bool get supportsSuggestions => true;

  static const _coverBase = 'https://uploads.mangadex.org/covers';

  Future<Map<String, dynamic>> _get(String path, [Map<String, dynamic>? query]) async {
    try {
      final resp = await _dio.get(path, queryParameters: query);
      return resp.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw SourceException('MangaDex request failed: ${e.message}', cause: e);
    }
  }

  String? _coverFromRelations(List<dynamic> rels, String mangaId) {
    for (final r in rels) {
      if (r['type'] == 'cover_art' && r['attributes'] != null) {
        final filename = r['attributes']['fileName'];
        if (filename != null) return '$_coverBase/$mangaId/$filename.256.jpg';
      }
    }
    return null;
  }

  List<SourceManga> _mangasFromData(List<dynamic> data) {
    return data.map((m) {
      final attrs = m['attributes'] as Map<String, dynamic>;
      final titles = attrs['title'] as Map<String, dynamic>? ?? {};
      final title = titles['en'] ??
          titles['ja-ro'] ??
          titles['ja'] ??
          titles.values.firstOrNull ??
          'Untitled';
      final rels = m['relationships'] as List<dynamic>? ?? const [];
      final id = m['id'] as String;
      final tags = (attrs['tags'] as List<dynamic>? ?? const [])
          .map((t) => ((t['attributes'] as Map<String, dynamic>? ?? {})['name'])
              is Map
              ? (((t['attributes'] as Map)['name'] as Map)['en'] ?? '').toString()
              : '')
          .where((s) => s.isNotEmpty)
          .toList();
      final alt = attrs['altTitles'] as List<dynamic>? ?? const [];
      String? descEn;
      final desc = attrs['description'] as Map<String, dynamic>? ?? {};
      descEn = desc['en'] ?? desc.values.firstOrNull?.toString();
      return SourceManga(
        sourceId: id,
        remoteId: id,
        title: title,
        author: _firstAuthor(attrs),
        description: descEn,
        tags: tags,
        status: attrs['status']?.toString(),
        coverUrl: _coverFromRelations(rels, id),
        extra: {
          if (attrs['year'] != null) 'year': attrs['year'].toString(),
          if (alt.isNotEmpty) 'altTitle': (alt.first is Map ? (alt.first as Map)['en']?.toString() : alt.first?.toString()) ?? '',
        },
      );
    }).toList();
  }

  String? _firstAuthor(Map<String, dynamic> attrs) {
    final authors = attrs['author'] ?? attrs['artist'];
    if (authors is List && authors.isNotEmpty) {
      return authors.first.toString();
    }
    return null;
  }

  @override
  Future<List<SourceManga>> getPopular(int page) async {
    final data = await _get('/manga', {
      'limit': 24,
      'offset': (page - 1) * 24,
      'includes[]': 'cover_art',
      'order[followedCount]': 'desc',
      'contentRating[]': ['safe', 'suggestive'],
      'hasAvailableChapters': 'true',
    });
    return _mangasFromData((data['data'] as List?) ?? const []);
  }

  @override
  Future<List<SourceManga>> getLatest(int page) async {
    final data = await _get('/manga', {
      'limit': 20,
      'offset': (page - 1) * 20,
      'includes[]': 'cover_art',
      'order[latestUploadedChapter]': 'desc',
      'contentRating[]': ['safe', 'suggestive'],
      'hasAvailableChapters': 'true',
    });
    return _mangasFromData((data['data'] as List?) ?? const []);
  }

  @override
  Future<List<SourceManga>> search(String query, int page) async {
    final data = await _get('/manga', {
      'limit': 24,
      'offset': (page - 1) * 24,
      'includes[]': 'cover_art',
      'title': query,
      'order[relevance]': 'desc',
      'contentRating[]': ['safe', 'suggestive'],
      'hasAvailableChapters': 'true',
    });
    return _mangasFromData((data['data'] as List?) ?? const []);
  }

  @override
  Future<SourceManga> getMangaDetail(String mangaId) async {
    final data = await _get('/manga/$mangaId', {
      'includes[]': ['cover_art', 'author', 'artist'],
    });
    final m = data['data'] as Map<String, dynamic>;
    final list = _mangasFromData([m]);
    return list.first;
  }

  @override
  Future<List<SourceChapter>> getChapters(String mangaId) async {
    // fetch in ascending order; MD caps at 500/chunk → loop
    final chapters = <SourceChapter>[];
    var offset = 0;
    while (true) {
      final data = await _get('/manga/$mangaId/feed', {
        'limit': 500,
        'offset': offset,
        'translatedLanguage[]': 'en',
        'order[chapter]': 'asc',
        'includes[]': 'scanlation_group',
        'contentRating[]': ['safe', 'suggestive', 'erotica'],
      });
      final list = (data['data'] as List?) ?? const [];
      for (final c in list) {
        final attrs = c['attributes'] as Map<String, dynamic>;
        final numStr = attrs['chapter']?.toString();
        final number = numStr == null || numStr.isEmpty ? 0.0 : (double.tryParse(numStr) ?? 0.0);
        final rels = c['relationships'] as List? ?? const [];
        String? group;
        for (final r in rels) {
          if (r['type'] == 'scanlation_group') {
            group = (r['attributes'] as Map?)?.containsKey('name') == true
                ? ((r['attributes'] as Map)['name'] as String?)
                : null;
            break;
          }
        }
        final uploadedAt = DateTime.tryParse(attrs['publishAt']?.toString() ?? '');
        chapters.add(SourceChapter(
          url: c['id'] as String,
          name: 'Ch. ${attrs['chapter']?.toString() ?? '?'}${(attrs['title'] as String? ?? '').isNotEmpty ? ' — ${attrs['title']}' : ''}',
          scanlator: group,
          dateUpload: uploadedAt,
          number: number,
        ));
      }
      final total = (data['total'] as num?)?.toInt() ?? 0;
      offset += list.length;
      if (list.isEmpty || offset >= total) break;
    }
    return chapters;
  }

  @override
  Future<List<SourcePage>> getPages(String mangaId, String chapterId) async {
    final data = await _get('/at-home/server/$chapterId');
    final baseUrl = data['baseUrl'] as String;
    final hash = (data['chapter'] as Map)['hash'] as String;
    final files = ((data['chapter'] as Map)['data'] as List).cast<String>();
    return files
        .asMap()
        .entries
        .map((e) => SourcePage(index: e.key, url: '$baseUrl/data/$hash/${e.value}', fileName: e.value))
        .toList();
  }

  @override
  Future<List<SourceManga>> getSuggestions(String mangaId) async {
    // Related via the manga's links field (adaptations, spin-offs, related).
    try {
      final data = await _get('/manga/$mangaId', {'includes[]': 'cover_art'});
      final m = data['data'] as Map<String, dynamic>;
      final links = (m['attributes'] as Map)['links'] as Map<String, dynamic>? ?? {};
      final relatedIds = <String>[];
      for (final entry in links.entries) {
        final v = entry.value?.toString() ?? '';
        if (entry.key.startsWith('mu') || entry.key.startsWith('ap') || entry.key.startsWith('al')) continue;
        if (v.startsWith('/manga/')) {
          final id = v.split('/manga/').last;
          if (id.length == 36) relatedIds.add(id);
        }
      }
      // Also: search titles sharing the same tag cluster is too heavy; fall back
      // to "followed count" neighbours if no links found.
      final results = <SourceManga>[];
      for (final id in relatedIds.take(6)) {
        try {
          final d = await _get('/manga/$id', {'includes[]': 'cover_art'});
          results.addAll(_mangasFromData([d['data']]));
        } catch (_) {}
      }
      if (results.isEmpty) {
        // Search by dominant tags as a cheap suggestion pipeline.
        final tags = (m['attributes'] as Map)['tags'] as List? ?? const [];
        if (tags.isNotEmpty) {
          final tagId = (tags.first as Map)['id'] as String?;
          if (tagId != null) {
            final d = await _get('/manga', {
              'limit': 6,
              'includes[]': 'cover_art',
              'includedTags[]': tagId,
              'excludedTagsMode': 'AND',
              'order[followedCount]': 'desc',
              'contentRating[]': ['safe', 'suggestive'],
            });
            results.addAll(_mangasFromData((d['data'] as List?) ?? const []).where((x) => x.remoteId != mangaId));
          }
        }
      }
      return results.take(8).toList();
    } catch (_) {
      return const [];
    }
  }

  /// Chapter date formatter shared with the UI.
  static String formatDate(DateTime? d) {
    if (d == null) return '';
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return '${math.max(1, diff.inMinutes)}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (d.year == now.year) return DateFormat('MMM d').format(d);
    return DateFormat('MMM d, yyyy').format(d);
  }
}