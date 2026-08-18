import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Colors;
import '../../core/design/k_theme.dart';
import '../../core/design/tokens.dart';
import 'k_pressable.dart';

/// Button. Variants: primary (accent fill), secondary (surface + border),
/// ghost (text only), danger. All built from Container + KPressable.
class KButton extends StatelessWidget {
  const KButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.iconEnd,
    this.variant = KButtonVariant.primary,
    this.size = KButtonSize.md,
    this.disabled = false,
    this.expand = false,
    this.padding,
  });

  final String label;
  final VoidCallback? onTap;
  final Widget? icon;
  final Widget? iconEnd;
  final KButtonVariant variant;
  final KButtonSize size;
  final bool disabled;
  final bool expand;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;

    final (Color bg, Color fg, Color border, Color ripple) = switch (variant) {
      KButtonVariant.primary => (c.accent, c.accentInk, c.accent, c.accentInk),
      KButtonVariant.secondary => (c.surface, c.ink, c.lineStrong, c.accent),
      KButtonVariant.ghost => (Colors.transparent, c.inkMuted, Colors.transparent, c.accent),
      KButtonVariant.danger => (c.surface, const Color(0xFFE5484D), c.lineStrong, const Color(0xFFE5484D)),
    };

    final (double h, double fs, double padH, double padV, double iconGap) = switch (size) {
      KButtonSize.sm => (34.0, 13.0, 12.0, 0.0, 6.0),
      KButtonSize.md => (42.0, 14.0, 18.0, 0.0, 8.0),
      KButtonSize.lg => (50.0, 16.0, 24.0, 0.0, 10.0),
    };

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[icon!, SizedBox(width: iconGap)],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.text(KTypeStyle.label, color: disabled ? c.inkFaint : fg, size: fs, weight: FontWeight.w700, spacing: 0.4),
          ),
        ),
        if (iconEnd != null) ...[SizedBox(width: iconGap), iconEnd!],
      ],
    );

    return KPressable(
      onTap: onTap,
      disabled: disabled,
      radius: 14,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        height: h,
        padding: padding ?? EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        decoration: BoxDecoration(
          color: disabled ? c.surfaceAlt : bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: disabled ? c.line : border, width: variant == KButtonVariant.primary ? 0 : 1.1),
          boxShadow: variant == KButtonVariant.primary && !disabled ? KShadow.glow(c.accent, strength: 0.16) : null,
        ),
        child: expand ? SizedBox(width: double.infinity, child: content) : content,
      ),
    );
  }
}

enum KButtonVariant { primary, secondary, ghost, danger }

enum KButtonSize { sm, md, lg }

/// Icon-only button.
class KIconButton extends StatelessWidget {
  const KIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.onLongPress,
    this.size = 40,
    this.iconSize = 20,
    this.tone = KIconTone.defaults,
    this.radius = 12,
    this.tooltip,
    this.disabled = false,
  });

  final Widget icon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double size;
  final double iconSize;
  final KIconTone tone;
  final double radius;
  final String? tooltip;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final (Color bg, Color fg) = switch (tone) {
      KIconTone.defaults => (c.surfaceAlt.withValues(alpha: 0.8), c.inkMuted),
      KIconTone.accent => (c.accentSoft, c.accent),
      KIconTone.plain => (Colors.transparent, c.inkMuted),
      KIconTone.danger => (Colors.transparent, const Color(0xFFE5484D)),
    };
    final btn = KPressable(
      onTap: disabled ? null : onTap,
      onLongPress: disabled ? null : onLongPress,
      radius: radius,
      scale: 0.9,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(radius), border: tone == KIconTone.defaults ? Border.all(color: c.line) : null),
        child: Center(
          child: SizedBox(width: iconSize, height: iconSize, child: FittedBox(child: IconTheme(data: IconThemeData(color: disabled ? c.inkFaint : fg, size: iconSize), child: icon))),
        ),
      ),
    );
    if (tooltip == null) return btn;
    return KTooltip(message: tooltip!, child: btn);
  }
}

enum KIconTone { defaults, accent, plain, danger }

/// Minimal tooltip (no Material Tooltip).
class KTooltip extends StatefulWidget {
  const KTooltip({super.key, required this.message, required this.child, this.offset = const Offset(0, -38)});

  final String message;
  final Widget child;
  final Offset offset;

  @override
  State<KTooltip> createState() => _KTooltipState();
}

class _KTooltipState extends State<KTooltip> {
  late final OverlayPortalController _controller = OverlayPortalController();
  final _shown = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _show(true),
      onExit: (_) => _show(false),
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: (_) => ValueListenableBuilder<bool>(
          valueListenable: _shown,
          builder: (context, shown, _) => AnimatedOpacity(
            opacity: shown ? 1 : 0,
            duration: const Duration(milliseconds: 140),
            child: AnimatedSlide(
              offset: shown ? Offset.zero : const Offset(0, 0.06),
              duration: const Duration(milliseconds: 140),
              child: CompositedTransformFollower(
                link: _link,
                showWhenUnlinked: false,
                offset: widget.offset,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.kColors.ink,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: KShadow.float(Colors.black),
                    ),
                    child: Text(widget.message, style: context.kTheme.text(KTypeStyle.caption, color: context.kColors.bg, weight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
          ),
        ),
        child: CompositedTransformTarget(link: _link, child: widget.child),
      ),
    );
  }

  final LayerLink _link = LayerLink();

  void _show(bool v) {
    if (v == _shown.value) return;
    _shown.value = v;
    if (v) {
      _controller.show();
    } else {
      _controller.hide();
    }
  }
}
