import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Colors;
import '../core/data/settings_service.dart';
import '../core/design/k_theme.dart';
import '../core/design/tokens.dart';

/// Holds the active [KTheme] and reacts to settings changes
/// (palette, brightness, cover auto-tint).
class ThemeController extends ValueNotifier<KTheme> {
  ThemeController(this.settings) : super(_initial(settings));

  final SettingsService settings;
  static const _defaultTypeScale = [
    (40.0, FontWeight.w700, 1.05, -1.0),
    (28.0, FontWeight.w700, 1.12, -0.5),
    (22.0, FontWeight.w700, 1.2, -0.2),
    (17.0, FontWeight.w600, 1.3, 0.0),
    (15.0, FontWeight.w400, 1.45, 0.0),
    (14.0, FontWeight.w400, 1.4, 0.0),
    (12.0, FontWeight.w400, 1.35, 0.1),
    (13.0, FontWeight.w600, 1.2, 0.6),
    (11.0, FontWeight.w600, 1.2, 1.2),
  ];

  static KTheme _initial(SettingsService settings) {
    final palette = kPalettes.firstWhere((p) => p.id == settings.paletteId, orElse: () => kPalettes.first);
    return KTheme(palette: palette, brightness: _resolveBrightness(settings), typeScale: _defaultTypeScale);
  }

  static Brightness _resolveBrightness(SettingsService settings) {
    switch (settings.themeMode) {
      case 'light':
        return Brightness.light;
      case 'dark':
        return Brightness.dark;
      default:
        final platform = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return platform;
    }
  }

  void setPalette(String id) {
    settings.paletteId = id;
    value = value.copyWith(palette: kPalettes.firstWhere((p) => p.id == id, orElse: () => kPalettes.first));
  }

  void setMode(String mode) {
    settings.themeMode = mode;
    value = value.copyWith(brightness: _resolveBrightness(settings));
  }

  void refreshBrightness() => value = value.copyWith(brightness: _resolveBrightness(settings));

  /// Apply an accent override from a cover color (auto theme tint).
  void applyCoverTint(Color c, {required String mangaKey}) {
    if (!settings.autoTint) return;
    settings.setCoverTint(mangaKey, c.toARGB32());
    // per-screen tint is resolved in UI via settings.coverTint(key);
  }

  /// Theme with a cover-derived accent blended in (for one screen).
  KTheme tintedFor(String? mangaKey) {
    if (mangaKey == null || !settings.autoTint) return value;
    final tint = settings.coverTint(mangaKey);
    if (tint == null) return value;
    final accent = Color(tint);
    final colors = value.colors;
    final blended = PaletteColors(
      bg: colors.bg,
      surface: colors.surface,
      surfaceAlt: colors.surfaceAlt,
      ink: colors.ink,
      inkMuted: colors.inkMuted,
      inkFaint: colors.inkFaint,
      accent: accent,
      accentAlt: Color.lerp(accent, colors.accentAlt, 0.45)!,
      accentSoft: accent.withValues(alpha: value.isDark ? 0.20 : 0.14),
      accentInk: Color.lerp(accent, Colors.white, 0.85)!,
      line: colors.line,
      lineStrong: colors.lineStrong,
      scrim: colors.scrim,
    );
    return KTheme(palette: value.palette, brightness: value.brightness, typeScale: value.typeScale, colors: blended);
  }
}
