import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';
import '../../../data/models/models.dart';
import '../../../data/sources/source.dart';

/// Migration — move library entries from one source to another
/// (Komikku: "Source migration… migrate all your manga").
import 'package:flutter/material.dart' show Icons;
import '../../../ui/widgets/widgets.dart';
class MigrationScreen extends StatefulWidget {
  const MigrationScreen({super.key});

  @override
  State<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends State<MigrationScreen> {
  List<Manga> _mangas = const [];
  int _current = 0;
  bool _running = false;
  final Map<int, SourceManga?> _mapped = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final mangas = await context.app.repos.allMangas(onlyFavorites: true);
    if (mounted) setState(() => _mangas = mangas);
  }

  List<Source> _targetSources(Source? from) =>
      context.app.sources.all.where((s) => s.id != from?.id && s.supportsSearch).toList();

  Future<void> _migrateAll() async {
    if (_mangas.isEmpty) return;
    setState(() => _running = true);
    final target = _targetSources(null).firstOrNull;
    if (target == null) {
      KToastHost.show(context, 'No target source available');
      setState(() => _running = false);
      return;
    }
    for (var i = 0; i < _mangas.length; i++) {
      _current = i;
      setState(() {});
      final m = _mangas[i];
      try {
        final results = await target.search(m.title, 1);
        if (results.isNotEmpty && mounted) {
          await _doMigrate(m, results.first);
        }
      } catch (_) {}
    }
    setState(() => _running = false);
    if (!mounted) return;
    KToastHost.show(context, 'Migration finished');
  }

  Future<void> _doMigrate(Manga m, SourceManga target) async {
    final app = context.app;
    await app.repos.removeFromLibrary(m.id!);
    final added = await app.library.addToLibrary(target.copyWith(extra: {...?target.extra, 'fromSource': m.sourceId}));
    try {
      await app.library.refreshManga(added);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {

    return KPage(
      child: Column(
        children: [
          KAppBar(
            title: 'Migration',
            onBack: () => KRoute.pop(context),
            trailing: [
              KButton(
                label: _running ? 'Migrating…' : 'Migrate all',
                size: KButtonSize.sm,
                onTap: _running ? null : _migrateAll,
              ),
            ],
          ),
          if (_running) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: KSpacing.l, vertical: 6),
              child: KProgressBar(value: _mangas.isEmpty ? 0 : _current / _mangas.length),
            ),
          ],
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.s, KSpacing.l, 60),
              itemCount: _mangas.length,
              itemBuilder: (context, i) {
                final m = _mangas[i];
                final mapped = _mapped[m.id];
                return Padding(
                  padding: const EdgeInsets.only(bottom: KSpacing.s),
                  child: _MigrationRow(
                    manga: m,
                    mappedTo: mapped,
                    onSearch: () => _searchFor(m),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchFor(Manga m) async {
    final sources = _targetSources(context.app.sources.byId(m.sourceId));
    if (sources.isEmpty) {
      KToastHost.show(context, 'No searchable target sources');
      return;
    }
    final theme = context.kTheme;
    final c = context.kColors;
    final controller = TextEditingController(text: m.title);
    final selectedSource = ValueNotifier<Source>(sources.first);
    await showKSheet<void>(context, child: StatefulBuilder(
      builder: (context, setSheet) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Migrate ${m.title}', style: theme.text(KTypeStyle.h2, size: 16, weight: FontWeight.w700)),
          const SizedBox(height: 10),
          ValueListenableBuilder<Source>(
            valueListenable: selectedSource,
            builder: (context, source, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final s in sources)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: KChip(label: s.name, selected: s.id == source.id, onTap: () => selectedSource.value = s),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                KSearchField(controller: controller, onSubmitted: (_) => setSheet(() {})),
                const SizedBox(height: 8),
                FutureBuilder<List<SourceManga>>(
                  future: _searchFuture(source, controller.text),
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Padding(padding: EdgeInsets.all(24), child: Center(child: KProgressRing(indeterminate: true, size: 22)));
                    }
                    final results = snap.data ?? const [];
                    if (results.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('No matches — refine the title', style: theme.text(KTypeStyle.caption, color: c.inkFaint)),
                      );
                    }
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (final r in results)
                            KListTile(
                              leading: SizedBox(width: 38, height: 54, child: KCover(url: r.coverUrl, title: r.title, width: 38, height: 54, borderRadius: 6)),
                              title: r.title,
                              subtitle: r.author,
                              trailing: const Icon(Icons.north_east, size: 16),
                              onTap: () async {
                                if (!mounted) return;
                                KRoute.pop(context);
                                await _doMigrate(m, r);
                                if (!context.mounted) return;
                                setState(() => _mapped[m.id!] = r);
                                await _load();
                                if (!context.mounted) return;
                                KToastHost.show(context, 'Migrated to ${r.title}');
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Future<List<SourceManga>> _searchFuture(Source source, String query) {
    if (query.trim().isEmpty) return Future.value(const []);
    return source.search(query.trim(), 1);
  }
}

class _MigrationRow extends StatelessWidget {
  const _MigrationRow({required this.manga, required this.mappedTo, required this.onSearch});
  final Manga manga;
  final SourceManga? mappedTo;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    return KCard(
      corner: PanelCorner.none,
      child: Row(
        children: [
          SizedBox(width: 40, height: 58, child: KCover(url: manga.coverUrl, title: manga.title, width: 40, height: 58, borderRadius: 6)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(manga.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.text(KTypeStyle.bodyMuted, size: 13.5, weight: FontWeight.w600)),
                Text(
                  mappedTo == null ? 'source: ${manga.sourceId}' : '→ ${mappedTo!.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.text(KTypeStyle.caption, size: 11.5, color: mappedTo == null ? c.inkFaint : c.accent),
                ),
              ],
            ),
          ),
          KButton(label: mappedTo == null ? 'Find' : 'Redo', variant: KButtonVariant.secondary, size: KButtonSize.sm, onTap: onSearch),
        ],
      ),
    );
  }
}

// icons