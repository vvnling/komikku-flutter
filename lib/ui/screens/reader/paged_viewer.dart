import 'dart:math' as math;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';
import 'chapter_session.dart';
import 'dart:io' show File;
import 'package:flutter/material.dart' show Icons;

/// Paged reader. One gesture arena drives everything:
/// - horizontal drag at scale 1 → page flip (with edge chapter switch)
/// - pinch / double-tap → zoom & pan
/// - tap zones → prev / toggle chrome / next
/// Transitions: slide / cover / fade / depth (setting-driven).
class PagedViewer extends StatefulWidget {
  const PagedViewer({
    super.key,
    required this.session,
    required this.initialPage,
    required this.onPageChanged,
    required this.onChapterEdge,
    this.readingRtl = false,
    this.transition = 0,
    this.tapZones = 0,
    this.autoscroll = false,
    this.autoscrollSpeed = 1.0,
    this.background = const Color(0xFF0A0A0A),
  });

  final ChapterSession session;
  final int initialPage;
  final ValueChanged<int> onPageChanged;
  final void Function(int direction) onChapterEdge; // -1 prev, +1 next
  final bool readingRtl;
  final int transition;
  final int tapZones;
  final bool autoscroll;
  final double autoscrollSpeed;
  final Color background;

  @override
  State<PagedViewer> createState() => _PagedViewerState();
}

class _PagedViewerState extends State<PagedViewer> with TickerProviderStateMixin {
  late int _index = 0;
  late final AnimationController _flip;
  int _flipFrom = 0;
  int _flipTo = 0;
  bool _flipping = false;
  bool _flipForward = true;

  // drag
  double _dragDx = 0;
  double _dragDy = 0;
  bool _dragging = false;
  double _velocity = 0;
  double _lastDx = 0;
  Duration _lastTime = Duration.zero;

  // zoom (per current page)
  double _scale = 1;
  Offset _zoomOffset = Offset.zero;
  double _pinchStartScale = 1;
  bool _zoomed = false;
  Offset _doubleTapFocal = Offset.zero;
  bool _chromeVisible = true;

  // autoscroll
  Ticker? _autoTicker;

  Size _viewport = Size.zero;
  double get _pageWidth => _viewport.width;
  double get _pageHeight => _viewport.height;

  @override
  void initState() {
    super.initState();
    _index = widget.initialPage.clamp(0, math.max(0, widget.session.total - 1));
    _flip = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
    _lastTime = SchedulerBinding.instance.currentFrameTimeStamp;
    if (widget.autoscroll) _startAutoscroll();
  }

  @override
  void didUpdateWidget(PagedViewer old) {
    super.didUpdateWidget(old);
    if (old.autoscroll != widget.autoscroll) {
      widget.autoscroll ? _startAutoscroll() : _stopAutoscroll();
    }
    if (old.autoscrollSpeed != widget.autoscrollSpeed && _autoTicker != null) {
      _stopAutoscroll();
      _startAutoscroll();
    }
  }

  @override
  void dispose() {
    _stopAutoscroll();
    _flip.dispose();
    super.dispose();
  }

  // ── autoscroll ────────────────────────────────────────────────────────────
  void _startAutoscroll() {
    _autoTicker = createTicker((elapsed) {
      if (!_flipping && !_zoomed && _dragging == false) {
        _dragDx += elapsed.inMicroseconds / 1000000 * 60 * widget.autoscrollSpeed;
        if (mounted) setState(() {});
      }
    })..start();
  }

  void _stopAutoscroll() {
    _autoTicker?.dispose();
    _autoTicker = null;
    _dragDx = 0;
  }

  // ── gesture handling ──────────────────────────────────────────────────────
  void _onScaleStart(ScaleStartDetails d) {
    if (_flipping) return;
    _pinchStartScale = _scale;
    _lastDx = d.localFocalPoint.dx;
    _lastTime = SchedulerBinding.instance.currentFrameTimeStamp;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    if (_flipping) return;
    if (d.pointerCount >= 2) {
      // pinch zoom around focal
      final newScale = (_pinchStartScale * d.scale).clamp(1.0, 4.0);
      final ds = newScale / _scale;
      final local = d.localFocalPoint;
      _zoomOffset = local - (local - _zoomOffset) * ds;
      _scale = newScale;
      _zoomed = _scale > 1.01;
      if (mounted) setState(() {});
      return;
    }
    if (_zoomed) {
      // single-finger pan while zoomed
      _zoomOffset += d.focalPointDelta;
      if (mounted) setState(() {});
      return;
    }
    // page drag
    _dragging = true;
    _dragDx += d.focalPointDelta.dx;
    _dragDy += d.focalPointDelta.dy;
    final now = SchedulerBinding.instance.currentFrameTimeStamp;
    final dt = (now - _lastTime).inMicroseconds / 1000000;
    if (dt > 0) _velocity = (d.localFocalPoint.dx - _lastDx) / dt;
    _lastDx = d.localFocalPoint.dx;
    _lastTime = now;
    if (mounted) setState(() {});
  }

  void _onScaleEnd(ScaleEndDetails d) {
    _dragging = false;
    if (_zoomed && _scale > 1) {
      // keep zoom; clamp offset
      _clampZoom();
      return;
    }
    if (_flipping) return;
    final threshold = _pageWidth * 0.16;
    final commit = _dragDx.abs() > threshold || _velocity.abs() > 700;
    if (!commit) {
      // spring back
      _dragDx = 0;
      _dragDy = 0;
      if (mounted) setState(() {});
      HapticFeedback.selectionClick();
      return;
    }
    // edge chapter switch: at first page swiping "back", at last swiping "forward"
    final goingForward = widget.readingRtl ? _dragDx > 0 : _dragDx < 0;
    if (goingForward && _index >= widget.session.total - 1) {
      _dragDx = 0;
      if (mounted) setState(() {});
      widget.onChapterEdge(1);
      return;
    }
    if (!goingForward && _index <= 0) {
      _dragDx = 0;
      if (mounted) setState(() {});
      widget.onChapterEdge(-1);
      return;
    }
    _commitFlip(goingForward);
  }

  void _commitFlip(bool forward) {
    final target = _index + (forward ? 1 : -1);
    if (target < 0 || target >= widget.session.total) return;
    _flipFrom = _index;
    _flipTo = target;
    _flipForward = forward;
    _flipping = true;
    _scale = 1;
    _zoomOffset = Offset.zero;
    _zoomed = false;
    _flip.forward(from: 0).whenComplete(() {
      if (!mounted) return;
      _index = _flipTo;
      _flipping = false;
      _dragDx = 0;
      _dragDy = 0;
      setState(() {});
      widget.onPageChanged(_index);
      HapticFeedback.selectionClick();
    });
  }

  void _clampZoom() {
    final s = _scale;
    final maxX = _pageWidth * (s - 1) / 2;
    final maxY = _pageHeight * (s - 1) / 2;
    _zoomOffset = Offset(
      _zoomOffset.dx.clamp(-maxX - _pageWidth * 0.2, maxX + _pageWidth * 0.2),
      _zoomOffset.dy.clamp(-maxY - _pageHeight * 0.2, maxY + _pageHeight * 0.2),
    );
    if (mounted) setState(() {});
  }

  void _onDoubleTap(Offset local) {
    if (_zoomed) {
      _scale = 1;
      _zoomOffset = Offset.zero;
      _zoomed = false;
    } else {
      _scale = 2.5;
      _zoomOffset = Offset(_pageWidth / 2 - local.dx, 0) * 1.5;
      _zoomed = true;
      _clampZoom();
    }
    setState(() {});
  }

  void _onTap(Offset local) {
    final w = _pageWidth;
    if (widget.tapZones == 1) {
      widget.onPageChanged(_index); // chrome toggle handled by parent
      _chromeVisible = !_chromeVisible;
      return;
    }
    if (local.dx < w * 0.3) {
      // prev
      if (_index > 0) {
        _commitFlip(false);
      } else {
        widget.onChapterEdge(-1);
      }
    } else if (local.dx > w * 0.7) {
      if (_index < widget.session.total - 1) {
        _commitFlip(true);
      } else {
        widget.onChapterEdge(1);
      }
    } else {
      _chromeVisible = !_chromeVisible;
    }
    setState(() {});
  }

  // ── build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _viewport = constraints.biggest;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        onScaleEnd: _onScaleEnd,
        onDoubleTapDown: (d) => _doubleTapFocal = d.localPosition,
        onDoubleTap: () => _onDoubleTap(_doubleTapFocal),
        onTapUp: (d) {
          if (_dragDx.abs() > 8) return;
          _onTap(d.localPosition);
        },
        child: ColoredBox(
          color: widget.background,
          child: AnimatedBuilder(
            animation: _flip,
            builder: (context, child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  _layer(_index, dragOffset: _dragDx, isCurrent: true),
                  if (_flipping && _flipTo != _index) _layer(_flipTo, dragOffset: 0, isCurrent: false, transitioning: true),
                  // edge hint chips
                  if (_dragging && !_flipping && _dragDx.abs() > 40) _edgeHint(),
                ],
              );
            },
          ),
        ),
      );
    });
  }

  Widget _layer(int index, {required double dragOffset, required bool isCurrent, bool transitioning = false}) {
    if (index < 0 || index >= widget.session.total) return const SizedBox.shrink();
    final forward = _flipForward;
    final t = Curves.easeOutCubic.transform(_flip.value);

    Offset slide = Offset.zero;
    double opacity = 1;
    double scale = 1;

    if (_flipping && transitioning) {
      switch (widget.transition) {
        case 1: // cover — incoming covers
          slide = Offset((1 - t) * (_flipForward ? 1 : -1) * _pageWidth, 0);
        case 2: // fade
          opacity = t;
        case 3: // depth
          if (_flipFrom == index) {
            scale = 1 - 0.06 * t;
            slide = Offset(t * (forward ? -0.08 : 0.08) * _pageWidth, 0);
          } else {
            slide = Offset((1 - t) * (forward ? 0.35 : -0.35) * _pageWidth, 0);
          }
        default: // slide
          if (_flipFrom == index) {
            slide = Offset(t * (forward ? -1 : 1) * _pageWidth, 0);
          } else {
            slide = Offset((1 - t) * (forward ? 1 : -1) * _pageWidth, 0);
          }
      }
    } else if (isCurrent) {
      slide = Offset(dragOffset, _dragDy * 0.2);
      if (dragOffset.abs() > 0) {
        final k = (dragOffset / _pageWidth).abs().clamp(0.0, 1.0);
        opacity = 1 - k * 0.25;
      }
    }

    return Transform.translate(
      offset: slide,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: _PageTile(
            session: widget.session,
            index: index,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _edgeHint() {
    final c = context.kColors;
    final goingForward = _dragDx < 0;
    final label = goingForward ? 'Next chapter' : 'Previous chapter';
    final active = goingForward ? _index >= widget.session.total - 1 : _index <= 0;
    if (!active) return const SizedBox.shrink();
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: c.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(KRadius.pill),
          border: Border.all(color: c.accent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(goingForward ? Icons.skip_next : Icons.skip_previous, size: 18, color: c.accent),
            const SizedBox(width: 8),
            Text(label, style: context.kTheme.text(KTypeStyle.label, size: 13, color: c.accent)),
          ],
        ),
      ),
    );
  }
}

/// One page tile — disk file or bytes (demo/local/network).
class _PageTile extends StatelessWidget {
  const _PageTile({required this.session, required this.index, this.fit = BoxFit.contain});

  final ChapterSession session;
  final int index;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final file = session.fileOf(index);
    if (file != null) {
      return Image.file(
        File(file),
        fit: fit,
        gaplessPlayback: true,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, __, ___) => _error(context),
      );
    }
    return FutureBuilder<Uint8List?>(
      future: session.bytesOf(index),
      builder: (context, snap) {
        final bytes = snap.data;
        if (bytes == null) {
          return _placeholder(context);
        }
        return Image.memory(bytes, fit: fit, gaplessPlayback: true, filterQuality: FilterQuality.medium);
      },
    );
  }

  Widget _placeholder(BuildContext context) {
    return ColoredBox(
      color: context.kColors.surfaceAlt.withValues(alpha: 0.25),
      child: Center(
        child: CustomPaint(
          painter: _PageLoadingPainter(context.kColors.accent.withValues(alpha: 0.6)),
          child: const SizedBox(width: 26, height: 26),
        ),
      ),
    );
  }

  Widget _error(BuildContext context) {
    final c = context.kColors;
    return ColoredBox(
      color: c.surfaceAlt.withValues(alpha: 0.2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_outlined, size: 26, color: c.inkFaint),
            const SizedBox(height: 6),
            Text('Page ${index + 1}', style: context.kTheme.text(KTypeStyle.caption, color: c.inkFaint)),
          ],
        ),
      ),
    );
  }
}

class _PageLoadingPainter extends CustomPainter {
  _PageLoadingPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(Rect.fromCircle(center: size.center(Offset.zero), radius: size.shortestSide / 2 - 2), 0, 4.2, false, paint);
  }

  @override
  bool shouldRepaint(_PageLoadingPainter old) => old.color != color;
}
