import 'dart:async';
import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/motion.dart';
import '../../../core/design/tokens.dart';
import '../../../data/models/models.dart';
import '../../../data/sources/source.dart' show Source;
import '../reader/reader_screen.dart';
import '../trackers/trackers_screen.dart';

/// Manga detail — cover hero with cover-derived tint, description, tags,
/// chapters (grouped by volume where possible), downloads, tracking,
/// suggestions.
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart' show Icons, Colors;
import 'package:share_plus/share_plus.dart' show Share;
import 'package:url_launcher/url_launcher.dart' show launchUrl, LaunchMode;
import '../../../ui/widgets/widgets.dart';
class MangaDetailScreen extends StatefulWidget {
  const MangaDetailScreen({super.key, required this.mangaKey, this.initialChapter});

  final String mangaKey;
  final Chapter? initialChapter;

  @override
  State<MangaDetailScreen> createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen> with SingleTickerProviderStateMixin {
  Manga? _manga;
  List<Chapter> _chapters = const [];
  bool _loading = true;
  bool _refreshing = false;
  String? _error;
  int _tab = 0; // 0 chapters, 1 about, 2 suggestions
  List<SourceManga> _suggestions = const [];
  late final AnimationController _tintAnim;

  String get _key => widget.mangaKey;

  @override
  void initState() {
    super.initState();
    _tintAnim = AnimationController(vsync: this, duration: KMotion.slow);
    _load();
  }

  Future<void> _load() async {
    final parts = _key.split(':');
    if (parts.length != 2) {
      setState(() => _error = 'Invalid manga key');
      return;
    }
    final app = context.app;
    final manga = await app.repos.mangaByKey(parts[0], parts[1]);
    if (manga == null) {
      // not in library — fetch from source
      final source = app.sources.byId(parts[0]);
      if (source == null) {
        setState(() {
          _loading = false;
          _error = 'Unknown source ${parts[0]}';
        });
        return;
      }
      try {
        final sm = await source.getMangaDetail(parts[1]);
        final stored = await app.library.addToLibrary(sm);
        _init(stored, const []);
      } catch (e) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
      return;
    }
    final chapters = await app.repos.chaptersOfManga(manga.id!);
    _init(manga, chapters);
  }

  void _init(Manga manga, List<Chapter> chapters) {
    setState(() {
      _manga = manga;
      _chapters = chapters;
      _loading = false;
    });
    if (chapters.isEmpty && manga.initialized == false) {
      _refresh();
    }
    _tintAnim.forward(from: 0);
    _loadSuggestions();
  }

  Future<void> _refresh() async {
    final manga = _manga;
    if (manga == null || _refreshing) return;
    final app = context.app;
    setState(() => _refreshing = true);
    try {
      final updated = await app.library.refreshManga(manga);
      final chapters = await app.repos.chaptersOfManga(updated.id!);
      if (mounted) {
        setState(() {
        _manga = updated;
        _chapters = chapters;
      });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  Future<void> _loadSuggestions() async {
    final source = context.app.sources.byId(_manga!.sourceId);
    if (source == null || !source.supportsSuggestions) return;
    try {
      final suggestions = await source.getSuggestions(_manga!.remoteId);
      if (mounted) setState(() => _suggestions = suggestions);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;

    if (_loading) {
      return KPage(color: c.bg, child: const Center(child: KProgressRing(indeterminate: true, size: 30)));
    }
    if (_error != null) {
      return KPage(
        color: c.bg,
        child: Column(
          children: [
            KAppBar(title: 'Manga', onBack: () => KRoute.pop(context)),
            Expanded(child: KEmpty(icon: Icon(Icons.error_outline, size: 34, color: c.inkFaint), title: 'Could not load', message: _error)),
          ],
        ),
      );
    }

    final manga = _manga!;
    final tinted = context.app.theme.tintedFor(_key);
    final source = context.app.sources.byId(manga.sourceId);

    // chapters grouped by volume number (integers) for a shelf feel
    final grouped = <(String, List<Chapter>)>[];
    for (final ch in _chapters) {
      final vol = ch.number >= 1 ? 'Volume ${ch.number.round()}' : 'Chapters';
      if (grouped.isEmpty || grouped.last.$1 != vol) {
        grouped.add((vol, [ch]));
      } else {
        grouped.last.$2.add(ch);
      }
    }

    return KPage(
      color: tinted.colors.bg,
      child: Stack(
        children: [
          // ambient tint wash
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _tintAnim,
                builder: (context, _) => Opacity(
                  opacity: _tintAnim.value * 0.16,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [tinted.colors.accent, Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _hero(tinted, manga, source)),
                SliverToBoxAdapter(child: _tabBar(tinted)),
                SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: KMotion.base,
                    child: _tab == 0
                        ? _chaptersPane(tinted, manga)
                        : _tab == 1
                            ? _aboutPane(tinted, manga, source)
                            : _suggestionsPane(tinted),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 60)),
              ],
            ),
          ),
          // floating app bar over hero
          Positioned(
            top: MediaQuery.paddingOf(context).top + 4,
            left: 12,
            right: 12,
            child: Row(
              children: [
                KIconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                  onTap: () => KRoute.pop(context),
                  tone: KIconTone.plain,
                ),
                const Spacer(),
                if (manga.favorite)
                  KIconButton(
                    icon: const Icon(Icons.favorite, size: 17),
                    onTap: _removeFromLibrary,
                    tone: KIconTone.accent,
                    tooltip: 'Remove from library',
                  ),
                const SizedBox(width: 8),
                KMenuButton(
                  items: [
                    KMenuItem('Open in browser', icon: const Icon(Icons.open_in_new), onTap: () async {
                      final url = source?.baseUrl;
                      if (url != null) await launchUrl(Uri.parse('$url/title/${manga.remoteId}'), mode: LaunchMode.externalApplication);
                    }),
                    KMenuItem('Track on AniList', icon: const Icon(Icons.track_changes), onTap: () => KRoute.push(context, TrackersScreen(mangaKey: manga.key))),
                    KMenuItem(manga.favorite ? 'Remove from library' : 'Add to library', icon: Icon(manga.favorite ? Icons.delete_outline : Icons.add), onTap: manga.favorite ? _removeFromLibrary : _addToLibrary),
                  ],
                  child: KIconButton(icon: const Icon(Icons.more_vert), onTap: () {}, tone: KIconTone.plain),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero(KTheme theme, Manga manga, Source? source) {
    final w = MediaQuery.sizeOf(context).width;
    final coverH = w * 0.62;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: coverH,
          width: w,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // blurred cover backdrop
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
                child: KCover(url: manga.coverUrl, title: manga.title, borderRadius: 0),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, theme.colors.bg],
                  ),
                ),
              ),
              // foreground cover with float spring
              Positioned(
                left: KSpacing.l,
                top: MediaQuery.paddingOf(context).top + 56,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: KMotion.slow,
                  curve: KMotion.outQuart,
                  builder: (context, t, child) => Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, (1 - t) * 30),
                      child: child,
                    ),
                  ),
                  child: KCover(
                    url: manga.coverUrl,
                    title: manga.title,
                    height: coverH - MediaQuery.paddingOf(context).top - 70,
                    borderRadius: KRadius.m,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: KSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(manga.title, style: theme.text(KTypeStyle.h1, size: 22, weight: FontWeight.w700)),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (source != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colors.accentSoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(source.name, style: theme.text(KTypeStyle.caption, size: 10.5, color: theme.colors.accent, weight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (manga.author != null)
                    Text(manga.author!, style: theme.text(KTypeStyle.caption, color: theme.colors.inkMuted)),
                  const Spacer(),
                  if (manga.unread > 0)
                    Text('${manga.unread} unread', style: theme.text(KTypeStyle.label, size: 12, color: theme.colors.accent)),
                ],
              ),
              const SizedBox(height: KSpacing.m),
              Row(
                children: [
                  Expanded(
                    child: KButton(
                      label: _chapters.isEmpty ? 'Fetch chapters' : 'Continue reading',
                      icon: const Icon(Icons.play_arrow, size: 18),
                      onTap: () {
                        final chapter = _resumeChapter();
                        if (chapter != null) {
                          KRoute.push(context, ReaderScreen(manga: manga, initialChapter: chapter));
                        } else {
                          _refresh();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  KIconButton(
                    icon: const Icon(Icons.download_outlined, size: 19),
                    onTap: () => _downloadNext(),
                    tone: KIconTone.accent,
                    tooltip: 'Download next 5',
                  ),
                  const SizedBox(width: 6),
                  KIconButton(
                    icon: const Icon(Icons.track_changes, size: 19),
                    onTap: () => KRoute.push(context, TrackersScreen(mangaKey: manga.key)),
                    tone: KIconTone.defaults,
                    tooltip: 'Track',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Chapter? _resumeChapter() {
    if (_chapters.isEmpty) return null;
    // last read chapter with progress, else first unread
    Chapter? inProgress;
    for (final ch in _chapters) {
      if (ch.lastReadAt != null && (inProgress == null || (ch.lastReadAt!.isAfter(inProgress.lastReadAt!)))) {
        inProgress = ch;
      }
    }
    if (inProgress != null && !inProgress.read) return inProgress;
    final firstUnread = _chapters.reversed.where((c) => !c.read).firstOrNull;
    return firstUnread ?? _chapters.first;
  }

  Widget _tabBar(KTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.l, KSpacing.l, 0),
      child: KTabBar(
        tabs: ['Chapters', 'About', 'Suggestions'],
        index: _tab,
        onChanged: (i) => setState(() => _tab = i),
      ),
    );
  }

  Widget _chaptersPane(KTheme theme, Manga manga) {
    final c = theme.colors;
    if (_refreshing) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: KProgressRing(indeterminate: true, size: 24)),
      );
    }
    if (_chapters.isEmpty) {
      return KEmpty(
        icon: Icon(Icons.menu_book_outlined, size: 34, color: c.accent),
        title: 'No chapters yet',
        message: 'Fetch chapters from the source.',
        action: KButton(label: 'Fetch chapters', onTap: _refresh),
      );
    }
    final grouped = <(String, List<Chapter>)>[];
    for (final ch in _chapters) {
      final vol = ch.number >= 1 ? 'Volume ${ch.number.round()}' : 'Chapters';
      if (grouped.isEmpty || grouped.last.$1 != vol) {
        grouped.add((vol, [ch]));
      } else {
        grouped.last.$2.add(ch);
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (vol, chs) in grouped) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.m, KSpacing.l, 2),
            child: Text(vol, style: theme.text(KTypeStyle.overline, size: 10.5, color: c.inkFaint)),
          ),
          for (final ch in chs) _chapterTile(theme, manga, ch),
        ],
      ],
    );
  }

  Widget _chapterTile(KTheme theme, Manga manga, Chapter ch) {
    final c = theme.colors;
    return KListTile(
      leading: ch.read
          ? Icon(Icons.check_circle_outline, size: 19, color: c.inkFaint)
          : Icon(Icons.radio_button_unchecked, size: 19, color: c.accent),
      title: ch.name,
      subtitle: [
        if (ch.scanlator != null) ch.scanlator!,
        ch.dateUpload != null ? _date(ch.dateUpload!) : null,
      ].whereType<String>().join(' · '),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ch.downloaded) Icon(Icons.download_done, size: 17, color: c.inkFaint),
          if (ch.downloaded) const SizedBox(width: 6),
          if (ch.bookmark) Icon(Icons.bookmark, size: 17, color: c.accent),
        ],
      ),
      onTap: () => KRoute.push(context, ReaderScreen(manga: manga, initialChapter: ch)),
      onLongPress: () => _chapterMenu(theme, manga, ch),
    );
  }

  Future<void> _chapterMenu(KTheme theme, Manga manga, Chapter ch) async {
    final c = theme.colors;
    await showKSheet<void>(context, child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ch.name, style: theme.text(KTypeStyle.h2, size: 16, weight: FontWeight.w700)),
        const SizedBox(height: 8),
        KListTile(
          title: ch.read ? 'Mark as unread' : 'Mark as read',
          leading: Icon(ch.read ? Icons.undo : Icons.done_all, size: 19, color: c.inkMuted),
          onTap: () async {
            await context.app.repos.setChapterRead(ch, !ch.read);
            if (!mounted) return;
            KRoute.pop(context);
            setState(() {});
          },
        ),
        KListTile(
          title: ch.downloaded ? 'Delete download' : 'Download chapter',
          leading: Icon(ch.downloaded ? Icons.delete_outline : Icons.download_outlined, size: 19, color: c.inkMuted),
          onTap: () async {
            KRoute.pop(context);
            if (ch.downloaded) {
              await context.app.downloads.removeDownload(manga, ch);
            } else {
              await context.app.downloads.enqueue(manga, ch);
            }
            setState(() {});
          },
        ),
        KListTile(
          title: ch.bookmark ? 'Remove bookmark' : 'Bookmark',
          leading: Icon(Icons.bookmark_outline, size: 19, color: c.inkMuted),
          onTap: () async {
            await context.app.repos.updateChapter(ch.copyWith(bookmark: !ch.bookmark));
            if (!mounted) return;
            KRoute.pop(context);
            setState(() {});
          },
        ),
        KListTile(
          title: 'Share chapter',
          leading: Icon(Icons.share_outlined, size: 19, color: c.inkMuted),
          onTap: () {
            KRoute.pop(context);
            final source = context.app.sources.byId(manga.sourceId);
            if (source?.baseUrl != null) {
              shareText('${manga.title} — ${ch.name}\n${source!.baseUrl}/title/${manga.remoteId}');
            }
          },
        ),
      ],
    ));
  }

  Widget _aboutPane(KTheme theme, Manga manga, Source? source) {
    final c = theme.colors;
    return Padding(
      padding: const EdgeInsets.all(KSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (manga.description != null && manga.description!.isNotEmpty) ...[
            Text(manga.description!, style: theme.text(KTypeStyle.bodyMuted, size: 13.5, height: 1.55)),
            const SizedBox(height: 14),
          ],
          if (manga.tags.isNotEmpty) ...[
            Wrap(spacing: 6, runSpacing: 6, children: [for (final t in manga.tags) KTag(label: t)]),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              _fact(c, 'Status', manga.status ?? 'unknown'),
              _fact(c, 'Chapters', '${manga.totalChapters}'),
              _fact(c, 'Added', manga.dateAdded == null ? '—' : '${manga.dateAdded!.year}-${manga.dateAdded!.month.toString().padLeft(2, '0')}-${manga.dateAdded!.day.toString().padLeft(2, '0')}'),
            ],
          ),
          const SizedBox(height: 14),
          KButton(
            label: 'Edit details',
            variant: KButtonVariant.secondary,
            onTap: () => _editDetails(theme, manga),
          ),
        ],
      ),
    );
  }

  Widget _fact(PaletteColors c, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 1, color: c.inkFaint)),
          const SizedBox(height: 3),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: c.ink)),
        ],
      ),
    );
  }

  Widget _suggestionsPane(KTheme theme) {
    final c = theme.colors;
    if (_suggestions.isEmpty) {
      return KEmpty(icon: Icon(Icons.auto_awesome_outlined, size: 30, color: c.inkFaint), title: 'No suggestions', message: 'Related titles will appear here.', compact: true);
    }
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: KSpacing.l),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: KSpacing.m),
        itemBuilder: (context, i) {
          final sm = _suggestions[i];
          return GestureDetector(
            onTap: () => KRoute.push(context, MangaDetailScreen(mangaKey: sm.key)),
            child: SizedBox(
              width: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KCover(url: sm.coverUrl, title: sm.title, height: 150, borderRadius: KRadius.m, revealIndex: i),
                  const SizedBox(height: 6),
                  Text(sm.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.text(KTypeStyle.caption, size: 11.5, weight: FontWeight.w600, height: 1.2)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── actions ───────────────────────────────────────────────────────────────

  Future<void> _addToLibrary() async {
    final manga = _manga!;
    await context.app.library.addToLibrary(SourceManga(
      sourceId: manga.sourceId,
      remoteId: manga.remoteId,
      title: manga.title,
      author: manga.author,
      description: manga.description,
      tags: manga.tags,
      status: manga.status,
      coverUrl: manga.coverUrl,
    ));
    if (!mounted) return;
    setState(() => _manga = _manga!.copyWith(favorite: true));
    KToastHost.show(context, 'Added to library');
  }

  Future<void> _removeFromLibrary() async {
    final confirmed = await showKDialog<bool>(context, child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Remove from library?', style: context.kTheme.text(KTypeStyle.title, size: 16, weight: FontWeight.w700)),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            KButton(label: 'Cancel', variant: KButtonVariant.ghost, onTap: () => KRoute.pop(context, false)),
            const SizedBox(width: 8),
            KButton(label: 'Remove', variant: KButtonVariant.danger, onTap: () => KRoute.pop(context, true)),
          ],
        ),
      ],
    ));
    if (confirmed != true) return;
    if (!mounted) return;
    final library = context.app.library;
    await library.removeFromLibrary(_manga!);
    if (!mounted) return;
    KRoute.pop(context);
  }

  Future<void> _downloadNext() async {
    final manga = _manga!;
    final next = _chapters.where((c) => !c.downloaded).take(5).toList();
    if (next.isEmpty) {
      KToastHost.show(context, 'Everything is downloaded');
      return;
    }
    await context.app.downloads.enqueueAll(manga, next);
    if (!mounted) return;
    KToastHost.show(context, 'Queued ${next.length} chapters');
  }

  Future<void> _editDetails(KTheme theme, Manga manga) async {
    final title = TextEditingController(text: manga.title);
    final author = TextEditingController(text: manga.author ?? '');
    final desc = TextEditingController(text: manga.description ?? '');
    await showKSheet<void>(context, child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Edit details', style: theme.text(KTypeStyle.h2, size: 17, weight: FontWeight.w700)),
        const SizedBox(height: 12),
        KTextField(controller: title, label: 'Title'),
        const SizedBox(height: 10),
        KTextField(controller: author, label: 'Author'),
        const SizedBox(height: 10),
        KTextField(controller: desc, label: 'Description', maxLines: 4),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            KButton(label: 'Cancel', variant: KButtonVariant.ghost, onTap: () => KRoute.pop(context)),
            const SizedBox(width: 8),
            KButton(label: 'Save', onTap: () async {
              await context.app.repos.updateManga(manga.copyWith(title: title.text, author: author.text.isEmpty ? null : author.text, description: desc.text));
              if (!mounted) return;
              KRoute.pop(context);
              setState(() {});
              _refresh();
            }),
          ],
        ),
      ],
    ));
  }

  static String _date(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// imports

Future<void> shareText(String text) => Share.share(text);
