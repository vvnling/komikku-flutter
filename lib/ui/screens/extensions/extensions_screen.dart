import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';
import '../../../data/sources/source.dart';

import '../../../ui/widgets/widgets.dart';
class ExtensionsScreen extends StatefulWidget {
  const ExtensionsScreen({super.key});

  @override
  State<ExtensionsScreen> createState() => _ExtensionsScreenState();
}

class _ExtensionsScreenState extends State<ExtensionsScreen> {
  String _query = '';
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final settings = context.app.settings;
    final sources = context.app.sources.all;

    final filtered = sources.where((s) => s.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return KPage(
      child: Column(
        children: [
          KAppBar(title: 'Sources & extensions', onBack: () => KRoute.pop(context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: KSpacing.l),
            child: KSearchField(controller: _search, hint: 'Search sources…', onChanged: (v) => setState(() => _query = v)),
          ),
          const SizedBox(height: KSpacing.m),
          Text('${filtered.length} sources', style: theme.text(KTypeStyle.caption, color: c.inkMuted, size: 12)),
          const SizedBox(height: 4),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(KSpacing.l, 0, KSpacing.l, 60),
              children: [
                for (final source in filtered)
                  Padding(
                    padding: const EdgeInsets.only(bottom: KSpacing.m),
                    child: KCard(
                      corner: PanelCorner.none,
                      child: Row(
                        children: [
                          _SourceIcon(source),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(source.name, style: theme.text(KTypeStyle.title, size: 14.5, weight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(
                                  '${source.lang.toUpperCase()} · ${source.baseUrl ?? 'offline'}',
                                  style: theme.text(KTypeStyle.caption, size: 11.5, color: c.inkFaint),
                                ),
                              ],
                            ),
                          ),
                          KSwitch(
                            value: settings.isSourceEnabled(source.id),
                            onChanged: (v) {
                              settings.setSourceEnabled(source.id, v);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: KSpacing.l),
                Text('Local library', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                const SizedBox(height: 8),
                KCard(
                  corner: PanelCorner.none,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Read manga from folders on this device (images, CBZ, ZIP).', style: theme.text(KTypeStyle.caption, size: 12.5, color: c.inkMuted)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          KButton(label: 'Scan folder…', variant: KButtonVariant.secondary, onTap: _scanFolder),
                          const SizedBox(width: 8),
                          Text('Folder: $_rootLabel', style: theme.text(KTypeStyle.caption, size: 11.5, color: c.inkFaint)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _rootLabel {
    final path = context.app.settings.localRoot;
    if (path == null) return 'not set';
    final parts = path.split('/');
    return parts.length > 2 ? '…/${parts.sublist(parts.length - 2).join('/')}' : path;
  }

  Future<void> _scanFolder() async {
    final path = await context.app.library.pickLocalRoot();
    if (path == null) return;
    context.app.settings.localRoot = path;
    final found = await context.app.library.scanLocalRoot(path);
    final count = found.length;
    if (!mounted) return;
    setState(() {});
    KToastHost.show(context, 'Found $count manga in folder');
    if (count > 0) {
      await showKSheet<void>(context, child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add from local storage', style: context.kTheme.text(KTypeStyle.h2, size: 17, weight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('$count entries found. Tap to add to library.', style: context.kTheme.text(KTypeStyle.caption, size: 12.5, color: context.kColors.inkMuted)),
          const SizedBox(height: 8),
          for (final sm in found.take(30))
            KListTile(
              leading: SizedBox(width: 40, height: 56, child: KCover(url: sm.coverUrl, title: sm.title, width: 40, height: 56, borderRadius: 6)),
              title: sm.title,
              onTap: () async {
                await context.app.library.addLocalEntry(sm, root: path);
                KToastHost.show(context, 'Added ${sm.title}');
                KRoute.pop(context);
              },
            ),
        ],
      ));
    }
  }
}

class _SourceIcon extends StatelessWidget {
  const _SourceIcon(this.source);
  final Source source;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final color = source.icon.color != null ? Color(source.icon.color!) : c.accent;
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Center(
        child: Text(
          source.name.isEmpty ? '?' : source.name[0].toUpperCase(),
          style: context.kTheme.text(KTypeStyle.label, size: 15, weight: FontWeight.w800, color: color),
        ),
      ),
    );
  }
}

// imports