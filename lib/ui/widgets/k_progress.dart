import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../../core/design/k_theme.dart';
import '../../core/design/tokens.dart';

/// Custom progress ring (no Material CircularProgressIndicator).
class KProgressRing extends StatelessWidget {
  const KProgressRing({super.key, this.value, this.size = 22, this.stroke = 2.6, this.color, this.track = true, this.indeterminate = false});

  /// 0..1; null → indeterminate.
  final double? value;
  final double size;
  final double stroke;
  final Color? color;
  final bool track;
  final bool indeterminate;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.kColors.accent;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(value: value, color: c, stroke: stroke, track: track, indeterminate: indeterminate),
        child: indeterminate && value == null
            ? const _IndeterminateSpin()
            : null,
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({this.value, required this.color, required this.stroke, required this.track, this.indeterminate = false});
  final double? value;
  final Color color;
  final double stroke;
  final bool track;
  final bool indeterminate;

  @override
  void paint(Canvas canvas, Size size) {
    final arc = stroke / 2 + 0.5;
    final r = size.shortestSide / 2 - arc;
    final center = size.center(Offset.zero);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    if (track && !indeterminate) {
      base.color = color.withValues(alpha: 0.14);
      canvas.drawCircle(center, r, base);
    }
    base.color = color;
    final sweep = (value ?? 0.25) * math.pi * 2;
    canvas.drawArc(Rect.fromCircle(center: center, radius: r), -math.pi / 2, sweep, false, base);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value || old.color != color;
}

class _IndeterminateSpin extends StatefulWidget {
  const _IndeterminateSpin();
  @override
  State<_IndeterminateSpin> createState() => _IndeterminateSpinState();
}

class _IndeterminateSpinState extends State<_IndeterminateSpin> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RotationTransition(turns: _c, child: const SizedBox.expand());
}

/// Linear progress (custom).
class KProgressBar extends StatelessWidget {
  const KProgressBar({super.key, this.value = 0, this.height = 4, this.color, this.background});

  final double value;
  final double height;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(KRadius.pill),
      child: Container(
        height: height,
        color: background ?? c.surfaceAlt,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: color ?? c.accent,
              borderRadius: BorderRadius.circular(KRadius.pill),
              boxShadow: KShadow.glow(color ?? c.accent, strength: 0.35),
            ),
          ),
        ),
      ),
    );
  }
}

/// Skeleton shimmer block.
class KSkeleton extends StatefulWidget {
  const KSkeleton({super.key, this.width, this.height = 14, this.radius = 8, this.circle = false});

  final double? width;
  final double height;
  final double radius;
  final bool circle;

  @override
  State<KSkeleton> createState() => _KSkeletonState();
}

class _KSkeletonState extends State<KSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.circle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget.circle ? null : BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * t, 0),
              end: Alignment(-0.4 + 2 * t, 0),
              colors: [c.surfaceAlt, c.surfaceAlt.withValues(alpha: 0.4), c.surfaceAlt],
            ),
          ),
        );
      },
    );
  }
}

/// Empty state — ink waves shader backdrop + message + optional action.
class KEmpty extends StatelessWidget {
  const KEmpty({super.key, this.icon, this.title, this.message, this.action, this.compact = false});

  final Widget? icon;
  final String? title;
  final String? message;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final a = c.accent.withValues(alpha: 0.55);
    final b = c.accentAlt.withValues(alpha: 0.45);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(KSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!compact) ...[
              SizedBox(
                width: 200,
                height: 110,
                child: CustomPaint(
                  painter: _StaticWavePainter(a, b),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (icon != null) ...[icon!, const SizedBox(height: 12)],
            if (title != null) Text(title!, textAlign: TextAlign.center, style: theme.text(KTypeStyle.title, size: 16, weight: FontWeight.w700)),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(message!, textAlign: TextAlign.center, style: theme.text(KTypeStyle.bodyMuted, size: 13.5, color: c.inkMuted)),
            ],
            if (action != null) ...[const SizedBox(height: 18), action!],
          ],
        ),
      ),
    );
  }
}

class _StaticWavePainter extends CustomPainter {
  _StaticWavePainter(this.a, this.b);
  final Color a, b;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      paint.color = i == 1 ? b : a;
      final path = Path();
      final baseY = size.height * (0.3 + i * 0.2);
      for (double x = 0; x <= size.width; x += 4) {
        final y = baseY + math.sin(x / size.width * math.pi * 2 + i * 1.9) * 9 + math.sin(x / size.width * math.pi * 5 + i) * 4;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_StaticWavePainter old) => old.a != a || old.b != b;
}
