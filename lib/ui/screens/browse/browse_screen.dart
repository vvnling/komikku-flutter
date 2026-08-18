import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';
import '../../../data/models/models.dart';
import '../../../data/sources/source.dart';
import '../manga/manga_detail_screen.dart';
import 'search_screen.dart';

/// Browse tab — sources, global search, feed of latest entries.
import 'package:flutter/material.dart' show Icons;
import '../../../ui/widgets/widgets.dart';
class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> with AutomaticKeepAliveClientMixin {
  Source? _source;
  List<SourceManga> _entries = const [];
  bool _loading = true;
  bool _feedMode = true;
  int _page = 1;
  bool _hasMore = true;
  String? _error;
  final _searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // default source: first enabled non-local
    final sources = context.app.sources.all.where((s) => context.app.settings.isSourceEnabled(s.id) && s.id != 'local').toList();
    _source = sources.firstOrNull;
    _load();
  }

  Future<void> _load({bool reset = false}) async {
    final source = _source;
    if (source == null) {
      setState(() {
        _loading = false;
        _entries = const [];
        _error = 'No sources enabled';
      });
      return;
    }
    if (reset) {
      setState(() {
        _loading = true;
        _entries = const [];
        _page = 1;
        _error = null;
      });
    }
    try {
      final items = _feedMode ? await source.getLatest(_page) : await source.getPopular(_page);
      if (!mounted) return;
      setState(() {
        _entries = [..._entries, ...items];
        _loading = false;
        _hasMore = items.length >= 20;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = context.kTheme;
    final c = theme.colors;
    final sources = context.app.sources.all.where((s) => context.app.settings.isSourceEnabled(s.id)).toList();

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.l, KSpacing.l, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Browse', style: theme.text(KTypeStyle.h1, size: 26, weight: FontWeight.w700)),
                      Text(_source == null ? 'no sources' : '${_source!.name} · ${_feedMode ? 'latest' : 'popular'}', style: theme.text(KTypeStyle.caption, color: c.inkMuted)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: KSearchField(
                    controller: _searchController,
                    hint: 'Search…',
                    onSubmitted: (v) {
                      if (v.trim().isEmpty) return;
                      KRoute.push(context, SearchScreen(initialQuery: v.trim(), source: _source));
                    },
                  ),
                ),
              ],
            ),
          ),
          // source chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: KSpacing.l, vertical: 4),
              children: [
                KChip(
                  label: 'Feed',
                  selected: _feedMode,
                  onTap: () {
                    _feedMode = true;
                    setState(() {});
                    _load(reset: true);
                  },
                ),
                const SizedBox(width: 8),
                for (final s in sources)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: KChip(
                      label: s.name,
                      selected: _source?.id == s.id && !_feedMode,
                      onTap: () {
                        _feedMode = false;
                        _source = s;
                        setState(() {});
                        _load(reset: true);
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: KChip(
                    label: 'Saved',
                    icon: const Icon(Icons.bookmark_outline, size: 13),
                    onTap: () => _showSavedSearches(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _body(theme, c)),
        ],
      ),
    );
  }

  Widget _body(KTheme theme, PaletteColors c) {
    if (_loading && _entries.isEmpty) {
      return const Center(child: KProgressRing(indeterminate: true, size: 28));
    }
    if (_error != null && _entries.isEmpty) {
      return KEmpty(icon: Icon(Icons.cloud_off, size: 34, color: c.inkFaint), title: 'Could not load', message: _error);
    }
    if (_entries.isEmpty) {
      return KEmpty(icon: Icon(Icons.explore_outlined, size: 34, color: c.accent), title: 'Nothing here yet', message: 'Pull to refresh or switch source.');
    }
    return KRefresh(
      onRefresh: () => _load(reset: true),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.s, KSpacing.l, 90),
        itemCount: _entries.length + 1,
        itemBuilder: (context, i) {
          if (i == _entries.length) {
            if (!_hasMore) return const SizedBox(height: 40);
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: KButton(
                  label: 'Load more',
                  variant: KButtonVariant.secondary,
                  onTap: () {
                    _page++;
                    _load();
                  },
                ),
              ),
            );
          }
          return _entryRow(_entries[i], i);
        },
      ),
    );
  }

  Widget _entryRow(SourceManga m, int index) {
    final theme = context.kTheme;
    final c = theme.colors;
    return KListTile(
      leading: SizedBox(
        width: 46,
        height: 66,
        child: KCover(url: m.coverUrl, title: m.title, width: 46, height: 66, borderRadius: 8, revealIndex: index),
      ),
      title: m.title,
      subtitle: [
        if (m.author != null) m.author!,
        if (m.tags.isNotEmpty) m.tags.take(3).join(' · '),
      ].join(' · '),
      onTap: () => KRoute.push(context, MangaDetailScreen(mangaKey: m.key)),
      onLongPress: () async {
        await context.app.library.addToLibrary(m);
        KToastHost.show(context, 'Added to library');
      },
    );
  }

  Future<void> _showSavedSearches() async {
    final searches = context.app.settings.savedSearches;
    if (searches.isEmpty) {
      KToastHost.show(context, 'No saved searches yet — save one from Search');
      return;
    }
    await showKSheet<void>(context, child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Saved searches', style: context.kTheme.text(KTypeStyle.h2, size: 17, weight: FontWeight.w700)),
        const SizedBox(height: 8),
        for (final s in searches)
          KListTile(
            title: s['label'] ?? s['query'] ?? '',
            subtitle: s['sourceId'],
            trailing: KIconButton(icon: const Icon(Icons.close, size: 16), tone: KIconTone.plain, onTap: () {
              context.app.settings.savedSearches = searches.where((x) => x != s).toList();
              KRoute.pop(context);
              _showSavedSearches();
            }),
            onTap: () {
              KRoute.pop(context);
              KRoute.push(context, SearchScreen(
                initialQuery: s['query'] ?? '',
                source: context.app.sources.byId(s['sourceId'] ?? ''),
              ));
            },
          ),
      ],
    ));
  }
}

// icons
