import '../models/models.dart';

/// A content provider. Mirrors the extension concept of the original app:
/// every source implements the same contract (popular/latest/search → detail
/// → chapters → pages) so the whole UI works uniformly over any source.
abstract class Source {
  String get id;
  String get name;
  String get lang;
  String? get baseUrl;
  IconSpec get icon;

  bool get supportsLatest => true;
  bool get supportsSearch => true;
  bool get supportsSuggestions => false;
  /// Entries can be merged (same title across sources).
  bool get isNsfw => false;

  /// Popular / browse listing.
  Future<List<SourceManga>> getPopular(int page);

  /// Latest entries — feeds the Feed tab.
  Future<List<SourceManga>> getLatest(int page);

  /// Free-text search.
  Future<List<SourceManga>> search(String query, int page);

  /// Full metadata for an entry.
  Future<SourceManga> getMangaDetail(String mangaId);

  /// Chapters (ascending order recommended).
  Future<List<SourceChapter>> getChapters(String mangaId);

  /// Reader pages for a chapter.
  Future<List<SourcePage>> getPages(String mangaId, String chapterId);

  /// Cover URL for a summary item (or null → placeholder).
  String? coverUrl(SourceManga manga) => manga.coverUrl;

  /// Related/recommended entries (Komikku "Suggestions").
  Future<List<SourceManga>> getSuggestions(String mangaId) async => const [];
}

/// Icon descriptor — drawn by a CustomPainter, never an emoji hack.
class IconSpec {
  const IconSpec(this.assetKey, {this.color});
  final String assetKey; // 'source.generic', 'source.mangadex', ...
  final int? color;
}

/// Registry of known sources. Enable/disable state lives in settings.
class SourceManager {
  SourceManager(this._sources);

  final List<Source> _sources;

  Source? byId(String id) {
    for (final s in _sources) {
      if (s.id == id) return s;
    }
    return null;
  }

  List<Source> get all => List.unmodifiable(_sources);

  List<Source> enabled(bool Function(Source s) isEnabled) =>
      _sources.where(isEnabled).toList();

  String? coverFallback(SourceManga m) => m.coverUrl;
}

/// Thrown by sources for network/proto issues; UI maps it to a toast.
class SourceException implements Exception {
  SourceException(this.message, {this.cause});
  final String message;
  final Object? cause;
  @override
  String toString() => message;
}