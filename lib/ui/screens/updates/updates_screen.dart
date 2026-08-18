import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';
import '../../../data/services/update_service.dart';
import '../manga/manga_detail_screen.dart';

/// Updates tab — new chapters grouped by manga (J2K-style).
import 'package:flutter/material.dart' show Icons;
import '../../../ui/widgets/widgets.dart';
class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.app.updates.rebuildUpdateList());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = context.kTheme;
    final c = theme.colors;

    return SafeArea(
      bottom: false,
      child: ValueListenableBuilder<List<MangaUpdate>>(
        valueListenable: context.app.updates.updates,
        builder: (context, updates, _) {
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
                          Text('Updates', style: theme.text(KTypeStyle.h1, size: 26, weight: FontWeight.w700)),
                          Text(_statsLine(updates), style: theme.text(KTypeStyle.caption, color: c.inkMuted)),
                        ],
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: context.app.updates.isChecking,
                      builder: (context, checking, _) => KButton(
                        label: checking ? 'Checking…' : 'Check now',
                        variant: KButtonVariant.secondary,
                        size: KButtonSize.sm,
                        onTap: checking ? null : () async {
                          final result = await context.app.updates.checkAll();
                          if (result.newChapters > 0) {
                            KToastHost.show(context, '${result.newChapters} new chapters');
                          } else {
                            KToastHost.show(context, 'Everything is up to date');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _body(theme, c, updates)),
            ],
          );
        },
      ),
    );
  }

  String _statsLine(List<MangaUpdate> u) {
    final total = u.fold<int>(0, (a, b) => a + b.unreadCount);
    return total == 0 ? 'No unread updates' : '$total unread across ${u.length} series';
  }

  Widget _body(KTheme theme, PaletteColors c, List<MangaUpdate> updates) {
    if (updates.isEmpty) {
      return KEmpty(
        icon: Icon(Icons.new_releases_outlined, size: 34, color: c.accent),
        title: 'No new chapters',
        message: 'Comicko checks your library on a schedule. Check now to refresh.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.s, KSpacing.l, 90),
      itemCount: updates.length,
      itemBuilder: (context, i) {
        final u = updates[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: KSpacing.m),
          child: KListTile(
            leading: SizedBox(
              width: 46,
              height: 66,
              child: KCover(url: u.manga.coverUrl, title: u.manga.title, width: 46, height: 66, borderRadius: 8, revealIndex: i),
            ),
            title: u.manga.title,
            subtitle: '${u.newestChapter.name} · ${u.unreadCount} unread',
            trailing: KButton(
              label: 'Read',
              size: KButtonSize.sm,
              onTap: () => KRoute.push(context, MangaDetailScreen(mangaKey: u.manga.key)),
            ),
            onTap: () => KRoute.push(context, MangaDetailScreen(mangaKey: u.manga.key)),
          ),
        );
      },
    );
  }
}

// icons
