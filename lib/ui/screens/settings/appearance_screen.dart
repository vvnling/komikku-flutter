import 'package:flutter/widgets.dart';
import '../../../core/app_scope.dart';
import '../../../core/design/k_theme.dart';
import '../../../core/design/tokens.dart';

import '../../../ui/widgets/widgets.dart';
class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final settings = context.app.settings;

    return KPage(
      child: Column(
        children: [
          KAppBar(title: 'Appearance', onBack: () => KRoute.pop(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(KSpacing.l),
              children: [
                Text('Theme mode', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                const SizedBox(height: 8),
                KSegmented<String>(
                  options: const [('system', 'System'), ('light', 'Light'), ('dark', 'Dark')],
                  value: settings.themeMode,
                  onChanged: (v) {
                    context.app.theme.setMode(v);
                    setState(() {});
                  },
                ),
                const SizedBox(height: KSpacing.xl),

                Text('Color palette', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                const SizedBox(height: 4),
                Text('Every palette re-tints the whole app — surfaces, ink, accents, aurora.', style: theme.text(KTypeStyle.caption, size: 12, color: c.inkFaint)),
                const SizedBox(height: KSpacing.m),
                Wrap(
                  spacing: KSpacing.m,
                  runSpacing: KSpacing.m,
                  children: [
                    for (final palette in kPalettes)
                      _PaletteSwatch(
                        palette: palette,
                        selected: palette.id == settings.paletteId,
                        onTap: () {
                          context.app.theme.setPalette(palette.id);
                          setState(() {});
                        },
                      ),
                  ],
                ),
                const SizedBox(height: KSpacing.xl),

                Text('Finishing', style: theme.text(KTypeStyle.label, size: 12, color: c.inkMuted)),
                const SizedBox(height: 8),
                KCard(
                  corner: PanelCorner.none,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      KListTile(
                        title: 'Auto tint from cover',
                        subtitle: 'Detail screens and reader take their accent from the cover art',
                        trailing: KSwitch(value: settings.autoTint, onChanged: (v) {
                          settings.autoTint = v;
                          setState(() {});
                        }),
                      ),
                      KListTile(
                        title: 'Film grain',
                        subtitle: 'A subtle animated grain over the whole app',
                        trailing: KSlider(
                          value: settings.grain,
                          min: 0,
                          max: 1,
                          divisions: 10,
                          onChanged: (v) {
                            settings.grain = v;
                            setState(() {});
                          },
                          valueLabel: (v) => '${(v * 100).round()}%',
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

class _PaletteSwatch extends StatelessWidget {
  const _PaletteSwatch({required this.palette, required this.selected, required this.onTap});

  final KPalette palette;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.kTheme;
    final c = theme.colors;
    final dark = theme.isDark;
    final colors = dark ? palette.dark : palette.light;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 96,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(KRadius.m),
          border: Border.all(color: selected ? colors.accent : c.lineStrong, width: selected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (final col in [colors.accent, colors.accentAlt, colors.ink])
                  Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(color: col, shape: BoxShape.circle),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(palette.name, style: theme.text(KTypeStyle.label, size: 11.5, color: colors.ink, weight: FontWeight.w700)),
            const SizedBox(height: 3),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: colors.bg,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: colors.lineStrong),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// imports
