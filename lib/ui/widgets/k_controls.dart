import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Colors;
import '../../core/design/k_theme.dart';
import '../../core/design/motion.dart';
import '../../core/design/tokens.dart';
import 'dart:math' as math;
import 'k_pressable.dart';

/// Switch — spring-loaded track + thumb, custom painted.
class KSwitch extends StatefulWidget {
  const KSwitch({super.key, required this.value, required this.onChanged, this.disabled = false, this.label});

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool disabled;
  final String? label;

  @override
  State<KSwitch> createState() => _KSwitchState();
}

class _KSwitchState extends State<KSwitch> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController.unbounded(vsync: this, value: widget.value ? 1 : 0);
  }

  @override
  void didUpdateWidget(KSwitch old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _c.animateWith(SpringSimulation(KMotion.springBouncy, _c.value, widget.value ? 1 : 0, 0));
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final content = AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final on = _c.value;
        return Container(
          width: 50,
          height: 30,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Color.lerp(c.surfaceAlt, c.accent, Curves.easeOut.transform(on))!,
            borderRadius: BorderRadius.circular(KRadius.pill),
            border: Border.all(color: Color.lerp(c.lineStrong, c.accent, on)!),
            boxShadow: on > 0.3 ? KShadow.glow(c.accent, strength: 0.18 * on) : null,
          ),
          child: Align(
            alignment: Alignment(math.cos(on * 3.14159) * 0.99, 0),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(KRadius.pill),
                boxShadow: KShadow.soft(Colors.black),
              ),
            ),
          ),
        );
      },
    );

    if (widget.label == null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.disabled ? null : () => widget.onChanged(!widget.value),
        child: content,
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.disabled ? null : () => widget.onChanged(!widget.value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.label!, style: theme.text(KTypeStyle.bodyMuted)),
          const SizedBox(width: 10),
          content,
        ],
      ),
    );
  }
}

/// Slider — custom track + thumb with spring follow.
class KSlider extends StatefulWidget {
  const KSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.label,
    this.valueLabel,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final String Function(double)? valueLabel;

  @override
  State<KSlider> createState() => _KSliderState();
}

class _KSliderState extends State<KSlider> {
  double _dragValue = 0;
  bool _dragging = false;

  double _clamp(double v) => v.clamp(widget.min, widget.max);

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final effective = _dragging ? _dragValue : widget.value;
    final t = (effective - widget.min) / (widget.max - widget.min);

    final bar = LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (d) {
          _dragging = true;
          _dragValue = _clamp(widget.min + (d.localPosition.dx / width) * (widget.max - widget.min));
          setState(() {});
        },
        onPanUpdate: (d) {
          _dragValue = _clamp(widget.min + (d.localPosition.dx / width) * (widget.max - widget.min));
          widget.onChanged(_dragValue);
          setState(() {});
        },
        onPanEnd: (_) {
          _dragging = false;
          widget.onChanged(_dragValue);
          setState(() {});
        },
        child: SizedBox(
          height: 36,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // track
              Container(
                height: 6,
                width: width,
                decoration: BoxDecoration(
                  color: c.surfaceAlt,
                  borderRadius: BorderRadius.circular(KRadius.pill),
                  border: Border.all(color: c.line),
                ),
              ),
              // filled
              FractionallySizedBox(
                widthFactor: t.clamp(0.0, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: c.accent,
                    borderRadius: BorderRadius.circular(KRadius.pill),
                    boxShadow: KShadow.glow(c.accent, strength: 0.3),
                  ),
                ),
              ),
              // thumb
              AnimatedAlign(
                duration: _dragging ? Duration.zero : KMotion.fast,
                curve: KMotion.outCubic,
                alignment: Alignment(t.clamp(0.0, 1.0) * 2 - 1, 0),
                child: FractionallySizedBox(
                  widthFactor: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    transform: Matrix4.translationValues(-9, 0, 0),
                    decoration: BoxDecoration(
                      color: c.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: c.accent, width: 2.5),
                      boxShadow: KShadow.float(Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    if (widget.label == null && widget.valueLabel == null) return bar;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null || widget.valueLabel != null)
          Row(
            children: [
              if (widget.label != null) Text(widget.label!, style: theme.text(KTypeStyle.label, size: 13, color: c.inkMuted)),
              const Spacer(),
              if (widget.valueLabel != null)
                Text(widget.valueLabel!(effective), style: theme.text(KTypeStyle.label, size: 13, color: c.accent)),
            ],
          ),
        bar,
      ],
    );
  }
}

/// Checkbox — custom square with spring check.
class KCheckbox extends StatelessWidget {
  const KCheckbox({super.key, required this.value, required this.onChanged, this.label, this.disabled = false});

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final box = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: disabled ? null : () => onChanged(!value),
      child: AnimatedContainer(
        duration: KMotion.base,
        curve: KMotion.outCubic,
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: value ? c.accent : c.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: value ? c.accent : c.lineStrong, width: value ? 0 : 1.4),
        ),
        child: value
            ? Center(
                child: CustomPaint(
                  size: const Size(12, 12),
                  painter: _CheckPainter(color: c.accentInk),
                ),
              )
            : null,
      ),
    );
    if (label == null) return box;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: disabled ? null : () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          box,
          const SizedBox(width: 9),
          Text(label!, style: theme.text(KTypeStyle.bodyMuted, size: 13.5)),
        ],
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.52)
      ..lineTo(size.width * 0.4, size.height * 0.84)
      ..lineTo(size.width * 0.94, size.height * 0.12);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.color != color;
}

/// Segmented control — custom indicator with spring slide.
class KSegmented<T> extends StatelessWidget {
  const KSegmented({super.key, required this.options, required this.value, required this.onChanged, this.expand = false});

  final List<(T, String)> options;
  final T value;
  final ValueChanged<T> onChanged;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final index = options.indexWhere((o) => o.$1 == value);
    final width = expand ? double.infinity : null;

    Widget item(int i) {
      final (v, label) = options[i];
      final selected = v == value;
      return Expanded(
        child: KPressable(
          onTap: () => onChanged(v),
          radius: 8,
          scale: 0.96,
          child: AnimatedContainer(
            duration: KMotion.base,
            curve: KMotion.outCubic,
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: selected ? c.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: selected ? KShadow.glow(c.accent, strength: 0.2) : null,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: theme.text(KTypeStyle.label, size: 12.5, color: selected ? c.accentInk : c.inkMuted, weight: FontWeight.w700),
            ),
          ),
        ),
      );
    }

    return Container(
      width: width,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: c.line),
      ),
      child: Row(children: [for (var i = 0; i < options.length; i++) item(i)]),
    );
  }
}
