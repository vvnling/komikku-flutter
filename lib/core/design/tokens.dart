import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show BoxShadow;

/// COMICKO DESIGN LANGUAGE — tokens.
///
/// Everything visual derives from these. Never hardcode a color, radius or
/// spacing in a widget; pull from [KTheme] via `context.kTheme`.
///
/// The language is "Paper & Ink, Living Color": manga-inspired ink strokes,
/// paper grain and speed lines, rendered with liquid aurora fields and
/// iridescent sheen. See README-DESIGN.md for the full rationale.

// ────────────────────────────────────────────────────────────────────────────
// Geometry
// ────────────────────────────────────────────────────────────────────────────

class KSpacing {
  const KSpacing._();
  static const double xxs = 2;
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double huge = 64;
}

class KRadius {
  const KRadius._();
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 36;
  static const double pill = 999;
}

class KBreakpoints {
  const KBreakpoints._();
  static const double phone = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Panel-border motif: manga panels get a double-stroke frame with corner
/// accents. Used by [KCard] and section frames.
class KPanelStroke {
  const KPanelStroke._();
  static const double hair = 0.75;
  static const double thin = 1.25;
  static const double bold = 2.5;
}

// ────────────────────────────────────────────────────────────────────────────
// Color palettes (Komikku feature: app themes with color palettes)
// ────────────────────────────────────────────────────────────────────────────

@immutable
class PaletteColors {
  const PaletteColors({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.ink,
    required this.inkMuted,
    required this.inkFaint,
    required this.accent,
    required this.accentAlt,
    required this.accentSoft,
    required this.accentInk,
    required this.line,
    required this.lineStrong,
    required this.scrim,
  });

  final Color bg; // app background (aurora sits behind this, translucent)
  final Color surface; // cards, sheets
  final Color surfaceAlt; // raised surfaces, wells
  final Color ink; // primary text
  final Color inkMuted; // secondary text
  final Color inkFaint; // tertiary / placeholders
  final Color accent; // primary action / focus
  final Color accentAlt; // secondary accent (gradient partner)
  final Color accentSoft; // translucent accent fill for chips/glows
  final Color accentInk; // text/icon on accent
  final Color line; // hairline borders
  final Color lineStrong; // panel strokes
  final Color scrim; // overlay scrim

  PaletteColors lerp(PaletteColors other, double t) => PaletteColors(
        bg: Color.lerp(bg, other.bg, t)!,
        surface: Color.lerp(surface, other.surface, t)!,
        surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
        ink: Color.lerp(ink, other.ink, t)!,
        inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
        inkFaint: Color.lerp(inkFaint, other.inkFaint, t)!,
        accent: Color.lerp(accent, other.accent, t)!,
        accentAlt: Color.lerp(accentAlt, other.accentAlt, t)!,
        accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
        accentInk: Color.lerp(accentInk, other.accentInk, t)!,
        line: Color.lerp(line, other.line, t)!,
        lineStrong: Color.lerp(lineStrong, other.lineStrong, t)!,
        scrim: Color.lerp(scrim, other.scrim, t)!,
      );
}

@immutable
class KPalette {
  const KPalette({required this.id, required this.name, required this.light, required this.dark});

  final String id;
  final String name;
  final PaletteColors light;
  final PaletteColors dark;
}

const _auroraAccent = Color(0xFF8B5CF6);
const _auroraAlt = Color(0xFFEC4899);

/// The shipped palettes. "Aurora" is the default; "Komikku" echoes the
/// original app's brand pink/violet.
const List<KPalette> kPalettes = [
  KPalette(
    id: 'aurora',
    name: 'Aurora',
    light: PaletteColors(
      bg: Color(0xFFF6F4FB),
      surface: Color(0xFFFDFCFF),
      surfaceAlt: Color(0xFFEFECF7),
      ink: Color(0xFF1B1830),
      inkMuted: Color(0xFF57526E),
      inkFaint: Color(0xFF8E88A6),
      accent: _auroraAccent,
      accentAlt: _auroraAlt,
      accentSoft: Color(0x248B5CF6),
      accentInk: Color(0xFFFDFCFF),
      line: Color(0x14000000),
      lineStrong: Color(0x26000000),
      scrim: Color(0x8A1B1830),
    ),
    dark: PaletteColors(
      bg: Color(0xFF0E0B1E),
      surface: Color(0xFF171330),
      surfaceAlt: Color(0xFF1F1A3E),
      ink: Color(0xFFEFEDFB),
      inkMuted: Color(0xFFB4AECF),
      inkFaint: Color(0xFF7C76A0),
      accent: Color(0xFFA78BFA),
      accentAlt: Color(0xFFF472B6),
      accentSoft: Color(0x33A78BFA),
      accentInk: Color(0xFF171330),
      line: Color(0x1AFFFFFF),
      lineStrong: Color(0x2EFFFFFF),
      scrim: Color(0xB30A0814),
    ),
  ),
  KPalette(
    id: 'komikku',
    name: 'Komikku',
    light: PaletteColors(
      bg: Color(0xFFFBF3F8),
      surface: Color(0xFFFEFAFD),
      surfaceAlt: Color(0xFFF3E4EF),
      ink: Color(0xFF2A1424),
      inkMuted: Color(0xFF6E4A63),
      inkFaint: Color(0xFF9C7C93),
      accent: Color(0xFFEA4AAA),
      accentAlt: Color(0xFF8B5CF6),
      accentSoft: Color(0x26EA4AAA),
      accentInk: Color(0xFFFFFFFF),
      line: Color(0x14000000),
      lineStrong: Color(0x26000000),
      scrim: Color(0x8A2A1424),
    ),
    dark: PaletteColors(
      bg: Color(0xFF160B12),
      surface: Color(0xFF221321),
      surfaceAlt: Color(0xFF2E1A2C),
      ink: Color(0xFFFBEDF6),
      inkMuted: Color(0xFFC49BB8),
      inkFaint: Color(0xFF8E6A84),
      accent: Color(0xFFF06BB9),
      accentAlt: Color(0xFFA78BFA),
      accentSoft: Color(0x33F06BB9),
      accentInk: Color(0xFF160B12),
      line: Color(0x1AFFFFFF),
      lineStrong: Color(0x2EFFFFFF),
      scrim: Color(0xB3100810),
    ),
  ),
  KPalette(
    id: 'midnight',
    name: 'Midnight',
    light: PaletteColors(
      bg: Color(0xFFF2F6FA),
      surface: Color(0xFFFBFDFF),
      surfaceAlt: Color(0xFFE8EFF6),
      ink: Color(0xFF10233C),
      inkMuted: Color(0xFF4B6179),
      inkFaint: Color(0xFF8395A8),
      accent: Color(0xFF1E5EFF),
      accentAlt: Color(0xFF00C2FF),
      accentSoft: Color(0x221E5EFF),
      accentInk: Color(0xFFFFFFFF),
      line: Color(0x14000000),
      lineStrong: Color(0x26000000),
      scrim: Color(0x8A10233C),
    ),
    dark: PaletteColors(
      bg: Color(0xFF070D18),
      surface: Color(0xFF0F1B2D),
      surfaceAlt: Color(0xFF16263D),
      ink: Color(0xFFE8F1FB),
      inkMuted: Color(0xFF9FB4CC),
      inkFaint: Color(0xFF64788F),
      accent: Color(0xFF4D8DFF),
      accentAlt: Color(0xFF00D0FF),
      accentSoft: Color(0x334D8DFF),
      accentInk: Color(0xFF070D18),
      line: Color(0x1AFFFFFF),
      lineStrong: Color(0x2EFFFFFF),
      scrim: Color(0xB3050A12),
    ),
  ),
  KPalette(
    id: 'sakura',
    name: 'Sakura',
    light: PaletteColors(
      bg: Color(0xFFFBF5F1),
      surface: Color(0xFFFFFBF7),
      surfaceAlt: Color(0xFFF3E8E0),
      ink: Color(0xFF33221A),
      inkMuted: Color(0xFF7A5F52),
      inkFaint: Color(0xFFA88F82),
      accent: Color(0xFFE2556E),
      accentAlt: Color(0xFFF7A072),
      accentSoft: Color(0x22E2556E),
      accentInk: Color(0xFFFFFFFF),
      line: Color(0x14000000),
      lineStrong: Color(0x26000000),
      scrim: Color(0x8A33221A),
    ),
    dark: PaletteColors(
      bg: Color(0xFF1C1210),
      surface: Color(0xFF2A1B17),
      surfaceAlt: Color(0xFF36241E),
      ink: Color(0xFFFBE9E1),
      inkMuted: Color(0xFFC4A294),
      inkFaint: Color(0xFF8F7265),
      accent: Color(0xFFFF7A93),
      accentAlt: Color(0xFFFFB085),
      accentSoft: Color(0x33FF7A93),
      accentInk: Color(0xFF1C1210),
      line: Color(0x1AFFFFFF),
      lineStrong: Color(0x2EFFFFFF),
      scrim: Color(0xB3140C0A),
    ),
  ),
  KPalette(
    id: 'mint',
    name: 'Mint',
    light: PaletteColors(
      bg: Color(0xFFF1F8F6),
      surface: Color(0xFFFAFEFD),
      surfaceAlt: Color(0xFFE4F1EE),
      ink: Color(0xFF12302A),
      inkMuted: Color(0xFF4E6F68),
      inkFaint: Color(0xFF829C96),
      accent: Color(0xFF0FA98C),
      accentAlt: Color(0xFF34D399),
      accentSoft: Color(0x220FA98C),
      accentInk: Color(0xFFFFFFFF),
      line: Color(0x14000000),
      lineStrong: Color(0x26000000),
      scrim: Color(0x8A12302A),
    ),
    dark: PaletteColors(
      bg: Color(0xFF081512),
      surface: Color(0xFF0F221E),
      surfaceAlt: Color(0xFF16302A),
      ink: Color(0xFFE2F5F0),
      inkMuted: Color(0xFF9CC4BB),
      inkFaint: Color(0xFF639089),
      accent: Color(0xFF2DD4A7),
      accentAlt: Color(0xFF6EE7B7),
      accentSoft: Color(0x332DD4A7),
      accentInk: Color(0xFF081512),
      line: Color(0x1AFFFFFF),
      lineStrong: Color(0x2EFFFFFF),
      scrim: Color(0xB305100D),
    ),
  ),
  KPalette(
    id: 'sunset',
    name: 'Sunset',
    light: PaletteColors(
      bg: Color(0xFFFBF3EF),
      surface: Color(0xFFFFF9F5),
      surfaceAlt: Color(0xFFF5E7DF),
      ink: Color(0xFF341F14),
      inkMuted: Color(0xFF7D5D4A),
      inkFaint: Color(0xFFAA8B79),
      accent: Color(0xFFF97316),
      accentAlt: Color(0xFFD946EF),
      accentSoft: Color(0x24F97316),
      accentInk: Color(0xFFFFFFFF),
      line: Color(0x14000000),
      lineStrong: Color(0x26000000),
      scrim: Color(0x8A341F14),
    ),
    dark: PaletteColors(
      bg: Color(0xFF1D1009),
      surface: Color(0xFF2B1A10),
      surfaceAlt: Color(0xFF382316),
      ink: Color(0xFFFBEAE0),
      inkMuted: Color(0xFFC9A58D),
      inkFaint: Color(0xFF967662),
      accent: Color(0xFFFB923C),
      accentAlt: Color(0xFFE879F9),
      accentSoft: Color(0x33FB923C),
      accentInk: Color(0xFF1D1009),
      line: Color(0x1AFFFFFF),
      lineStrong: Color(0x2EFFFFFF),
      scrim: Color(0xB3140A05),
    ),
  ),
  KPalette(
    id: 'mono',
    name: 'Ink',
    light: PaletteColors(
      bg: Color(0xFFF7F7F5),
      surface: Color(0xFFFDFDFC),
      surfaceAlt: Color(0xFFEDEDEA),
      ink: Color(0xFF1C1C1A),
      inkMuted: Color(0xFF5C5C57),
      inkFaint: Color(0xFF94948E),
      accent: Color(0xFF26262A),
      accentAlt: Color(0xFF6E6E78),
      accentSoft: Color(0x1F26262A),
      accentInk: Color(0xFFFDFDFC),
      line: Color(0x14000000),
      lineStrong: Color(0x2B000000),
      scrim: Color(0x8A1C1C1A),
    ),
    dark: PaletteColors(
      bg: Color(0xFF101010),
      surface: Color(0xFF1A1A1A),
      surfaceAlt: Color(0xFF232323),
      ink: Color(0xFFF2F2EE),
      inkMuted: Color(0xFFB0B0A8),
      inkFaint: Color(0xFF787872),
      accent: Color(0xFFE8E8E2),
      accentAlt: Color(0xFF9A9A92),
      accentSoft: Color(0x2EE8E8E2),
      accentInk: Color(0xFF101010),
      line: Color(0x1AFFFFFF),
      lineStrong: Color(0x30FFFFFF),
      scrim: Color(0xB30C0C0C),
    ),
  ),
  KPalette(
    id: 'forest',
    name: 'Forest',
    light: PaletteColors(
      bg: Color(0xFFF2F7F0),
      surface: Color(0xFFFAFDF8),
      surfaceAlt: Color(0xFFE6F0E2),
      ink: Color(0xFF18301A),
      inkMuted: Color(0xFF4F6E50),
      inkFaint: Color(0xFF82997F),
      accent: Color(0xFF3E9E3A),
      accentAlt: Color(0xFFF5B93E),
      accentSoft: Color(0x223E9E3A),
      accentInk: Color(0xFFFFFFFF),
      line: Color(0x14000000),
      lineStrong: Color(0x26000000),
      scrim: Color(0x8A18301A),
    ),
    dark: PaletteColors(
      bg: Color(0xFF0B150C),
      surface: Color(0xFF122215),
      surfaceAlt: Color(0xFF19301D),
      ink: Color(0xFFE9F5E6),
      inkMuted: Color(0xFFA3C49D),
      inkFaint: Color(0xFF6E9469),
      accent: Color(0xFF4CC94A),
      accentAlt: Color(0xFFF2C14E),
      accentSoft: Color(0x334CC94A),
      accentInk: Color(0xFF0B150C),
      line: Color(0x1AFFFFFF),
      lineStrong: Color(0x2EFFFFFF),
      scrim: Color(0xB3071008),
    ),
  ),
];

// ────────────────────────────────────────────────────────────────────────────
// Typography
// ────────────────────────────────────────────────────────────────────────────

class KType {
  const KType._();

  static const String display = 'SpaceGrotesk';

}

enum KTypeStyle { display, h1, h2, title, body, bodyMuted, caption, label, overline }

// ────────────────────────────────────────────────────────────────────────────
// Shadows
// ────────────────────────────────────────────────────────────────────────────

class KShadow {
  const KShadow._();
  static List<BoxShadow> soft(Color color) => [
        BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 8, offset: const Offset(0, 2)),
      ];
  static List<BoxShadow> float(Color color) => [
        BoxShadow(color: color.withValues(alpha: 0.14), blurRadius: 18, offset: const Offset(0, 6)),
        BoxShadow(color: color.withValues(alpha: 0.07), blurRadius: 6, offset: const Offset(0, 2)),
      ];
  static List<BoxShadow> deep(Color color) => [
        BoxShadow(color: color.withValues(alpha: 0.22), blurRadius: 36, offset: const Offset(0, 14)),
        BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 10, offset: const Offset(0, 4)),
      ];
  static List<BoxShadow> glow(Color color, {double strength = 0.35}) => [
        BoxShadow(color: color.withValues(alpha: strength), blurRadius: 24, spreadRadius: -4),
      ];
}
