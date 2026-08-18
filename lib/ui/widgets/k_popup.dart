import 'package:flutter/widgets.dart';
import '../../core/design/k_theme.dart';
import '../../core/design/motion.dart';
import '../../core/design/tokens.dart';
import 'k_pressable.dart';

import 'package:flutter/material.dart' show Icons, Colors;
class KMenuItem {
  const KMenuItem(this.label, {this.icon, this.onTap, this.danger = false, this.trailing, this.enabled = true});
  final String label;
  final Widget? icon;
  final VoidCallback? onTap;
  final bool danger;
  final Widget? trailing;
  final bool enabled;
}

/// Popup menu anchored to a widget (right-click / long-press friendly).
class KMenuButton extends StatefulWidget {
  const KMenuButton({super.key, required this.items, required this.child, this.position = KMenuPosition.below});

  final List<KMenuItem> items;
  final Widget child;
  final KMenuPosition position;

  @override
  State<KMenuButton> createState() => _KMenuButtonState();
}

enum KMenuPosition { below, above, left }

class _KMenuButtonState extends State<KMenuButton> {
  final LayerLink _link = LayerLink();
  late final OverlayPortalController _portal = OverlayPortalController();

  void _toggle() {
    if (_portal.isShowing) {
      _portal.hide();
    } else {
      _portal.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggle,
        onSecondaryTap: _toggle,
        child: OverlayPortal(
          controller: _portal,
          overlayChildBuilder: (_) => CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: widget.position == KMenuPosition.below ? Alignment.topLeft : Alignment.bottomLeft,
            followerAnchor: widget.position == KMenuPosition.below ? Alignment.topLeft : Alignment.bottomLeft,
            offset: widget.position == KMenuPosition.above ? const Offset(0, -8) : const Offset(0, 8),
            child: _KMenuSheet(items: widget.items, onClose: _toggle),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _KMenuSheet extends StatefulWidget {
  const _KMenuSheet({required this.items, required this.onClose});
  final List<KMenuItem> items;
  final VoidCallback onClose;

  @override
  State<_KMenuSheet> createState() => _KMenuSheetState();
}

class _KMenuSheetState extends State<_KMenuSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: KMotion.fast)..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    return ScaleTransition(
      scale: Tween(begin: 0.9, end: 1.0).animate(CurvedAnimation(parent: _c, curve: KMotion.pop)),
      child: FadeTransition(
        opacity: _c,
        child: Container(
          constraints: const BoxConstraints(minWidth: 180, maxWidth: 260),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(KRadius.m),
              border: Border.all(color: c.lineStrong),
              boxShadow: KShadow.deep(Colors.black),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in widget.items)
                  KPressable(
                    onTap: item.enabled
                        ? () {
                            widget.onClose();
                            item.onTap?.call();
                          }
                        : null,
                    radius: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          if (item.icon != null) ...[
                            IconTheme(
                              data: IconThemeData(
                                size: 17,
                                color: item.danger
                                    ? const Color(0xFFE5484D)
                                    : item.enabled
                                        ? c.inkMuted
                                        : c.inkFaint,
                              ),
                              child: item.icon!,
                            ),
                            const SizedBox(width: 10),
                          ],
                          Expanded(
                            child: Text(
                              item.label,
                              style: theme.text(
                                KTypeStyle.bodyMuted,
                                size: 13.5,
                                weight: FontWeight.w600,
                                color: item.danger
                                    ? const Color(0xFFE5484D)
                                    : item.enabled
                                        ? c.ink
                                        : c.inkFaint,
                              ),
                            ),
                          ),
                          if (item.trailing != null) item.trailing!,
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ),
    );
  }
}

/// Custom pull-to-refresh — spring-driven, with an ink-ring indicator.
class KRefresh extends StatefulWidget {
  const KRefresh({super.key, required this.onRefresh, required this.child, this.triggerDistance = 84});

  final Future<void> Function() onRefresh;
  final Widget child;
  final double triggerDistance;

  @override
  State<KRefresh> createState() => _KRefreshState();
}

class _KRefreshState extends State<KRefresh> with SingleTickerProviderStateMixin {
  double _drag = 0;
  bool _refreshing = false;
  late final AnimationController _ring = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

  Future<void> _settle() async {
    _ring.forward();
    _refreshing = true;
    setState(() {});
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        _refreshing = false;
        _drag = 0;
        _ring.stop();
        _ring.value = 0;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (_refreshing) return false;
        if (n is OverscrollNotification && n.metrics.extentBefore == 0 && n.overscroll < 0) {
          setState(() => _drag = (_drag - n.overscroll).clamp(0, 140));
          return true;
        }
        if (n is ScrollEndNotification || n is ScrollUpdateNotification && n.scrollDelta == null) {
          if (_drag >= widget.triggerDistance) {
            _settle();
          } else if (_drag > 0) {
            setState(() => _drag = 0);
          }
          return false;
        }
        return false;
      },
      child: Stack(
        children: [
          widget.child,
          // indicator pinned to top while dragging
          Positioned(
            top: -_drag + 14,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _drag > 2 || _refreshing ? 1 : 0,
                duration: KMotion.fast,
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: c.lineStrong),
                      boxShadow: KShadow.float(Colors.black),
                    ),
                    child: _refreshing
                        ? RotationTransition(
                            turns: _ring,
                            child: CustomPaint(
                              size: const Size(20, 20),
                              painter: _RingSpinPainter(c.accent),
                            ),
                          )
                        : Transform.rotate(
                            angle: (_drag / widget.triggerDistance).clamp(0.0, 1.0) * 3.0,
                            child: Icon(Icons.refresh, size: 18, color: c.accent),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingSpinPainter extends CustomPainter {
  _RingSpinPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(Rect.fromCircle(center: size.center(Offset.zero), radius: size.shortestSide / 2 - 2), 0, 4.4, false, paint);
  }

  @override
  bool shouldRepaint(_RingSpinPainter old) => old.color != color;
}

// material import for Material (transparent wrapper only)
