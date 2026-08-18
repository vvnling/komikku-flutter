/// Domain models — the ubiquitous language of Comicko. Services and UI
/// only ever see these classes; drift rows are mapped in repositories.
library;

/// One manga entry in the library / from a source.
class Manga {
  const Manga({
    required this.sourceId,
    required this.remoteId,
    required this.title,
    this.author,
    this.artist,
    this.description,
    this.tags = const [],
    this.status,
    this.coverUrl,
    this.coverPath,
    this.favorite = false,
    this.initialized = false,
    this.viewer = -1,
    this.dateAdded,
    this.lastUpdate,
    this.totalChapters = 0,
    this.unread = 0,
    this.lastReadAt,
    this.lastChapterUrl,
    this.extra,
    this.id,
  });

  final int? id; // internal db id (null when not stored yet)
  final String sourceId;
  final String remoteId;
  final String title;
  final String? author;
  final String? artist;
  final String? description;
  final List<String> tags;
  final String? status;
  final String? coverUrl;
  final String? coverPath; // local cover (local source)
  final bool favorite;
  final bool initialized;
  final int viewer; // per-manga viewer override; -1 = global
  final DateTime? dateAdded;
  final DateTime? lastUpdate;
  final int totalChapters;
  final int unread;
  final DateTime? lastReadAt;
  final String? lastChapterUrl;
  final Map<String, String>? extra;

  String get key => '$sourceId:$remoteId';

  Manga copyWith({
    int? id,
    String? title,
    String? author,
    String? artist,
    String? description,
    List<String>? tags,
    String? status,
    String? coverUrl,
    String? coverPath,
    bool? favorite,
    bool? initialized,
    int? viewer,
    DateTime? dateAdded,
    DateTime? lastUpdate,
    int? totalChapters,
    int? unread,
    DateTime? lastReadAt,
    String? lastChapterUrl,
    Map<String, String>? extra,
  }) =>
      Manga(
        id: id ?? this.id,
        sourceId: sourceId,
        remoteId: remoteId,
        title: title ?? this.title,
        author: author ?? this.author,
        artist: artist ?? this.artist,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        status: status ?? this.status,
        coverUrl: coverUrl ?? this.coverUrl,
        coverPath: coverPath ?? this.coverPath,
        favorite: favorite ?? this.favorite,
        initialized: initialized ?? this.initialized,
        viewer: viewer ?? this.viewer,
        dateAdded: dateAdded ?? this.dateAdded,
        lastUpdate: lastUpdate ?? this.lastUpdate,
        totalChapters: totalChapters ?? this.totalChapters,
        unread: unread ?? this.unread,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        lastChapterUrl: lastChapterUrl ?? this.lastChapterUrl,
        extra: extra ?? this.extra,
      );

  Map<String, dynamic> toBackupJson() => {
        'sourceId': sourceId,
        'remoteId': remoteId,
        'title': title,
        'author': author,
        'artist': artist,
        'description': description,
        'tags': tags,
        'status': status,
        'coverUrl': coverUrl,
        'favorite': favorite,
        'viewer': viewer,
        'dateAdded': dateAdded?.toIso8601String(),
        'lastUpdate': lastUpdate?.toIso8601String(),
        'totalChapters': totalChapters,
        'unread': unread,
        'lastReadAt': lastReadAt?.toIso8601String(),
        'lastChapterUrl': lastChapterUrl,
        'extra': extra,
      };

  factory Manga.fromBackupJson(Map<String, dynamic> j) => Manga(
        sourceId: j['sourceId'] as String,
        remoteId: j['remoteId'] as String,
        title: j['title'] as String,
        author: j['author'] as String?,
        artist: j['artist'] as String?,
        description: j['description'] as String?,
        tags: (j['tags'] as List?)?.cast<String>() ?? const [],
        status: j['status'] as String?,
        coverUrl: j['coverUrl'] as String?,
        favorite: j['favorite'] as bool? ?? false,
        viewer: j['viewer'] as int? ?? -1,
        dateAdded: DateTime.tryParse(j['dateAdded'] as String? ?? ''),
        lastUpdate: DateTime.tryParse(j['lastUpdate'] as String? ?? ''),
        totalChapters: j['totalChapters'] as int? ?? 0,
        unread: j['unread'] as int? ?? 0,
        lastReadAt: DateTime.tryParse(j['lastReadAt'] as String? ?? ''),
        lastChapterUrl: j['lastChapterUrl'] as String?,
        extra: (j['extra'] as Map<String, dynamic>?)?.cast<String, String>(),
      );
}

/// One chapter of a manga.
class Chapter {
  const Chapter({
    required this.mangaId,
    required this.url,
    required this.name,
    this.scanlator,
    this.dateUpload,
    this.number = 0,
    this.read = false,
    this.bookmark = false,
    this.lastPageRead = 0,
    this.lastReadAt,
    this.downloaded = false,
    this.downloadPath,
    this.fetched = false,
    this.id,
  });

  final int? id;
  final int mangaId;
  final String url;
  final String name;
  final String? scanlator;
  final DateTime? dateUpload;
  final double number;
  final bool read;
  final bool bookmark;
  final int lastPageRead;
  final DateTime? lastReadAt;
  final bool downloaded;
  final String? downloadPath;
  final bool fetched;

  Chapter copyWith({
    int? id,
    bool? read,
    bool? bookmark,
    int? lastPageRead,
    DateTime? lastReadAt,
    bool? downloaded,
    String? downloadPath,
    bool? fetched,
    String? name,
    String? scanlator,
    DateTime? dateUpload,
    double? number,
  }) =>
      Chapter(
        id: id ?? this.id,
        mangaId: mangaId,
        url: url,
        name: name ?? this.name,
        scanlator: scanlator ?? this.scanlator,
        dateUpload: dateUpload ?? this.dateUpload,
        number: number ?? this.number,
        read: read ?? this.read,
        bookmark: bookmark ?? this.bookmark,
        lastPageRead: lastPageRead ?? this.lastPageRead,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        downloaded: downloaded ?? this.downloaded,
        downloadPath: downloadPath ?? this.downloadPath,
        fetched: fetched ?? this.fetched,
      );

  Map<String, dynamic> toBackupJson() => {
        'url': url,
        'name': name,
        'scanlator': scanlator,
        'dateUpload': dateUpload?.toIso8601String(),
        'number': number,
        'read': read,
        'bookmark': bookmark,
        'lastPageRead': lastPageRead,
        'lastReadAt': lastReadAt?.toIso8601String(),
        'fetched': fetched,
      };
}

class Category {
  const Category({this.id, required this.name, this.order = 0, this.hidden = false, this.createdAt});

  final int? id;
  final String name;
  final int order;
  final bool hidden;
  final DateTime? createdAt;

  Category copyWith({int? id, String? name, int? order, bool? hidden}) => Category(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
        hidden: hidden ?? this.hidden,
        createdAt: createdAt,
      );

  Map<String, dynamic> toBackupJson() => {'name': name, 'order': order, 'hidden': hidden};
}

class HistoryEntry {
  const HistoryEntry({this.id, required this.mangaId, required this.chapterId, this.page = 0, this.percent = 0, required this.readAt});

  final int? id;
  final int mangaId;
  final int chapterId;
  final int page;
  final double percent; // 0..1
  final DateTime readAt;

  Map<String, dynamic> toBackupJson() => {
        'mangaId': mangaId,
        'chapterId': chapterId,
        'page': page,
        'percent': percent,
        'readAt': readAt.toIso8601String(),
      };
}

class Track {
  const Track({
    this.id,
    required this.mangaId,
    required this.trackerId,
    this.remoteId,
    this.title,
    this.status,
    this.score = 0,
    this.lastChapterRead = 0,
    this.totalChapters = 0,
    this.trackedAt,
  });

  final int? id;
  final int mangaId;
  final String trackerId;
  final String? remoteId;
  final String? title;
  final String? status;
  final double score;
  final double lastChapterRead;
  final int totalChapters;
  final DateTime? trackedAt;

  Track copyWith({
    int? id,
    String? remoteId,
    String? title,
    String? status,
    double? score,
    double? lastChapterRead,
    int? totalChapters,
    DateTime? trackedAt,
  }) =>
      Track(
        id: id ?? this.id,
        mangaId: mangaId,
        trackerId: trackerId,
        remoteId: remoteId ?? this.remoteId,
        title: title ?? this.title,
        status: status ?? this.status,
        score: score ?? this.score,
        lastChapterRead: lastChapterRead ?? this.lastChapterRead,
        totalChapters: totalChapters ?? this.totalChapters,
        trackedAt: trackedAt ?? this.trackedAt,
      );

  Map<String, dynamic> toBackupJson() => {
        'mangaId': mangaId,
        'trackerId': trackerId,
        'remoteId': remoteId,
        'title': title,
        'status': status,
        'score': score,
        'lastChapterRead': lastChapterRead,
        'totalChapters': totalChapters,
        'trackedAt': trackedAt?.toIso8601String(),
      };
}

/// A feed entry (source "latest" item).
class FeedItem {
  const FeedItem({
    required this.sourceId,
    required this.remoteId,
    required this.title,
    this.coverUrl,
    this.chapterName,
    this.chapterUrl,
    this.updatedAt,
  });

  final String sourceId;
  final String remoteId;
  final String title;
  final String? coverUrl;
  final String? chapterName;
  final String? chapterUrl;
  final DateTime? updatedAt;

  Map<String, dynamic> toBackupJson() => {
        'sourceId': sourceId,
        'remoteId': remoteId,
        'title': title,
        'coverUrl': coverUrl,
        'chapterName': chapterName,
        'chapterUrl': chapterUrl,
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class SavedSearch {
  const SavedSearch({required this.query, this.label, this.sourceId, this.createdAt});

  final String query;
  final String? label;
  final String? sourceId;
  final DateTime? createdAt;

  Map<String, String> toMap() => {
        'query': query,
        if (label != null) 'label': label!,
        if (sourceId != null) 'sourceId': sourceId!,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };

  static SavedSearch fromMap(Map<String, String> m) => SavedSearch(
        query: m['query'] ?? '',
        label: m['label'],
        sourceId: m['sourceId'],
        createdAt: DateTime.tryParse(m['createdAt'] ?? ''),
      );
}

/// Reader page descriptor coming from a source.
class SourcePage {
  const SourcePage({required this.index, required this.url, this.fileName});

  final int index;
  final String url;
  final String? fileName; // for downloaded storage naming
}

/// Lightweight manga summary from a source listing.
class SourceManga {
  const SourceManga({
    required this.sourceId,
    required this.remoteId,
    required this.title,
    this.author,
    this.description,
    this.tags = const [],
    this.status,
    this.coverUrl,
    this.initialized = false,
    this.extra,
  });

  final String sourceId;
  final String remoteId;
  final String title;
  final String? author;
  final String? description;
  final List<String> tags;
  final String? status;
  final String? coverUrl;
  final bool initialized;
  final Map<String, String>? extra;

  String get key => '$sourceId:$remoteId';

  SourceManga copyWith({
    String? title,
    String? author,
    String? description,
    List<String>? tags,
    String? status,
    String? coverUrl,
    bool? initialized,
    Map<String, String>? extra,
  }) =>
      SourceManga(
        sourceId: sourceId,
        remoteId: remoteId,
        title: title ?? this.title,
        author: author ?? this.author,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        status: status ?? this.status,
        coverUrl: coverUrl ?? this.coverUrl,
        initialized: initialized ?? this.initialized,
        extra: extra ?? this.extra,
      );
}

/// Chapter metadata from a source.
class SourceChapter {
  const SourceChapter({
    required this.url,
    required this.name,
    this.scanlator,
    this.dateUpload,
    this.number = 0,
  });

  final String url;
  final String name;
  final String? scanlator;
  final DateTime? dateUpload;
  final double number;
}
