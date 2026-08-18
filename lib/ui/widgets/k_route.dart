import 'package:flutter/widgets.dart';
import '../../core/design/k_theme.dart';
import '../../core/design/motion.dart';
import '../../core/design/tokens.dart';
import 'k_button.dart';

/// Custom page route with spring/parallax transitions (no MaterialPageRoute).
import 'package:flutter/material.dart' show Icons;
import 'dart:ui' show ImageFilter;
class KRoute<T> extends PageRouteBuilder<T> {
  KRoute({
    required Widget page,
    KRouteKind kind = KRouteKind.push,
    super.opaque,
    Duration? duration,
  }) : super(
          transitionDuration: duration ?? KMotion.springSettleTime(KMotion.springSoft),
          reverseTransitionDuration: duration ?? KMotion.slow,
          pageBuilder: (context, animation, secondary) => page,
          transitionsBuilder: (context, animation, secondary, child) {
            switch (kind) {
              case KRouteKind.push:
                return _PushTransition(animation: animation, child: child);
              case KRouteKind.slideUp:
                return _SlideUpTransition(animation: animation, child: child);
              case KRouteKind.fade:
                return FadeTransition(opacity: animation, child: child);
              case KRouteKind.zoom:
                return _ZoomTransition(animation: animation, child: child);
              case KRouteKind.cover:
                return _CoverTransition(animation: animation, child: child);
            }
          },
        );

  static Future<T?> push<T>(BuildContext context, Widget page, {KRouteKind kind = KRouteKind.push}) =>
      Navigator.of(context, rootNavigator: true).push<T>(KRoute<T>(page: page, kind: kind));

  static Future<T?> pushReplacement<T, R>(BuildContext context, Widget page) =>
      Navigator.of(context, rootNavigator: true).pushReplacement<T, R>(KRoute<T>(page: page));

  static void pop<T>(BuildContext context, [T? result]) => Navigator.of(context, rootNavigator: true).pop(result);
}

enum KRouteKind { push, slideUp, fade, zoom, cover }

/// Full-screen page container — the Scaffold replacement. Just a colored
/// box with optional safe-area handling; layout is entirely up to the
/// screen's own composition.
class KPage extends StatelessWidget {
  const KPage({super.key, this.color, this.child, this.safeTop = false, this.safeBottom = false, this.stack = true});

  final Color? color;
  final Widget? child;
  final bool safeTop;
  final bool safeBottom;
  final bool stack;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? context.kTheme.colors.bg;
    final content = Padding(
      padding: EdgeInsets.only(
        top: safeTop ? MediaQuery.paddingOf(context).top : 0,
        bottom: safeBottom ? MediaQuery.paddingOf(context).bottom : 0,
      ),
      child: child,
    );
    return ColoredBox(color: bg, child: stack ? Stack(children: [Positioned.fill(child: content)]) : content);
  }
}

class _PushTransition extends StatelessWidget {
  const _PushTransition({required this.animation, required this.child});
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: animation, curve: KMotion.outQuart, reverseCurve: KMotion.outCubic);
    // parallax: incoming page slides 60px, outgoing page shifts 80px + dims
    final incoming = SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.14, 0), end: Offset.zero).animate(curved),
      child: FadeTransition(opacity: Tween<double>(begin: 0.4, end: 1.0).animate(curved), child: child),
    );
    return SlideTransition(position: Tween<Offset>(begin: Offset.zero, end: const Offset(-0.06, 0)).animate(curved), child: incoming);
  }
}

class _SlideUpTransition extends StatelessWidget {
  const _SlideUpTransition({required this.animation, required this.child});
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: animation, curve: KMotion.outQuart, reverseCurve: KMotion.outCubic);
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(curved),
      child: FadeTransition(opacity: Tween<double>(begin: 0.6, end: 1).animate(curved), child: child),
    );
  }
}

class _ZoomTransition extends StatelessWidget {
  const _ZoomTransition({required this.animation, required this.child});
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: animation, curve: KMotion.pop);
    return ScaleTransition(
      scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
      child: FadeTransition(opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: KMotion.outCubic)), child: child),
    );
  }
}

class _CoverTransition extends StatelessWidget {
  const _CoverTransition({required this.animation, required this.child});
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: animation, curve: KMotion.inOutQuint, reverseCurve: KMotion.outCubic);
    return ClipRect(
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(curved),
        child: child,
      ),
    );
  }
}

/// App header — frosted (BackdropFilter), spring back button, parallax
/// layers. No Material AppBar.
class KAppBar extends StatelessWidget {
  const KAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing = const [],
    this.onBack,
    this.blur = true,
    this.bottom,
    this.pinned = true,
    this.titleSpacing = 4,
  });

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> trailing;
  final VoidCallback? onBack;
  final bool blur;
  final Widget? bottom;
  final bool pinned;
  final double titleSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;

    final bar = Container(
      decoration: BoxDecoration(
        color: c.bg.withValues(alpha: blur ? 0.72 : 1),
        border: Border(bottom: BorderSide(color: c.line, width: 0.7)),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(KSpacing.s, MediaQuery.paddingOf(context).top + titleSpacing, KSpacing.m, titleSpacing),
                child: Row(
                  children: [
                    if (onBack != null || leading != null)
                      KIconButton(
                        icon: leading ?? const Icon(Icons.arrow_back_ios_new, size: 16),
                        onTap: onBack ?? () => KRoute.pop(context),
                        tone: KIconTone.plain,
                      ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null)
                            Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.text(KTypeStyle.title, size: 17.5, weight: FontWeight.w700)),
                          if (subtitle != null)
                            Text(subtitle!, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.text(KTypeStyle.caption, color: c.inkMuted)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...trailing,
                  ],
                ),
              ),
              if (bottom != null) bottom!,
            ],
          ),
        ),
      ),
    );

    if (!pinned) return bar;
    return bar;
  }
}

// icons
