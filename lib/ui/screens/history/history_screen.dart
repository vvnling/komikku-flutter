import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';
import '../../../data/models/models.dart';
import 'package:flutter/material.dart' show Icons;
import '../manga/manga_detail_screen.dart';
import '../reader/reader_screen.dart';
import '../../../ui/widgets/widgets.dart';

/// History tab — recently read chapters, grouped by manga.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = context.kTheme;
    final c = theme.colors;

    return SafeArea(
      bottom: false,
      child: StreamBuilder<List<HistoryEntry>>(
        stream: context.app.repos.watchHistory(limit: 80),
        builder: (context, snap) {
          final entries = snap.data ?? const <HistoryEntry>[];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.l, KSpacing.l, KSpacing.s),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('History', style: theme.text(KTypeStyle.h1, size: 26, weight: FontWeight.w700)),
                          Text('${entries.length} recent reads', style: theme.text(KTypeStyle.caption, color: c.inkMuted)),
                        ],
                      ),
                    ),
                    if (entries.isNotEmpty)
                      KButton(
                        label: 'Clear',
                        variant: KButtonVariant.ghost,
                        size: KButtonSize.sm,
                        onTap: () async {
                          await context.app.repos.clearHistory();
                          if (!context.mounted) return;
                          KToastHost.show(context, 'History cleared');
                        },
                      ),
                  ],
                ),
              ),
              Expanded(child: _body(entries)),
            ],
          );
        },
      ),
    );
  }

  Widget _body(List<HistoryEntry> entries) {
    final theme = context.kTheme;
    final c = theme.colors;
    if (entries.isEmpty) {
      return KEmpty(
        icon: Icon(Icons.history_outlined, size: 34, color: c.accent),
        title: 'Nothing read yet',
        message: 'Open a chapter and it will show up here.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.s, KSpacing.l, 90),
      itemCount: entries.length,
      itemBuilder: (context, i) => _HistoryRow(entry: entries[i]),
    );
  }
}

class _HistoryRow extends StatefulWidget {
  const _HistoryRow({required this.entry});
  final HistoryEntry entry;

  @override
  State<_HistoryRow> createState() => _HistoryRowState();
}

class _HistoryRowState extends State<_HistoryRow> {
  Manga? _manga;
  Chapter? _chapter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repos = context.app.repos;
    final manga = await repos.mangaById(widget.entry.mangaId);
    final chapter = (await repos.chaptersOfManga(widget.entry.mangaId)).where((c) => c.id == widget.entry.chapterId).firstOrNull;
    if (mounted) {
      setState(() {
      _manga = manga;
      _chapter = chapter;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = _manga;
    if (m == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: KSpacing.s),
      child: KListTile(
        leading: SizedBox(
          width: 46,
          height: 66,
          child: KCover(url: m.coverUrl, title: m.title, width: 46, height: 66, borderRadius: 8),
        ),
        title: m.title,
        subtitle: '${_chapter?.name ?? 'Chapter'} · ${(widget.entry.percent * 100).round()}%',
        trailing: SizedBox(
          width: 120,
          child: KProgressBar(value: widget.entry.percent, height: 3),
        ),
        onTap: () {
          if (_chapter != null && m.id != null) {
            KRoute.push(context, ReaderScreen(manga: m, initialChapter: _chapter!));
          }
        },
        onLongPress: () => KRoute.push(context, MangaDetailScreen(mangaKey: m.key)),
      ),
    );
  }
}
