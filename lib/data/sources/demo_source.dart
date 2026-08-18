import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';
import 'demo_art.dart';
import 'source.dart';

/// Demo source — fully offline. Covers and pages are generated
/// procedurally by [DemoArt]; no network needed, deterministic per seed.
class DemoSource extends Source {
  DemoSource._();

  static final DemoSource instance = DemoSource._();

  @override
  String get id => 'demo';
  @override
  String get name => 'Comicko Demo';
  @override
  String get lang => 'en';
  @override
  String? get baseUrl => null;
  @override
  IconSpec get icon => const IconSpec('source.demo', color: 0xFF8B5CF6);
  @override
  bool get supportsSuggestions => true;

  static const _mangas = <_DemoManga>[
    _DemoManga('starlight-runner', 'Starlight Runner', 'Lena Aoki', 3, 'A courier who outruns the sunrise across a city on rails.', ['Action', 'Sci-Fi', 'Adventure']),
    _DemoManga('paper-blooms', 'Paper Blooms', 'Miya Satou', 3, 'An origami artist finds her folds come to life at midnight.', ['Slice of Life', 'Fantasy', 'Romance']),
    _DemoManga('iron-fist-totoro', 'Iron Fist Totoro', 'Kenji Ramos', 3, 'A gentle giant bodyguard protects the last flower shop in Neo-Neo-Tokyo.', ['Action', 'Comedy']),
    _DemoManga('tidecaller', 'Tidecaller', 'Ana Voss', 3, 'Voices from the deep answer when the tidecaller sings.', ['Fantasy', 'Mystery']),
    _DemoManga('neon-scales', 'Neon Scales', 'Ryu Teramoto', 3, 'A dragon shifter hustles in the neon streets of Shinjuku-2.', ['Urban Fantasy', 'Action']),
    _DemoManga('ghost-notes', 'Ghost Notes', 'Clara Ito', 2, 'A pianist haunted by the unfinished melody of a vanished master.', ['Drama', 'Music']),
    _DemoManga('sky-fisher', 'Sky Fisher', 'Tomás Reyes', 2, 'Fishing clouds above a city that is slowly sinking.', ['Adventure', 'Mystery']),
    _DemoManga('honey-badger', 'Honey Badger Club', 'Yuki Han', 2, 'High-school problem-solvers who never back down.', ['Comedy', 'School']),
    _DemoManga('zero-garden', 'Zero Garden', 'Elias Berg', 2, 'Botanists decode a garden that grows in zero gravity.', ['Sci-Fi', 'Drama']),
    _DemoManga('last-reel', 'The Last Reel', 'Nadia Okafor', 2, 'A cinema that only screens films from futures that never happened.', ['Mystery', 'Drama']),
    _DemoManga('scarlet-circuit', 'Scarlet Circuit', 'Hana Fudo', 2, 'Underground racing where every win costs a memory.', ['Action', 'Sports']),
    _DemoManga('paper-moon', 'Paper Moon', 'Sora Mizuki', 2, 'A young astronaut receives letters from a moon that no longer exists.', ['Sci-Fi', 'Romance']),
  ];

  static const _chaptersPerManga = 6;

  Future<Directory> _artDir() async {
    Directory base;
    try {
      base = await getApplicationSupportDirectory();
    } catch (_) {
      base = Directory.systemTemp; // tests / no platform channel
    }
    final dir = Directory('${base.path}/demo_art');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  Future<String> _coverPath(String mangaId) async {
    final dir = await _artDir();
    final f = File('${dir.path}/cover_$mangaId.jpg');
    if (!f.existsSync()) {
      final meta = _mangas.firstWhere((m) => m.id == mangaId);
      final png = await DemoArt.cover(mangaId, meta.title);
      f.writeAsBytesSync(DemoArt.downscale(png, maxW: 240));
    }
    return f.path;
  }

  Future<String> _pagePath(String mangaId, int chapter, int page) async {
    final dir = await _artDir();
    final f = File('${dir.path}/${mangaId}_c${chapter}_p$page.png');
    if (!f.existsSync()) {
      final png = await DemoArt.page(mangaId, chapter, page);
      f.writeAsBytesSync(png);
    }
    return f.path;
  }

  SourceManga _toSourceManga(_DemoManga m, {bool withCover = true}) => SourceManga(
        sourceId: id,
        remoteId: m.id,
        title: m.title,
        author: m.author,
        description: m.description,
        tags: m.tags,
        status: 'ongoing',
        coverUrl: withCover ? 'demo://cover/${m.id}' : null,
        extra: {'pagesPerChapter': '${m.pagesPerChapter}'},
      );

  @override
  Future<List<SourceManga>> getPopular(int page) async {
    final start = (page - 1) * 6;
    final slice = _mangas.skip(start).take(6);
    await Future<void>.delayed(const Duration(milliseconds: 220)); // feel of a real fetch
    return slice.map((m) => _toSourceManga(m)).toList();
  }

  @override
  Future<List<SourceManga>> getLatest(int page) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final shuffled = List<_DemoManga>.of(_mangas)..sort((a, b) => (a.id.hashCode ^ page).compareTo(b.id.hashCode ^ page));
    return shuffled.take(8).map((m) => _toSourceManga(m)).toList();
  }

  @override
  Future<List<SourceManga>> search(String query, int page) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final q = query.toLowerCase();
    return _mangas
        .where((m) => m.title.toLowerCase().contains(q) || m.description.toLowerCase().contains(q) || m.tags.any((t) => t.toLowerCase().contains(q)))
        .map((m) => _toSourceManga(m))
        .toList();
  }

  @override
  Future<SourceManga> getMangaDetail(String mangaId) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return _toSourceManga(_mangas.firstWhere((m) => m.id == mangaId));
  }

  @override
  Future<List<SourceChapter>> getChapters(String mangaId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final meta = _mangas.firstWhere((m) => m.id == mangaId);
    final now = DateTime.now();
    return List.generate(_chaptersPerManga, (i) {
      final n = _chaptersPerManga - i;
      return SourceChapter(
        url: 'ch$n',
        name: 'Chapter $n',
        scanlator: 'Comicko Studio',
        dateUpload: now.subtract(Duration(days: n * 3 + meta.id.hashCode.abs() % 5)),
        number: n.toDouble(),
      );
    });
  }

  @override
  Future<List<SourcePage>> getPages(String mangaId, String chapterId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final meta = _mangas.firstWhere((m) => m.id == mangaId);
    final ch = int.tryParse(chapterId.replaceAll('ch', '')) ?? 1;
    final count = meta.pagesPerChapter + (ch % 3);
    return List.generate(count, (i) => SourcePage(index: i, url: 'demo://page/$mangaId/$chapterId/$i', fileName: 'page_${(i + 1).toString().padLeft(3, '0')}.png'));
  }

  @override
  String? coverUrl(SourceManga manga) => manga.coverUrl;

  /// Resolves a demo:// URL to a local file path.
  Future<String?> resolveAsset(String url) async {
    if (url.startsWith('demo://cover/')) {
      return _coverPath(url.substring('demo://cover/'.length));
    }
    if (url.startsWith('demo://page/')) {
      final parts = url.substring('demo://page/'.length).split('/');
      if (parts.length == 3) {
        final ch = int.tryParse(parts[1].replaceAll('ch', '')) ?? 1;
        final p = int.tryParse(parts[2]) ?? 0;
        return _pagePath(parts[0], ch, p);
      }
    }
    return null;
  }

  @override
  Future<List<SourceManga>> getSuggestions(String mangaId) async {
    final meta = _mangas.firstWhere((m) => m.id == mangaId);
    final others = _mangas.where((m) => m.id != mangaId).toList()..sort((a, b) => a.tags.first.compareTo(b.tags.first));
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return others.take(4).map((m) => _toSourceManga(m)).toList();
  }
}

class _DemoManga {
  const _DemoManga(this.id, this.title, this.author, this.pagesPerChapter, this.description, this.tags);
  final String id;
  final String title;
  final String author;
  final int pagesPerChapter;
  final String description;
  final List<String> tags;
}