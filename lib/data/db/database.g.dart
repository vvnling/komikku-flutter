// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MangasTable extends Mangas with TableInfo<$MangasTable, MangaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MangasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
      'artist', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverUrlMeta =
      const VerificationMeta('coverUrl');
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
      'cover_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverPathMeta =
      const VerificationMeta('coverPath');
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
      'cover_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _favoriteMeta =
      const VerificationMeta('favorite');
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
      'favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _initializedMeta =
      const VerificationMeta('initialized');
  @override
  late final GeneratedColumn<bool> initialized = GeneratedColumn<bool>(
      'initialized', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("initialized" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _viewerMeta = const VerificationMeta('viewer');
  @override
  late final GeneratedColumn<int> viewer = GeneratedColumn<int>(
      'viewer', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(-1));
  static const VerificationMeta _dateAddedMeta =
      const VerificationMeta('dateAdded');
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
      'date_added', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastUpdateMeta =
      const VerificationMeta('lastUpdate');
  @override
  late final GeneratedColumn<DateTime> lastUpdate = GeneratedColumn<DateTime>(
      'last_update', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _totalChaptersMeta =
      const VerificationMeta('totalChapters');
  @override
  late final GeneratedColumn<int> totalChapters = GeneratedColumn<int>(
      'total_chapters', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unreadMeta = const VerificationMeta('unread');
  @override
  late final GeneratedColumn<int> unread = GeneratedColumn<int>(
      'unread', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastReadAtMeta =
      const VerificationMeta('lastReadAt');
  @override
  late final GeneratedColumn<DateTime> lastReadAt = GeneratedColumn<DateTime>(
      'last_read_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastChapterUrlMeta =
      const VerificationMeta('lastChapterUrl');
  @override
  late final GeneratedColumn<String> lastChapterUrl = GeneratedColumn<String>(
      'last_chapter_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _extraMeta = const VerificationMeta('extra');
  @override
  late final GeneratedColumn<String> extra = GeneratedColumn<String>(
      'extra', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sourceId,
        remoteId,
        title,
        author,
        artist,
        description,
        tags,
        status,
        coverUrl,
        coverPath,
        favorite,
        initialized,
        viewer,
        dateAdded,
        lastUpdate,
        totalChapters,
        unread,
        lastReadAt,
        lastChapterUrl,
        extra
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mangas';
  @override
  VerificationContext validateIntegrity(Insertable<MangaRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('cover_url')) {
      context.handle(_coverUrlMeta,
          coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta));
    }
    if (data.containsKey('cover_path')) {
      context.handle(_coverPathMeta,
          coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta));
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    }
    if (data.containsKey('initialized')) {
      context.handle(
          _initializedMeta,
          initialized.isAcceptableOrUnknown(
              data['initialized']!, _initializedMeta));
    }
    if (data.containsKey('viewer')) {
      context.handle(_viewerMeta,
          viewer.isAcceptableOrUnknown(data['viewer']!, _viewerMeta));
    }
    if (data.containsKey('date_added')) {
      context.handle(_dateAddedMeta,
          dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta));
    }
    if (data.containsKey('last_update')) {
      context.handle(
          _lastUpdateMeta,
          lastUpdate.isAcceptableOrUnknown(
              data['last_update']!, _lastUpdateMeta));
    }
    if (data.containsKey('total_chapters')) {
      context.handle(
          _totalChaptersMeta,
          totalChapters.isAcceptableOrUnknown(
              data['total_chapters']!, _totalChaptersMeta));
    }
    if (data.containsKey('unread')) {
      context.handle(_unreadMeta,
          unread.isAcceptableOrUnknown(data['unread']!, _unreadMeta));
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
          _lastReadAtMeta,
          lastReadAt.isAcceptableOrUnknown(
              data['last_read_at']!, _lastReadAtMeta));
    }
    if (data.containsKey('last_chapter_url')) {
      context.handle(
          _lastChapterUrlMeta,
          lastChapterUrl.isAcceptableOrUnknown(
              data['last_chapter_url']!, _lastChapterUrlMeta));
    }
    if (data.containsKey('extra')) {
      context.handle(
          _extraMeta, extra.isAcceptableOrUnknown(data['extra']!, _extraMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {sourceId, remoteId},
      ];
  @override
  MangaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MangaRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      coverUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_url']),
      coverPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_path']),
      favorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}favorite'])!,
      initialized: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}initialized'])!,
      viewer: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}viewer'])!,
      dateAdded: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_added']),
      lastUpdate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_update']),
      totalChapters: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_chapters'])!,
      unread: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unread'])!,
      lastReadAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_read_at']),
      lastChapterUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_chapter_url']),
      extra: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra']),
    );
  }

  @override
  $MangasTable createAlias(String alias) {
    return $MangasTable(attachedDatabase, alias);
  }
}

class MangaRow extends DataClass implements Insertable<MangaRow> {
  final int id;
  final String sourceId;
  final String remoteId;
  final String title;
  final String? author;
  final String? artist;
  final String? description;
  final String tags;
  final String? status;
  final String? coverUrl;
  final String? coverPath;
  final bool favorite;
  final bool initialized;
  final int viewer;
  final DateTime? dateAdded;
  final DateTime? lastUpdate;
  final int totalChapters;
  final int unread;
  final DateTime? lastReadAt;
  final String? lastChapterUrl;
  final String? extra;
  const MangaRow(
      {required this.id,
      required this.sourceId,
      required this.remoteId,
      required this.title,
      this.author,
      this.artist,
      this.description,
      required this.tags,
      this.status,
      this.coverUrl,
      this.coverPath,
      required this.favorite,
      required this.initialized,
      required this.viewer,
      this.dateAdded,
      this.lastUpdate,
      required this.totalChapters,
      required this.unread,
      this.lastReadAt,
      this.lastChapterUrl,
      this.extra});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['remote_id'] = Variable<String>(remoteId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<String>(artist);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    map['favorite'] = Variable<bool>(favorite);
    map['initialized'] = Variable<bool>(initialized);
    map['viewer'] = Variable<int>(viewer);
    if (!nullToAbsent || dateAdded != null) {
      map['date_added'] = Variable<DateTime>(dateAdded);
    }
    if (!nullToAbsent || lastUpdate != null) {
      map['last_update'] = Variable<DateTime>(lastUpdate);
    }
    map['total_chapters'] = Variable<int>(totalChapters);
    map['unread'] = Variable<int>(unread);
    if (!nullToAbsent || lastReadAt != null) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt);
    }
    if (!nullToAbsent || lastChapterUrl != null) {
      map['last_chapter_url'] = Variable<String>(lastChapterUrl);
    }
    if (!nullToAbsent || extra != null) {
      map['extra'] = Variable<String>(extra);
    }
    return map;
  }

  MangasCompanion toCompanion(bool nullToAbsent) {
    return MangasCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      remoteId: Value(remoteId),
      title: Value(title),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      artist:
          artist == null && nullToAbsent ? const Value.absent() : Value(artist),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      tags: Value(tags),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      favorite: Value(favorite),
      initialized: Value(initialized),
      viewer: Value(viewer),
      dateAdded: dateAdded == null && nullToAbsent
          ? const Value.absent()
          : Value(dateAdded),
      lastUpdate: lastUpdate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdate),
      totalChapters: Value(totalChapters),
      unread: Value(unread),
      lastReadAt: lastReadAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadAt),
      lastChapterUrl: lastChapterUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(lastChapterUrl),
      extra:
          extra == null && nullToAbsent ? const Value.absent() : Value(extra),
    );
  }

  factory MangaRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MangaRow(
      id: serializer.fromJson<int>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      artist: serializer.fromJson<String?>(json['artist']),
      description: serializer.fromJson<String?>(json['description']),
      tags: serializer.fromJson<String>(json['tags']),
      status: serializer.fromJson<String?>(json['status']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      initialized: serializer.fromJson<bool>(json['initialized']),
      viewer: serializer.fromJson<int>(json['viewer']),
      dateAdded: serializer.fromJson<DateTime?>(json['dateAdded']),
      lastUpdate: serializer.fromJson<DateTime?>(json['lastUpdate']),
      totalChapters: serializer.fromJson<int>(json['totalChapters']),
      unread: serializer.fromJson<int>(json['unread']),
      lastReadAt: serializer.fromJson<DateTime?>(json['lastReadAt']),
      lastChapterUrl: serializer.fromJson<String?>(json['lastChapterUrl']),
      extra: serializer.fromJson<String?>(json['extra']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'remoteId': serializer.toJson<String>(remoteId),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'artist': serializer.toJson<String?>(artist),
      'description': serializer.toJson<String?>(description),
      'tags': serializer.toJson<String>(tags),
      'status': serializer.toJson<String?>(status),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'coverPath': serializer.toJson<String?>(coverPath),
      'favorite': serializer.toJson<bool>(favorite),
      'initialized': serializer.toJson<bool>(initialized),
      'viewer': serializer.toJson<int>(viewer),
      'dateAdded': serializer.toJson<DateTime?>(dateAdded),
      'lastUpdate': serializer.toJson<DateTime?>(lastUpdate),
      'totalChapters': serializer.toJson<int>(totalChapters),
      'unread': serializer.toJson<int>(unread),
      'lastReadAt': serializer.toJson<DateTime?>(lastReadAt),
      'lastChapterUrl': serializer.toJson<String?>(lastChapterUrl),
      'extra': serializer.toJson<String?>(extra),
    };
  }

  MangaRow copyWith(
          {int? id,
          String? sourceId,
          String? remoteId,
          String? title,
          Value<String?> author = const Value.absent(),
          Value<String?> artist = const Value.absent(),
          Value<String?> description = const Value.absent(),
          String? tags,
          Value<String?> status = const Value.absent(),
          Value<String?> coverUrl = const Value.absent(),
          Value<String?> coverPath = const Value.absent(),
          bool? favorite,
          bool? initialized,
          int? viewer,
          Value<DateTime?> dateAdded = const Value.absent(),
          Value<DateTime?> lastUpdate = const Value.absent(),
          int? totalChapters,
          int? unread,
          Value<DateTime?> lastReadAt = const Value.absent(),
          Value<String?> lastChapterUrl = const Value.absent(),
          Value<String?> extra = const Value.absent()}) =>
      MangaRow(
        id: id ?? this.id,
        sourceId: sourceId ?? this.sourceId,
        remoteId: remoteId ?? this.remoteId,
        title: title ?? this.title,
        author: author.present ? author.value : this.author,
        artist: artist.present ? artist.value : this.artist,
        description: description.present ? description.value : this.description,
        tags: tags ?? this.tags,
        status: status.present ? status.value : this.status,
        coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
        coverPath: coverPath.present ? coverPath.value : this.coverPath,
        favorite: favorite ?? this.favorite,
        initialized: initialized ?? this.initialized,
        viewer: viewer ?? this.viewer,
        dateAdded: dateAdded.present ? dateAdded.value : this.dateAdded,
        lastUpdate: lastUpdate.present ? lastUpdate.value : this.lastUpdate,
        totalChapters: totalChapters ?? this.totalChapters,
        unread: unread ?? this.unread,
        lastReadAt: lastReadAt.present ? lastReadAt.value : this.lastReadAt,
        lastChapterUrl:
            lastChapterUrl.present ? lastChapterUrl.value : this.lastChapterUrl,
        extra: extra.present ? extra.value : this.extra,
      );
  MangaRow copyWithCompanion(MangasCompanion data) {
    return MangaRow(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      artist: data.artist.present ? data.artist.value : this.artist,
      description:
          data.description.present ? data.description.value : this.description,
      tags: data.tags.present ? data.tags.value : this.tags,
      status: data.status.present ? data.status.value : this.status,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      initialized:
          data.initialized.present ? data.initialized.value : this.initialized,
      viewer: data.viewer.present ? data.viewer.value : this.viewer,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      lastUpdate:
          data.lastUpdate.present ? data.lastUpdate.value : this.lastUpdate,
      totalChapters: data.totalChapters.present
          ? data.totalChapters.value
          : this.totalChapters,
      unread: data.unread.present ? data.unread.value : this.unread,
      lastReadAt:
          data.lastReadAt.present ? data.lastReadAt.value : this.lastReadAt,
      lastChapterUrl: data.lastChapterUrl.present
          ? data.lastChapterUrl.value
          : this.lastChapterUrl,
      extra: data.extra.present ? data.extra.value : this.extra,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MangaRow(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('artist: $artist, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('status: $status, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('coverPath: $coverPath, ')
          ..write('favorite: $favorite, ')
          ..write('initialized: $initialized, ')
          ..write('viewer: $viewer, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('lastUpdate: $lastUpdate, ')
          ..write('totalChapters: $totalChapters, ')
          ..write('unread: $unread, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('lastChapterUrl: $lastChapterUrl, ')
          ..write('extra: $extra')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        sourceId,
        remoteId,
        title,
        author,
        artist,
        description,
        tags,
        status,
        coverUrl,
        coverPath,
        favorite,
        initialized,
        viewer,
        dateAdded,
        lastUpdate,
        totalChapters,
        unread,
        lastReadAt,
        lastChapterUrl,
        extra
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MangaRow &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.remoteId == this.remoteId &&
          other.title == this.title &&
          other.author == this.author &&
          other.artist == this.artist &&
          other.description == this.description &&
          other.tags == this.tags &&
          other.status == this.status &&
          other.coverUrl == this.coverUrl &&
          other.coverPath == this.coverPath &&
          other.favorite == this.favorite &&
          other.initialized == this.initialized &&
          other.viewer == this.viewer &&
          other.dateAdded == this.dateAdded &&
          other.lastUpdate == this.lastUpdate &&
          other.totalChapters == this.totalChapters &&
          other.unread == this.unread &&
          other.lastReadAt == this.lastReadAt &&
          other.lastChapterUrl == this.lastChapterUrl &&
          other.extra == this.extra);
}

class MangasCompanion extends UpdateCompanion<MangaRow> {
  final Value<int> id;
  final Value<String> sourceId;
  final Value<String> remoteId;
  final Value<String> title;
  final Value<String?> author;
  final Value<String?> artist;
  final Value<String?> description;
  final Value<String> tags;
  final Value<String?> status;
  final Value<String?> coverUrl;
  final Value<String?> coverPath;
  final Value<bool> favorite;
  final Value<bool> initialized;
  final Value<int> viewer;
  final Value<DateTime?> dateAdded;
  final Value<DateTime?> lastUpdate;
  final Value<int> totalChapters;
  final Value<int> unread;
  final Value<DateTime?> lastReadAt;
  final Value<String?> lastChapterUrl;
  final Value<String?> extra;
  const MangasCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.artist = const Value.absent(),
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.status = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.favorite = const Value.absent(),
    this.initialized = const Value.absent(),
    this.viewer = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.lastUpdate = const Value.absent(),
    this.totalChapters = const Value.absent(),
    this.unread = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.lastChapterUrl = const Value.absent(),
    this.extra = const Value.absent(),
  });
  MangasCompanion.insert({
    this.id = const Value.absent(),
    required String sourceId,
    required String remoteId,
    required String title,
    this.author = const Value.absent(),
    this.artist = const Value.absent(),
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.status = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.favorite = const Value.absent(),
    this.initialized = const Value.absent(),
    this.viewer = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.lastUpdate = const Value.absent(),
    this.totalChapters = const Value.absent(),
    this.unread = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.lastChapterUrl = const Value.absent(),
    this.extra = const Value.absent(),
  })  : sourceId = Value(sourceId),
        remoteId = Value(remoteId),
        title = Value(title);
  static Insertable<MangaRow> custom({
    Expression<int>? id,
    Expression<String>? sourceId,
    Expression<String>? remoteId,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? artist,
    Expression<String>? description,
    Expression<String>? tags,
    Expression<String>? status,
    Expression<String>? coverUrl,
    Expression<String>? coverPath,
    Expression<bool>? favorite,
    Expression<bool>? initialized,
    Expression<int>? viewer,
    Expression<DateTime>? dateAdded,
    Expression<DateTime>? lastUpdate,
    Expression<int>? totalChapters,
    Expression<int>? unread,
    Expression<DateTime>? lastReadAt,
    Expression<String>? lastChapterUrl,
    Expression<String>? extra,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (remoteId != null) 'remote_id': remoteId,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (artist != null) 'artist': artist,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
      if (status != null) 'status': status,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (coverPath != null) 'cover_path': coverPath,
      if (favorite != null) 'favorite': favorite,
      if (initialized != null) 'initialized': initialized,
      if (viewer != null) 'viewer': viewer,
      if (dateAdded != null) 'date_added': dateAdded,
      if (lastUpdate != null) 'last_update': lastUpdate,
      if (totalChapters != null) 'total_chapters': totalChapters,
      if (unread != null) 'unread': unread,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (lastChapterUrl != null) 'last_chapter_url': lastChapterUrl,
      if (extra != null) 'extra': extra,
    });
  }

  MangasCompanion copyWith(
      {Value<int>? id,
      Value<String>? sourceId,
      Value<String>? remoteId,
      Value<String>? title,
      Value<String?>? author,
      Value<String?>? artist,
      Value<String?>? description,
      Value<String>? tags,
      Value<String?>? status,
      Value<String?>? coverUrl,
      Value<String?>? coverPath,
      Value<bool>? favorite,
      Value<bool>? initialized,
      Value<int>? viewer,
      Value<DateTime?>? dateAdded,
      Value<DateTime?>? lastUpdate,
      Value<int>? totalChapters,
      Value<int>? unread,
      Value<DateTime?>? lastReadAt,
      Value<String?>? lastChapterUrl,
      Value<String?>? extra}) {
    return MangasCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      remoteId: remoteId ?? this.remoteId,
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
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (initialized.present) {
      map['initialized'] = Variable<bool>(initialized.value);
    }
    if (viewer.present) {
      map['viewer'] = Variable<int>(viewer.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (lastUpdate.present) {
      map['last_update'] = Variable<DateTime>(lastUpdate.value);
    }
    if (totalChapters.present) {
      map['total_chapters'] = Variable<int>(totalChapters.value);
    }
    if (unread.present) {
      map['unread'] = Variable<int>(unread.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt.value);
    }
    if (lastChapterUrl.present) {
      map['last_chapter_url'] = Variable<String>(lastChapterUrl.value);
    }
    if (extra.present) {
      map['extra'] = Variable<String>(extra.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MangasCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('artist: $artist, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('status: $status, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('coverPath: $coverPath, ')
          ..write('favorite: $favorite, ')
          ..write('initialized: $initialized, ')
          ..write('viewer: $viewer, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('lastUpdate: $lastUpdate, ')
          ..write('totalChapters: $totalChapters, ')
          ..write('unread: $unread, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('lastChapterUrl: $lastChapterUrl, ')
          ..write('extra: $extra')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters
    with TableInfo<$ChaptersTable, ChapterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mangaIdMeta =
      const VerificationMeta('mangaId');
  @override
  late final GeneratedColumn<int> mangaId = GeneratedColumn<int>(
      'manga_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES mangas (id) ON DELETE CASCADE'));
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scanlatorMeta =
      const VerificationMeta('scanlator');
  @override
  late final GeneratedColumn<String> scanlator = GeneratedColumn<String>(
      'scanlator', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateUploadMeta =
      const VerificationMeta('dateUpload');
  @override
  late final GeneratedColumn<DateTime> dateUpload = GeneratedColumn<DateTime>(
      'date_upload', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<double> number = GeneratedColumn<double>(
      'number', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<bool> read = GeneratedColumn<bool>(
      'read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bookmarkMeta =
      const VerificationMeta('bookmark');
  @override
  late final GeneratedColumn<bool> bookmark = GeneratedColumn<bool>(
      'bookmark', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("bookmark" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastPageReadMeta =
      const VerificationMeta('lastPageRead');
  @override
  late final GeneratedColumn<int> lastPageRead = GeneratedColumn<int>(
      'last_page_read', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastReadAtMeta =
      const VerificationMeta('lastReadAt');
  @override
  late final GeneratedColumn<DateTime> lastReadAt = GeneratedColumn<DateTime>(
      'last_read_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _downloadedMeta =
      const VerificationMeta('downloaded');
  @override
  late final GeneratedColumn<bool> downloaded = GeneratedColumn<bool>(
      'downloaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("downloaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _downloadPathMeta =
      const VerificationMeta('downloadPath');
  @override
  late final GeneratedColumn<String> downloadPath = GeneratedColumn<String>(
      'download_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fetchedMeta =
      const VerificationMeta('fetched');
  @override
  late final GeneratedColumn<bool> fetched = GeneratedColumn<bool>(
      'fetched', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("fetched" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        mangaId,
        url,
        name,
        scanlator,
        dateUpload,
        number,
        read,
        bookmark,
        lastPageRead,
        lastReadAt,
        downloaded,
        downloadPath,
        fetched
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(Insertable<ChapterRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manga_id')) {
      context.handle(_mangaIdMeta,
          mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta));
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('scanlator')) {
      context.handle(_scanlatorMeta,
          scanlator.isAcceptableOrUnknown(data['scanlator']!, _scanlatorMeta));
    }
    if (data.containsKey('date_upload')) {
      context.handle(
          _dateUploadMeta,
          dateUpload.isAcceptableOrUnknown(
              data['date_upload']!, _dateUploadMeta));
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    }
    if (data.containsKey('read')) {
      context.handle(
          _readMeta, read.isAcceptableOrUnknown(data['read']!, _readMeta));
    }
    if (data.containsKey('bookmark')) {
      context.handle(_bookmarkMeta,
          bookmark.isAcceptableOrUnknown(data['bookmark']!, _bookmarkMeta));
    }
    if (data.containsKey('last_page_read')) {
      context.handle(
          _lastPageReadMeta,
          lastPageRead.isAcceptableOrUnknown(
              data['last_page_read']!, _lastPageReadMeta));
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
          _lastReadAtMeta,
          lastReadAt.isAcceptableOrUnknown(
              data['last_read_at']!, _lastReadAtMeta));
    }
    if (data.containsKey('downloaded')) {
      context.handle(
          _downloadedMeta,
          downloaded.isAcceptableOrUnknown(
              data['downloaded']!, _downloadedMeta));
    }
    if (data.containsKey('download_path')) {
      context.handle(
          _downloadPathMeta,
          downloadPath.isAcceptableOrUnknown(
              data['download_path']!, _downloadPathMeta));
    }
    if (data.containsKey('fetched')) {
      context.handle(_fetchedMeta,
          fetched.isAcceptableOrUnknown(data['fetched']!, _fetchedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {mangaId, url},
      ];
  @override
  ChapterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mangaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}manga_id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      scanlator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scanlator']),
      dateUpload: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_upload']),
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}number'])!,
      read: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}read'])!,
      bookmark: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}bookmark'])!,
      lastPageRead: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_page_read'])!,
      lastReadAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_read_at']),
      downloaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}downloaded'])!,
      downloadPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}download_path']),
      fetched: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}fetched'])!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class ChapterRow extends DataClass implements Insertable<ChapterRow> {
  final int id;
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
  const ChapterRow(
      {required this.id,
      required this.mangaId,
      required this.url,
      required this.name,
      this.scanlator,
      this.dateUpload,
      required this.number,
      required this.read,
      required this.bookmark,
      required this.lastPageRead,
      this.lastReadAt,
      required this.downloaded,
      this.downloadPath,
      required this.fetched});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manga_id'] = Variable<int>(mangaId);
    map['url'] = Variable<String>(url);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || scanlator != null) {
      map['scanlator'] = Variable<String>(scanlator);
    }
    if (!nullToAbsent || dateUpload != null) {
      map['date_upload'] = Variable<DateTime>(dateUpload);
    }
    map['number'] = Variable<double>(number);
    map['read'] = Variable<bool>(read);
    map['bookmark'] = Variable<bool>(bookmark);
    map['last_page_read'] = Variable<int>(lastPageRead);
    if (!nullToAbsent || lastReadAt != null) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt);
    }
    map['downloaded'] = Variable<bool>(downloaded);
    if (!nullToAbsent || downloadPath != null) {
      map['download_path'] = Variable<String>(downloadPath);
    }
    map['fetched'] = Variable<bool>(fetched);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      mangaId: Value(mangaId),
      url: Value(url),
      name: Value(name),
      scanlator: scanlator == null && nullToAbsent
          ? const Value.absent()
          : Value(scanlator),
      dateUpload: dateUpload == null && nullToAbsent
          ? const Value.absent()
          : Value(dateUpload),
      number: Value(number),
      read: Value(read),
      bookmark: Value(bookmark),
      lastPageRead: Value(lastPageRead),
      lastReadAt: lastReadAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadAt),
      downloaded: Value(downloaded),
      downloadPath: downloadPath == null && nullToAbsent
          ? const Value.absent()
          : Value(downloadPath),
      fetched: Value(fetched),
    );
  }

  factory ChapterRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterRow(
      id: serializer.fromJson<int>(json['id']),
      mangaId: serializer.fromJson<int>(json['mangaId']),
      url: serializer.fromJson<String>(json['url']),
      name: serializer.fromJson<String>(json['name']),
      scanlator: serializer.fromJson<String?>(json['scanlator']),
      dateUpload: serializer.fromJson<DateTime?>(json['dateUpload']),
      number: serializer.fromJson<double>(json['number']),
      read: serializer.fromJson<bool>(json['read']),
      bookmark: serializer.fromJson<bool>(json['bookmark']),
      lastPageRead: serializer.fromJson<int>(json['lastPageRead']),
      lastReadAt: serializer.fromJson<DateTime?>(json['lastReadAt']),
      downloaded: serializer.fromJson<bool>(json['downloaded']),
      downloadPath: serializer.fromJson<String?>(json['downloadPath']),
      fetched: serializer.fromJson<bool>(json['fetched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mangaId': serializer.toJson<int>(mangaId),
      'url': serializer.toJson<String>(url),
      'name': serializer.toJson<String>(name),
      'scanlator': serializer.toJson<String?>(scanlator),
      'dateUpload': serializer.toJson<DateTime?>(dateUpload),
      'number': serializer.toJson<double>(number),
      'read': serializer.toJson<bool>(read),
      'bookmark': serializer.toJson<bool>(bookmark),
      'lastPageRead': serializer.toJson<int>(lastPageRead),
      'lastReadAt': serializer.toJson<DateTime?>(lastReadAt),
      'downloaded': serializer.toJson<bool>(downloaded),
      'downloadPath': serializer.toJson<String?>(downloadPath),
      'fetched': serializer.toJson<bool>(fetched),
    };
  }

  ChapterRow copyWith(
          {int? id,
          int? mangaId,
          String? url,
          String? name,
          Value<String?> scanlator = const Value.absent(),
          Value<DateTime?> dateUpload = const Value.absent(),
          double? number,
          bool? read,
          bool? bookmark,
          int? lastPageRead,
          Value<DateTime?> lastReadAt = const Value.absent(),
          bool? downloaded,
          Value<String?> downloadPath = const Value.absent(),
          bool? fetched}) =>
      ChapterRow(
        id: id ?? this.id,
        mangaId: mangaId ?? this.mangaId,
        url: url ?? this.url,
        name: name ?? this.name,
        scanlator: scanlator.present ? scanlator.value : this.scanlator,
        dateUpload: dateUpload.present ? dateUpload.value : this.dateUpload,
        number: number ?? this.number,
        read: read ?? this.read,
        bookmark: bookmark ?? this.bookmark,
        lastPageRead: lastPageRead ?? this.lastPageRead,
        lastReadAt: lastReadAt.present ? lastReadAt.value : this.lastReadAt,
        downloaded: downloaded ?? this.downloaded,
        downloadPath:
            downloadPath.present ? downloadPath.value : this.downloadPath,
        fetched: fetched ?? this.fetched,
      );
  ChapterRow copyWithCompanion(ChaptersCompanion data) {
    return ChapterRow(
      id: data.id.present ? data.id.value : this.id,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      url: data.url.present ? data.url.value : this.url,
      name: data.name.present ? data.name.value : this.name,
      scanlator: data.scanlator.present ? data.scanlator.value : this.scanlator,
      dateUpload:
          data.dateUpload.present ? data.dateUpload.value : this.dateUpload,
      number: data.number.present ? data.number.value : this.number,
      read: data.read.present ? data.read.value : this.read,
      bookmark: data.bookmark.present ? data.bookmark.value : this.bookmark,
      lastPageRead: data.lastPageRead.present
          ? data.lastPageRead.value
          : this.lastPageRead,
      lastReadAt:
          data.lastReadAt.present ? data.lastReadAt.value : this.lastReadAt,
      downloaded:
          data.downloaded.present ? data.downloaded.value : this.downloaded,
      downloadPath: data.downloadPath.present
          ? data.downloadPath.value
          : this.downloadPath,
      fetched: data.fetched.present ? data.fetched.value : this.fetched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterRow(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('url: $url, ')
          ..write('name: $name, ')
          ..write('scanlator: $scanlator, ')
          ..write('dateUpload: $dateUpload, ')
          ..write('number: $number, ')
          ..write('read: $read, ')
          ..write('bookmark: $bookmark, ')
          ..write('lastPageRead: $lastPageRead, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('downloaded: $downloaded, ')
          ..write('downloadPath: $downloadPath, ')
          ..write('fetched: $fetched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      mangaId,
      url,
      name,
      scanlator,
      dateUpload,
      number,
      read,
      bookmark,
      lastPageRead,
      lastReadAt,
      downloaded,
      downloadPath,
      fetched);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterRow &&
          other.id == this.id &&
          other.mangaId == this.mangaId &&
          other.url == this.url &&
          other.name == this.name &&
          other.scanlator == this.scanlator &&
          other.dateUpload == this.dateUpload &&
          other.number == this.number &&
          other.read == this.read &&
          other.bookmark == this.bookmark &&
          other.lastPageRead == this.lastPageRead &&
          other.lastReadAt == this.lastReadAt &&
          other.downloaded == this.downloaded &&
          other.downloadPath == this.downloadPath &&
          other.fetched == this.fetched);
}

class ChaptersCompanion extends UpdateCompanion<ChapterRow> {
  final Value<int> id;
  final Value<int> mangaId;
  final Value<String> url;
  final Value<String> name;
  final Value<String?> scanlator;
  final Value<DateTime?> dateUpload;
  final Value<double> number;
  final Value<bool> read;
  final Value<bool> bookmark;
  final Value<int> lastPageRead;
  final Value<DateTime?> lastReadAt;
  final Value<bool> downloaded;
  final Value<String?> downloadPath;
  final Value<bool> fetched;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.url = const Value.absent(),
    this.name = const Value.absent(),
    this.scanlator = const Value.absent(),
    this.dateUpload = const Value.absent(),
    this.number = const Value.absent(),
    this.read = const Value.absent(),
    this.bookmark = const Value.absent(),
    this.lastPageRead = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.downloaded = const Value.absent(),
    this.downloadPath = const Value.absent(),
    this.fetched = const Value.absent(),
  });
  ChaptersCompanion.insert({
    this.id = const Value.absent(),
    required int mangaId,
    required String url,
    required String name,
    this.scanlator = const Value.absent(),
    this.dateUpload = const Value.absent(),
    this.number = const Value.absent(),
    this.read = const Value.absent(),
    this.bookmark = const Value.absent(),
    this.lastPageRead = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.downloaded = const Value.absent(),
    this.downloadPath = const Value.absent(),
    this.fetched = const Value.absent(),
  })  : mangaId = Value(mangaId),
        url = Value(url),
        name = Value(name);
  static Insertable<ChapterRow> custom({
    Expression<int>? id,
    Expression<int>? mangaId,
    Expression<String>? url,
    Expression<String>? name,
    Expression<String>? scanlator,
    Expression<DateTime>? dateUpload,
    Expression<double>? number,
    Expression<bool>? read,
    Expression<bool>? bookmark,
    Expression<int>? lastPageRead,
    Expression<DateTime>? lastReadAt,
    Expression<bool>? downloaded,
    Expression<String>? downloadPath,
    Expression<bool>? fetched,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mangaId != null) 'manga_id': mangaId,
      if (url != null) 'url': url,
      if (name != null) 'name': name,
      if (scanlator != null) 'scanlator': scanlator,
      if (dateUpload != null) 'date_upload': dateUpload,
      if (number != null) 'number': number,
      if (read != null) 'read': read,
      if (bookmark != null) 'bookmark': bookmark,
      if (lastPageRead != null) 'last_page_read': lastPageRead,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (downloaded != null) 'downloaded': downloaded,
      if (downloadPath != null) 'download_path': downloadPath,
      if (fetched != null) 'fetched': fetched,
    });
  }

  ChaptersCompanion copyWith(
      {Value<int>? id,
      Value<int>? mangaId,
      Value<String>? url,
      Value<String>? name,
      Value<String?>? scanlator,
      Value<DateTime?>? dateUpload,
      Value<double>? number,
      Value<bool>? read,
      Value<bool>? bookmark,
      Value<int>? lastPageRead,
      Value<DateTime?>? lastReadAt,
      Value<bool>? downloaded,
      Value<String?>? downloadPath,
      Value<bool>? fetched}) {
    return ChaptersCompanion(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      url: url ?? this.url,
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
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<int>(mangaId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (scanlator.present) {
      map['scanlator'] = Variable<String>(scanlator.value);
    }
    if (dateUpload.present) {
      map['date_upload'] = Variable<DateTime>(dateUpload.value);
    }
    if (number.present) {
      map['number'] = Variable<double>(number.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    if (bookmark.present) {
      map['bookmark'] = Variable<bool>(bookmark.value);
    }
    if (lastPageRead.present) {
      map['last_page_read'] = Variable<int>(lastPageRead.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt.value);
    }
    if (downloaded.present) {
      map['downloaded'] = Variable<bool>(downloaded.value);
    }
    if (downloadPath.present) {
      map['download_path'] = Variable<String>(downloadPath.value);
    }
    if (fetched.present) {
      map['fetched'] = Variable<bool>(fetched.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('url: $url, ')
          ..write('name: $name, ')
          ..write('scanlator: $scanlator, ')
          ..write('dateUpload: $dateUpload, ')
          ..write('number: $number, ')
          ..write('read: $read, ')
          ..write('bookmark: $bookmark, ')
          ..write('lastPageRead: $lastPageRead, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('downloaded: $downloaded, ')
          ..write('downloadPath: $downloadPath, ')
          ..write('fetched: $fetched')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
      'hidden', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("hidden" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, order, hidden, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    if (data.containsKey('hidden')) {
      context.handle(_hiddenMeta,
          hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      hidden: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hidden'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final int id;
  final String name;
  final int order;
  final bool hidden;
  final DateTime? createdAt;
  const CategoryRow(
      {required this.id,
      required this.name,
      required this.order,
      required this.hidden,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['order'] = Variable<int>(order);
    map['hidden'] = Variable<bool>(hidden);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      order: Value(order),
      hidden: Value(hidden),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory CategoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int>(json['order']),
      hidden: serializer.fromJson<bool>(json['hidden']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int>(order),
      'hidden': serializer.toJson<bool>(hidden),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  CategoryRow copyWith(
          {int? id,
          String? name,
          int? order,
          bool? hidden,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      CategoryRow(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
        hidden: hidden ?? this.hidden,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      order: data.order.present ? data.order.value : this.order,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('hidden: $hidden, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, order, hidden, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.order == this.order &&
          other.hidden == this.hidden &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> order;
  final Value<bool> hidden;
  final Value<DateTime?> createdAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
    this.hidden = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.order = const Value.absent(),
    this.hidden = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? order,
    Expression<bool>? hidden,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
      if (hidden != null) 'hidden': hidden,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? order,
      Value<bool>? hidden,
      Value<DateTime?>? createdAt}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      hidden: hidden ?? this.hidden,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('hidden: $hidden, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MangaCategoryTable extends MangaCategory
    with TableInfo<$MangaCategoryTable, MangaCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MangaCategoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mangaIdMeta =
      const VerificationMeta('mangaId');
  @override
  late final GeneratedColumn<int> mangaId = GeneratedColumn<int>(
      'manga_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES mangas (id) ON DELETE CASCADE'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [mangaId, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manga_category';
  @override
  VerificationContext validateIntegrity(Insertable<MangaCategoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('manga_id')) {
      context.handle(_mangaIdMeta,
          mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta));
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mangaId, categoryId};
  @override
  MangaCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MangaCategoryRow(
      mangaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}manga_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
    );
  }

  @override
  $MangaCategoryTable createAlias(String alias) {
    return $MangaCategoryTable(attachedDatabase, alias);
  }
}

class MangaCategoryRow extends DataClass
    implements Insertable<MangaCategoryRow> {
  final int mangaId;
  final int categoryId;
  const MangaCategoryRow({required this.mangaId, required this.categoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['manga_id'] = Variable<int>(mangaId);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  MangaCategoryCompanion toCompanion(bool nullToAbsent) {
    return MangaCategoryCompanion(
      mangaId: Value(mangaId),
      categoryId: Value(categoryId),
    );
  }

  factory MangaCategoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MangaCategoryRow(
      mangaId: serializer.fromJson<int>(json['mangaId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mangaId': serializer.toJson<int>(mangaId),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  MangaCategoryRow copyWith({int? mangaId, int? categoryId}) =>
      MangaCategoryRow(
        mangaId: mangaId ?? this.mangaId,
        categoryId: categoryId ?? this.categoryId,
      );
  MangaCategoryRow copyWithCompanion(MangaCategoryCompanion data) {
    return MangaCategoryRow(
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MangaCategoryRow(')
          ..write('mangaId: $mangaId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mangaId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MangaCategoryRow &&
          other.mangaId == this.mangaId &&
          other.categoryId == this.categoryId);
}

class MangaCategoryCompanion extends UpdateCompanion<MangaCategoryRow> {
  final Value<int> mangaId;
  final Value<int> categoryId;
  final Value<int> rowid;
  const MangaCategoryCompanion({
    this.mangaId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MangaCategoryCompanion.insert({
    required int mangaId,
    required int categoryId,
    this.rowid = const Value.absent(),
  })  : mangaId = Value(mangaId),
        categoryId = Value(categoryId);
  static Insertable<MangaCategoryRow> custom({
    Expression<int>? mangaId,
    Expression<int>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mangaId != null) 'manga_id': mangaId,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MangaCategoryCompanion copyWith(
      {Value<int>? mangaId, Value<int>? categoryId, Value<int>? rowid}) {
    return MangaCategoryCompanion(
      mangaId: mangaId ?? this.mangaId,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mangaId.present) {
      map['manga_id'] = Variable<int>(mangaId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MangaCategoryCompanion(')
          ..write('mangaId: $mangaId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoryTable extends History with TableInfo<$HistoryTable, HistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mangaIdMeta =
      const VerificationMeta('mangaId');
  @override
  late final GeneratedColumn<int> mangaId = GeneratedColumn<int>(
      'manga_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES mangas (id) ON DELETE CASCADE'));
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<int> chapterId = GeneratedColumn<int>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES chapters (id) ON DELETE CASCADE'));
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
      'page', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _percentMeta =
      const VerificationMeta('percent');
  @override
  late final GeneratedColumn<double> percent = GeneratedColumn<double>(
      'percent', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
      'read_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, mangaId, chapterId, page, percent, readAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history';
  @override
  VerificationContext validateIntegrity(Insertable<HistoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manga_id')) {
      context.handle(_mangaIdMeta,
          mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta));
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
          _pageMeta, page.isAcceptableOrUnknown(data['page']!, _pageMeta));
    }
    if (data.containsKey('percent')) {
      context.handle(_percentMeta,
          percent.isAcceptableOrUnknown(data['percent']!, _percentMeta));
    }
    if (data.containsKey('read_at')) {
      context.handle(_readAtMeta,
          readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta));
    } else if (isInserting) {
      context.missing(_readAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {mangaId, chapterId},
      ];
  @override
  HistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mangaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}manga_id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter_id'])!,
      page: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page'])!,
      percent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}percent'])!,
      readAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}read_at'])!,
    );
  }

  @override
  $HistoryTable createAlias(String alias) {
    return $HistoryTable(attachedDatabase, alias);
  }
}

class HistoryRow extends DataClass implements Insertable<HistoryRow> {
  final int id;
  final int mangaId;
  final int chapterId;
  final int page;
  final double percent;
  final DateTime readAt;
  const HistoryRow(
      {required this.id,
      required this.mangaId,
      required this.chapterId,
      required this.page,
      required this.percent,
      required this.readAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manga_id'] = Variable<int>(mangaId);
    map['chapter_id'] = Variable<int>(chapterId);
    map['page'] = Variable<int>(page);
    map['percent'] = Variable<double>(percent);
    map['read_at'] = Variable<DateTime>(readAt);
    return map;
  }

  HistoryCompanion toCompanion(bool nullToAbsent) {
    return HistoryCompanion(
      id: Value(id),
      mangaId: Value(mangaId),
      chapterId: Value(chapterId),
      page: Value(page),
      percent: Value(percent),
      readAt: Value(readAt),
    );
  }

  factory HistoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryRow(
      id: serializer.fromJson<int>(json['id']),
      mangaId: serializer.fromJson<int>(json['mangaId']),
      chapterId: serializer.fromJson<int>(json['chapterId']),
      page: serializer.fromJson<int>(json['page']),
      percent: serializer.fromJson<double>(json['percent']),
      readAt: serializer.fromJson<DateTime>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mangaId': serializer.toJson<int>(mangaId),
      'chapterId': serializer.toJson<int>(chapterId),
      'page': serializer.toJson<int>(page),
      'percent': serializer.toJson<double>(percent),
      'readAt': serializer.toJson<DateTime>(readAt),
    };
  }

  HistoryRow copyWith(
          {int? id,
          int? mangaId,
          int? chapterId,
          int? page,
          double? percent,
          DateTime? readAt}) =>
      HistoryRow(
        id: id ?? this.id,
        mangaId: mangaId ?? this.mangaId,
        chapterId: chapterId ?? this.chapterId,
        page: page ?? this.page,
        percent: percent ?? this.percent,
        readAt: readAt ?? this.readAt,
      );
  HistoryRow copyWithCompanion(HistoryCompanion data) {
    return HistoryRow(
      id: data.id.present ? data.id.value : this.id,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      page: data.page.present ? data.page.value : this.page,
      percent: data.percent.present ? data.percent.value : this.percent,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryRow(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('chapterId: $chapterId, ')
          ..write('page: $page, ')
          ..write('percent: $percent, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, mangaId, chapterId, page, percent, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryRow &&
          other.id == this.id &&
          other.mangaId == this.mangaId &&
          other.chapterId == this.chapterId &&
          other.page == this.page &&
          other.percent == this.percent &&
          other.readAt == this.readAt);
}

class HistoryCompanion extends UpdateCompanion<HistoryRow> {
  final Value<int> id;
  final Value<int> mangaId;
  final Value<int> chapterId;
  final Value<int> page;
  final Value<double> percent;
  final Value<DateTime> readAt;
  const HistoryCompanion({
    this.id = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.page = const Value.absent(),
    this.percent = const Value.absent(),
    this.readAt = const Value.absent(),
  });
  HistoryCompanion.insert({
    this.id = const Value.absent(),
    required int mangaId,
    required int chapterId,
    this.page = const Value.absent(),
    this.percent = const Value.absent(),
    required DateTime readAt,
  })  : mangaId = Value(mangaId),
        chapterId = Value(chapterId),
        readAt = Value(readAt);
  static Insertable<HistoryRow> custom({
    Expression<int>? id,
    Expression<int>? mangaId,
    Expression<int>? chapterId,
    Expression<int>? page,
    Expression<double>? percent,
    Expression<DateTime>? readAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mangaId != null) 'manga_id': mangaId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (page != null) 'page': page,
      if (percent != null) 'percent': percent,
      if (readAt != null) 'read_at': readAt,
    });
  }

  HistoryCompanion copyWith(
      {Value<int>? id,
      Value<int>? mangaId,
      Value<int>? chapterId,
      Value<int>? page,
      Value<double>? percent,
      Value<DateTime>? readAt}) {
    return HistoryCompanion(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      chapterId: chapterId ?? this.chapterId,
      page: page ?? this.page,
      percent: percent ?? this.percent,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<int>(mangaId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<int>(chapterId.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (percent.present) {
      map['percent'] = Variable<double>(percent.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryCompanion(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('chapterId: $chapterId, ')
          ..write('page: $page, ')
          ..write('percent: $percent, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }
}

class $TracksTable extends Tracks with TableInfo<$TracksTable, TrackRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mangaIdMeta =
      const VerificationMeta('mangaId');
  @override
  late final GeneratedColumn<int> mangaId = GeneratedColumn<int>(
      'manga_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES mangas (id) ON DELETE CASCADE'));
  static const VerificationMeta _trackerIdMeta =
      const VerificationMeta('trackerId');
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
      'tracker_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
      'score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastChapterReadMeta =
      const VerificationMeta('lastChapterRead');
  @override
  late final GeneratedColumn<double> lastChapterRead = GeneratedColumn<double>(
      'last_chapter_read', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalChaptersMeta =
      const VerificationMeta('totalChapters');
  @override
  late final GeneratedColumn<int> totalChapters = GeneratedColumn<int>(
      'total_chapters', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _trackedAtMeta =
      const VerificationMeta('trackedAt');
  @override
  late final GeneratedColumn<DateTime> trackedAt = GeneratedColumn<DateTime>(
      'tracked_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        mangaId,
        trackerId,
        remoteId,
        title,
        status,
        score,
        lastChapterRead,
        totalChapters,
        trackedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracks';
  @override
  VerificationContext validateIntegrity(Insertable<TrackRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manga_id')) {
      context.handle(_mangaIdMeta,
          mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta));
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('tracker_id')) {
      context.handle(_trackerIdMeta,
          trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta));
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    if (data.containsKey('last_chapter_read')) {
      context.handle(
          _lastChapterReadMeta,
          lastChapterRead.isAcceptableOrUnknown(
              data['last_chapter_read']!, _lastChapterReadMeta));
    }
    if (data.containsKey('total_chapters')) {
      context.handle(
          _totalChaptersMeta,
          totalChapters.isAcceptableOrUnknown(
              data['total_chapters']!, _totalChaptersMeta));
    }
    if (data.containsKey('tracked_at')) {
      context.handle(_trackedAtMeta,
          trackedAt.isAcceptableOrUnknown(data['tracked_at']!, _trackedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {mangaId, trackerId},
      ];
  @override
  TrackRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mangaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}manga_id'])!,
      trackerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tracker_id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}score'])!,
      lastChapterRead: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}last_chapter_read'])!,
      totalChapters: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_chapters'])!,
      trackedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}tracked_at']),
    );
  }

  @override
  $TracksTable createAlias(String alias) {
    return $TracksTable(attachedDatabase, alias);
  }
}

class TrackRow extends DataClass implements Insertable<TrackRow> {
  final int id;
  final int mangaId;
  final String trackerId;
  final String? remoteId;
  final String? title;
  final String? status;
  final double score;
  final double lastChapterRead;
  final int totalChapters;
  final DateTime? trackedAt;
  const TrackRow(
      {required this.id,
      required this.mangaId,
      required this.trackerId,
      this.remoteId,
      this.title,
      this.status,
      required this.score,
      required this.lastChapterRead,
      required this.totalChapters,
      this.trackedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manga_id'] = Variable<int>(mangaId);
    map['tracker_id'] = Variable<String>(trackerId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    map['score'] = Variable<double>(score);
    map['last_chapter_read'] = Variable<double>(lastChapterRead);
    map['total_chapters'] = Variable<int>(totalChapters);
    if (!nullToAbsent || trackedAt != null) {
      map['tracked_at'] = Variable<DateTime>(trackedAt);
    }
    return map;
  }

  TracksCompanion toCompanion(bool nullToAbsent) {
    return TracksCompanion(
      id: Value(id),
      mangaId: Value(mangaId),
      trackerId: Value(trackerId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      score: Value(score),
      lastChapterRead: Value(lastChapterRead),
      totalChapters: Value(totalChapters),
      trackedAt: trackedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(trackedAt),
    );
  }

  factory TrackRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackRow(
      id: serializer.fromJson<int>(json['id']),
      mangaId: serializer.fromJson<int>(json['mangaId']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      title: serializer.fromJson<String?>(json['title']),
      status: serializer.fromJson<String?>(json['status']),
      score: serializer.fromJson<double>(json['score']),
      lastChapterRead: serializer.fromJson<double>(json['lastChapterRead']),
      totalChapters: serializer.fromJson<int>(json['totalChapters']),
      trackedAt: serializer.fromJson<DateTime?>(json['trackedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mangaId': serializer.toJson<int>(mangaId),
      'trackerId': serializer.toJson<String>(trackerId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'title': serializer.toJson<String?>(title),
      'status': serializer.toJson<String?>(status),
      'score': serializer.toJson<double>(score),
      'lastChapterRead': serializer.toJson<double>(lastChapterRead),
      'totalChapters': serializer.toJson<int>(totalChapters),
      'trackedAt': serializer.toJson<DateTime?>(trackedAt),
    };
  }

  TrackRow copyWith(
          {int? id,
          int? mangaId,
          String? trackerId,
          Value<String?> remoteId = const Value.absent(),
          Value<String?> title = const Value.absent(),
          Value<String?> status = const Value.absent(),
          double? score,
          double? lastChapterRead,
          int? totalChapters,
          Value<DateTime?> trackedAt = const Value.absent()}) =>
      TrackRow(
        id: id ?? this.id,
        mangaId: mangaId ?? this.mangaId,
        trackerId: trackerId ?? this.trackerId,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        title: title.present ? title.value : this.title,
        status: status.present ? status.value : this.status,
        score: score ?? this.score,
        lastChapterRead: lastChapterRead ?? this.lastChapterRead,
        totalChapters: totalChapters ?? this.totalChapters,
        trackedAt: trackedAt.present ? trackedAt.value : this.trackedAt,
      );
  TrackRow copyWithCompanion(TracksCompanion data) {
    return TrackRow(
      id: data.id.present ? data.id.value : this.id,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      score: data.score.present ? data.score.value : this.score,
      lastChapterRead: data.lastChapterRead.present
          ? data.lastChapterRead.value
          : this.lastChapterRead,
      totalChapters: data.totalChapters.present
          ? data.totalChapters.value
          : this.totalChapters,
      trackedAt: data.trackedAt.present ? data.trackedAt.value : this.trackedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackRow(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('trackerId: $trackerId, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('score: $score, ')
          ..write('lastChapterRead: $lastChapterRead, ')
          ..write('totalChapters: $totalChapters, ')
          ..write('trackedAt: $trackedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mangaId, trackerId, remoteId, title,
      status, score, lastChapterRead, totalChapters, trackedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackRow &&
          other.id == this.id &&
          other.mangaId == this.mangaId &&
          other.trackerId == this.trackerId &&
          other.remoteId == this.remoteId &&
          other.title == this.title &&
          other.status == this.status &&
          other.score == this.score &&
          other.lastChapterRead == this.lastChapterRead &&
          other.totalChapters == this.totalChapters &&
          other.trackedAt == this.trackedAt);
}

class TracksCompanion extends UpdateCompanion<TrackRow> {
  final Value<int> id;
  final Value<int> mangaId;
  final Value<String> trackerId;
  final Value<String?> remoteId;
  final Value<String?> title;
  final Value<String?> status;
  final Value<double> score;
  final Value<double> lastChapterRead;
  final Value<int> totalChapters;
  final Value<DateTime?> trackedAt;
  const TracksCompanion({
    this.id = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.score = const Value.absent(),
    this.lastChapterRead = const Value.absent(),
    this.totalChapters = const Value.absent(),
    this.trackedAt = const Value.absent(),
  });
  TracksCompanion.insert({
    this.id = const Value.absent(),
    required int mangaId,
    required String trackerId,
    this.remoteId = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.score = const Value.absent(),
    this.lastChapterRead = const Value.absent(),
    this.totalChapters = const Value.absent(),
    this.trackedAt = const Value.absent(),
  })  : mangaId = Value(mangaId),
        trackerId = Value(trackerId);
  static Insertable<TrackRow> custom({
    Expression<int>? id,
    Expression<int>? mangaId,
    Expression<String>? trackerId,
    Expression<String>? remoteId,
    Expression<String>? title,
    Expression<String>? status,
    Expression<double>? score,
    Expression<double>? lastChapterRead,
    Expression<int>? totalChapters,
    Expression<DateTime>? trackedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mangaId != null) 'manga_id': mangaId,
      if (trackerId != null) 'tracker_id': trackerId,
      if (remoteId != null) 'remote_id': remoteId,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (score != null) 'score': score,
      if (lastChapterRead != null) 'last_chapter_read': lastChapterRead,
      if (totalChapters != null) 'total_chapters': totalChapters,
      if (trackedAt != null) 'tracked_at': trackedAt,
    });
  }

  TracksCompanion copyWith(
      {Value<int>? id,
      Value<int>? mangaId,
      Value<String>? trackerId,
      Value<String?>? remoteId,
      Value<String?>? title,
      Value<String?>? status,
      Value<double>? score,
      Value<double>? lastChapterRead,
      Value<int>? totalChapters,
      Value<DateTime?>? trackedAt}) {
    return TracksCompanion(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      trackerId: trackerId ?? this.trackerId,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      status: status ?? this.status,
      score: score ?? this.score,
      lastChapterRead: lastChapterRead ?? this.lastChapterRead,
      totalChapters: totalChapters ?? this.totalChapters,
      trackedAt: trackedAt ?? this.trackedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<int>(mangaId.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (lastChapterRead.present) {
      map['last_chapter_read'] = Variable<double>(lastChapterRead.value);
    }
    if (totalChapters.present) {
      map['total_chapters'] = Variable<int>(totalChapters.value);
    }
    if (trackedAt.present) {
      map['tracked_at'] = Variable<DateTime>(trackedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TracksCompanion(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('trackerId: $trackerId, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('score: $score, ')
          ..write('lastChapterRead: $lastChapterRead, ')
          ..write('totalChapters: $totalChapters, ')
          ..write('trackedAt: $trackedAt')
          ..write(')'))
        .toString();
  }
}

class $FeedTable extends Feed with TableInfo<$FeedTable, FeedRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _coverUrlMeta =
      const VerificationMeta('coverUrl');
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
      'cover_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chapterNameMeta =
      const VerificationMeta('chapterName');
  @override
  late final GeneratedColumn<String> chapterName = GeneratedColumn<String>(
      'chapter_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chapterUrlMeta =
      const VerificationMeta('chapterUrl');
  @override
  late final GeneratedColumn<String> chapterUrl = GeneratedColumn<String>(
      'chapter_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sourceId,
        remoteId,
        title,
        coverUrl,
        chapterName,
        chapterUrl,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feed';
  @override
  VerificationContext validateIntegrity(Insertable<FeedRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('cover_url')) {
      context.handle(_coverUrlMeta,
          coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta));
    }
    if (data.containsKey('chapter_name')) {
      context.handle(
          _chapterNameMeta,
          chapterName.isAcceptableOrUnknown(
              data['chapter_name']!, _chapterNameMeta));
    }
    if (data.containsKey('chapter_url')) {
      context.handle(
          _chapterUrlMeta,
          chapterUrl.isAcceptableOrUnknown(
              data['chapter_url']!, _chapterUrlMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {sourceId, remoteId},
      ];
  @override
  FeedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      coverUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_url']),
      chapterName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_name']),
      chapterUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_url']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $FeedTable createAlias(String alias) {
    return $FeedTable(attachedDatabase, alias);
  }
}

class FeedRow extends DataClass implements Insertable<FeedRow> {
  final int id;
  final String sourceId;
  final String remoteId;
  final String title;
  final String? coverUrl;
  final String? chapterName;
  final String? chapterUrl;
  final DateTime? updatedAt;
  const FeedRow(
      {required this.id,
      required this.sourceId,
      required this.remoteId,
      required this.title,
      this.coverUrl,
      this.chapterName,
      this.chapterUrl,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['remote_id'] = Variable<String>(remoteId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || chapterName != null) {
      map['chapter_name'] = Variable<String>(chapterName);
    }
    if (!nullToAbsent || chapterUrl != null) {
      map['chapter_url'] = Variable<String>(chapterUrl);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  FeedCompanion toCompanion(bool nullToAbsent) {
    return FeedCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      remoteId: Value(remoteId),
      title: Value(title),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      chapterName: chapterName == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterName),
      chapterUrl: chapterUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterUrl),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory FeedRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedRow(
      id: serializer.fromJson<int>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      title: serializer.fromJson<String>(json['title']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      chapterName: serializer.fromJson<String?>(json['chapterName']),
      chapterUrl: serializer.fromJson<String?>(json['chapterUrl']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'remoteId': serializer.toJson<String>(remoteId),
      'title': serializer.toJson<String>(title),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'chapterName': serializer.toJson<String?>(chapterName),
      'chapterUrl': serializer.toJson<String?>(chapterUrl),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  FeedRow copyWith(
          {int? id,
          String? sourceId,
          String? remoteId,
          String? title,
          Value<String?> coverUrl = const Value.absent(),
          Value<String?> chapterName = const Value.absent(),
          Value<String?> chapterUrl = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      FeedRow(
        id: id ?? this.id,
        sourceId: sourceId ?? this.sourceId,
        remoteId: remoteId ?? this.remoteId,
        title: title ?? this.title,
        coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
        chapterName: chapterName.present ? chapterName.value : this.chapterName,
        chapterUrl: chapterUrl.present ? chapterUrl.value : this.chapterUrl,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  FeedRow copyWithCompanion(FeedCompanion data) {
    return FeedRow(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      title: data.title.present ? data.title.value : this.title,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      chapterName:
          data.chapterName.present ? data.chapterName.value : this.chapterName,
      chapterUrl:
          data.chapterUrl.present ? data.chapterUrl.value : this.chapterUrl,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedRow(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('chapterName: $chapterName, ')
          ..write('chapterUrl: $chapterUrl, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sourceId, remoteId, title, coverUrl,
      chapterName, chapterUrl, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedRow &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.remoteId == this.remoteId &&
          other.title == this.title &&
          other.coverUrl == this.coverUrl &&
          other.chapterName == this.chapterName &&
          other.chapterUrl == this.chapterUrl &&
          other.updatedAt == this.updatedAt);
}

class FeedCompanion extends UpdateCompanion<FeedRow> {
  final Value<int> id;
  final Value<String> sourceId;
  final Value<String> remoteId;
  final Value<String> title;
  final Value<String?> coverUrl;
  final Value<String?> chapterName;
  final Value<String?> chapterUrl;
  final Value<DateTime?> updatedAt;
  const FeedCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.title = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.chapterName = const Value.absent(),
    this.chapterUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FeedCompanion.insert({
    this.id = const Value.absent(),
    required String sourceId,
    required String remoteId,
    required String title,
    this.coverUrl = const Value.absent(),
    this.chapterName = const Value.absent(),
    this.chapterUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : sourceId = Value(sourceId),
        remoteId = Value(remoteId),
        title = Value(title);
  static Insertable<FeedRow> custom({
    Expression<int>? id,
    Expression<String>? sourceId,
    Expression<String>? remoteId,
    Expression<String>? title,
    Expression<String>? coverUrl,
    Expression<String>? chapterName,
    Expression<String>? chapterUrl,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (remoteId != null) 'remote_id': remoteId,
      if (title != null) 'title': title,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (chapterName != null) 'chapter_name': chapterName,
      if (chapterUrl != null) 'chapter_url': chapterUrl,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FeedCompanion copyWith(
      {Value<int>? id,
      Value<String>? sourceId,
      Value<String>? remoteId,
      Value<String>? title,
      Value<String?>? coverUrl,
      Value<String?>? chapterName,
      Value<String?>? chapterUrl,
      Value<DateTime?>? updatedAt}) {
    return FeedCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      chapterName: chapterName ?? this.chapterName,
      chapterUrl: chapterUrl ?? this.chapterUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (chapterName.present) {
      map['chapter_name'] = Variable<String>(chapterName.value);
    }
    if (chapterUrl.present) {
      map['chapter_url'] = Variable<String>(chapterUrl.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('chapterName: $chapterName, ')
          ..write('chapterUrl: $chapterUrl, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MangasTable mangas = $MangasTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $MangaCategoryTable mangaCategory = $MangaCategoryTable(this);
  late final $HistoryTable history = $HistoryTable(this);
  late final $TracksTable tracks = $TracksTable(this);
  late final $FeedTable feed = $FeedTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [mangas, chapters, categories, mangaCategory, history, tracks, feed];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('mangas',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chapters', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('mangas',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('manga_category', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('manga_category', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('mangas',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('history', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('chapters',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('history', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('mangas',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('tracks', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$MangasTableCreateCompanionBuilder = MangasCompanion Function({
  Value<int> id,
  required String sourceId,
  required String remoteId,
  required String title,
  Value<String?> author,
  Value<String?> artist,
  Value<String?> description,
  Value<String> tags,
  Value<String?> status,
  Value<String?> coverUrl,
  Value<String?> coverPath,
  Value<bool> favorite,
  Value<bool> initialized,
  Value<int> viewer,
  Value<DateTime?> dateAdded,
  Value<DateTime?> lastUpdate,
  Value<int> totalChapters,
  Value<int> unread,
  Value<DateTime?> lastReadAt,
  Value<String?> lastChapterUrl,
  Value<String?> extra,
});
typedef $$MangasTableUpdateCompanionBuilder = MangasCompanion Function({
  Value<int> id,
  Value<String> sourceId,
  Value<String> remoteId,
  Value<String> title,
  Value<String?> author,
  Value<String?> artist,
  Value<String?> description,
  Value<String> tags,
  Value<String?> status,
  Value<String?> coverUrl,
  Value<String?> coverPath,
  Value<bool> favorite,
  Value<bool> initialized,
  Value<int> viewer,
  Value<DateTime?> dateAdded,
  Value<DateTime?> lastUpdate,
  Value<int> totalChapters,
  Value<int> unread,
  Value<DateTime?> lastReadAt,
  Value<String?> lastChapterUrl,
  Value<String?> extra,
});

final class $$MangasTableReferences
    extends BaseReferences<_$AppDatabase, $MangasTable, MangaRow> {
  $$MangasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChaptersTable, List<ChapterRow>>
      _chaptersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.chapters,
              aliasName: 'mangas__id__chapters__manga_id');

  $$ChaptersTableProcessedTableManager get chaptersRefs {
    final manager = $$ChaptersTableTableManager($_db, $_db.chapters)
        .filter((f) => f.mangaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MangaCategoryTable, List<MangaCategoryRow>>
      _mangaCategoryRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.mangaCategory,
              aliasName: 'mangas__id__manga_category__manga_id');

  $$MangaCategoryTableProcessedTableManager get mangaCategoryRefs {
    final manager = $$MangaCategoryTableTableManager($_db, $_db.mangaCategory)
        .filter((f) => f.mangaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mangaCategoryRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HistoryTable, List<HistoryRow>> _historyRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.history,
          aliasName: 'mangas__id__history__manga_id');

  $$HistoryTableProcessedTableManager get historyRefs {
    final manager = $$HistoryTableTableManager($_db, $_db.history)
        .filter((f) => f.mangaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_historyRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TracksTable, List<TrackRow>> _tracksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.tracks,
          aliasName: 'mangas__id__tracks__manga_id');

  $$TracksTableProcessedTableManager get tracksRefs {
    final manager = $$TracksTableTableManager($_db, $_db.tracks)
        .filter((f) => f.mangaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tracksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MangasTableFilterComposer
    extends Composer<_$AppDatabase, $MangasTable> {
  $$MangasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverUrl => $composableBuilder(
      column: $table.coverUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverPath => $composableBuilder(
      column: $table.coverPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get initialized => $composableBuilder(
      column: $table.initialized, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get viewer => $composableBuilder(
      column: $table.viewer, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
      column: $table.dateAdded, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdate => $composableBuilder(
      column: $table.lastUpdate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalChapters => $composableBuilder(
      column: $table.totalChapters, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unread => $composableBuilder(
      column: $table.unread, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastChapterUrl => $composableBuilder(
      column: $table.lastChapterUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extra => $composableBuilder(
      column: $table.extra, builder: (column) => ColumnFilters(column));

  Expression<bool> chaptersRefs(
      Expression<bool> Function($$ChaptersTableFilterComposer f) f) {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.mangaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableFilterComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> mangaCategoryRefs(
      Expression<bool> Function($$MangaCategoryTableFilterComposer f) f) {
    final $$MangaCategoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mangaCategory,
        getReferencedColumn: (t) => t.mangaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangaCategoryTableFilterComposer(
              $db: $db,
              $table: $db.mangaCategory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> historyRefs(
      Expression<bool> Function($$HistoryTableFilterComposer f) f) {
    final $$HistoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.history,
        getReferencedColumn: (t) => t.mangaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HistoryTableFilterComposer(
              $db: $db,
              $table: $db.history,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tracksRefs(
      Expression<bool> Function($$TracksTableFilterComposer f) f) {
    final $$TracksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tracks,
        getReferencedColumn: (t) => t.mangaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TracksTableFilterComposer(
              $db: $db,
              $table: $db.tracks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MangasTableOrderingComposer
    extends Composer<_$AppDatabase, $MangasTable> {
  $$MangasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverUrl => $composableBuilder(
      column: $table.coverUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverPath => $composableBuilder(
      column: $table.coverPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get initialized => $composableBuilder(
      column: $table.initialized, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get viewer => $composableBuilder(
      column: $table.viewer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
      column: $table.dateAdded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdate => $composableBuilder(
      column: $table.lastUpdate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalChapters => $composableBuilder(
      column: $table.totalChapters,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unread => $composableBuilder(
      column: $table.unread, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastChapterUrl => $composableBuilder(
      column: $table.lastChapterUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extra => $composableBuilder(
      column: $table.extra, builder: (column) => ColumnOrderings(column));
}

class $$MangasTableAnnotationComposer
    extends Composer<_$AppDatabase, $MangasTable> {
  $$MangasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<bool> get initialized => $composableBuilder(
      column: $table.initialized, builder: (column) => column);

  GeneratedColumn<int> get viewer =>
      $composableBuilder(column: $table.viewer, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdate => $composableBuilder(
      column: $table.lastUpdate, builder: (column) => column);

  GeneratedColumn<int> get totalChapters => $composableBuilder(
      column: $table.totalChapters, builder: (column) => column);

  GeneratedColumn<int> get unread =>
      $composableBuilder(column: $table.unread, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => column);

  GeneratedColumn<String> get lastChapterUrl => $composableBuilder(
      column: $table.lastChapterUrl, builder: (column) => column);

  GeneratedColumn<String> get extra =>
      $composableBuilder(column: $table.extra, builder: (column) => column);

  Expression<T> chaptersRefs<T extends Object>(
      Expression<T> Function($$ChaptersTableAnnotationComposer a) f) {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.mangaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableAnnotationComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> mangaCategoryRefs<T extends Object>(
      Expression<T> Function($$MangaCategoryTableAnnotationComposer a) f) {
    final $$MangaCategoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mangaCategory,
        getReferencedColumn: (t) => t.mangaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangaCategoryTableAnnotationComposer(
              $db: $db,
              $table: $db.mangaCategory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> historyRefs<T extends Object>(
      Expression<T> Function($$HistoryTableAnnotationComposer a) f) {
    final $$HistoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.history,
        getReferencedColumn: (t) => t.mangaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HistoryTableAnnotationComposer(
              $db: $db,
              $table: $db.history,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> tracksRefs<T extends Object>(
      Expression<T> Function($$TracksTableAnnotationComposer a) f) {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tracks,
        getReferencedColumn: (t) => t.mangaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TracksTableAnnotationComposer(
              $db: $db,
              $table: $db.tracks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MangasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MangasTable,
    MangaRow,
    $$MangasTableFilterComposer,
    $$MangasTableOrderingComposer,
    $$MangasTableAnnotationComposer,
    $$MangasTableCreateCompanionBuilder,
    $$MangasTableUpdateCompanionBuilder,
    (MangaRow, $$MangasTableReferences),
    MangaRow,
    PrefetchHooks Function(
        {bool chaptersRefs,
        bool mangaCategoryRefs,
        bool historyRefs,
        bool tracksRefs})> {
  $$MangasTableTableManager(_$AppDatabase db, $MangasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MangasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MangasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MangasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sourceId = const Value.absent(),
            Value<String> remoteId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<String?> artist = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> coverUrl = const Value.absent(),
            Value<String?> coverPath = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> initialized = const Value.absent(),
            Value<int> viewer = const Value.absent(),
            Value<DateTime?> dateAdded = const Value.absent(),
            Value<DateTime?> lastUpdate = const Value.absent(),
            Value<int> totalChapters = const Value.absent(),
            Value<int> unread = const Value.absent(),
            Value<DateTime?> lastReadAt = const Value.absent(),
            Value<String?> lastChapterUrl = const Value.absent(),
            Value<String?> extra = const Value.absent(),
          }) =>
              MangasCompanion(
            id: id,
            sourceId: sourceId,
            remoteId: remoteId,
            title: title,
            author: author,
            artist: artist,
            description: description,
            tags: tags,
            status: status,
            coverUrl: coverUrl,
            coverPath: coverPath,
            favorite: favorite,
            initialized: initialized,
            viewer: viewer,
            dateAdded: dateAdded,
            lastUpdate: lastUpdate,
            totalChapters: totalChapters,
            unread: unread,
            lastReadAt: lastReadAt,
            lastChapterUrl: lastChapterUrl,
            extra: extra,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sourceId,
            required String remoteId,
            required String title,
            Value<String?> author = const Value.absent(),
            Value<String?> artist = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> coverUrl = const Value.absent(),
            Value<String?> coverPath = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> initialized = const Value.absent(),
            Value<int> viewer = const Value.absent(),
            Value<DateTime?> dateAdded = const Value.absent(),
            Value<DateTime?> lastUpdate = const Value.absent(),
            Value<int> totalChapters = const Value.absent(),
            Value<int> unread = const Value.absent(),
            Value<DateTime?> lastReadAt = const Value.absent(),
            Value<String?> lastChapterUrl = const Value.absent(),
            Value<String?> extra = const Value.absent(),
          }) =>
              MangasCompanion.insert(
            id: id,
            sourceId: sourceId,
            remoteId: remoteId,
            title: title,
            author: author,
            artist: artist,
            description: description,
            tags: tags,
            status: status,
            coverUrl: coverUrl,
            coverPath: coverPath,
            favorite: favorite,
            initialized: initialized,
            viewer: viewer,
            dateAdded: dateAdded,
            lastUpdate: lastUpdate,
            totalChapters: totalChapters,
            unread: unread,
            lastReadAt: lastReadAt,
            lastChapterUrl: lastChapterUrl,
            extra: extra,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MangasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {chaptersRefs = false,
              mangaCategoryRefs = false,
              historyRefs = false,
              tracksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (chaptersRefs) db.chapters,
                if (mangaCategoryRefs) db.mangaCategory,
                if (historyRefs) db.history,
                if (tracksRefs) db.tracks
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chaptersRefs)
                    await $_getPrefetchedData<MangaRow, $MangasTable,
                            ChapterRow>(
                        currentTable: table,
                        referencedTable:
                            $$MangasTableReferences._chaptersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MangasTableReferences(db, table, p0).chaptersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mangaId == item.id),
                        typedResults: items),
                  if (mangaCategoryRefs)
                    await $_getPrefetchedData<MangaRow, $MangasTable,
                            MangaCategoryRow>(
                        currentTable: table,
                        referencedTable:
                            $$MangasTableReferences._mangaCategoryRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MangasTableReferences(db, table, p0)
                                .mangaCategoryRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mangaId == item.id),
                        typedResults: items),
                  if (historyRefs)
                    await $_getPrefetchedData<MangaRow, $MangasTable,
                            HistoryRow>(
                        currentTable: table,
                        referencedTable:
                            $$MangasTableReferences._historyRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MangasTableReferences(db, table, p0).historyRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mangaId == item.id),
                        typedResults: items),
                  if (tracksRefs)
                    await $_getPrefetchedData<MangaRow, $MangasTable, TrackRow>(
                        currentTable: table,
                        referencedTable:
                            $$MangasTableReferences._tracksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MangasTableReferences(db, table, p0).tracksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mangaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MangasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MangasTable,
    MangaRow,
    $$MangasTableFilterComposer,
    $$MangasTableOrderingComposer,
    $$MangasTableAnnotationComposer,
    $$MangasTableCreateCompanionBuilder,
    $$MangasTableUpdateCompanionBuilder,
    (MangaRow, $$MangasTableReferences),
    MangaRow,
    PrefetchHooks Function(
        {bool chaptersRefs,
        bool mangaCategoryRefs,
        bool historyRefs,
        bool tracksRefs})>;
typedef $$ChaptersTableCreateCompanionBuilder = ChaptersCompanion Function({
  Value<int> id,
  required int mangaId,
  required String url,
  required String name,
  Value<String?> scanlator,
  Value<DateTime?> dateUpload,
  Value<double> number,
  Value<bool> read,
  Value<bool> bookmark,
  Value<int> lastPageRead,
  Value<DateTime?> lastReadAt,
  Value<bool> downloaded,
  Value<String?> downloadPath,
  Value<bool> fetched,
});
typedef $$ChaptersTableUpdateCompanionBuilder = ChaptersCompanion Function({
  Value<int> id,
  Value<int> mangaId,
  Value<String> url,
  Value<String> name,
  Value<String?> scanlator,
  Value<DateTime?> dateUpload,
  Value<double> number,
  Value<bool> read,
  Value<bool> bookmark,
  Value<int> lastPageRead,
  Value<DateTime?> lastReadAt,
  Value<bool> downloaded,
  Value<String?> downloadPath,
  Value<bool> fetched,
});

final class $$ChaptersTableReferences
    extends BaseReferences<_$AppDatabase, $ChaptersTable, ChapterRow> {
  $$ChaptersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MangasTable _mangaIdTable(_$AppDatabase db) =>
      db.mangas.createAlias('chapters__manga_id__mangas__id');

  $$MangasTableProcessedTableManager get mangaId {
    final $_column = $_itemColumn<int>('manga_id')!;

    final manager = $$MangasTableTableManager($_db, $_db.mangas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mangaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$HistoryTable, List<HistoryRow>> _historyRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.history,
          aliasName: 'chapters__id__history__chapter_id');

  $$HistoryTableProcessedTableManager get historyRefs {
    final manager = $$HistoryTableTableManager($_db, $_db.history)
        .filter((f) => f.chapterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_historyRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scanlator => $composableBuilder(
      column: $table.scanlator, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateUpload => $composableBuilder(
      column: $table.dateUpload, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get read => $composableBuilder(
      column: $table.read, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get bookmark => $composableBuilder(
      column: $table.bookmark, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastPageRead => $composableBuilder(
      column: $table.lastPageRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get downloadPath => $composableBuilder(
      column: $table.downloadPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get fetched => $composableBuilder(
      column: $table.fetched, builder: (column) => ColumnFilters(column));

  $$MangasTableFilterComposer get mangaId {
    final $$MangasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableFilterComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> historyRefs(
      Expression<bool> Function($$HistoryTableFilterComposer f) f) {
    final $$HistoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.history,
        getReferencedColumn: (t) => t.chapterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HistoryTableFilterComposer(
              $db: $db,
              $table: $db.history,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scanlator => $composableBuilder(
      column: $table.scanlator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateUpload => $composableBuilder(
      column: $table.dateUpload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get read => $composableBuilder(
      column: $table.read, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get bookmark => $composableBuilder(
      column: $table.bookmark, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastPageRead => $composableBuilder(
      column: $table.lastPageRead,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get downloadPath => $composableBuilder(
      column: $table.downloadPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get fetched => $composableBuilder(
      column: $table.fetched, builder: (column) => ColumnOrderings(column));

  $$MangasTableOrderingComposer get mangaId {
    final $$MangasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableOrderingComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get scanlator =>
      $composableBuilder(column: $table.scanlator, builder: (column) => column);

  GeneratedColumn<DateTime> get dateUpload => $composableBuilder(
      column: $table.dateUpload, builder: (column) => column);

  GeneratedColumn<double> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<bool> get read =>
      $composableBuilder(column: $table.read, builder: (column) => column);

  GeneratedColumn<bool> get bookmark =>
      $composableBuilder(column: $table.bookmark, builder: (column) => column);

  GeneratedColumn<int> get lastPageRead => $composableBuilder(
      column: $table.lastPageRead, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => column);

  GeneratedColumn<bool> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => column);

  GeneratedColumn<String> get downloadPath => $composableBuilder(
      column: $table.downloadPath, builder: (column) => column);

  GeneratedColumn<bool> get fetched =>
      $composableBuilder(column: $table.fetched, builder: (column) => column);

  $$MangasTableAnnotationComposer get mangaId {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableAnnotationComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> historyRefs<T extends Object>(
      Expression<T> Function($$HistoryTableAnnotationComposer a) f) {
    final $$HistoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.history,
        getReferencedColumn: (t) => t.chapterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HistoryTableAnnotationComposer(
              $db: $db,
              $table: $db.history,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChaptersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChaptersTable,
    ChapterRow,
    $$ChaptersTableFilterComposer,
    $$ChaptersTableOrderingComposer,
    $$ChaptersTableAnnotationComposer,
    $$ChaptersTableCreateCompanionBuilder,
    $$ChaptersTableUpdateCompanionBuilder,
    (ChapterRow, $$ChaptersTableReferences),
    ChapterRow,
    PrefetchHooks Function({bool mangaId, bool historyRefs})> {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> mangaId = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> scanlator = const Value.absent(),
            Value<DateTime?> dateUpload = const Value.absent(),
            Value<double> number = const Value.absent(),
            Value<bool> read = const Value.absent(),
            Value<bool> bookmark = const Value.absent(),
            Value<int> lastPageRead = const Value.absent(),
            Value<DateTime?> lastReadAt = const Value.absent(),
            Value<bool> downloaded = const Value.absent(),
            Value<String?> downloadPath = const Value.absent(),
            Value<bool> fetched = const Value.absent(),
          }) =>
              ChaptersCompanion(
            id: id,
            mangaId: mangaId,
            url: url,
            name: name,
            scanlator: scanlator,
            dateUpload: dateUpload,
            number: number,
            read: read,
            bookmark: bookmark,
            lastPageRead: lastPageRead,
            lastReadAt: lastReadAt,
            downloaded: downloaded,
            downloadPath: downloadPath,
            fetched: fetched,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int mangaId,
            required String url,
            required String name,
            Value<String?> scanlator = const Value.absent(),
            Value<DateTime?> dateUpload = const Value.absent(),
            Value<double> number = const Value.absent(),
            Value<bool> read = const Value.absent(),
            Value<bool> bookmark = const Value.absent(),
            Value<int> lastPageRead = const Value.absent(),
            Value<DateTime?> lastReadAt = const Value.absent(),
            Value<bool> downloaded = const Value.absent(),
            Value<String?> downloadPath = const Value.absent(),
            Value<bool> fetched = const Value.absent(),
          }) =>
              ChaptersCompanion.insert(
            id: id,
            mangaId: mangaId,
            url: url,
            name: name,
            scanlator: scanlator,
            dateUpload: dateUpload,
            number: number,
            read: read,
            bookmark: bookmark,
            lastPageRead: lastPageRead,
            lastReadAt: lastReadAt,
            downloaded: downloaded,
            downloadPath: downloadPath,
            fetched: fetched,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ChaptersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({mangaId = false, historyRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (historyRefs) db.history],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (mangaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mangaId,
                    referencedTable:
                        $$ChaptersTableReferences._mangaIdTable(db),
                    referencedColumn:
                        $$ChaptersTableReferences._mangaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (historyRefs)
                    await $_getPrefetchedData<ChapterRow, $ChaptersTable,
                            HistoryRow>(
                        currentTable: table,
                        referencedTable:
                            $$ChaptersTableReferences._historyRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChaptersTableReferences(db, table, p0)
                                .historyRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.chapterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChaptersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChaptersTable,
    ChapterRow,
    $$ChaptersTableFilterComposer,
    $$ChaptersTableOrderingComposer,
    $$ChaptersTableAnnotationComposer,
    $$ChaptersTableCreateCompanionBuilder,
    $$ChaptersTableUpdateCompanionBuilder,
    (ChapterRow, $$ChaptersTableReferences),
    ChapterRow,
    PrefetchHooks Function({bool mangaId, bool historyRefs})>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<int> order,
  Value<bool> hidden,
  Value<DateTime?> createdAt,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> order,
  Value<bool> hidden,
  Value<DateTime?> createdAt,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MangaCategoryTable, List<MangaCategoryRow>>
      _mangaCategoryRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.mangaCategory,
              aliasName: 'categories__id__manga_category__category_id');

  $$MangaCategoryTableProcessedTableManager get mangaCategoryRefs {
    final manager = $$MangaCategoryTableTableManager($_db, $_db.mangaCategory)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mangaCategoryRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hidden => $composableBuilder(
      column: $table.hidden, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> mangaCategoryRefs(
      Expression<bool> Function($$MangaCategoryTableFilterComposer f) f) {
    final $$MangaCategoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mangaCategory,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangaCategoryTableFilterComposer(
              $db: $db,
              $table: $db.mangaCategory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hidden => $composableBuilder(
      column: $table.hidden, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<bool> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> mangaCategoryRefs<T extends Object>(
      Expression<T> Function($$MangaCategoryTableAnnotationComposer a) f) {
    final $$MangaCategoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mangaCategory,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangaCategoryTableAnnotationComposer(
              $db: $db,
              $table: $db.mangaCategory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    CategoryRow,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (CategoryRow, $$CategoriesTableReferences),
    CategoryRow,
    PrefetchHooks Function({bool mangaCategoryRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<bool> hidden = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            order: order,
            hidden: hidden,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> order = const Value.absent(),
            Value<bool> hidden = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            order: order,
            hidden: hidden,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({mangaCategoryRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mangaCategoryRefs) db.mangaCategory
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mangaCategoryRefs)
                    await $_getPrefetchedData<CategoryRow, $CategoriesTable,
                            MangaCategoryRow>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._mangaCategoryRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .mangaCategoryRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    CategoryRow,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (CategoryRow, $$CategoriesTableReferences),
    CategoryRow,
    PrefetchHooks Function({bool mangaCategoryRefs})>;
typedef $$MangaCategoryTableCreateCompanionBuilder = MangaCategoryCompanion
    Function({
  required int mangaId,
  required int categoryId,
  Value<int> rowid,
});
typedef $$MangaCategoryTableUpdateCompanionBuilder = MangaCategoryCompanion
    Function({
  Value<int> mangaId,
  Value<int> categoryId,
  Value<int> rowid,
});

final class $$MangaCategoryTableReferences extends BaseReferences<_$AppDatabase,
    $MangaCategoryTable, MangaCategoryRow> {
  $$MangaCategoryTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MangasTable _mangaIdTable(_$AppDatabase db) =>
      db.mangas.createAlias('manga_category__manga_id__mangas__id');

  $$MangasTableProcessedTableManager get mangaId {
    final $_column = $_itemColumn<int>('manga_id')!;

    final manager = $$MangasTableTableManager($_db, $_db.mangas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mangaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('manga_category__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MangaCategoryTableFilterComposer
    extends Composer<_$AppDatabase, $MangaCategoryTable> {
  $$MangaCategoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MangasTableFilterComposer get mangaId {
    final $$MangasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableFilterComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MangaCategoryTableOrderingComposer
    extends Composer<_$AppDatabase, $MangaCategoryTable> {
  $$MangaCategoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MangasTableOrderingComposer get mangaId {
    final $$MangasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableOrderingComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MangaCategoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $MangaCategoryTable> {
  $$MangaCategoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MangasTableAnnotationComposer get mangaId {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableAnnotationComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MangaCategoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MangaCategoryTable,
    MangaCategoryRow,
    $$MangaCategoryTableFilterComposer,
    $$MangaCategoryTableOrderingComposer,
    $$MangaCategoryTableAnnotationComposer,
    $$MangaCategoryTableCreateCompanionBuilder,
    $$MangaCategoryTableUpdateCompanionBuilder,
    (MangaCategoryRow, $$MangaCategoryTableReferences),
    MangaCategoryRow,
    PrefetchHooks Function({bool mangaId, bool categoryId})> {
  $$MangaCategoryTableTableManager(_$AppDatabase db, $MangaCategoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MangaCategoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MangaCategoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MangaCategoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> mangaId = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MangaCategoryCompanion(
            mangaId: mangaId,
            categoryId: categoryId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int mangaId,
            required int categoryId,
            Value<int> rowid = const Value.absent(),
          }) =>
              MangaCategoryCompanion.insert(
            mangaId: mangaId,
            categoryId: categoryId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MangaCategoryTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({mangaId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (mangaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mangaId,
                    referencedTable:
                        $$MangaCategoryTableReferences._mangaIdTable(db),
                    referencedColumn:
                        $$MangaCategoryTableReferences._mangaIdTable(db).id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$MangaCategoryTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$MangaCategoryTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MangaCategoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MangaCategoryTable,
    MangaCategoryRow,
    $$MangaCategoryTableFilterComposer,
    $$MangaCategoryTableOrderingComposer,
    $$MangaCategoryTableAnnotationComposer,
    $$MangaCategoryTableCreateCompanionBuilder,
    $$MangaCategoryTableUpdateCompanionBuilder,
    (MangaCategoryRow, $$MangaCategoryTableReferences),
    MangaCategoryRow,
    PrefetchHooks Function({bool mangaId, bool categoryId})>;
typedef $$HistoryTableCreateCompanionBuilder = HistoryCompanion Function({
  Value<int> id,
  required int mangaId,
  required int chapterId,
  Value<int> page,
  Value<double> percent,
  required DateTime readAt,
});
typedef $$HistoryTableUpdateCompanionBuilder = HistoryCompanion Function({
  Value<int> id,
  Value<int> mangaId,
  Value<int> chapterId,
  Value<int> page,
  Value<double> percent,
  Value<DateTime> readAt,
});

final class $$HistoryTableReferences
    extends BaseReferences<_$AppDatabase, $HistoryTable, HistoryRow> {
  $$HistoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MangasTable _mangaIdTable(_$AppDatabase db) =>
      db.mangas.createAlias('history__manga_id__mangas__id');

  $$MangasTableProcessedTableManager get mangaId {
    final $_column = $_itemColumn<int>('manga_id')!;

    final manager = $$MangasTableTableManager($_db, $_db.mangas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mangaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias('history__chapter_id__chapters__id');

  $$ChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<int>('chapter_id')!;

    final manager = $$ChaptersTableTableManager($_db, $_db.chapters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HistoryTableFilterComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get percent => $composableBuilder(
      column: $table.percent, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnFilters(column));

  $$MangasTableFilterComposer get mangaId {
    final $$MangasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableFilterComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chapterId,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableFilterComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get percent => $composableBuilder(
      column: $table.percent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnOrderings(column));

  $$MangasTableOrderingComposer get mangaId {
    final $$MangasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableOrderingComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chapterId,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableOrderingComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<double> get percent =>
      $composableBuilder(column: $table.percent, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  $$MangasTableAnnotationComposer get mangaId {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableAnnotationComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chapterId,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableAnnotationComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistoryTable,
    HistoryRow,
    $$HistoryTableFilterComposer,
    $$HistoryTableOrderingComposer,
    $$HistoryTableAnnotationComposer,
    $$HistoryTableCreateCompanionBuilder,
    $$HistoryTableUpdateCompanionBuilder,
    (HistoryRow, $$HistoryTableReferences),
    HistoryRow,
    PrefetchHooks Function({bool mangaId, bool chapterId})> {
  $$HistoryTableTableManager(_$AppDatabase db, $HistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> mangaId = const Value.absent(),
            Value<int> chapterId = const Value.absent(),
            Value<int> page = const Value.absent(),
            Value<double> percent = const Value.absent(),
            Value<DateTime> readAt = const Value.absent(),
          }) =>
              HistoryCompanion(
            id: id,
            mangaId: mangaId,
            chapterId: chapterId,
            page: page,
            percent: percent,
            readAt: readAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int mangaId,
            required int chapterId,
            Value<int> page = const Value.absent(),
            Value<double> percent = const Value.absent(),
            required DateTime readAt,
          }) =>
              HistoryCompanion.insert(
            id: id,
            mangaId: mangaId,
            chapterId: chapterId,
            page: page,
            percent: percent,
            readAt: readAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$HistoryTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({mangaId = false, chapterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (mangaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mangaId,
                    referencedTable: $$HistoryTableReferences._mangaIdTable(db),
                    referencedColumn:
                        $$HistoryTableReferences._mangaIdTable(db).id,
                  ) as T;
                }
                if (chapterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.chapterId,
                    referencedTable:
                        $$HistoryTableReferences._chapterIdTable(db),
                    referencedColumn:
                        $$HistoryTableReferences._chapterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HistoryTable,
    HistoryRow,
    $$HistoryTableFilterComposer,
    $$HistoryTableOrderingComposer,
    $$HistoryTableAnnotationComposer,
    $$HistoryTableCreateCompanionBuilder,
    $$HistoryTableUpdateCompanionBuilder,
    (HistoryRow, $$HistoryTableReferences),
    HistoryRow,
    PrefetchHooks Function({bool mangaId, bool chapterId})>;
typedef $$TracksTableCreateCompanionBuilder = TracksCompanion Function({
  Value<int> id,
  required int mangaId,
  required String trackerId,
  Value<String?> remoteId,
  Value<String?> title,
  Value<String?> status,
  Value<double> score,
  Value<double> lastChapterRead,
  Value<int> totalChapters,
  Value<DateTime?> trackedAt,
});
typedef $$TracksTableUpdateCompanionBuilder = TracksCompanion Function({
  Value<int> id,
  Value<int> mangaId,
  Value<String> trackerId,
  Value<String?> remoteId,
  Value<String?> title,
  Value<String?> status,
  Value<double> score,
  Value<double> lastChapterRead,
  Value<int> totalChapters,
  Value<DateTime?> trackedAt,
});

final class $$TracksTableReferences
    extends BaseReferences<_$AppDatabase, $TracksTable, TrackRow> {
  $$TracksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MangasTable _mangaIdTable(_$AppDatabase db) =>
      db.mangas.createAlias('tracks__manga_id__mangas__id');

  $$MangasTableProcessedTableManager get mangaId {
    final $_column = $_itemColumn<int>('manga_id')!;

    final manager = $$MangasTableTableManager($_db, $_db.mangas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mangaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TracksTableFilterComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trackerId => $composableBuilder(
      column: $table.trackerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lastChapterRead => $composableBuilder(
      column: $table.lastChapterRead,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalChapters => $composableBuilder(
      column: $table.totalChapters, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get trackedAt => $composableBuilder(
      column: $table.trackedAt, builder: (column) => ColumnFilters(column));

  $$MangasTableFilterComposer get mangaId {
    final $$MangasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableFilterComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TracksTableOrderingComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trackerId => $composableBuilder(
      column: $table.trackerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lastChapterRead => $composableBuilder(
      column: $table.lastChapterRead,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalChapters => $composableBuilder(
      column: $table.totalChapters,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get trackedAt => $composableBuilder(
      column: $table.trackedAt, builder: (column) => ColumnOrderings(column));

  $$MangasTableOrderingComposer get mangaId {
    final $$MangasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableOrderingComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackerId =>
      $composableBuilder(column: $table.trackerId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<double> get lastChapterRead => $composableBuilder(
      column: $table.lastChapterRead, builder: (column) => column);

  GeneratedColumn<int> get totalChapters => $composableBuilder(
      column: $table.totalChapters, builder: (column) => column);

  GeneratedColumn<DateTime> get trackedAt =>
      $composableBuilder(column: $table.trackedAt, builder: (column) => column);

  $$MangasTableAnnotationComposer get mangaId {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mangaId,
        referencedTable: $db.mangas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MangasTableAnnotationComposer(
              $db: $db,
              $table: $db.mangas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TracksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TracksTable,
    TrackRow,
    $$TracksTableFilterComposer,
    $$TracksTableOrderingComposer,
    $$TracksTableAnnotationComposer,
    $$TracksTableCreateCompanionBuilder,
    $$TracksTableUpdateCompanionBuilder,
    (TrackRow, $$TracksTableReferences),
    TrackRow,
    PrefetchHooks Function({bool mangaId})> {
  $$TracksTableTableManager(_$AppDatabase db, $TracksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> mangaId = const Value.absent(),
            Value<String> trackerId = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<double> score = const Value.absent(),
            Value<double> lastChapterRead = const Value.absent(),
            Value<int> totalChapters = const Value.absent(),
            Value<DateTime?> trackedAt = const Value.absent(),
          }) =>
              TracksCompanion(
            id: id,
            mangaId: mangaId,
            trackerId: trackerId,
            remoteId: remoteId,
            title: title,
            status: status,
            score: score,
            lastChapterRead: lastChapterRead,
            totalChapters: totalChapters,
            trackedAt: trackedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int mangaId,
            required String trackerId,
            Value<String?> remoteId = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<double> score = const Value.absent(),
            Value<double> lastChapterRead = const Value.absent(),
            Value<int> totalChapters = const Value.absent(),
            Value<DateTime?> trackedAt = const Value.absent(),
          }) =>
              TracksCompanion.insert(
            id: id,
            mangaId: mangaId,
            trackerId: trackerId,
            remoteId: remoteId,
            title: title,
            status: status,
            score: score,
            lastChapterRead: lastChapterRead,
            totalChapters: totalChapters,
            trackedAt: trackedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TracksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({mangaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (mangaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mangaId,
                    referencedTable: $$TracksTableReferences._mangaIdTable(db),
                    referencedColumn:
                        $$TracksTableReferences._mangaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TracksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TracksTable,
    TrackRow,
    $$TracksTableFilterComposer,
    $$TracksTableOrderingComposer,
    $$TracksTableAnnotationComposer,
    $$TracksTableCreateCompanionBuilder,
    $$TracksTableUpdateCompanionBuilder,
    (TrackRow, $$TracksTableReferences),
    TrackRow,
    PrefetchHooks Function({bool mangaId})>;
typedef $$FeedTableCreateCompanionBuilder = FeedCompanion Function({
  Value<int> id,
  required String sourceId,
  required String remoteId,
  required String title,
  Value<String?> coverUrl,
  Value<String?> chapterName,
  Value<String?> chapterUrl,
  Value<DateTime?> updatedAt,
});
typedef $$FeedTableUpdateCompanionBuilder = FeedCompanion Function({
  Value<int> id,
  Value<String> sourceId,
  Value<String> remoteId,
  Value<String> title,
  Value<String?> coverUrl,
  Value<String?> chapterName,
  Value<String?> chapterUrl,
  Value<DateTime?> updatedAt,
});

class $$FeedTableFilterComposer extends Composer<_$AppDatabase, $FeedTable> {
  $$FeedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverUrl => $composableBuilder(
      column: $table.coverUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterName => $composableBuilder(
      column: $table.chapterName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterUrl => $composableBuilder(
      column: $table.chapterUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FeedTableOrderingComposer extends Composer<_$AppDatabase, $FeedTable> {
  $$FeedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverUrl => $composableBuilder(
      column: $table.coverUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterName => $composableBuilder(
      column: $table.chapterName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterUrl => $composableBuilder(
      column: $table.chapterUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FeedTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedTable> {
  $$FeedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get chapterName => $composableBuilder(
      column: $table.chapterName, builder: (column) => column);

  GeneratedColumn<String> get chapterUrl => $composableBuilder(
      column: $table.chapterUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FeedTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FeedTable,
    FeedRow,
    $$FeedTableFilterComposer,
    $$FeedTableOrderingComposer,
    $$FeedTableAnnotationComposer,
    $$FeedTableCreateCompanionBuilder,
    $$FeedTableUpdateCompanionBuilder,
    (FeedRow, BaseReferences<_$AppDatabase, $FeedTable, FeedRow>),
    FeedRow,
    PrefetchHooks Function()> {
  $$FeedTableTableManager(_$AppDatabase db, $FeedTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sourceId = const Value.absent(),
            Value<String> remoteId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> coverUrl = const Value.absent(),
            Value<String?> chapterName = const Value.absent(),
            Value<String?> chapterUrl = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              FeedCompanion(
            id: id,
            sourceId: sourceId,
            remoteId: remoteId,
            title: title,
            coverUrl: coverUrl,
            chapterName: chapterName,
            chapterUrl: chapterUrl,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sourceId,
            required String remoteId,
            required String title,
            Value<String?> coverUrl = const Value.absent(),
            Value<String?> chapterName = const Value.absent(),
            Value<String?> chapterUrl = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              FeedCompanion.insert(
            id: id,
            sourceId: sourceId,
            remoteId: remoteId,
            title: title,
            coverUrl: coverUrl,
            chapterName: chapterName,
            chapterUrl: chapterUrl,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FeedTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FeedTable,
    FeedRow,
    $$FeedTableFilterComposer,
    $$FeedTableOrderingComposer,
    $$FeedTableAnnotationComposer,
    $$FeedTableCreateCompanionBuilder,
    $$FeedTableUpdateCompanionBuilder,
    (FeedRow, BaseReferences<_$AppDatabase, $FeedTable, FeedRow>),
    FeedRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MangasTableTableManager get mangas =>
      $$MangasTableTableManager(_db, _db.mangas);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$MangaCategoryTableTableManager get mangaCategory =>
      $$MangaCategoryTableTableManager(_db, _db.mangaCategory);
  $$HistoryTableTableManager get history =>
      $$HistoryTableTableManager(_db, _db.history);
  $$TracksTableTableManager get tracks =>
      $$TracksTableTableManager(_db, _db.tracks);
  $$FeedTableTableManager get feed => $$FeedTableTableManager(_db, _db.feed);
}
