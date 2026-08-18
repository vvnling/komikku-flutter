import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Colors;
import '../../core/design/k_theme.dart';
import '../../core/design/motion.dart';
import '../../core/design/tokens.dart';
import '../../core/design/motifs.dart' show PanelFramePainter, PanelCorner;

/// Bottom sheet — custom route + spring, frosted, drag-to-dismiss.
Future<T?> showKSheet<T>(BuildContext context, {required Widget child, bool scrollable = true, double? height, bool dismissible = true}) {
  return Navigator.of(context, rootNavigator: true).push<T>(_SheetRoute(
    child: child,
    height: height,
    scrollable: scrollable,
    dismissible: dismissible,
  ));
}

class _SheetRoute<T> extends PageRoute<T> {
  _SheetRoute({required this.child, this.height, this.scrollable = true, this.dismissible = true});

  final Widget child;
  final double? height;
  final bool scrollable;
  final bool dismissible;

  @override
  Color get barrierColor => const Color(0x66000000);

  @override
  bool get barrierDismissible => dismissible;

  @override
  String get barrierLabel => 'Dismiss';

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => KMotion.springSettleTime(KMotion.springSoft);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 240);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return _SheetSurface(height: height, scrollable: scrollable, onDismiss: dismissible ? () => navigator!.pop() : null, child: child);
  }
}

class _SheetSurface extends StatefulWidget {
  const _SheetSurface({required this.child, this.height, this.scrollable, this.onDismiss});
  final Widget child;
  final double? height;
  final bool? scrollable;
  final VoidCallback? onDismiss;

  @override
  State<_SheetSurface> createState() => _SheetSurfaceState();
}

class _SheetSurfaceState extends State<_SheetSurface> with SingleTickerProviderStateMixin {
  late final AnimationController _drag;
  bool _dragging = false;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _drag = AnimationController.unbounded(vsync: this, value: 0);
  }

  @override
  void dispose() {
    _drag.dispose();
    super.dispose();
  }

  void _onUpdate(DragUpdateDetails d) {
    if (_dragging) {
      setState(() => _dragOffset = (_dragOffset + d.delta.dy).clamp(-60, 600));
      return;
    }
    setState(() {
      _dragging = true;
      _dragOffset = d.delta.dy.clamp(0, 600);
    });
  }

  void _onEnd() {
    if (_dragOffset > 130) {
      widget.onDismiss?.call();
    } else {
      setState(() => _dragOffset = 0);
    }
    _dragging = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final sheetHeight = widget.height ?? MediaQuery.sizeOf(context).height * 0.72;

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _drag,
        builder: (context, _) {
          return GestureDetector(
            onVerticalDragStart: (_) => _dragging = true,
            onVerticalDragUpdate: _onUpdate,
            onVerticalDragEnd: (_) => _onEnd(),
            child: Transform.translate(
              offset: Offset(0, _dragOffset),
              child: Container(
                height: sheetHeight.clamp(160, MediaQuery.sizeOf(context).height - topInset - 24),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(KRadius.xl)),
                  border: Border.all(color: c.lineStrong),
                  boxShadow: KShadow.deep(Colors.black),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                          child: Container(color: c.surface.withValues(alpha: 0.94)),
                        ),
                      ),
                    ),
                    // drag handle
                    Positioned(
                      top: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: c.lineStrong,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 24,
                      left: 0,
                      right: 0,
                      bottom: bottomInset,
                      child: widget.scrollable!
                          ? ListView(padding: const EdgeInsets.fromLTRB(KSpacing.l, 0, KSpacing.l, KSpacing.xl), children: [widget.child])
                          : SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(KSpacing.l, 0, KSpacing.l, KSpacing.xl),
                              child: widget.child,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Dialog — speed-lines veil + panel frame, spring zoom in.
Future<T?> showKDialog<T>(BuildContext context, {required Widget child, bool dismissible = true}) {
  return Navigator.of(context, rootNavigator: true).push<T>(_DialogRoute(child: child, dismissible: dismissible));
}

class _DialogRoute<T> extends PageRoute<T> {
  _DialogRoute({required this.child, this.dismissible = true});
  final Widget child;
  final bool dismissible;

  @override
  Color get barrierColor => const Color(0x88000000);
  @override
  bool get barrierDismissible => dismissible;
  @override
  String get barrierLabel => 'Dismiss';
  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 340);
  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 180);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return _DialogSurface(child: child);
  }
}

class _DialogSurface extends StatelessWidget {
  const _DialogSurface({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 36),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(KRadius.l),
          border: Border.all(color: c.lineStrong),
          boxShadow: KShadow.deep(Colors.black),
        ),
        child: CustomPaint(
          painter: PanelFramePainter(line: c.line, accent: c.accent.withValues(alpha: 0.5), radius: KRadius.l, bold: KPanelStroke.hair, accentSize: 10, corner: PanelCorner.topRight),
          child: Padding(padding: const EdgeInsets.all(KSpacing.xl), child: child),
        ),
      ),
    );
  }
}

// ── Toast ───────────────────────────────────────────────────────────────────

class ToastEntry {
  const ToastEntry(this.id, this.message, this.icon);
  final int id;
  final String message;
  final Widget? icon;
}

/// Hosted by the app shell; push toasts via KToastHost.of(context).
class KToastHost extends StatefulWidget {
  const KToastHost({super.key, required this.child});
  final Widget child;

  static void show(BuildContext context, String message, {Widget? icon}) {
    final state = context.findAncestorStateOfType<_KToastHostState>();
    state?.show(ToastEntry(DateTime.now().microsecondsSinceEpoch, message, icon));
  }

  @override
  State<KToastHost> createState() => _KToastHostState();
}

class _KToastHostState extends State<KToastHost> with TickerProviderStateMixin {
  final List<(ToastEntry, AnimationController)> _toasts = [];

  void show(ToastEntry e) {
    final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _toasts.add((e, controller));
    controller.forward();
    setState(() {});
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted || !_toasts.any((t) => t.$1.id == e.id)) return;
      controller.reverse().whenComplete(() {
        if (!mounted) return;
        setState(() => _toasts.removeWhere((t) => t.$1.id == e.id));
        controller.dispose();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: MediaQuery.paddingOf(context).top + 12,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (e, c) in _toasts.reversed)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, -1.2), end: Offset.zero).animate(
                        CurvedAnimation(parent: c, curve: KMotion.outQuart, reverseCurve: KMotion.outCubic),
                      ),
                      child: Opacity(
                        opacity: c.value,
                        child: _toastSurface(context, e),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _toastSurface(BuildContext context, ToastEntry e) {
    final theme = context.kTheme;
    final c = theme.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: c.ink,
        borderRadius: BorderRadius.circular(KRadius.pill),
        boxShadow: KShadow.float(Colors.black),
        border: Border.all(color: c.lineStrong.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (e.icon != null) ...[e.icon!, const SizedBox(width: 9)],
          Flexible(
            child: Text(
              e.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.text(KTypeStyle.bodyMuted, size: 13, weight: FontWeight.w600, color: c.bg),
            ),
          ),
        ],
      ),
    );
  }
}
