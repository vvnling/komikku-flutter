import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';
import '../../../ui/widgets/widgets.dart';

/// Reader defaults — global settings the reader starts from.
class ReaderSettingsScreen extends StatefulWidget {
  const ReaderSettingsScreen({super.key});

  @override
  State<ReaderSettingsScreen> createState() => _ReaderSettingsScreenState();
}

class _ReaderSettingsScreenState extends State<ReaderSettingsScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final s = context.app.settings;

    return KPage(
      child: Column(
        children: [
          KAppBar(title: 'Reader settings', onBack: () => KRoute.pop(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(KSpacing.l),
              children: [
                Text('Default viewer', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                const SizedBox(height: 8),
                KSegmented<int>(
                  options: const [(0, 'LTR'), (1, 'RTL'), (2, 'Vertical'), (3, 'Continuous')],
                  value: s.readerViewer,
                  onChanged: (v) {
                    s.readerViewer = v;
                    (context as Element).markNeedsBuild();
                  },
                ),
                const SizedBox(height: KSpacing.xl),

                KCard(
                  corner: PanelCorner.none,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      KListTile(
                        title: 'Page transition',
                        trailing: KSegmented<int>(
                          options: const [(0, 'Slide'), (1, 'Cover'), (2, 'Fade'), (3, 'Depth')],
                          value: s.pageTransition,
                          onChanged: (v) => s.pageTransition = v,
                        ),
                      ),
                      KListTile(
                        title: 'Reader background',
                        trailing: KSegmented<int>(
                          options: const [(0, 'Black'), (1, 'Paper'), (2, 'Gray'), (3, 'Auto')],
                          value: s.readerBackground,
                          onChanged: (v) => s.readerBackground = v,
                        ),
                      ),
                      KListTile(
                        title: 'Tap zones',
                        trailing: KSegmented<int>(
                          options: const [(0, 'LR'), (1, 'Anywhere')],
                          value: s.tapZones,
                          onChanged: (v) => s.tapZones = v,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: KSpacing.l),

                KCard(
                  corner: PanelCorner.none,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      KListTile(
                        title: 'Webtoon detection',
                        subtitle: 'Switch to vertical viewer automatically for tall pages',
                        trailing: KSwitch(value: s.webtoonDetection, onChanged: (v) => s.webtoonDetection = v),
                      ),
                      KListTile(
                        title: 'Auto next chapter',
                        trailing: KSwitch(value: s.autoNextChapter, onChanged: (v) => s.autoNextChapter = v),
                      ),
                      KListTile(
                        title: 'Keep screen on',
                        trailing: KSwitch(value: s.keepScreenOn, onChanged: (v) => s.keepScreenOn = v),
                      ),
                      KListTile(
                        title: 'Autoscroll speed',
                        trailing: SizedBox(
                          width: 160,
                          child: KSlider(
                            value: s.autoscrollSpeed,
                            min: 0.2,
                            max: 3,
                            divisions: 28,
                            onChanged: (v) => s.autoscrollSpeed = v,
                          ),
                        ),
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
}
