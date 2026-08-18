import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../sources/demo_source.dart';
import '../sources/local_source.dart';

/// Cover images: memory LRU + disk cache. Sources with generated/demo
/// assets resolve through [DemoSource]/[LocalSource].
import 'dart:ui' as ui;
class CoverCache {
  CoverCache() {
    _init();
  }

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'User-Agent': 'Comicko/0.1'},
  ));

  final Map<String, Uint8List> _memory = {};
  final List<String> _lru = [];
  static const int _memLimit = 60;

  Directory? _diskDir;
  Future<void> _init() async {
    try {
      final base = await getApplicationSupportDirectory();
      _diskDir = Directory('${base.path}/covers');
      if (!_diskDir!.existsSync()) _diskDir!.createSync(recursive: true);
    } catch (_) {}
  }

  String _hash(String url) => crypto.md5.convert(url.codeUnits).toString();

  Future<String?> _diskPath(String url) async {
    await _init();
    return _diskDir == null ? null : p.join(_diskDir!.path, '${_hash(url)}.img');
  }

  /// Resolve URL → bytes (memory → disk → network/generator).
  Future<Uint8List?> fetch(String url, {bool cache = true}) async {
    final mem = _memory[url];
    if (mem != null) {
      _touch(url);
      return mem;
    }

    // demo / local asset URLs
    if (url.startsWith('demo://')) {
      final path = await DemoSource.instance.resolveAsset(url);
      if (path != null) return File(path).readAsBytes();
      return null;
    }
    if (url.startsWith('local://')) {
      final resolved = await LocalSource.resolve(url);
      return resolved?.bytes ?? (resolved?.path != null ? File(resolved!.path!).readAsBytes() : null);
    }

    final diskPath = await _diskPath(url);
    if (diskPath != null) {
      final f = File(diskPath);
      if (f.existsSync()) {
        final bytes = await f.readAsBytes();
        if (cache) _putMemory(url, bytes);
        return bytes;
      }
    }

    try {
      final resp = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = Uint8List.fromList(resp.data ?? const []);
      if (bytes.isEmpty) return null;
      if (cache) {
        _putMemory(url, bytes);
        final path = await _diskPath(url);
        if (path != null) {
          try {
            await File(path).writeAsBytes(bytes, flush: true);
          } catch (_) {}
        }
      }
      return bytes;
    } on DioException {
      return null;
    }
  }

  void _putMemory(String url, Uint8List bytes) {
    if (_memory.containsKey(url)) {
      _touch(url);
      return;
    }
    if (_lru.length >= _memLimit) {
      final evict = _lru.removeAt(0);
      _memory.remove(evict);
    }
    _memory[url] = bytes;
    _lru.add(url);
  }

  void _touch(String url) {
    _lru.remove(url);
    _lru.add(url);
  }

  Future<void> evict(String url) async {
    _memory.remove(url);
    _lru.remove(url);
    final path = await _diskPath(url);
    if (path != null) {
      final f = File(path);
      if (f.existsSync()) f.deleteSync();
    }
  }

  Future<void> clearDisk() async {
    _memory.clear();
    _lru.clear();
    final dir = _diskDir;
    if (dir != null && dir.existsSync()) {
      for (final f in dir.listSync()) {
        if (f is File) f.deleteSync();
      }
    }
  }
}

/// Dominant color extraction from cover bytes → used for the auto theme
/// tint (Komikku feature: theme color from entry cover).
class ImagePalette {
  static Future<int> dominantColor(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes, targetWidth: 48);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      codec.dispose();
      if (data == null) return 0xFF8B5CF6;
      return _quantize(data.buffer.asUint8List());
    } catch (_) {
      return 0xFF8B5CF6;
    }
  }

  static int _quantize(Uint8List rgba) {
    // 4×4×4 color cube histogram (skip near-transparent & near-gray)
    final bins = <int, int>{};
    for (int i = 0; i + 3 < rgba.length; i += 4) {
      final a = rgba[i + 3];
      if (a < 100) continue;
      final r = rgba[i] >> 6, g = rgba[i + 1] >> 6, b = rgba[i + 2] >> 6;
      // skip grayish (low saturation) — they read as "neutral"
      final rr = rgba[i].toDouble(), gg = rgba[i + 1].toDouble(), bb = rgba[i + 2].toDouble();
      final mx = [rr, gg, bb].reduce((a2, b2) => a2 > b2 ? a2 : b2);
      final mn = [rr, gg, bb].reduce((a2, b2) => a2 < b2 ? a2 : b2);
      if (mx - mn < 24) continue;
      final key = (r << 4) | (g << 2) | b;
      bins[key] = (bins[key] ?? 0) + 1;
    }
    if (bins.isEmpty) return 0xFF8B5CF6;
    final top = bins.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final r = ((top >> 4) & 3) * 64 + 32;
    final g = ((top >> 2) & 3) * 64 + 32;
    final b = (top & 3) * 64 + 32;
    return (0xFF << 24) | (r << 16) | (g << 8) | b;
  }
}

// import alias
