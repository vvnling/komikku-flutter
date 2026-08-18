import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

/// Procedural manga art engine for the Demo source.
///
/// Every cover and page is generated deterministically from a seed, so the
/// offline demo is fully self-contained. This doubles as a live showcase of
/// the COMICKO motif library (halftones, panels, speed lines, ink).
class DemoArt {
  DemoArt._();

  static const List<(String, Color, Color)> _schemes = [
    ('sun' , Color(0xFFFF6B35), Color(0xFFFFC53E)),
    ('tide', Color(0xFF0EA5E9), Color(0xFF6366F1)),
    ('rose', Color(0xFFF43F5E), Color(0xFFFB923C)),
    ('moss', Color(0xFF10B981), Color(0xFF84CC16)),
    ('violet', Color(0xFF8B5CF6), Color(0xFFEC4899)),
    ('coal', Color(0xFF334155), Color(0xFF94A3B8)),
  ];

  /// Renders a procedurally generated cover PNG → bytes.
  static Future<Uint8List> cover(String mangaId, String title, {int width = 480, int height = 720}) async {
    final rec = ui.PictureRecorder();
    final canvas = Canvas(rec);
    final (_, c1, c2) = _schemes[mangaId.hashCode.abs() % _schemes.length];
    final rng = math.Random(mangaId.hashCode & 0x7fffffff);

    // base gradient
    final rect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
    final grad = Paint()
      ..shader = ui.Gradient.linear(Offset.zero, Offset(width.toDouble(), height.toDouble()), [c1, c2]);
    canvas.drawRect(rect, grad);

    // halftone band
    final dots = Paint()..color = const Color(0x22FFFFFF);
    for (int i = 0; i < 90; i++) {
      final x = rng.nextDouble() * width;
      final y = rng.nextDouble() * height * 0.5;
      canvas.drawCircle(Offset(x, y), 1.5 + rng.nextDouble() * 3, dots);
    }

    // big translucent circle (solar emblem)
    final emblem = Paint()..color = const Color(0x33FFFFFF);
    canvas.drawCircle(Offset(width * 0.72, height * 0.30), width * 0.26, emblem);

    // speed lines from corner
    final sp = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 2;
    final cx = width * 0.15, cy = height * 0.18;
    for (int i = 0; i < 26; i++) {
      final a = rng.nextDouble() * 2.4 + 2.6;
      canvas.drawLine(Offset(cx, cy), Offset(cx + math.cos(a) * width, cy + math.sin(a) * height), sp);
    }

    // title block
    final tp = TextPainter(
      text: TextSpan(
        text: title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontWeight: FontWeight.w700,
          fontSize: 30,
          height: 1.1,
          color: const Color(0xFFFDFCFF),
          shadows: const [Shadow(color: Color(0x66000000), blurRadius: 18)],
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 4,
      ellipsis: '…',
    )..layout(maxWidth: width * 0.82);
    tp.paint(canvas, Offset(width * 0.09, height * 0.76));

    // accent bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(width * 0.09, height * 0.76 + tp.height + 16, width * 0.34, 8),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xCCFFFFFF),
    );

    // speech "ing" bubble
    final bubble = Path()
      ..addOval(Rect.fromCircle(center: Offset(width * 0.5, height * 0.14), radius: 46))
      ..moveTo(width * 0.5 - 20, height * 0.14 + 42)
      ..lineTo(width * 0.5 - 34, height * 0.14 + 66)
      ..lineTo(width * 0.5 + 6, height * 0.14 + 44);
    canvas.drawPath(bubble, Paint()..color = const Color(0xB3FFFFFF));
    final kp = TextPainter(
      text: const TextSpan(
        text: 'K',
        style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 40, color: Color(0xFF1B1830)),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    kp.paint(canvas, Offset(width * 0.5 - 28, height * 0.14 - 30));

    final pic = rec.endRecording();
    final image = await pic.toImage(width, height);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return bytes!.buffer.asUint8List();
  }

  /// Renders one procedural "manga page" as PNG bytes (800×1200).
  static Future<Uint8List> page(String mangaId, int chapter, int pageIndex) async {
    const width = 800, height = 1200;
    final rec = ui.PictureRecorder();
    final canvas = Canvas(rec);
    final rng = math.Random((mangaId.hashCode & 0x7fffffff) ^ (chapter * 7919) ^ (pageIndex * 104729));

    final paper = Color(0xFFF7F3EA);
    final inkColor = Color(0xFF1F1B16);
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), Paint()..color = paper);

    // panel layout: 2×3 grid with random gutters
    final panels = <Rect>[];
    for (int row = 0; row < 3; row++) {
      final cols = row == 1 ? 1 : 2; // middle row = splash panel
      final pw = (width - 40 - (cols - 1) * 16) / cols;
      for (int col = 0; col < cols; col++) {
        final h = (height - 40 - 2 * 16) / 3;
        panels.add(Rect.fromLTWH(20 + col * (pw + 16), 20 + row * (h + 16), pw, h));
      }
    }

    final panelPaint = Paint()..color = inkColor;
    final fillPaint = Paint()..color = paper;
    var idx = 0;
    for (final p in panels) {
      idx++;
      canvas.drawRRect(RRect.fromRectAndRadius(p, const Radius.circular(6)), panelPaint);
      final inner = p.deflate(5);
      canvas.drawRRect(RRect.fromRectAndRadius(inner, const Radius.circular(3)), fillPaint);

      // background texture: halftone or crosshatch
      final shade = Paint()..color = inkColor.withValues(alpha: 0.10 + rng.nextDouble() * 0.14);
      if (idx % 3 == 0) {
        for (int i = 0; i < 26; i++) {
          final x = inner.left + rng.nextDouble() * inner.width;
          final y = inner.top + rng.nextDouble() * inner.height;
          canvas.drawCircle(Offset(x, y), 2.2, shade);
        }
      } else {
        final line = Paint()..color = inkColor.withValues(alpha: 0.10);
        for (double y = inner.top; y < inner.bottom; y += 26) {
          canvas.drawLine(Offset(inner.left, y), Offset(inner.right, y), line);
        }
      }

      // speed lines in one panel
      if (idx == 4 || idx == 2) {
        final sp = Paint()
          ..color = inkColor.withValues(alpha: 0.28)
          ..strokeWidth = 2.4;
        final fx = inner.left + inner.width * (idx == 4 ? 0.8 : 0.2);
        final fy = inner.top + inner.height * 0.5;
        for (int i = 0; i < 14; i++) {
          final a = rng.nextDouble() * math.pi * 2;
          canvas.drawLine(Offset(fx, fy), Offset(fx + math.cos(a) * inner.width * 0.7, fy + math.sin(a) * inner.height * 0.8), sp);
        }
      }

      // figure: simple "character" blocks + action strokes
      final figure = Paint()..color = inkColor;
      final head = Offset(inner.left + inner.width * (0.3 + rng.nextDouble() * 0.4), inner.top + inner.height * 0.42);
      canvas.drawCircle(head, inner.shortestSide * 0.09, figure);
      final torso = Rect.fromCenter(center: head + Offset(0, inner.shortestSide * 0.16), width: inner.shortestSide * 0.2, height: inner.shortestSide * 0.24);
      canvas.drawRRect(RRect.fromRectAndRadius(torso, Radius.circular(inner.shortestSide * 0.06)), figure);

      // speech bubble
      if (rng.nextDouble() < 0.65) {
        final bubbleCenter = head + Offset(inner.width * (0.18 + rng.nextDouble() * 0.2), -inner.height * 0.18);
        final r = 26.0 + rng.nextDouble() * 18;
        final bubble = Path()
          ..addOval(Rect.fromCircle(center: bubbleCenter, radius: r))
          ..moveTo(bubbleCenter.dx - r * 0.4, bubbleCenter.dy + r * 0.75)
          ..lineTo(bubbleCenter.dx - r * 0.15, bubbleCenter.dy + r * 1.3)
          ..lineTo(bubbleCenter.dx + r * 0.35, bubbleCenter.dy + r * 0.7);
        canvas.drawPath(bubble, Paint()..color = const Color(0xFFFFFFFF));
        canvas.drawPath(bubble, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2
          ..color = inkColor);
        final words = _bubbles[rng.nextInt(_bubbles.length)];
        final tp = TextPainter(
          text: TextSpan(text: words, style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w500, fontSize: 15, color: inkColor)),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: r * 1.6);
        tp.paint(canvas, bubbleCenter - Offset(tp.width / 2, tp.height / 2));
      }

      // panel number (page gutter mark)
      final numPaint = TextPainter(
        text: TextSpan(text: '$idx', style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 11, color: Color(0x66808080))),
        textDirection: TextDirection.ltr,
      )..layout();
      numPaint.paint(canvas, Offset(p.right - 14, p.bottom - 20));
    }

    // page footer
    final footer = TextPainter(
      text: TextSpan(
        text: 'COMICKO DEMO  •  ${chapter.toString().padLeft(2, '0')}  •  ${pageIndex.toString().padLeft(3, '0')}',
        style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 10, letterSpacing: 2, color: Color(0x55909090)),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    footer.paint(canvas, Offset(40, height - 18));

    final pic = rec.endRecording();
    final image = await pic.toImage(width, height);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return bytes!.buffer.asUint8List();
  }

  static const _bubbles = [
    'NEXT CHAPTER!',
    'WHAT?!',
    'IMPOSSIBLE…',
    'LET\'S GO!',
    'NO WAY…',
    'HA!',
    'WHO ARE YOU?',
    'I\'LL PROTECT YOU',
    'TO BE CONTINUED',
    'STOP RIGHT THERE',
    'NOT SO FAST!',
    'THIS IS IT!',
  ];

  /// Downscale a generated PNG for covers (jpg for pages is not needed).
  static Uint8List downscale(Uint8List png, {int maxW = 240}) {
    final decoded = img.decodePng(png);
    if (decoded == null) return png;
    final scaled = img.copyResize(decoded, width: maxW, interpolation: img.Interpolation.average);
    return Uint8List.fromList(img.encodeJpg(scaled, quality: 82));
  }
}