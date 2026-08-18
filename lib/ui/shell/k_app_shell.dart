import 'package:flutter/widgets.dart';
import '../../core/app_scope.dart';
import '../../core/design/k_theme.dart';
import '../../core/design/motion.dart';
import '../../core/design/tokens.dart';
import '../../data/services/update_service.dart';
import '../../data/services/library_service.dart' show SyncState;
import '../screens/browse/browse_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/more/more_screen.dart';
import '../screens/updates/updates_screen.dart';
import '../widgets/widgets.dart';

import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart' show Icons, Colors;

/// The application frame: aurora backdrop + grain, custom navigation
/// (bottom bar on phones, rail on wide screens), tab transitions with
/// parallax, toast host and the Komikku-style progress banner.
class KAppShell extends StatefulWidget {
  const KAppShell({super.key});

  @override
  State<KAppShell> createState() => _KAppShellState();
}

class _KAppShellState extends State<KAppShell> with TickerProviderStateMixin {
  int _tab = 0;
  late final AnimationController _time = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
  late final AnimationController _tabAnim = AnimationController(vsync: this, duration: KMotion.slow);
  int _lastTab = 0;

  static const _tabs = <_TabSpec>[
    _TabSpec(0, 'Library', Icons.auto_stories_outlined, Icons.auto_stories),
    _TabSpec(1, 'Browse', Icons.explore_outlined, Icons.explore),
    _TabSpec(2, 'Updates', Icons.new_releases_outlined, Icons.new_releases),
    _TabSpec(3, 'History', Icons.history_outlined, Icons.history),
    _TabSpec(4, 'More', Icons.more_horiz_outlined, Icons.more_horiz),
  ];

  @override
  void dispose() {
    _time.dispose();
    _tabAnim.dispose();
    super.dispose();
  }

  void _select(int i) {
    if (i == _tab) return;
    _lastTab = _tab;
    setState(() => _tab = i);
    _tabAnim.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final wide = MediaQuery.sizeOf(context).width >= KBreakpoints.tablet;

    final pages = [
      const LibraryScreen(),
      const BrowseScreen(),
      const UpdatesScreen(),
      const HistoryScreen(),
      const MoreScreen(),
    ];

    return KToastHost(
      child: Stack(
        children: [
          // ── aurora ambient field ─────────────────────────────────────────
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: context.shaders.auroraPainter(
                  time: _time,
                  a: c.accent.withValues(alpha: 0.16),
                  b: c.accentAlt.withValues(alpha: 0.12),
                  c: c.accent.withValues(alpha: 0.08),
                  speed: 0.7,
                  intensity: 1,
                ),
              ),
            ),
          ),
          // ── grain veil ───────────────────────────────────────────────────
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: context.shaders.grainPainter(time: _time, amount: 0.4, opacity: 0.05),
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                if (wide) _rail(context, theme),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRect(
                          child: AnimatedBuilder(
                            animation: _tabAnim,
                            builder: (context, child) {
                              final t = Curves.easeOutCubic.transform(_tabAnim.value);
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  for (final (i, page) in pages.indexed)
                                    if (i != _tab)
                                      Offstage(
                                        offstage: true,
                                        child: page,
                                      ),
                                  Transform.translate(
                                    offset: Offset((1 - t) * (wide ? 40 : 70) * (_tab > _lastTab ? 1 : -1), 0),
                                    child: Opacity(opacity: t.clamp(0.0, 1.0), child: pages[_tab]),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      if (!wide) _bottomBar(context, theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const _SyncBanner(),
        ],
      ),
    );
  }

  // ── Bottom bar (phones) ───────────────────────────────────────────────────
  Widget _bottomBar(BuildContext context, KTheme theme) {
    final c = theme.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.bg.withValues(alpha: 0.82),
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 62,
              child: Row(
                children: [
                  for (final spec in _tabs) _navItem(spec, wide: false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Rail (wide screens) ───────────────────────────────────────────────────
  Widget _rail(BuildContext context, KTheme theme) {
    final c = theme.colors;
    return Container(
      width: 78,
      decoration: BoxDecoration(
        color: c.bg.withValues(alpha: 0.65),
        border: Border(right: BorderSide(color: c.line)),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.paddingOf(context).top + 12),
              // logo mark
              CustomPaint(
                size: const Size(44, 44),
                painter: KLogoPainter(ink: c.ink, accent: c.accent, detail: 0.9),
              ),
              const SizedBox(height: 28),
              for (final spec in _tabs) _navItem(spec, wide: true),
              const Spacer(),
              const _UpdateDot(),
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(_TabSpec spec, {required bool wide}) {
    final theme = context.kTheme;
    final c = theme.colors;
    final selected = spec.index == _tab;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _select(spec.index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: KMotion.base,
              curve: KMotion.outCubic,
              width: wide ? 52 : 44,
              height: wide ? 46 : 30,
              decoration: BoxDecoration(
                color: selected ? c.accentSoft : Colors.transparent,
                borderRadius: BorderRadius.circular(wide ? 14 : KRadius.pill),
              ),
              child: Icon(
                selected ? spec.activeIcon : spec.icon,
                size: wide ? 22 : 21,
                color: selected ? c.accent : c.inkFaint,
              ),
            ),
            if (!wide) ...[
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: KMotion.fast,
                style: theme.text(KTypeStyle.caption, size: 10, weight: FontWeight.w700, color: selected ? c.accent : c.inkFaint),
                child: Text(spec.label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Unread indicator in the rail (updates count).
class _UpdateDot extends StatelessWidget {
  const _UpdateDot();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MangaUpdate>>(
      valueListenable: context.app.updates.updates,
      builder: (context, list, _) {
        final count = list.fold<int>(0, (a, b) => a + b.unreadCount);
        if (count == 0) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.kColors.accentSoft,
            borderRadius: BorderRadius.circular(KRadius.pill),
          ),
          child: Text('$count new', style: context.kTheme.text(KTypeStyle.caption, size: 10, color: context.kColors.accent, weight: FontWeight.w700)),
        );
      },
    );
  }
}

/// Komikku-style in-app progress banner for library sync.
class _SyncBanner extends StatelessWidget {
  const _SyncBanner();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SyncState?>(
      valueListenable: context.app.library.syncState,
      builder: (context, state, _) {
        if (state == null) return const SizedBox.shrink();
        final theme = context.kTheme;
        final c = theme.colors;
        final fraction = state.total == 0 ? 0.0 : state.current / state.total;
        return Positioned(
          left: 0,
          right: 0,
          top: MediaQuery.paddingOf(context).top + 6,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.lineStrong),
                boxShadow: KShadow.float(Colors.black),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CustomPaint(
                      painter: _BannerRingPainter(c.accent, fraction),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(
                      state.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.text(KTypeStyle.caption, size: 12, weight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${state.current}/${state.total}', style: theme.text(KTypeStyle.caption, size: 11, color: c.inkFaint)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BannerRingPainter extends CustomPainter {
  _BannerRingPainter(this.color, this.fraction);
  final Color color;
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(Rect.fromCircle(center: size.center(Offset.zero), radius: size.shortestSide / 2 - 2), -1.5708, fraction * 6.2832, false, paint);
  }

  @override
  bool shouldRepaint(_BannerRingPainter old) => old.fraction != fraction;
}

class _TabSpec {
  const _TabSpec(this.index, this.label, this.icon, this.activeIcon);
  final int index;
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

// imports
