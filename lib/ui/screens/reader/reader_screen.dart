import 'dart:async';
import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/motion.dart';
import '../../../core/design/tokens.dart';
import '../../../data/models/models.dart';
import 'chapter_session.dart';
import 'paged_viewer.dart';
import 'webtoon_viewer.dart';

/// Reader screen — full-bleed, chrome overlays, chapter orchestration.
import 'dart:math' as math;
import '../../../data/services/cover_cache.dart' show ImagePalette;
import '../../../ui/widgets/widgets.dart';
import 'package:flutter/material.dart' show Icons, Colors;
class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, required this.manga, required this.initialChapter});

  final Manga manga;
  final Chapter initialChapter;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> with SingleTickerProviderStateMixin {
  late final List<Chapter> _chapters;
  late int _chapterIndex;
  late ChapterSession _session;
  bool _chromeVisible = true;
  int _page = 0;
  double _webtoonProgress = 0;
  Timer? _chromeTimer;
  Color _background = const Color(0xFF0A0A0A);
  late int _viewer;
  late int _transition;
  late int _backgroundMode;
  late int _tapZones;
  late bool _autoScroll;
  late bool _autoNext;
  bool _prefetchDone = false;
  bool _pageDirty = false;

  @override
  void initState() {
    super.initState();
    _chapters = const [];
    _chapterIndex = 0;
    _session = ChapterSession(manga: widget.manga, chapter: widget.initialChapter);
    _loadChapters();
    _applySettings();
  }

  Future<void> _loadChapters() async {
    final chapters = await context.app.repos.chaptersOfManga(widget.manga.id!);
    if (!mounted) return;
    setState(() {
      _chapters = chapters;
      final idx = chapters.indexWhere((c) => c.url == widget.initialChapter.url);
      _chapterIndex = idx >= 0 ? idx : 0;
    });
    _openChapter(_chapterIndex);
  }

  void _applySettings() {
    final s = context.app.settings;
    final override = widget.manga.viewer >= 0 ? widget.manga.viewer : s.readerViewer;
    _viewer = override;
    _transition = s.pageTransition;
    _backgroundMode = s.readerBackground;
    _tapZones = s.tapZones;
    _autoScroll = false;
    _autoNext = s.autoNextChapter;
    _applyBackground();
  }

  void _applyBackground() {
    switch (_backgroundMode) {
      case 1:
        _background = const Color(0xFFF4F1EA);
      case 2:
        _background = const Color(0xFF3A3A3E);
      case 3:
        _background = const Color(0xFF0A0A0A); // auto → sampled per page
      default:
        _background = const Color(0xFF0A0A0A);
    }
  }

  Future<void> _openChapter(int index) async {
    if (index < 0 || index >= _chapters.length) return;
    _page = 0;
    setState(() {
      _chapterIndex = index;
      _session = ChapterSession(manga: widget.manga, chapter: _chapters[index])
        ..attach(context.app);
      _prefetchDone = false;
    });
    _session.addListener(_onSession);
    unawaited(_session.load());
    // restore progress
    final history = await context.app.repos.historyFor(widget.manga.id!, _chapters[index].id!);
    if (mounted && history != null && _chapters[index].id == _session.chapter.id) {
      final start = history.page.clamp(0, _session.total - 1);
      if (start > 0) setState(() => _page = start);
    }
    _scheduleChromeHide();
  }

  void _onSession() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _chromeTimer?.cancel();
    _persistProgress();
    super.dispose();
  }

  Future<void> _persistProgress() async {
    final chapter = _session.chapter;
    final total = _session.total;
    if (total == 0 || _pageDirty == false && _page == 0) {
      // still record minimal
    }
    final repos = context.app.repos;
    final percent = total == 0 ? 0.0 : (_page + 1) / total;
    await repos.recordHistory(widget.manga.id!, chapter.id!, _page, percent);
    await repos.updateChapter(chapter.copyWith(
      lastPageRead: _page,
      lastReadAt: DateTime.now(),
      read: percent >= 0.95,
    ));
    // mark manga as started
    final manga = await repos.mangaById(widget.manga.id!);
    if (manga != null) {
      await repos.updateManga(manga.copyWith(
        lastReadAt: DateTime.now(),
        lastChapterUrl: chapter.url,
      ));
    }
  }

  void _onPageChanged(int page) {
    _page = page;
    _pageDirty = true;
    // debounced persist
    _persistProgress();
    if (_backgroundMode == 3) _sampleBackground(page);
    if (!_prefetchDone && page > 0) {
      _prefetchDone = true;
      _prefetchPages();
    }
  }

  Future<void> _prefetchPages() async {
    for (var i = _page + 1; i < math.min(_session.total, _page + 3); i++) {
      unawaited(_session.bytesOf(i));
    }
  }

  Future<void> _sampleBackground(int page) async {
    final bytes = await _session.bytesOf(page);
    if (bytes == null || !mounted) return;
    final color = await ImagePalette.dominantColor(bytes);
    setState(() => _background = Color(color));
  }

  void _onChapterEdge(int direction) {
    final target = _chapterIndex + direction;
    if (target < 0 || target >= _chapters.length) {
      KToastHost.show(context, direction > 0 ? 'Last chapter' : 'First chapter');
      return;
    }
    // persist current before switching
    unawaited(_persistProgress());
    _openChapter(target);
  }

  void _scheduleChromeHide() {
    _chromeTimer?.cancel();
    if (!_chromeVisible) return;
    _chromeTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _chromeVisible = false);
    });
  }

  void _toggleChrome() {
    setState(() => _chromeVisible = !_chromeVisible);
    if (_chromeVisible) _scheduleChromeHide();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final total = _session.total;
    final chapter = _session.chapter;

    return KPage(
      color: _background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // viewer
          if (_viewer >= 2)
            WebtoonViewer(
              key: ValueKey('webtoon-${_session.chapter.id}'),
              session: _session,
              background: _background,
              autoscroll: _autoScroll,
              autoscrollSpeed: context.app.settings.autoscrollSpeed,
              onPageChanged: _onPageChanged,
              onChapterEdge: _onChapterEdge,
              onScrollChanged: (p) => _webtoonProgress = p,
            )
          else
            PagedViewer(
              key: ValueKey('paged-${_session.chapter.id}'),
              session: _session,
              initialPage: _page,
              background: _background,
              readingRtl: _viewer == 1,
              transition: _transition,
              tapZones: _tapZones,
              autoscroll: _autoScroll,
              autoscrollSpeed: context.app.settings.autoscrollSpeed,
              onPageChanged: _onPageChanged,
              onChapterEdge: _onChapterEdge,
            ),

          // webtoon scrubber (right edge)
          if (_viewer >= 2 && _chromeVisible)
            _Scrubber(onScrub: _scrubTo, progress: _webtoonProgress),

          // chrome
          AnimatedSlide(
            duration: KMotion.base,
            curve: KMotion.outCubic,
            offset: _chromeVisible ? Offset.zero : const Offset(0, -1.15),
            child: _topChrome(theme, c, chapter, total),
          ),
          AnimatedSlide(
            duration: KMotion.base,
            curve: KMotion.outCubic,
            offset: _chromeVisible ? Offset.zero : const Offset(0, 1.15),
            child: _bottomChrome(theme, c, total),
          ),

          // loading veil
          if (_session.loading && total == 0)
            const Center(child: KProgressRing(indeterminate: true, size: 30)),
          if (_session.error != null && total == 0) _errorVeil(theme, c),
        ],
      ),
    );
  }

  void _scrubTo(double dy) {
    // webtoon scrub handled by viewer via jump; paged mode converts to page
    if (_viewer < 2) {
      final total = _session.total;
      if (total == 0) return;
      final page = (dy * total).floor().clamp(0, total - 1);
      setState(() => _page = page);
      _onPageChanged(page);
    }
  }

  Widget _topChrome(KTheme theme, PaletteColors c, Chapter chapter, int total) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleChrome,
        child: Container(
          padding: EdgeInsets.fromLTRB(8, MediaQuery.paddingOf(context).top + 6, 8, 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withValues(alpha: 0.72), Colors.transparent],
            ),
          ),
          child: Row(
            children: [
              KIconButton(
                icon: const Icon(Icons.arrow_back, size: 19),
                onTap: () => KRoute.pop(context),
                tone: KIconTone.plain,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.manga.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.text(KTypeStyle.title, size: 14, weight: FontWeight.w700, color: Colors.white)),
                    Text(
                      chapter.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.text(KTypeStyle.caption, size: 11.5, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              KIconButton(
                icon: const Icon(Icons.settings_outlined, size: 18),
                onTap: () => _openSettings(theme),
                tone: KIconTone.plain,
              ),
              const SizedBox(width: 4),
              KIconButton(
                icon: const Icon(Icons.download_outlined, size: 18),
                onTap: () async {
                  if (_session.chapter.downloaded) {
                    KToastHost.show(context, 'Already downloaded');
                    return;
                  }
                  await context.app.downloads.enqueue(widget.manga, _session.chapter);
                  if (!mounted) return;
                  KToastHost.show(context, 'Download queued');
                },
                tone: KIconTone.plain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomChrome(KTheme theme, PaletteColors c, int total) {
    final percent = total == 0 ? 0.0 : (_viewer >= 2 ? _webtoonProgress : (_page + 1) / total);
    final white = Colors.white;
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleChrome,
        child: Container(
          padding: EdgeInsets.fromLTRB(14, 12, 14, MediaQuery.paddingOf(context).bottom + 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withValues(alpha: 0.78), Colors.transparent],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // progress bar (draggable)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (d) {
                  final box = context.findRenderObject();
                  if (box is! RenderBox) return;
                  final w = box.size.width - 28;
                  final p = (d.localPosition.dx / w).clamp(0.0, 1.0);
                  if (_viewer >= 2) {
                    _scrubTo(p);
                  } else {
                    final page = (p * total).floor().clamp(0, total - 1);
                    setState(() => _page = page);
                  }
                },
                child: SizedBox(
                  height: 22,
                  child: Center(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colors.accent,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: KShadow.glow(theme.colors.accent, strength: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  KIconButton(
                    icon: const Icon(Icons.skip_previous, size: 20),
                    onTap: () => _onChapterEdge(-1),
                    tone: KIconTone.plain,
                  ),
                  KIconButton(
                    icon: Icon(_viewer == 2 ? Icons.vertical_align_top : Icons.chevron_left, size: 20),
                    onTap: () {
                      if (_viewer >= 2) {
                        // back to top
                        setState(() => _page = 0);
                      } else if (_page > 0) {
                        setState(() => _page = _page - 1);
                      }
                    },
                    tone: KIconTone.plain,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        total == 0 ? '…' : _viewer >= 2 ? '${(percent * 100).round()}%' : '${_page + 1} / $total',
                        style: theme.text(KTypeStyle.label, size: 12.5, color: white, weight: FontWeight.w700),
                      ),
                    ),
                  ),
                  KIconButton(
                    icon: Icon(_viewer == 2 ? Icons.vertical_align_bottom : Icons.chevron_right, size: 20),
                    onTap: () {
                      if (_viewer >= 2) {
                        _onChapterEdge(1);
                      } else if (_page < total - 1) {
                        setState(() => _page = _page + 1);
                      } else {
                        _onChapterEdge(1);
                      }
                    },
                    tone: KIconTone.plain,
                  ),
                  KIconButton(
                    icon: Icon(_autoScroll ? Icons.speed : Icons.speed_outlined, size: 20),
                    onTap: () => setState(() => _autoScroll = !_autoScroll),
                    tone: _autoScroll ? KIconTone.accent : KIconTone.plain,
                  ),
                  KIconButton(
                    icon: const Icon(Icons.skip_next, size: 20),
                    onTap: () => _onChapterEdge(1),
                    tone: KIconTone.plain,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorVeil(KTheme theme, PaletteColors c) {
    return Positioned.fill(
      child: ColoredBox(
        color: _background,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off, size: 38, color: Colors.white54),
                const SizedBox(height: 12),
                Text('Could not load this chapter', style: theme.text(KTypeStyle.title, size: 15, weight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 6),
                Text(_session.error!, textAlign: TextAlign.center, style: theme.text(KTypeStyle.caption, size: 12, color: Colors.white54)),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KButton(label: 'Retry', onTap: () {
                      _session.error = null;
                      _session.loading = false;
                      _session.load();
                    }),
                    const SizedBox(width: 10),
                    KButton(label: 'Back', variant: KButtonVariant.secondary, onTap: () => KRoute.pop(context)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSettings(KTheme theme) async {
    _chromeTimer?.cancel();
    final s = context.app.settings;
    var viewer = _viewer;
    var transition = _transition;
    var backgroundMode = _backgroundMode;
    var tapZones = _tapZones;
    var autoNext = _autoNext;

    await showKSheet<void>(context, child: StatefulBuilder(
      builder: (context, setSheetState) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reader settings', style: theme.text(KTypeStyle.h2, size: 17, weight: FontWeight.w700)),
          const SizedBox(height: 14),

          Text('Viewer', style: theme.text(KTypeStyle.label, size: 12, color: theme.colors.inkMuted)),
          const SizedBox(height: 6),
          KSegmented<int>(
            options: const [(0, 'LTR'), (1, 'RTL'), (2, 'Vertical'), (3, 'Cont.')],
            value: viewer,
            onChanged: (v) {
              viewer = v;
              setSheetState(() {});
            },
          ),
          const SizedBox(height: 14),

          Text('Page transition', style: theme.text(KTypeStyle.label, size: 12, color: theme.colors.inkMuted)),
          const SizedBox(height: 6),
          KSegmented<int>(
            options: const [(0, 'Slide'), (1, 'Cover'), (2, 'Fade'), (3, 'Depth')],
            value: transition,
            onChanged: (v) {
              transition = v;
              setSheetState(() {});
            },
          ),
          const SizedBox(height: 14),

          Text('Background', style: theme.text(KTypeStyle.label, size: 12, color: theme.colors.inkMuted)),
          const SizedBox(height: 6),
          KSegmented<int>(
            options: const [(0, 'Black'), (1, 'Paper'), (2, 'Gray'), (3, 'Auto')],
            value: backgroundMode,
            onChanged: (v) {
              backgroundMode = v;
              setSheetState(() {});
            },
          ),
          const SizedBox(height: 14),

          Text('Tap zones', style: theme.text(KTypeStyle.label, size: 12, color: theme.colors.inkMuted)),
          const SizedBox(height: 6),
          KSegmented<int>(
            options: const [(0, 'Left/Right'), (1, 'Anywhere')],
            value: tapZones,
            onChanged: (v) {
              tapZones = v;
              setSheetState(() {});
            },
          ),
          const SizedBox(height: 14),

          KListTile(
            title: 'Autoscroll speed',
            subtitle: 'Drag to tune',
            trailing: KSlider(
              value: s.autoscrollSpeed,
              min: 0.2,
              max: 3,
              divisions: 28,
              onChanged: (v) => s.autoscrollSpeed = v,
            ),
          ),
          const SizedBox(height: 4),
          KListTile(
            title: 'Auto next chapter',
            trailing: KSwitch(value: autoNext, onChanged: (v) => autoNext = v),
            onTap: () => setSheetState(() => autoNext = !autoNext),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KButton(label: 'Reset to global', variant: KButtonVariant.ghost, onTap: () {
                s.readerViewer = 0;
                s.pageTransition = 0;
                s.readerBackground = 0;
                s.tapZones = 0;
                viewer = 0;
                transition = 0;
                backgroundMode = 0;
                tapZones = 0;
                setSheetState(() {});
              }),
              const SizedBox(width: 8),
              KButton(label: 'Apply', onTap: () {
                s.readerViewer = viewer;
                s.pageTransition = transition;
                s.readerBackground = backgroundMode;
                s.tapZones = tapZones;
                setState(() {
                  _viewer = viewer;
                  _transition = transition;
                  _backgroundMode = backgroundMode;
                  _tapZones = tapZones;
                  _autoNext = autoNext;
                });
                _applyBackground();
                KRoute.pop(context);
                _scheduleChromeHide();
              }),
            ],
          ),
        ],
      ),
    ));
  }
}

/// Vertical scrubber overlay (webtoon mode).
class _Scrubber extends StatefulWidget {
  const _Scrubber({required this.onScrub, required this.progress});
  final ValueChanged<double> onScrub;
  final double progress;

  @override
  State<_Scrubber> createState() => _ScrubberState();
}

class _ScrubberState extends State<_Scrubber> {
  bool _active = false;
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      width: 44,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (d) {
          _active = true;
          _value = (d.localPosition.dy / MediaQuery.sizeOf(context).height).clamp(0.0, 1.0);
          widget.onScrub(_value);
          setState(() {});
        },
        onVerticalDragUpdate: (d) {
          _value = (d.localPosition.dy / MediaQuery.sizeOf(context).height).clamp(0.0, 1.0);
          widget.onScrub(_value);
          setState(() {});
        },
        onVerticalDragEnd: (_) => setState(() => _active = false),
        child: Stack(
          children: [
            if (_active)
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.14,
                    child: Container(
                      decoration: BoxDecoration(
                        color: c.accent,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: KShadow.glow(c.accent),
                      ),
                    ),
                  ),
                ),
              ),
            if (_active)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${(_value * 100).round()}%', style: context.kTheme.text(KTypeStyle.label, size: 12, color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// palette import

// imports
