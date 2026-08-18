import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';

/// Backup & restore — JSON export/import via system file dialogs.
import 'package:flutter/material.dart' show Icons;
import '../../../ui/widgets/widgets.dart';
class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final backups = context.app.backups;

    return KPage(
      child: Column(
        children: [
          KAppBar(title: 'Backup & restore', onBack: () => KRoute.pop(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(KSpacing.l),
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: backups.busy,
                  builder: (context, busy, _) => KCard(
                    corner: PanelCorner.none,
                    child: busy
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: KProgressRing(indeterminate: true, size: 24)),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Library, categories, history, tracks and settings — one JSON file.', style: theme.text(KTypeStyle.bodyMuted, size: 13.5)),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: KButton(label: 'Export backup', icon: const Icon(Icons.upload_file, size: 17), onTap: () async {
                                      await backups.exportToFile();
                                    }),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: KButton(label: 'Restore', variant: KButtonVariant.secondary, icon: const Icon(Icons.download, size: 17), onTap: () async {
                                      final result = await backups.importFromFile();
                                      KToastHost.show(context, 'Restored ${result.imported} entries${result.skipped > 0 ? ', ${result.skipped} skipped' : ''}');
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: KSpacing.l),
                ValueListenableBuilder<String?>(
                  valueListenable: backups.message,
                  builder: (context, msg, _) => msg == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(msg, style: theme.text(KTypeStyle.caption, color: c.accent)),
                        ),
                ),
                Text('Backup contents', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                const SizedBox(height: 8),
                Text('• Manga entries with metadata and chapters\n• Category assignments (incl. hidden)\n• Read history and per-chapter progress\n• Tracker links and scores\n• Reader and appearance settings', style: theme.text(KTypeStyle.caption, size: 12.5, color: c.inkMuted, height: 1.7)),
                const SizedBox(height: KSpacing.xl),
                Text('Notes', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                const SizedBox(height: 8),
                Text('Downloaded pages are not embedded in the backup. Restoring merges entries — existing, initialized manga are left untouched.', style: theme.text(KTypeStyle.caption, size: 12.5, color: c.inkFaint, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// icons