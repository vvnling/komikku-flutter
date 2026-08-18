import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'tokens.dart';

/// Signature painted motifs of the COMICKO language — halftone dots,
/// manga panel frames and the app mark. These repeat across the app so
/// the visual identity reads instantly.

// ────────────────────────────────────────────────────────────────────────────
// Halftone dots (screen-tone texture)
// ────────────────────────────────────────────────────────────────────────────

class HalftonePainter extends CustomPainter {
  HalftonePainter({required this.color, this.density = 0.5, this.phase = 0});

  final Color color;
  /// 0..1 — how packed the dots are.
  final double density;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final spacing = 14.0 - density * 6;
    final radius = 1.6 + density * 1.6;
    final paint = Paint()..color = color;
    final startX = -spacing + phase * spacing;
    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      final off = (y / spacing).round().isEven ? 0.0 : spacing / 2;
      for (double x = startX + off; x < size.width + spacing; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(HalftonePainter old) =>
      old.color != color || old.density != density || old.phase != phase;
}

// ────────────────────────────────────────────────────────────────────────────
// Panel frame — double-stroke manga panel with corner accents
// ────────────────────────────────────────────────────────────────────────────

class PanelFramePainter extends CustomPainter {
  PanelFramePainter({
    required this.line,
    required this.accent,
    this.radius = KRadius.m,
    this.hair = KPanelStroke.hair,
    this.bold = KPanelStroke.thin,
    this.accentSize = 8,
    this.corner = PanelCorner.topLeft,
  });

  final Color line;
  final Color accent;
  final double radius;
  final double hair;
  final double bold;
  final double accentSize;
  final PanelCorner corner;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final hairPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = hair
      ..color = line;
    final boldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = bold
      ..color = line;

    // outer bold frame
    canvas.drawRRect(RRect.fromRectAndRadius(rect.deflate(bold / 2 + hair + 2), Radius.circular(radius + 2)), boldPaint);
    // inner hairline
    canvas.drawRRect(RRect.fromRectAndRadius(rect.deflate(hair / 2 + bold + 4), Radius.circular(radius - 2)), hairPaint);

    // corner accent stroke (seal mark)
    final s = accentSize;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = bold * 1.6
      ..strokeCap = StrokeCap.round
      ..color = accent;
    switch (corner) {
      case PanelCorner.topLeft:
        canvas.drawLine(Offset(0, s), Offset(0, s * 0.2), p);
        canvas.drawLine(Offset(0, s * 0.2), Offset(s, s * 0.2), p);
      case PanelCorner.topRight:
        canvas.drawLine(Offset(size.width, s), Offset(size.width, s * 0.2), p);
        canvas.drawLine(Offset(size.width, s * 0.2), Offset(size.width - s, s * 0.2), p);
      case PanelCorner.bottomLeft:
        canvas.drawLine(Offset(0, size.height - s), Offset(0, size.height - s * 0.2), p);
        canvas.drawLine(Offset(0, size.height - s * 0.2), Offset(s, size.height - s * 0.2), p);
      case PanelCorner.bottomRight:
        canvas.drawLine(Offset(size.width, size.height - s), Offset(size.width, size.height - s * 0.2), p);
        canvas.drawLine(Offset(size.width, size.height - s * 0.2), Offset(size.width - s, size.height - s * 0.2), p);
      case PanelCorner.none:
        break;
    }

    // stray ink speck near the corner
    canvas.drawCircle(Offset(size.width - s * 1.2, s * 1.3), 1.4, Paint()..color = accent);
  }

  @override
  bool shouldRepaint(PanelFramePainter old) =>
      old.line != line || old.accent != accent || old.radius != radius;
}

enum PanelCorner { none, topLeft, topRight, bottomLeft, bottomRight }

// ────────────────────────────────────────────────────────────────────────────
// App mark — "panel + ink stroke"
// ────────────────────────────────────────────────────────────────────────────

class KLogoPainter extends CustomPainter {
  KLogoPainter({required this.ink, required this.accent, this.detail = 1});

  final Color ink;
  final Color accent;
  final double detail;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final s = size.shortestSide;

    // halftone ring
    final dots = Paint()..color = ink.withValues(alpha: 0.16 * detail);
    for (int i = 0; i < 14; i++) {
      final a = i / 14 * math.pi * 2;
      final r = s * (0.44 + 0.02 * math.sin(i * 3.7));
      canvas.drawCircle(c + Offset(math.cos(a), math.sin(a)) * r, s * 0.022, dots);
    }

    // bubble panel with tail
    final panel = RRect.fromRectAndRadius(
      Rect.fromCenter(center: c, width: s * 0.78, height: s * 0.78),
      Radius.circular(s * 0.2),
    );
    final tail = Path()
      ..moveTo(c.dx - s * 0.12, c.dy + s * 0.36)
      ..lineTo(c.dx - s * 0.26, c.dy + s * 0.52)
      ..lineTo(c.dx + s * 0.04, c.dy + s * 0.40)
      ..close();
    final frame = Path()..addRRect(panel)..addPath(tail, Offset.zero);

    canvas.drawPath(frame, Paint()..color = ink.withValues(alpha: 0.10 * detail));
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.05
      ..color = ink;
    canvas.drawPath(frame, stroke);

    // ink stroke "K"
    final k = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.085
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = ink;
    final base = c.dx - s * 0.18;
    final top = c.dy - s * 0.22;
    final bottom = c.dy + s * 0.22;
    final mid = c.dy + s * 0.02;
    canvas.drawLine(Offset(base, top), Offset(base, bottom), k);
    canvas.drawLine(Offset(base, top), Offset(base + s * 0.36, mid - s * 0.02), k);
    canvas.drawLine(Offset(base + s * 0.36, mid - s * 0.02), Offset(base, bottom), k);

    // seal dot
    canvas.drawCircle(c + Offset(s * 0.30, s * 0.30), s * 0.055, Paint()..color = accent);
  }

  @override
  bool shouldRepaint(KLogoPainter old) =>
      old.ink != ink || old.accent != accent || old.detail != detail;
}

/// Static speed-line ring (used behind dialogs and the reader veil).
class SpeedRingPainter extends CustomPainter {
  SpeedRingPainter({required this.ink, this.spokes = 72, this.gap = 0.28});

  final Color ink;
  final int spokes;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final maxR = size.shortestSide * 0.72;
    final minR = maxR * gap;
    final paint = Paint()
      ..color = ink
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < spokes; i++) {
      final a = i / spokes * math.pi * 2;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(c + dir * minR, c + dir * maxR, paint);
    }
  }

  @override
  bool shouldRepaint(SpeedRingPainter old) => old.ink != ink;
}
