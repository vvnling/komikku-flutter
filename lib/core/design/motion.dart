import 'dart:math' as math;
import 'package:flutter/animation.dart';
import 'package:flutter/physics.dart';

/// Motion language. Every animation in Comicko springs or eases through
/// these primitives — never raw `Duration(milliseconds: 300)` + default
/// curve scattered around. Micro-interactions, staggers and parallax are
/// composed from these in the component layer.

class KMotion {
  const KMotion._();

  // ── Springs (the default for anything tactile) ──────────────────────────
  /// Fast, precise: buttons, chips, toggles.
  static const SpringDescription springSnappy = SpringDescription(mass: 0.9, stiffness: 420, damping: 32);

  /// Softer: cards, sheets, panels.
  static const SpringDescription springSoft = SpringDescription(mass: 1.0, stiffness: 210, damping: 24);

  /// Noticeable bounce: reveal moments, confirmation.
  static const SpringDescription springBouncy = SpringDescription(mass: 1.0, stiffness: 200, damping: 14);

  /// Floating entry: hero art, covers.
  static const SpringDescription springFloat = SpringDescription(mass: 1.15, stiffness: 120, damping: 18);

  /// Heavy settle: full-screen transitions.
  static const SpringDescription springSettle = SpringDescription(mass: 1.3, stiffness: 150, damping: 26);

  // ── Durations ───────────────────────────────────────────────────────────
  static const Duration micro = Duration(milliseconds: 90);
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration base = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 420);
  static const Duration epic = Duration(milliseconds: 800);

  // ── Curves ──────────────────────────────────────────────────────────────
  static const Curve outCubic = Cubic(0.33, 1.0, 0.68, 1.0);
  static const Curve outQuart = Cubic(0.165, 0.84, 0.44, 1.0);
  static const Curve inOutQuint = Cubic(0.83, 0.0, 0.17, 1.0);
  static const Curve outExpo = Cubic(0.16, 1.0, 0.3, 1.0);
  static const Curve pop = Cubic(0.34, 1.56, 0.64, 1.0);
  static const Curve easeOut = Curves.easeOut;

  /// Stagger helper: per-item delay in a cascade (index → Duration).
  static Duration stagger(int i, {Duration step = const Duration(milliseconds: 48)}) => step * i;

  /// How long a spring takes to settle from [start] to [end] within a
  /// practical tolerance (drives route durations for spring transitions).
  static Duration springSettleTime(SpringDescription spring, {double start = 0, double end = 1}) {
    final sim = SpringSimulation(spring, start, end, 0);
    for (int i = 1; i <= 4000; i++) {
      final t = i / 120.0;
      if (sim.isDone(t)) return Duration(milliseconds: (t * 1000).round());
    }
    return const Duration(seconds: 2);
  }

  /// Random-ish deterministic delay for organic cascade entries.
  static Duration jitter(int seed, {Duration max = const Duration(milliseconds: 160)}) {
    final r = math.sin(seed * 127.1 + 311.7) * 43758.5453;
    return Duration(milliseconds: ((r - r.floorToDouble()) * max.inMilliseconds).round());
  }
}
