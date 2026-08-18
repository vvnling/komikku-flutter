import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../../core/app_scope.dart';
import '../../core/design/k_theme.dart';
import '../../core/design/motion.dart';
import '../../core/design/tokens.dart';
import 'k_pressable.dart';
import '../../core/design/motifs.dart' show HalftonePainter;

/// Cover art with the full COMICKO treatment: procedural placeholder,
/// sheen sweep, halftone fallback, spring reveal, palette tint.
import 'dart:typed_data';
import 'package:flutter/material.dart' show Icons, Colors;
class KCover extends StatefulWidget {
  const KCover({
    super.key,
    required this.url,
    this.title,
    this.width,
    this.height,
    this.borderRadius = KRadius.m,
    this.onTap,
    this.onLongPress,
    this.revealIndex = 0,
    this.tint,
    this.aspectRatio = 2 / 3,
    this.hero = false,
  });

  final String? url;
  final String? title;
  final double? width;
  final double? height;
  final double borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final int revealIndex;
  final Color? tint;
  final double aspectRatio;
  final bool hero;

  @override
  State<KCover> createState() => _KCoverState();
}

class _KCoverState extends State<KCover> with SingleTickerProviderStateMixin {
  late final AnimationController _reveal;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _reveal = AnimationController(vsync: this, duration: KMotion.slow);
    Future.delayed(KMotion.stagger(widget.revealIndex, step: const Duration(milliseconds: 60)), () {
      if (mounted) _reveal.forward();
    });
  }

  @override
  void didUpdateWidget(KCover old) {
    super.didUpdateWidget(old);
    if (old.url != widget.url) {
      _loaded = false;
      _reveal.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final scope = context.getInheritedWidgetOfExactType<AppScope>();

    final size = widget.height != null
        ? Size(widget.width ?? widget.height! * widget.aspectRatio, widget.height!)
        : null;

    Widget body;
    if (widget.url == null || widget.url!.isEmpty) {
      body = _placeholder(context);
    } else {
      body = _CoverImage(
        url: widget.url!,
        borderRadius: widget.borderRadius,
        onLoaded: () {
          if (mounted && !_loaded) setState(() => _loaded = true);
        },
      );
    }

    final cover = Container(
      width: size?.width,
      height: size?.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: c.lineStrong.withValues(alpha: 0.55), width: 0.8),
        boxShadow: KShadow.float(Colors.black),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          body,
          // ambient sheen over everything (skip without an app scope)
          if (scope?.scope.shaders != null)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: scope!.scope.shaders.sheenPainter(
                    time: _reveal,
                    tint: Colors.white.withValues(alpha: 0.85),
                    strength: 0.32,
                    speed: 0.55,
                    phase: widget.revealIndex * 0.9,
                  ),
                ),
              ),
            ),
          // gradient scrim for legibility at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 30,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.28)],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final revealed = AnimatedBuilder(
      animation: _reveal,
      builder: (context, child) {
        final t = Curves.easeOutBack.transform(_reveal.value);
        return Opacity(
          opacity: _reveal.value,
          child: Transform.scale(scale: 0.92 + 0.08 * t, child: child),
        );
      },
      child: cover,
    );

    if (widget.onTap == null && widget.onLongPress == null) return revealed;
    return KPressable(onTap: widget.onTap, onLongPress: widget.onLongPress, radius: widget.borderRadius, child: revealed);
  }

  Widget _placeholder(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final seed = (widget.title ?? '').hashCode;
    final accent = widget.tint ?? c.accent;
    return CustomPaint(
      painter: _CoverPlaceholderPainter(
        title: widget.title ?? '?',
        seed: seed,
        accent: accent,
        alt: c.accentAlt,
        ink: c.inkMuted,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            widget.title ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.text(KTypeStyle.caption, size: 11, weight: FontWeight.w700, color: c.surface),
          ),
        ),
      ),
    );
  }
}

class _CoverImage extends StatefulWidget {
  const _CoverImage({required this.url, required this.borderRadius, this.onLoaded});
  final String url;
  final double borderRadius;
  final VoidCallback? onLoaded;

  @override
  State<_CoverImage> createState() => _CoverImageState();
}

class _CoverImageState extends State<_CoverImage> {
  Future<Uint8List?>? _future;

  @override
  void initState() {
    super.initState();
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    _future = scope?.scope.covers.fetch(widget.url) ?? Future.value(null);
    _future?.then((_) => widget.onLoaded?.call());
  }

  @override
  void didUpdateWidget(_CoverImage old) {
    super.didUpdateWidget(old);
    if (old.url != widget.url) {
      _future = context.covers.fetch(widget.url);
      _future?.then((_) => widget.onLoaded?.call());
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    return FutureBuilder<Uint8List?>(
      future: _future,
      builder: (context, snap) {
        final bytes = snap.data;
        if (bytes == null) {
          if (snap.connectionState != ConnectionState.done) {
            return Container(
              color: c.surfaceAlt,
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CustomPaint(
                    painter: _MiniRingPainter(c.accent.withValues(alpha: 0.7)),
                  ),
                ),
              ),
            );
          }
          return Container(
            color: c.surfaceAlt,
            child: CustomPaint(
              painter: HalftonePainter(color: c.inkFaint.withValues(alpha: 0.25), density: 0.7),
              child: Center(child: Icon(Icons.broken_image_outlined, size: 22, color: c.inkFaint)),
            ),
          );
        }
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) => Container(
            color: c.surfaceAlt,
            child: Center(child: Icon(Icons.broken_image_outlined, size: 22, color: c.inkFaint)),
          ),
        );
      },
    );
  }
}

class _MiniRingPainter extends CustomPainter {
  _MiniRingPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(Rect.fromCircle(center: size.center(Offset.zero), radius: size.shortestSide / 2 - 3), 0, math.pi * 1.4, false, paint);
  }

  @override
  bool shouldRepaint(_MiniRingPainter old) => old.color != color;
}

class _CoverPlaceholderPainter extends CustomPainter {
  _CoverPlaceholderPainter({required this.title, required this.seed, required this.accent, required this.alt, required this.ink});
  final String title;
  final int seed;
  final Color accent, alt, ink;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(seed & 0x7fffffff);
    final rect = Offset.zero & size;
    final grad = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accent, alt],
      ).createShader(rect);
    canvas.drawRect(rect, grad);

    // halftone overlay
    canvas.save();
    canvas.clipRect(rect);
    final dots = Paint()..color = Colors.white.withValues(alpha: 0.10);
    for (int i = 0; i < 40; i++) {
      canvas.drawCircle(Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height), 1.6 + rng.nextDouble() * 2.4, dots);
    }
    // big emblem circle
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.28),
      size.shortestSide * 0.26,
      Paint()..color = Colors.white.withValues(alpha: 0.13),
    );
    // speed lines from corner
    final sp = Paint()
      ..color = Colors.black.withValues(alpha: 0.16)
      ..strokeWidth = 1.8;
    for (int i = 0; i < 12; i++) {
      final a = rng.nextDouble() * 2.2 + 2.8;
      canvas.drawLine(
        Offset(size.width * 0.12, size.height * 0.12),
        Offset(size.width * 0.12 + math.cos(a) * size.width, size.height * 0.12 + math.sin(a) * size.height),
        sp,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CoverPlaceholderPainter old) => old.seed != seed || old.accent != accent;
}

// icon import
