import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';
import '../../../data/models/models.dart';
import '../../../data/sources/source.dart';
import '../manga/manga_detail_screen.dart';

/// Search screen — global search across a source with saved-search chips.
import 'package:flutter/material.dart' show Icons;
import '../../../ui/widgets/widgets.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.initialQuery, this.source});

  final String initialQuery;
  final Source? source;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller = TextEditingController(text: widget.initialQuery);
  List<SourceManga> _results = const [];
  bool _loading = false;
  String? _error;
  int _page = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery.isNotEmpty) _search(reset: true);
  }

  Future<void> _search({bool reset = false}) async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    final source = widget.source ?? context.app.sources.all.where((s) => context.app.settings.isSourceEnabled(s.id) && s.id != 'local').firstOrNull;
    if (source == null) return;
    if (reset) {
      _page = 1;
      _results = const [];
      setState(() => _loading = true);
    }
    try {
      final found = await source.search(query, _page);
      if (!mounted) return;
      setState(() {
        _results = [..._results, ...found];
        _loading = false;
        _hasMore = found.length >= 20;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _saveSearch() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    final searches = context.app.settings.savedSearches;
    if (searches.any((s) => s['query'] == query)) {
      KToastHost.show(context, 'Already saved');
      return;
    }
    context.app.settings.savedSearches = [
      ...searches,
      SavedSearch(query: query, sourceId: widget.source?.id, createdAt: DateTime.now()).toMap(),
    ];
    KToastHost.show(context, 'Search saved');
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final source = widget.source;

    return KPage(
      child: Column(
        children: [
          KAppBar(
            title: 'Search',
            subtitle: source?.name,
            onBack: () => KRoute.pop(context),
            trailing: [
              KIconButton(
                icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                onTap: _saveSearch,
                tone: KIconTone.plain,
                tooltip: 'Save search',
              ),
              KButton(
                label: 'Search',
                size: KButtonSize.sm,
                onTap: () => _search(reset: true),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: KSpacing.l),
            child: KSearchField(
              controller: _controller,
              hint: 'Title, author, tag…',
              autofocus: widget.initialQuery.isEmpty,
              onSubmitted: (_) => _search(reset: true),
            ),
          ),
          if (source?.supportsSearch == false)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('This source does not support search.', style: theme.text(KTypeStyle.bodyMuted, size: 13)),
            ),
          Expanded(child: _body(theme, c)),
        ],
      ),
    );
  }

  Widget _body(KTheme theme, PaletteColors c) {
    if (_loading && _results.isEmpty) {
      return const Center(child: KProgressRing(indeterminate: true, size: 26));
    }
    if (_error != null && _results.isEmpty) {
      return KEmpty(icon: Icon(Icons.error_outline, size: 32, color: c.inkFaint), title: 'Search failed', message: _error);
    }
    if (_results.isEmpty) {
      return KEmpty(icon: Icon(Icons.search, size: 32, color: c.inkFaint), title: 'Search the catalog', message: 'Try a title or author name.', compact: true);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.s, KSpacing.l, 40),
      itemCount: _results.length + 1,
      itemBuilder: (context, i) {
        if (i == _results.length) {
          if (!_hasMore) return const SizedBox(height: 20);
          return Padding(
            padding: const EdgeInsets.all(14),
            child: Center(child: KButton(label: 'Load more', variant: KButtonVariant.secondary, onTap: () {
              _page++;
              _search();
            })),
          );
        }
        final m = _results[i];
        return KListTile(
          leading: SizedBox(width: 44, height: 64, child: KCover(url: m.coverUrl, title: m.title, width: 44, height: 64, borderRadius: 8)),
          title: m.title,
          subtitle: m.author ?? m.tags.take(2).join(' · '),
          onTap: () => KRoute.push(context, MangaDetailScreen(mangaKey: m.key)),
          onLongPress: () async {
            await context.app.library.addToLibrary(m);
            if (!context.mounted) return;
            KToastHost.show(context, 'Added to library');
          },
        );
      },
    );
  }
}

// icons
