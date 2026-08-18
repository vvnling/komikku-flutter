import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';
import 'chapter_session.dart';

/// Webtoon viewer — continuous vertical strip with natural page aspects,
/// pinch/double-tap zoom, autoscroll and a draggable scrubber.
import 'dart:ui' as ui;
class WebtoonViewer extends StatefulWidget {
  const WebtoonViewer({
    super.key,
    required this.session,
    required this.onPageChanged,
    required this.onChapterEdge,
    this.autoscroll = false,
    this.autoscrollSpeed = 1.0,
    this.background = const Color(0xFF0A0A0A),
    this.onScrollChanged,
  });

  final ChapterSession session;
  final ValueChanged<int> onPageChanged;
  final void Function(int direction) onChapterEdge;
  final bool autoscroll;
  final double autoscrollSpeed;
  final Color background;
  final ValueChanged<double>? onScrollChanged; // normalized 0..1

  @override
  State<WebtoonViewer> createState() => _WebtoonViewerState();
}

class _WebtoonViewerState extends State<WebtoonViewer> with TickerProviderStateMixin {
  final ScrollController _scroll = ScrollController();
  final List<double> _heights = []; // aspect ratios per page (w/h)
  int _currentIndex = 0;
  bool _endReached = false;

  // zoom
  double _scale = 1;
  Offset _zoomOffset = Offset.zero;
  bool _zoomed = false;

  // autoscroll
  Ticker? _autoTicker;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    if (widget.autoscroll) _startAutoscroll();
  }

  @override
  void didUpdateWidget(WebtoonViewer old) {
    super.didUpdateWidget(old);
    if (old.autoscroll != widget.autoscroll) {
      widget.autoscroll ? _startAutoscroll() : _stopAutoscroll();
    }
    if (old.autoscrollSpeed != widget.autoscrollSpeed) {
      _stopAutoscroll();
      if (widget.autoscroll) _startAutoscroll();
    }
  }

  @override
  void dispose() {
    _stopAutoscroll();
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    if (max <= 0) return;
    final p = (_scroll.offset / max).clamp(0.0, 1.0);
    widget.onScrollChanged?.call(p);

    // track current page index by cumulative heights
    var acc = 0.0;
    var idx = 0;
    for (var i = 0; i < _heights.length; i++) {
      acc += _heights[i];
      if (acc >= _scroll.offset) {
        idx = i;
        break;
      }
      idx = i + 1;
    }
    final clamped = idx.clamp(0, math.max(0, widget.session.total - 1)).toInt();
    if (clamped != _currentIndex) {
      _currentIndex = clamped;
      widget.onPageChanged(clamped);
    }

    // chapter end
    if (!_endReached && _scroll.offset >= max - 4) {
      _endReached = true;
      widget.onChapterEdge(1);
    } else if (_endReached && _scroll.offset < max - 4) {
      _endReached = false;
    }
  }

  // ── autoscroll ────────────────────────────────────────────────────────────
  void _startAutoscroll() {
    _autoTicker = createTicker((elapsed) {
      if (!_scroll.hasClients || _zoomed) return;
      final delta = elapsed.inMicroseconds / 1000000 * 140 * widget.autoscrollSpeed;
      final next = _scroll.offset + delta;
      final max = _scroll.position.maxScrollExtent;
      if (next >= max) {
        _scroll.jumpTo(max);
        widget.onChapterEdge(1);
      } else {
        _scroll.jumpTo(next);
      }
    })..start();
  }

  void _stopAutoscroll() {
    _autoTicker?.dispose();
    _autoTicker = null;
  }

  // ── zoom ──────────────────────────────────────────────────────────────────
  void _onScaleStart(ScaleStartDetails d) {}

  void _onScaleUpdate(ScaleUpdateDetails d) {
    if (d.pointerCount >= 2) {
      final newScale = (d.scale).clamp(1.0, 3.0);
      final ds = newScale / _scale;
      final local = d.localFocalPoint;
      _zoomOffset = (local - (local - _zoomOffset) * ds);
      _scale = newScale;
      _zoomed = _scale > 1.01;
      setState(() {});
    } else if (_zoomed) {
      _zoomOffset += d.focalPointDelta;
      setState(() {});
    }
  }

  void _onScaleEnd(ScaleEndDetails d) {
    if (_zoomed) {
      _clampZoom();
      if (_scale < 1.15) {
        _scale = 1;
        _zoomOffset = Offset.zero;
        _zoomed = false;
        setState(() {});
      }
    }
  }

  void _clampZoom() {
    final maxY = _pageHeight * (_scale - 1) / 2 + 400;
    _zoomOffset = Offset(_zoomOffset.dx.clamp(-_pageWidth * 0.3, _pageWidth * 0.3), _zoomOffset.dy.clamp(-maxY, maxY));
  }

  void _onDoubleTap() {
    if (_zoomed) {
      _scale = 1;
      _zoomOffset = Offset.zero;
      _zoomed = false;
    } else {
      _scale = 2.2;
      _zoomed = true;
      _clampZoom();
    }
    setState(() {});
  }

  double get _pageWidth => MediaQuery.sizeOf(context).width;
  double get _pageHeight => MediaQuery.sizeOf(context).height;

  // ── scrubber drag ─────────────────────────────────────────────────────────
  void _scrub(double dy) {
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    final target = (dy / _pageHeight).clamp(0.0, 1.0) * max;
    _scroll.jumpTo(target);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      onDoubleTap: _onDoubleTap,
      child: ColoredBox(
        color: widget.background,
        child: Transform.translate(
          offset: _zoomOffset,
          child: Transform.scale(
            scale: _scale,
            alignment: Alignment.topCenter,
            child: ListView.builder(
              controller: _scroll,
              physics: _zoomed ? const NeverScrollableScrollPhysics() : null,
              padding: EdgeInsets.zero,
              itemCount: widget.session.total,
              itemBuilder: (context, i) => _WebtoonTile(
                session: widget.session,
                index: i,
                onHeight: (aspect) {
                  if (i < _heights.length && _heights[i] == aspect) return;
                  if (_heights.length <= i) {
                    _heights.addAll(List.filled(i - _heights.length + 1, ChapterSession.placeholderAspect));
                  }
                  _heights[i] = aspect;
                  if (mounted) setState(() {});
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One webtoon strip: decodes dimensions for accurate layout, shows a
/// shimmer placeholder until loaded.
class _WebtoonTile extends StatefulWidget {
  const _WebtoonTile({required this.session, required this.index, required this.onHeight});

  final ChapterSession session;
  final int index;
  final ValueChanged<double> onHeight;

  @override
  State<_WebtoonTile> createState() => _WebtoonTileState();
}

class _WebtoonTileState extends State<_WebtoonTile> {
  Future<Uint8List?>? _future;
  double? _aspect; // width/height

  @override
  void initState() {
    super.initState();
    _future = widget.session.bytesOf(widget.index);
    _future?.then((bytes) {
      if (bytes == null) return;
      _decodeAspect(bytes);
    });
  }

  Future<void> _decodeAspect(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes, targetWidth: 64);
      final frame = await codec.getNextFrame();
      final w = frame.image.width.toDouble();
      final h = frame.image.height.toDouble();
      frame.image.dispose();
      codec.dispose();
      if (h > 0 && mounted) {
        setState(() => _aspect = w / h);
        widget.onHeight(w / h);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final aspect = _aspect ?? ChapterSession.placeholderAspect;
    final file = widget.session.fileOf(widget.index);
    final c = context.kColors;

    return AspectRatio(
      aspectRatio: aspect,
      child: file != null
          ? Image.file(
              File(file),
              fit: BoxFit.contain,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => _error(context),
            )
          : FutureBuilder<Uint8List?>(
              future: _future,
              builder: (context, snap) {
                final bytes = snap.data;
                if (bytes == null) {
                  return ColoredBox(
                    color: c.surfaceAlt.withValues(alpha: 0.18),
                    child: Center(
                      child: Text('${widget.index + 1}', style: context.kTheme.text(KTypeStyle.caption, color: c.inkFaint.withValues(alpha: 0.5))),
                    ),
                  );
                }
                return Image.memory(bytes, fit: BoxFit.contain, gaplessPlayback: true);
              },
            ),
    );
  }

  Widget _error(BuildContext context) {
    final c = context.kColors;
    return ColoredBox(
      color: c.surfaceAlt.withValues(alpha: 0.2),
      child: Center(
        child: Text('Page ${widget.index + 1} failed', style: context.kTheme.text(KTypeStyle.caption, color: c.inkFaint)),
      ),
    );
  }
}

// dart:ui alias
