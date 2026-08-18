import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';

/// Downloads — queue monitor, network rules, clear storage.
import 'package:flutter/material.dart' show Icons;
import '../../../data/services/download_service.dart' show DownloadJob, DownloadStatus;
import '../../../ui/widgets/widgets.dart';
class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final s = context.app.settings;

    return KPage(
      child: Column(
        children: [
          KAppBar(
            title: 'Downloads',
            onBack: () => KRoute.pop(context),
            trailing: [
              KButton(label: 'Clear finished', variant: KButtonVariant.ghost, size: KButtonSize.sm, onTap: () {
                context.app.downloads.clearFinished();
                setState(() {});
              }),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(KSpacing.l),
              children: [
                ValueListenableBuilder<List<DownloadJob>>(
                  valueListenable: context.app.downloads.jobs,
                  builder: (context, jobs, _) {
                    final active = jobs.where((j) => j.isActive).toList();
                    final done = jobs.where((j) => j.status == DownloadStatus.done).length;
                    final failed = jobs.where((j) => j.status == DownloadStatus.failed).length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Queue', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                        const SizedBox(height: 8),
                        if (active.isEmpty)
                          Text('$done completed · $failed failed${jobs.isEmpty ? ' · queue is empty' : ''}', style: theme.text(KTypeStyle.caption, color: c.inkFaint))
                        else
                          for (final job in active) _JobTile(job: job),
                      ],
                    );
                  },
                ),
                const SizedBox(height: KSpacing.xl),
                Text('Network', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                const SizedBox(height: 8),
                KCard(
                  corner: PanelCorner.none,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      KListTile(
                        title: 'Only on Wi-Fi',
                        trailing: KSwitch(value: s.onlyOverWifi, onChanged: (v) => s.onlyOverWifi = v),
                      ),
                      KListTile(
                        title: 'Parallel downloads',
                        trailing: KSlider(
                          value: s.downloadThreads.toDouble(),
                          min: 1,
                          max: 4,
                          divisions: 3,
                          onChanged: (v) => s.downloadThreads = v.round(),
                          valueLabel: (v) => '${v.round()}',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: KSpacing.xl),
                Text('Library update schedule', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                const SizedBox(height: 8),
                KCard(
                  corner: PanelCorner.none,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      KListTile(
                        title: 'Check every',
                        trailing: KSlider(
                          value: s.updateIntervalHours.toDouble(),
                          min: 0,
                          max: 48,
                          divisions: 16,
                          onChanged: (v) => s.updateIntervalHours = v.round(),
                          valueLabel: (v) => v == 0 ? 'off' : '${v.round()}h',
                        ),
                      ),
                      KListTile(
                        title: 'Last run',
                        subtitle: s.lastUpdateRun?.toLocal().toString() ?? 'never',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: KSpacing.xl),
                KButton(
                  label: 'Clear all downloads',
                  variant: KButtonVariant.danger,
                  onTap: () async {
                    await context.app.downloads.clearAllDownloads();
                    KToastHost.show(context, 'All downloads cleared');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JobTile extends StatelessWidget {
  const _JobTile({required this.job});
  final DownloadJob job;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final failed = job.status == DownloadStatus.failed;
    return Padding(
      padding: const EdgeInsets.only(bottom: KSpacing.s),
      child: KCard(
        corner: PanelCorner.none,
        child: Row(
          children: [
            SizedBox(width: 26, height: 26, child: failed ? Icon(Icons.error_outline, size: 20, color: c.inkFaint) : KProgressRing(value: job.fraction, size: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.chapter.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.text(KTypeStyle.bodyMuted, size: 13.5, weight: FontWeight.w600)),
                  Text(job.manga.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.text(KTypeStyle.caption, size: 11.5, color: c.inkFaint)),
                ],
              ),
            ),
            if (job.status == DownloadStatus.done)
              Icon(Icons.check_circle, size: 20, color: c.accent)
            else
              KPressable(
                onTap: () => context.app.downloads.cancel(job.chapter),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 18, color: c.inkFaint),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// imports