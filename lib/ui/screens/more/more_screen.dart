import 'package:flutter/widgets.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';
import '../backup/backup_screen.dart';
import '../extensions/extensions_screen.dart';
import '../migration/migration_screen.dart';
import '../settings/appearance_screen.dart';
import '../settings/downloads_screen.dart';
import '../settings/reader_settings_screen.dart';
import '../trackers/trackers_screen.dart';

/// More tab — settings hub, extensions, backup, trackers, about.
import 'package:flutter/material.dart' show Icons;
import '../../../ui/widgets/widgets.dart';
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(KSpacing.l, KSpacing.l, KSpacing.l, 90),
        children: [
          Text('More', style: theme.text(KTypeStyle.h1, size: 26, weight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Settings, sources, backups and more', style: theme.text(KTypeStyle.caption, color: c.inkMuted)),
          const SizedBox(height: KSpacing.l),

          // appearance hero card
          KCard(
            accent: c.accent,
            corner: PanelCorner.topLeft,
            onTap: () => KRoute.push(context, const AppearanceScreen()),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [c.accent, c.accentAlt]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.palette_outlined, color: c.accentInk, size: 21),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Appearance', style: theme.text(KTypeStyle.title, size: 15.5, weight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('Palettes, dark mode, grain, cover tint', style: theme.text(KTypeStyle.caption, color: c.inkMuted)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 18, color: c.inkFaint),
              ],
            ),
          ),
          const SizedBox(height: KSpacing.m),

          _section(context, theme, c, 'Reading', [
            _Item(Icons.tune, 'Reader settings', 'Viewer, transitions, zoom, autoscroll', () => KRoute.push(context, const ReaderSettingsScreen())),
            _Item(Icons.download_outlined, 'Downloads', 'Queue, storage, network rules', () => KRoute.push(context, const DownloadsScreen())),
          ]),

          _section(context, theme, c, 'Library', [
            _Item(Icons.sync_alt, 'Update scheduler', 'Interval, last run', () => KRoute.push(context, const DownloadsScreen())),
            _Item(Icons.swap_horiz, 'Migration', 'Move entries between sources', () => KRoute.push(context, const MigrationScreen())),
          ]),

          _section(context, theme, c, 'Sources', [
            _Item(Icons.extension_outlined, 'Extensions & sources', 'Enable, disable, repos', () => KRoute.push(context, const ExtensionsScreen())),
            _Item(Icons.track_changes, 'Trackers', 'AniList and local tracking', () => KRoute.push(context, const TrackersScreen())),
          ]),

          _section(context, theme, c, 'Data', [
            _Item(Icons.backup_outlined, 'Backup & restore', 'JSON export/import', () => KRoute.push(context, const BackupScreen())),
            _Item(Icons.save_outlined, 'Local storage', 'Scan device folders', () => KRoute.push(context, const DownloadsScreen())),
          ]),

          const SizedBox(height: KSpacing.xl),
          _about(theme, c),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, KTheme theme, PaletteColors c, String title, List<_Item> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(title.toUpperCase(), style: theme.text(KTypeStyle.overline, size: 10.5, color: c.inkFaint)),
        ),
        const SizedBox(height: 4),
        KCard(
          corner: PanelCorner.none,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) Container(height: 1, color: c.line),
                items[i].build(context),
              ],
            ],
          ),
        ),
        const SizedBox(height: KSpacing.l),
      ],
    );
  }

  Widget _about(KTheme theme, PaletteColors c) {
    return Column(
      children: [
        CustomPaint(
          size: const Size(56, 56),
          painter: KLogoPainter(ink: c.ink, accent: c.accent, detail: 0.8),
        ),
        const SizedBox(height: 10),
        Text('Comicko', style: theme.text(KTypeStyle.h2, size: 19, weight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text('Komikku, rewritten in Flutter — v0.1.0', style: theme.text(KTypeStyle.caption, color: c.inkMuted)),
        const SizedBox(height: 2),
        Text('Apache-2.0 · craft & motion by design', style: theme.text(KTypeStyle.overline, size: 9.5, color: c.inkFaint)),
      ],
    );
  }
}

class _Item {
  const _Item(this.icon, this.title, this.subtitle, this.onTap);
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    return KListTile(
      leading: Icon(icon, size: 20, color: c.inkMuted),
      title: title,
      subtitle: subtitle,
      trailing: Icon(Icons.chevron_right, size: 17, color: c.inkFaint),
      onTap: onTap,
    );
  }
}

// imports
