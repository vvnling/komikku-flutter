import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/motion.dart';
import '../../../core/design/tokens.dart';
import '../../../data/models/models.dart';
import '../../../data/services/library_service.dart' show LibraryService, SyncState;
import '../manga/manga_detail_screen.dart';

/// Library tab — categories, sort/filter, search, bulk mode, continue row.
import 'package:flutter/material.dart' show Icons;
import '../../../ui/widgets/widgets.dart';
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  List<Category> _categories = const [];
  int? _categoryId; // null = all
  String _query = '';
  bool _bulkMode = false;
  final Set<int> _selected = {};
  List<Manga>? _mangas;
  bool _loading = true;
  final _searchController = TextEditingController();
  LibraryService? _library; // captured in initState for dispose-safety

  @override
  void initState() {
    super.initState();
    _library = context.app.library;
    _library!.libraryVersion.addListener(_reload);
    _reload();
  }

  @override
  void dispose() {
    _library?.libraryVersion.removeListener(_reload);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final repos = context.app.repos;
    final settings = context.app.settings;
    final cats = await repos.allCategories();
    final mangas = await repos.libraryMangas(
      categoryIds: _categoryId == null ? null : {_categoryId!},
      downloadedOnly: settings.libraryFilter == 1,
      unreadOnly: settings.libraryFilter == 2,
      startedOnly: settings.libraryFilter == 3,
      trackedOnly: settings.libraryFilter == 4,
      notTrackedOnly: settings.libraryFilter == 5,
      searchTerm: _query.trim().isEmpty ? null : _query.trim(),
      sortBy: _sortKey(settings.librarySort),
      ascending: settings.librarySortAsc,
      includeHiddenCategoryMangas: settings.showHidden,
    );
    if (!mounted) return;
    setState(() {
      _categories = cats;
      _mangas = mangas;
      _loading = false;
    });
  }

  static String? _sortKey(int i) => switch (i) {
        1 => 'title',
        2 => 'lastRead',
        3 => 'lastUpdate',
        4 => 'unread',
        5 => 'totalChapters',
        6 => 'source',
        _ => 'added',
      };

  void _enterBulk() {
    setState(() {
      _bulkMode = true;
      _selected.clear();
    });
  }

  void _exitBulk() => setState(() {
        _bulkMode = false;
        _selected.clear();
      });

  void _toggleSelect(Manga m) => setState(() {
        if (!_selected.remove(m.id!)) _selected.add(m.id!);
      });

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final settings = context.app.settings;
    final mangas = _mangas ?? const <Manga>[];

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(theme, c),
          _categoryRow(theme, c),
          _toolbar(theme, c, settings),
          const SizedBox(height: 4),
          Expanded(child: _body(theme, c, mangas)),
        ],
      ),
    );
  }

  // ── header ────────────────────────────────────────────────────────────────
  Widget _header(KTheme theme, PaletteColors c) {
    final settings = context.app.settings;
    return Padding(
      padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.l, KSpacing.l, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Library', style: theme.text(KTypeStyle.h1, size: 26, weight: FontWeight.w700)),
                if (_bulkMode)
                  Text('${_selected.length} selected', style: theme.text(KTypeStyle.caption, color: c.accent))
                else
                  Text('${_categoryId == null ? _mangas?.length ?? 0 : (_mangas?.length ?? 0)} entries', style: theme.text(KTypeStyle.caption, color: c.inkMuted)),
              ],
            ),
          ),
          if (_bulkMode) ...[
            KIconButton(
              icon: const Icon(Icons.close),
              onTap: _exitBulk,
              tooltip: 'Exit selection',
            ),
            const SizedBox(width: 8),
            KMenuButton(
              items: [
                KMenuItem('Merge selected', icon: const Icon(Icons.call_merge), onTap: _mergeSelected, enabled: _selected.length > 1),
                KMenuItem('Add to category…', icon: const Icon(Icons.folder_outlined), onTap: _categorizeSelected),
                KMenuItem('Mark read', icon: const Icon(Icons.done_all), onTap: () => _markSelected(true)),
                KMenuItem('Mark unread', icon: const Icon(Icons.undo), onTap: () => _markSelected(false)),
                KMenuItem('Remove from library', icon: const Icon(Icons.delete_outline), onTap: _deleteSelected, danger: true),
              ],
              child: KIconButton(icon: const Icon(Icons.more_vert), onTap: () {}, tooltip: 'Bulk actions'),
            ),
          ] else ...[
            SizedBox(
              width: 200,
              child: KSearchField(
                controller: _searchController,
                hint: 'Search library…',
                onChanged: (v) {
                  _query = v;
                  _reload();
                },
              ),
            ),
            const SizedBox(width: 10),
            KMenuButton(
              items: [
                KMenuItem('Layout', icon: const Icon(Icons.grid_view_outlined), trailing: KSegmented<String>(
                  options: const [('grid', 'Grid'), ('list', 'List')],
                  value: settings.libraryLayout,
                  onChanged: (v) {
                    settings.libraryLayout = v;
                    setState(() {});
                  },
                )),
              ],
              child: KIconButton(
                icon: const Icon(Icons.grid_view_outlined),
                onTap: () {},
                tooltip: 'Layout',
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── category chips ────────────────────────────────────────────────────────
  Widget _categoryRow(KTheme theme, PaletteColors c) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: KSpacing.l),
        children: [
          KChip(label: 'All', selected: _categoryId == null, onTap: () {
            _categoryId = null;
            _reload();
          }),
          const SizedBox(width: 8),
          for (final cat in _categories)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: KChip(
                label: cat.hidden ? '👁 ${cat.name}' : cat.name,
                selected: _categoryId == cat.id,
                onTap: () {
                  _categoryId = cat.id;
                  _reload();
                },
              ),
            ),
          KChip(
            label: '+ New category',
            icon: const Icon(Icons.add, size: 13),
            onTap: _newCategory,
          ),
        ],
      ),
    );
  }

  // ── sort / filter toolbar ─────────────────────────────────────────────────
  Widget _toolbar(KTheme theme, PaletteColors c, settings) {
    final sortLabels = const ['Date added', 'Title', 'Last read', 'Last updated', 'Unread', 'Total chapters', 'Source'];
    final filterLabels = const ['All', 'Downloaded', 'Unread', 'Started', 'Tracked', 'Not tracked'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KSpacing.l, vertical: 6),
      child: Row(
        children: [
          KMenuButton(
            position: KMenuPosition.above,
            items: [
              for (var i = 0; i < sortLabels.length; i++)
                KMenuItem(sortLabels[i], onTap: () {
                  settings.librarySort = i;
                  _reload();
                }, trailing: settings.librarySort == i ? Icon(Icons.check, size: 16, color: c.accent) : null),
            ],
            child: KChip(label: sortLabels[settings.librarySort], icon: const Icon(Icons.swap_vert, size: 13)),
          ),
          const SizedBox(width: 8),
          KMenuButton(
            position: KMenuPosition.above,
            items: [
              for (var i = 0; i < filterLabels.length; i++)
                KMenuItem(filterLabels[i], onTap: () {
                  settings.libraryFilter = i;
                  _reload();
                }, trailing: settings.libraryFilter == i ? Icon(Icons.check, size: 16, color: c.accent) : null),
            ],
            child: KChip(label: filterLabels[settings.libraryFilter], icon: const Icon(Icons.filter_alt_outlined, size: 13)),
          ),
          const Spacer(),
          KChip(
            label: settings.librarySortAsc ? 'Asc' : 'Desc',
            onTap: () {
              settings.librarySortAsc = !settings.librarySortAsc;
              _reload();
            },
          ),
        ],
      ),
    );
  }

  // ── body ──────────────────────────────────────────────────────────────────
  Widget _body(KTheme theme, PaletteColors c, List<Manga> mangas) {
    final settings = context.app.settings;
    if (_loading) {
      return const Center(child: KProgressRing(indeterminate: true, size: 26));
    }
    if (mangas.isEmpty && _query.isNotEmpty) {
      return KEmpty(icon: Icon(Icons.search_off, size: 34, color: c.inkFaint), title: 'No matches', message: 'Try a different search term.');
    }
    if (mangas.isEmpty) {
      return KEmpty(
        icon: Icon(Icons.auto_stories_outlined, size: 34, color: c.accent),
        title: 'Your library is empty',
        message: 'Browse sources to add manga, or load the offline demo to see Comicko in action.',
        action: KButton(label: 'Add demo entries', variant: KButtonVariant.secondary, onTap: _seedDemo),
      );
    }

    return KRefresh(
      onRefresh: _refreshAll,
      child: settings.libraryLayout == 'list' ? _list(mangas) : _grid(mangas),
    );
  }

  Widget _grid(List<Manga> mangas) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = width >= KBreakpoints.desktop ? 7 : width >= KBreakpoints.tablet ? 5 : width >= 420 ? 4 : 3;
    final spacing = KSpacing.m;
    final coverW = (width - KSpacing.l * 2 - spacing * (cols - 1)) / cols;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.s, KSpacing.l, 90),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: spacing,
        mainAxisSpacing: KSpacing.l,
        mainAxisExtent: coverW * 1.62 + 30,
      ),
      itemCount: mangas.length,
      itemBuilder: (context, i) => _gridItem(mangas[i], coverW, i),
    );
  }

  Widget _gridItem(Manga m, double coverW, int index) {
    final theme = context.kTheme;
    final selected = _selected.contains(m.id);
    return GestureDetector(
      onLongPress: _bulkMode ? null : () {
        _enterBulk();
        _toggleSelect(m);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              KCover(
                url: m.coverUrl,
                title: m.title,
                width: coverW,
                height: coverW * 1.5,
                revealIndex: index,
                onTap: _bulkMode ? () => _toggleSelect(m) : () => KRoute.push(context, MangaDetailScreen(mangaKey: m.key)),
                onLongPress: _bulkMode ? () => _toggleSelect(m) : null,
              ),
              if (_bulkMode)
                Positioned(
                  top: 8,
                  left: 8,
                  child: _BulkCheck(selected: selected),
                )
              else if (m.unread > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: KBadge(count: m.unread),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            m.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.text(KTypeStyle.caption, size: 12, weight: FontWeight.w600, height: 1.25),
          ),
        ],
      ),
    );
  }

  Widget _list(List<Manga> mangas) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.s, KSpacing.l, 90),
      itemCount: mangas.length,
      itemBuilder: (context, i) {
        final m = mangas[i];
        final source = context.app.sources.byId(m.sourceId);
        return KListTile(
          leading: SizedBox(
            width: 44,
            height: 62,
            child: KCover(url: m.coverUrl, title: m.title, width: 44, height: 62, borderRadius: 6, revealIndex: i),
          ),
          title: m.title,
          subtitle: '${source?.name ?? m.sourceId} · ${m.unread} unread',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_bulkMode)
                _BulkCheck(selected: _selected.contains(m.id))
              else if (m.unread > 0)
                KBadge(count: m.unread),
            ],
          ),
          onTap: _bulkMode ? () => _toggleSelect(m) : () => KRoute.push(context, MangaDetailScreen(mangaKey: m.key)),
          onLongPress: _bulkMode ? null : () {
            _enterBulk();
            _toggleSelect(m);
          },
        );
      },
    );
  }

  // ── actions ───────────────────────────────────────────────────────────────

  Future<void> _refreshAll() async {
    final app = context.app;
    final mangas = _mangas ?? const <Manga>[];
    var i = 0;
    for (final m in mangas.take(20)) {
      i++;
      app.library.syncState.value = SyncState(current: i, total: mangas.length, label: m.title);
      try {
        await app.library.refreshManga(m);
      } catch (_) {}
    }
    app.library.syncState.value = null;
    await _reload();
  }

  Future<void> _seedDemo() async {
    final app = context.app;
    final source = app.sources.byId('demo')!;
    final popular = await source.getPopular(1);
    var i = 0;
    for (final sm in popular) {
      i++;
      app.library.syncState.value = SyncState(current: i, total: popular.length, label: sm.title);
      final m = await app.library.addToLibrary(sm);
      await app.library.refreshManga(m);
    }
    app.library.syncState.value = null;
    if (!mounted) return;
    KToastHost.show(context, 'Added ${popular.length} demo entries');
    await _reload();
  }

  Future<void> _newCategory() async {
    final controller = TextEditingController();
    await showKDialog<void>(context, child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('New category', style: context.kTheme.text(KTypeStyle.h2, size: 18, weight: FontWeight.w700)),
        const SizedBox(height: 14),
        KTextField(controller: controller, hint: 'Category name', autofocus: true),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            KButton(label: 'Cancel', variant: KButtonVariant.ghost, onTap: () => KRoute.pop(context)),
            const SizedBox(width: 8),
            KButton(label: 'Create', onTap: () async {
              if (controller.text.trim().isEmpty) return;
              await context.app.repos.createCategory(controller.text.trim());
              if (!mounted) return;
              KRoute.pop(context);
              _reload();
            }),
          ],
        ),
      ],
    ));
  }

  Future<void> _mergeSelected() async {
    if (_selected.length < 2) return;
    final mangas = _mangas!.where((m) => _selected.contains(m.id)).toList();
    final primary = mangas.first;
    final secondary = mangas.skip(1).map((m) => m.id!).toList();
    await context.app.library.mergeMangas(primary.id!, secondary);
    _exitBulk();
    if (!mounted) return;
    KToastHost.show(context, 'Merged ${secondary.length} entries into ${primary.title}');
    await _reload();
  }

  Future<void> _categorizeSelected() async {
    final app = context.app;
    final repos = app.repos;
    final cats = await repos.allCategories();
    final controller = TextEditingController();
    if (!mounted) return;
    await showKSheet<void>(context, child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add to category', style: context.kTheme.text(KTypeStyle.h2, size: 17, weight: FontWeight.w700)),
        const SizedBox(height: 12),
        KTextField(controller: controller, hint: 'New category name…', onSubmitted: (v) async {
          if (v.trim().isEmpty) return;
          final cat = await repos.createCategory(v.trim());
          for (final id in _selected) {
            final current = await repos.categoriesOfManga(id);
            await repos.setMangaCategories(id, [...current.map((x) => x.id!), cat.id!]);
          }
          if (!mounted) return;
          KRoute.pop(context);
          KToastHost.show(context, 'Added to ${cat.name}');
          _reload();
        }),
        const SizedBox(height: 8),
        for (final cat in cats)
          KListTile(
            title: cat.name,
            onTap: () async {
              for (final id in _selected) {
                final current = await repos.categoriesOfManga(id);
                await repos.setMangaCategories(id, [...current.map((x) => x.id!), cat.id!]);
              }
              if (!mounted) return;
              KRoute.pop(context);
              KToastHost.show(context, 'Added to ${cat.name}');
              _reload();
            },
          ),
      ],
    ));
  }

  Future<void> _markSelected(bool read) async {
    final repos = context.app.repos;
    for (final id in _selected) {
      for (final ch in await repos.chaptersOfManga(id)) {
        await repos.setChapterRead(ch, read);
      }
    }
    _exitBulk();
    await _reload();
  }

  Future<void> _deleteSelected() async {
    final confirmed = await showKDialog<bool>(context, child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Remove ${_selected.length} entries?', style: context.kTheme.text(KTypeStyle.title, size: 16, weight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Downloads are kept on disk unless you delete them separately.', style: context.kTheme.text(KTypeStyle.bodyMuted, size: 13)),
        const SizedBox(height: 16),
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
    for (final id in _selected) {
      final m = _mangas!.firstWhere((x) => x.id == id);
      await library.removeFromLibrary(m);
    }
    _exitBulk();
    await _reload();
  }
}

class _BulkCheck extends StatelessWidget {
  const _BulkCheck({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    return AnimatedContainer(
      duration: KMotion.fast,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: selected ? c.accent : c.surface.withValues(alpha: 0.85),
        shape: BoxShape.circle,
        border: Border.all(color: selected ? c.accent : c.lineStrong, width: 1.6),
      ),
      child: selected
          ? Icon(Icons.check, size: 15, color: c.accentInk)
          : null,
    );
  }
}

// icons
