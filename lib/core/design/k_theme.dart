import 'package:flutter/widgets.dart';
import 'tokens.dart';

/// Resolved theme for one palette × brightness. Access via
/// `context.kTheme` (see [KThemeScope]).
@immutable
class KTheme {
  KTheme({required this.palette, required this.brightness, required this.typeScale, PaletteColors? colors})
      : colors = colors ?? (brightness == Brightness.dark ? palette.dark : palette.light);

  final KPalette palette;
  final Brightness brightness;
  final PaletteColors colors;

  /// [size, weight, height, letterSpacing] per style.
  final List<(double, FontWeight, double, double)> typeScale;

  bool get isDark => brightness == Brightness.dark;

  KTheme copyWith({KPalette? palette, Brightness? brightness, List<(double, FontWeight, double, double)>? typeScale}) {
    return KTheme(
      palette: palette ?? this.palette,
      brightness: brightness ?? this.brightness,
      typeScale: typeScale ?? this.typeScale,
    );
  }

  /// Text style for a semantic slot.
  TextStyle text(KTypeStyle style, {Color? color, FontWeight? weight, double? size, double? height, double? spacing, FontStyle? fontStyle}) {
    final (s, w, h, ls) = typeScale[style.index];
    return TextStyle(
      fontFamily: KType.display,
      fontSize: size ?? s,
      fontWeight: weight ?? w,
      height: height ?? h,
      letterSpacing: spacing ?? ls,
      color: color,
      fontStyle: fontStyle,
    );
  }

  TextStyle get display => text(KTypeStyle.display, color: colors.ink);
  TextStyle get h1 => text(KTypeStyle.h1, color: colors.ink);
  TextStyle get h2 => text(KTypeStyle.h2, color: colors.ink);
  TextStyle get title => text(KTypeStyle.title, color: colors.ink);
  TextStyle get body => text(KTypeStyle.body, color: colors.ink);
  TextStyle get bodyMuted => text(KTypeStyle.bodyMuted, color: colors.inkMuted);
  TextStyle get caption => text(KTypeStyle.caption, color: colors.inkMuted);
  TextStyle get label => text(KTypeStyle.label, color: colors.ink);
  TextStyle get overline => text(KTypeStyle.overline, color: colors.inkMuted);
}

/// Inherited scope providing the active [KTheme].
class KThemeScope extends InheritedWidget {
  const KThemeScope({super.key, required this.theme, required super.child});

  final KTheme theme;

  static KTheme of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<KThemeScope>();
    assert(scope != null, 'KThemeScope missing — is the app root above this context?');
    return scope!.theme;
  }

  @override
  bool updateShouldNotify(KThemeScope oldWidget) => oldWidget.theme != theme;
}

/// Convenience on BuildContext.
extension KThemeX on BuildContext {
  KTheme get kTheme => KThemeScope.of(this);
  PaletteColors get kColors => kTheme.colors;
  bool get kIsDark => kTheme.isDark;
}
