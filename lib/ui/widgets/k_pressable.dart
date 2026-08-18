import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../core/app_scope.dart';
import '../../core/design/k_theme.dart';
import '../../core/design/motion.dart';

/// The base interactive surface of COMICKO. Everything pressable derives
/// from this: shader ink-ripple feedback + spring scale, no Material.
class KPressable extends StatefulWidget {
  const KPressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
    this.disabled = false,
    this.radius = 12,
    this.scale = 0.97,
    this.ripple = true,
    this.haptic = true,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;
  final bool disabled;
  final double radius;
  final double scale;
  final bool ripple;
  final bool haptic;
  final HitTestBehavior behavior;

  @override
  State<KPressable> createState() => _KPressableState();
}

class _KPressableState extends State<KPressable> with TickerProviderStateMixin {
  late final AnimationController _rippleController;
  late final AnimationController _scaleController;
  Offset _rippleCenter = Offset.zero;
  bool _rippleActive = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 380), lowerBound: 0, upperBound: 1);
    _rippleController.addStatusListener((s) {
      if (s == AnimationStatus.completed) _rippleActive = false;
    });
    _scaleController = AnimationController.unbounded(vsync: this, value: 1);
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _springTo(double target, {double velocity = 0}) {
    _scaleController.animateWith(SpringSimulation(KMotion.springSnappy, _scaleController.value, target, velocity));
  }

  void _onDown(TapDownDetails d) {
    if (widget.disabled) return;
    _pressed = true;
    _rippleCenter = d.localPosition;
    _rippleActive = true;
    _rippleController.forward(from: 0);
    _springTo(widget.scale);
    if (widget.haptic) HapticFeedback.selectionClick();
  }

  void _onUp() {
    if (!_pressed) return;
    _pressed = false;
    _springTo(1);
  }

  CustomPainter? _inkPainter(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    final shaders = scope?.scope.shaders;
    if (shaders == null) return null; // tests / no scope: plain press feedback
    return shaders.inkPainter(
      time: _rippleController,
      center: _rippleCenter,
      color: context.kTheme.colors.accent.withValues(alpha: 0.55),
      maxRadius: 220,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _onDown,
      onTapUp: (_) => _onUp(),
      onTapCancel: _onUp,
      onTap: widget.disabled ? null : widget.onTap,
      onLongPress: widget.disabled ? null : () {
        _onUp();
        widget.onLongPress?.call();
      },
      onSecondaryTapDown: widget.onSecondaryTap == null ? null : (d) {
        _rippleCenter = d.localPosition;
        _rippleActive = true;
        _rippleController.forward(from: 0);
      },
      onSecondaryTap: widget.onSecondaryTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_rippleController, _scaleController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleController.value,
            child: widget.ripple && _rippleActive && !widget.disabled
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(widget.radius),
                    child: Stack(children: [
                      child!,
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: _inkPainter(context),
                          ),
                        ),
                      ),
                    ]),
                  )
                : child!,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Static press feedback without ripple (for tiny inline targets).
class KScaleTap extends StatefulWidget {
  const KScaleTap({super.key, required this.child, this.onTap, this.scale = 0.9, this.enabled = true});

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final bool enabled;

  @override
  State<KScaleTap> createState() => _KScaleTapState();
}

class _KScaleTapState extends State<KScaleTap> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  bool _down = false;

  @override
  void initState() {
    super.initState();
    _c = AnimationController.unbounded(vsync: this, value: 1);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.enabled
          ? (_) {
              _down = true;
              _c.animateWith(SpringSimulation(KMotion.springSnappy, 1, widget.scale, 0));
            }
          : null,
      onTapUp: widget.enabled ? (_) => _up() : null,
      onTapCancel: widget.enabled ? _up : null,
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) => Transform.scale(scale: _c.value, child: child),
        child: widget.child,
      ),
    );
  }

  void _up() {
    if (!_down) return;
    _down = false;
    _c.animateWith(SpringSimulation(KMotion.springSnappy, _c.value, 1, 0));
  }
}
