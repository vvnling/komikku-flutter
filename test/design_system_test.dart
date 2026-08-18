import 'package:flutter/material.dart' show Brightness, FontWeight;
import 'package:flutter_test/flutter_test.dart';
import 'package:comicko/core/design/k_theme.dart';
import 'package:comicko/core/design/motion.dart';
import 'package:comicko/core/design/tokens.dart';

void main() {
  group('Design tokens', () {
    test('palettes have both brightnesses with distinct surfaces', () {
      expect(kPalettes.length, greaterThanOrEqualTo(6));
      for (final p in kPalettes) {
        expect(p.light.bg, isNot(equals(p.dark.bg)));
        expect(p.light.ink, isNot(equals(p.dark.ink)));
        expect(p.light.accent, isNotNull);
        expect(p.dark.accent, isNotNull);
      }
    });

    test('unique palette ids', () {
      final ids = kPalettes.map((p) => p.id).toSet();
      expect(ids.length, kPalettes.length);
    });

    test('KTheme resolves light/dark colors by brightness', () {
      final aurora = kPalettes.first;
      const scale = [
        (40.0, FontWeight.w700, 1.05, -1.0),
        (17.0, FontWeight.w600, 1.3, 0.0),
      ];
      final light = KTheme(palette: aurora, brightness: Brightness.light, typeScale: scale);
      final dark = KTheme(palette: aurora, brightness: Brightness.dark, typeScale: scale);
      expect(light.colors.bg, equals(aurora.light.bg));
      expect(dark.colors.bg, equals(aurora.dark.bg));
      expect(dark.isDark, isTrue);
    });

    test('KTheme text styles map to the type scale', () {
      final t = KTheme(palette: kPalettes.first, brightness: Brightness.dark, typeScale: const [
        (40.0, FontWeight.w700, 1.05, -1.0),
        (28.0, FontWeight.w700, 1.12, -0.5),
        (22.0, FontWeight.w700, 1.2, -0.2),
        (17.0, FontWeight.w600, 1.3, 0.0),
        (15.0, FontWeight.w400, 1.45, 0.0),
        (14.0, FontWeight.w400, 1.4, 0.0),
        (12.0, FontWeight.w400, 1.35, 0.1),
        (13.0, FontWeight.w600, 1.2, 0.6),
        (11.0, FontWeight.w600, 1.2, 1.2),
      ]);
      expect(t.h1.fontSize, 28);
      expect(t.h1.fontWeight, FontWeight.w700);
      expect(t.bodyMuted.color, t.colors.inkMuted);
    });
  });

  group('Motion', () {
    test('springs settle within sane durations', () {
      final d = KMotion.springSettleTime(KMotion.springSnappy);
      expect(d.inMilliseconds, greaterThan(100));
      expect(d.inMilliseconds, lessThanOrEqualTo(2000));
    });

    test('stagger grows with index', () {
      expect(KMotion.stagger(0), lessThan(KMotion.stagger(1)));
    });
  });
}