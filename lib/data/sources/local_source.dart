import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import '../models/models.dart';
import 'source.dart';

/// Local source — read manga from the device: one root directory,
/// each subfolder (or zip/cbz) is a manga, each chapter is a folder of
/// images or a .cbz/.zip archive. Fully offline.
class LocalSource extends Source {
  LocalSource._();

  static final LocalSource instance = LocalSource._();

  @override
  String get id => 'local';
  @override
  String get name => 'Local Storage';
  @override
  String get lang => 'en';
  @override
  String? get baseUrl => null;
  @override
  IconSpec get icon => const IconSpec('source.local', color: 0xFF10B981);
  @override
  bool get supportsLatest => false;

  static const _imageExts = {'.jpg', '.jpeg', '.png', '.webp', '.gif', '.bmp', '.avif'};
  static const _archiveExts = {'.zip', '.cbz'};

  /// Ask the user for a folder; returns it (or null on cancel).
  Future<String?> pickLibraryFolder() async {
    final dir = await getDirectoryPath(confirmButtonText: 'Use this folder');
    if (dir == null) return null;
    final target = Directory(dir);
    if (!target.existsSync()) return null;
    return target.path;
  }

  Future<List<SourceManga>> scanRoot(String rootPath) async {
    final root = Directory(rootPath);
    if (!root.existsSync()) return const [];
    final mangaDirs = <SourceManga>[];
    for (final e in root.listSync()) {
      if (e is Directory) {
        final title = p.basename(e.path);
        mangaDirs.add(SourceManga(
          sourceId: id,
          remoteId: title,
          title: title,
          coverUrl: _findCoverInDir(e.path),
        ));
      } else if (e is File && _archiveExts.contains(p.extension(e.path).toLowerCase())) {
        final title = p.basenameWithoutExtension(e.path);
        mangaDirs.add(SourceManga(
          sourceId: id,
          remoteId: title,
          title: title,
          coverUrl: 'local://archive:$title:cover',
        ));
      }
    }
    mangaDirs.sort((a, b) => a.title.compareTo(b.title));
    return mangaDirs;
  }

  String? _findCoverInDir(String dirPath) {
    final dir = Directory(dirPath);
    for (final e in dir.listSync()) {
      if (e is File && _imageExts.contains(p.extension(e.path).toLowerCase())) {
        return 'local://file:${e.path}';
      }
    }
    // first chapter folder's first image
    for (final e in dir.listSync()) {
      if (e is Directory) {
        final c = _findCoverInDir(e.path);
        if (c != null) return c;
      }
    }
    return null;
  }

  /// Chapters for a folder manga: subfolders + archives inside it.
  Future<List<SourceChapter>> chaptersForDir(String mangaId, {required String rootPath}) async {
    final mangaDir = Directory(p.join(rootPath, mangaId));
    if (!mangaDir.existsSync()) return const [];
    final chapters = <SourceChapter>[];
    var n = 0;
    for (final e in mangaDir.listSync()) {
      n++;
      if (e is Directory) {
        final images = e.listSync().whereType<File>().where((f) => _imageExts.contains(p.extension(f.path).toLowerCase())).toList()
          ..sort((a, b) => a.path.compareTo(b.path));
        if (images.isEmpty) continue;
        chapters.add(SourceChapter(
          url: 'dir:${p.basename(e.path)}',
          name: p.basename(e.path),
          number: n.toDouble(),
        ));
      } else if (e is File && _archiveExts.contains(p.extension(e.path).toLowerCase())) {
        chapters.add(SourceChapter(
          url: 'arc:${p.basename(e.path)}',
          name: p.basenameWithoutExtension(e.path),
          number: n.toDouble(),
        ));
      }
    }
    chapters.sort((a, b) => a.name.compareTo(b.name));
    return chapters;
  }

  @override
  Future<List<SourceManga>> getPopular(int page) async => const [];

  @override
  Future<List<SourceManga>> getLatest(int page) async => const [];

  @override
  Future<List<SourceManga>> search(String query, int page) async => const [];

  @override
  Future<SourceManga> getMangaDetail(String mangaId) async => SourceManga(
        sourceId: id,
        remoteId: mangaId,
        title: mangaId,
        status: 'ongoing',
      );

  @override
  Future<List<SourceChapter>> getChapters(String mangaId) async {
    // Root path is stored in the manga's extra map by the scanner; the
    // library service supplies it through [withRoot].
    final root = _pendingRoot;
    _pendingRoot = null;
    if (root == null) return const [];
    return chaptersForDir(mangaId, rootPath: root);
  }

  String? _pendingRoot;
  void attachRoot(String rootPath) => _pendingRoot = rootPath;

  @override
  Future<List<SourcePage>> getPages(String mangaId, String chapterId) async {
    final root = _pendingRoot;
    _pendingRoot = null;
    if (root == null) return const [];
    if (chapterId.startsWith('dir:')) {
      final chapterDir = Directory(p.join(root, mangaId, chapterId.substring(4)));
      final images = chapterDir.listSync().whereType<File>().where((f) => _imageExts.contains(p.extension(f.path).toLowerCase())).toList()
        ..sort((a, b) => a.path.compareTo(b.path));
      return images.asMap().entries.map((e) => SourcePage(index: e.key, url: 'local://file:${e.value.path}')).toList();
    }
    if (chapterId.startsWith('arc:')) {
      final archiveFile = File(p.join(root, mangaId, chapterId.substring(4)));
      final bytes = await archiveFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      final entries = archive.files
          .where((f) => !f.isFile == false && _imageExts.contains(p.extension(f.name).toLowerCase()))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      return entries.asMap().entries.map((e) => SourcePage(index: e.key, url: 'local://arc:${archiveFile.path}:${e.value.name}', fileName: p.basename(e.value.name))).toList();
    }
    return const [];
  }

  /// Resolve a local:// URL to bytes (or a file path).
  static Future<({Uint8List? bytes, String? path})?> resolve(String url) async {
    if (url.startsWith('local://file:')) {
      final path = url.substring('local://file:'.length);
      final f = File(path);
      if (!f.existsSync()) return null;
      return (bytes: await f.readAsBytes(), path: f.path);
    }
    if (url.startsWith('local://arc:')) {
      final parts = url.substring('local://arc:'.length).split(':');
      final archivePath = parts[0];
      final entryName = parts.sublist(1).join(':');
      final bytes = await File(archivePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final f in archive.files) {
        if (f.name == entryName) return (bytes: f.content as Uint8List?, path: null);
      }
      return null;
    }
    return null;
  }
}