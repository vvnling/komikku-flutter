import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Colors;
import '../../core/design/k_theme.dart';
import '../../core/design/motion.dart';
import '../../core/design/tokens.dart';
import 'k_pressable.dart';
import '../../core/design/motifs.dart' show PanelFramePainter, PanelCorner;

/// Panel card — the manga-panel frame motif applied to surfaces.
class KCard extends StatelessWidget {
  const KCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.radius = KRadius.l,
    this.accent,
    this.corner = PanelCorner.topLeft,
    this.elevated = false,
    this.color,
    this.stroke,
    this.margin,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color? accent;
  final PanelCorner corner;
  final bool elevated;
  final Color? color;
  final Color? stroke;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? c.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: stroke ?? c.lineStrong),
        boxShadow: elevated ? KShadow.float(Colors.black) : null,
      ),
      child: CustomPaint(
        painter: PanelFramePainter(
          line: c.line,
          accent: accent ?? c.accent.withValues(alpha: 0.55),
          radius: radius,
          bold: KPanelStroke.hair,
          accentSize: 7,
          corner: corner,
        ),
        child: Padding(padding: padding ?? const EdgeInsets.all(KSpacing.l), child: child),
      ),
    );
    if (onTap == null && onLongPress == null) return card;
    return KPressable(onTap: onTap, onLongPress: onLongPress, radius: radius, child: card);
  }
}

/// List row — icon, title, subtitle, trailing, custom pressed state.
class KListTile extends StatelessWidget {
  const KListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.padding = const EdgeInsets.symmetric(horizontal: KSpacing.l, vertical: KSpacing.m),
    this.dense = false,
    this.selected = false,
  });

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;
  final bool dense;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final row = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: selected ? c.accentSoft : Colors.transparent,
        borderRadius: BorderRadius.circular(KRadius.m),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: KSpacing.m),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.text(KTypeStyle.body, weight: FontWeight.w600, size: dense ? 14 : 15)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.text(KTypeStyle.caption, color: c.inkMuted)),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: KSpacing.s),
            trailing!,
          ],
        ],
      ),
    );
    if (onTap == null && onLongPress == null) return row;
    return KPressable(onTap: onTap, onLongPress: onLongPress, radius: KRadius.m, child: row);
  }
}

/// Section header with optional action.
class KSectionHeader extends StatelessWidget {
  const KSectionHeader({super.key, required this.title, this.action, this.actionLabel, this.padding = const EdgeInsets.symmetric(horizontal: KSpacing.l)});

  final String title;
  final VoidCallback? action;
  final String? actionLabel;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(width: 4, height: 16, decoration: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: theme.text(KTypeStyle.h2, size: 17, weight: FontWeight.w700))),
          if (action != null)
            KPressable(
              onTap: action,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(actionLabel ?? 'See all', style: theme.text(KTypeStyle.label, size: 12.5, color: c.accent)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Tab bar — ink-stroke indicator that springs between tabs.
class KTabBar extends StatelessWidget {
  const KTabBar({super.key, required this.tabs, required this.index, required this.onChanged, this.padding = const EdgeInsets.symmetric(horizontal: KSpacing.l)});

  final List<String> tabs;
  final int index;
  final ValueChanged<int> onChanged;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: KPressable(
                onTap: () => onChanged(i),
                radius: 10,
                child: AnimatedContainer(
                  duration: KMotion.fast,
                  curve: KMotion.outCubic,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == index ? c.accent : Colors.transparent,
                        width: 2.6,
                      ),
                    ),
                  ),
                  child: Text(
                    tabs[i],
                    textAlign: TextAlign.center,
                    style: theme.text(KTypeStyle.label, size: 13.5, weight: FontWeight.w700, color: i == index ? c.ink : c.inkFaint),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Chip / tag / badge.
class KChip extends StatelessWidget {
  const KChip({super.key, required this.label, this.onTap, this.selected = false, this.icon, this.leading, this.compact = false});

  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? icon;
  final Widget? leading;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final chip = AnimatedContainer(
      duration: KMotion.fast,
      curve: KMotion.outCubic,
      padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 13, vertical: compact ? 5 : 7),
      decoration: BoxDecoration(
        color: selected ? c.accent : c.surfaceAlt.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(KRadius.pill),
        border: Border.all(color: selected ? c.accent : c.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 6)],
          if (icon != null) ...[icon!, const SizedBox(width: 5)],
          Text(label, style: theme.text(KTypeStyle.label, size: compact ? 11.5 : 12.5, color: selected ? c.accentInk : c.inkMuted, weight: FontWeight.w600)),
        ],
      ),
    );
    if (onTap == null) return chip;
    return KPressable(onTap: onTap, radius: KRadius.pill, scale: 0.94, child: chip);
  }
}

class KBadge extends StatelessWidget {
  const KBadge({super.key, required this.count, this.max = 99, this.accent = true});

  final int count;
  final int max;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    if (count <= 0) return const SizedBox.shrink();
    final text = count > max ? '$max+' : '$count';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: accent ? c.accent : c.surfaceAlt,
        borderRadius: BorderRadius.circular(KRadius.pill),
        border: Border.all(color: accent ? c.accent : c.lineStrong, width: 1),
      ),
      child: Text(text, style: theme.text(KTypeStyle.label, size: 10.5, color: accent ? c.accentInk : c.inkMuted, weight: FontWeight.w700)),
    );
  }
}

class KTag extends StatelessWidget {
  const KTag({super.key, required this.label, this.onTap, this.color, this.selected = false});

  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final tagColor = color ?? c.accent;
    final tag = Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? tagColor.withValues(alpha: 0.18) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: selected ? tagColor.withValues(alpha: 0.6) : c.lineStrong),
      ),
      child: Text(label, style: theme.text(KTypeStyle.caption, size: 10.5, color: selected ? tagColor : c.inkMuted)),
    );
    if (onTap == null) return tag;
    return KPressable(onTap: onTap, radius: 6, scale: 0.95, child: tag);
  }
}
