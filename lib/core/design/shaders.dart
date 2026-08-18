import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

/// Loads the app's FragmentPrograms once and hands out configured
/// [ui.FragmentShader] instances. Shaders are the signature of the
/// COMICKO visual language (aurora fields, ink ripples, sheen sweeps).
class KShaders {
  KShaders._(this._programs);

  final Map<String, ui.FragmentProgram> _programs;

  static Future<KShaders> load() async {
    // Fragment shaders are a native-platform enhancement: canvaskit's
    // runtime shader compilation is unreliable on web, so web builds get
    // the flat-surface fallbacks (gradients, painters) instead.
    if (kIsWeb) return KShaders._(<String, ui.FragmentProgram>{});
    const assets = <String, String>{
      'aurora': 'shaders/aurora.frag',
      'grain': 'shaders/grain.frag',
      'sheen': 'shaders/sheen.frag',
      'ink': 'shaders/ink.frag',
      'wave': 'shaders/wave.frag',
      'ambience': 'shaders/reader_ambience.frag',
      'speed': 'shaders/speed_lines.frag',
    };
    final programs = <String, ui.FragmentProgram>{};
    for (final entry in assets.entries) {
      try {
        programs[entry.key] = await ui.FragmentProgram.fromAsset(entry.value);
      } catch (_) {
        // Shaders are progressive enhancement: platforms without shader
        // support (e.g. some web renderers) degrade to flat surfaces.
      }
    }
    return KShaders._(programs);
  }

  bool get isSupported => _programs.isNotEmpty;

  /// Fresh shader instance; set its uniforms before painting.
  /// Returns null when the shader failed to load.
  ui.FragmentShader? shader(String name) => _programs[name]?.fragmentShader();

  // ── Convenience painters ────────────────────────────────────────────────

  /// Aurora backdrop painter. Colors come from the active palette.
  CustomPainter auroraPainter({
    required Animation<double> time,
    required Color a,
    required Color b,
    required Color c,
    double speed = 1,
    double intensity = 1,
  }) =>
      _AuroraPainter(this, time, a, b, c, speed, intensity);

  /// Film grain overlay.
  CustomPainter grainPainter({required Animation<double> time, double amount = 0.5, double opacity = 0.06}) =>
      _GrainPainter(this, time, amount, opacity);

  /// Animated sheen sweep over an image (covers, hero).
  CustomPainter sheenPainter({
    required Animation<double> time,
    Color tint = const Color(0xFFFFFFFF),
    double strength = 0.5,
    double speed = 1,
    double phase = 0,
    double sweepCount = 1.2,
  }) =>
      _SheenPainter(this, time, tint, strength, speed, phase, sweepCount);

  /// Ink ripple at a point (press feedback).
  CustomPainter inkPainter({
    required Animation<double> time,
    required Offset center,
    required Color color,
    required double maxRadius,
  }) =>
      _InkPainter(this, time, center, color, maxRadius);

  /// Flowing ink waves (empty states).
  CustomPainter wavePainter({required Animation<double> time, required Color a, required Color b}) =>
      _WavePainter(this, time, a, b);

  /// Reader ambience (scanlines + vignette + grade).
  CustomPainter ambiencePainter({
    required Animation<double> time,
    Color tint = const Color(0x00000000),
    double scan = 0,
    double vignette = 0,
    double breath = 0,
  }) =>
      _AmbiencePainter(this, time, tint, scan, vignette, breath);

  /// Concentration speed-lines radiating from [focus].
  CustomPainter speedLinesPainter({
    required Animation<double> time,
    Offset focus = const Offset(0.5, 0.5),
    Color ink = const Color(0xFF000000),
    double density = 0.5,
    double twist = 0,
  }) =>
      _SpeedLinesPainter(this, time, focus, ink, density, twist);
}

// ── Painters ────────────────────────────────────────────────────────────────

class _AuroraPainter extends CustomPainter {
  _AuroraPainter(this.shaders, this.time, this.a, this.b, this.c, this.speed, this.intensity)
      : super(repaint: time);
  final KShaders shaders;
  final Animation<double> time;
  final Color a, b, c;
  final double speed, intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = shaders.shader('aurora');
    if (shader == null) return;
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time.value)
      ..setFloat(3, a.r)
      ..setFloat(4, a.g)
      ..setFloat(5, a.b)
      ..setFloat(6, b.r)
      ..setFloat(7, b.g)
      ..setFloat(8, b.b)
      ..setFloat(9, c.r)
      ..setFloat(10, c.g)
      ..setFloat(11, c.b)
      ..setFloat(12, speed)
      ..setFloat(13, intensity);
    try {
      canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
    } catch (_) {
      // shader paint failed (e.g. canvaskit compile issue) — skip this layer
    }
  }

  @override
  bool shouldRepaint(_AuroraPainter old) => old.a != a || old.b != b || old.c != c;
}

class _GrainPainter extends CustomPainter {
  _GrainPainter(this.shaders, this.time, this.amount, this.opacity) : super(repaint: time);
  final KShaders shaders;
  final Animation<double> time;
  final double amount, opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = shaders.shader('grain');
    if (shader == null) return;
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time.value)
      ..setFloat(3, amount)
      ..setFloat(4, opacity);
    try {
      canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
    } catch (_) {
      // shader paint failed (e.g. canvaskit compile issue) — skip this layer
    }
  }

  @override
  bool shouldRepaint(_GrainPainter old) => old.amount != amount || old.opacity != opacity;
}

class _SheenPainter extends CustomPainter {
  _SheenPainter(this.shaders, this.time, this.tint, this.strength, this.speed, this.phase, this.sweepCount)
      : super(repaint: time);
  final KShaders shaders;
  final Animation<double> time;
  final Color tint;
  final double strength, speed, phase, sweepCount;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = shaders.shader('sheen');
    if (shader == null) return;
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time.value)
      ..setFloat(3, tint.r)
      ..setFloat(4, tint.g)
      ..setFloat(5, tint.b)
      ..setFloat(6, strength)
      ..setFloat(7, speed)
      ..setFloat(8, phase)
      ..setFloat(9, sweepCount);
    try {
      canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
    } catch (_) {
      // shader paint failed (e.g. canvaskit compile issue) — skip this layer
    }
  }

  @override
  bool shouldRepaint(_SheenPainter old) => old.tint != tint || old.strength != strength;
}

class _InkPainter extends CustomPainter {
  _InkPainter(this.shaders, this.time, this.center, this.color, this.maxRadius) : super(repaint: time);
  final KShaders shaders;
  final Animation<double> time;
  final Offset center;
  final Color color;
  final double maxRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = shaders.shader('ink');
    if (shader == null) return;
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, center.dx)
      ..setFloat(3, center.dy)
      ..setFloat(4, time.value)
      ..setFloat(5, color.r)
      ..setFloat(6, color.g)
      ..setFloat(7, color.b)
      ..setFloat(8, maxRadius);
    try {
      canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
    } catch (_) {
      // shader paint failed (e.g. canvaskit compile issue) — skip this layer
    }
  }

  @override
  bool shouldRepaint(_InkPainter old) => old.center != center || old.color != color;
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.shaders, this.time, this.a, this.b) : super(repaint: time);
  final KShaders shaders;
  final Animation<double> time;
  final Color a, b;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = shaders.shader('wave');
    if (shader == null) return;
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time.value)
      ..setFloat(3, a.r)
      ..setFloat(4, a.g)
      ..setFloat(5, a.b)
      ..setFloat(6, b.r)
      ..setFloat(7, b.g)
      ..setFloat(8, b.b);
    try {
      canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
    } catch (_) {
      // shader paint failed (e.g. canvaskit compile issue) — skip this layer
    }
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.a != a || old.b != b;
}

class _AmbiencePainter extends CustomPainter {
  _AmbiencePainter(this.shaders, this.time, this.tint, this.scan, this.vignette, this.breath)
      : super(repaint: time);
  final KShaders shaders;
  final Animation<double> time;
  final Color tint;
  final double scan, vignette, breath;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = shaders.shader('ambience');
    if (shader == null) return;
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time.value)
      ..setFloat(3, tint.r)
      ..setFloat(4, tint.g)
      ..setFloat(5, tint.b)
      ..setFloat(6, scan)
      ..setFloat(7, vignette)
      ..setFloat(8, breath);
    try {
      canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
    } catch (_) {
      // shader paint failed (e.g. canvaskit compile issue) — skip this layer
    }
  }

  @override
  bool shouldRepaint(_AmbiencePainter old) => old.tint != tint || old.scan != scan;
}

class _SpeedLinesPainter extends CustomPainter {
  _SpeedLinesPainter(this.shaders, this.time, this.focus, this.ink, this.density, this.twist)
      : super(repaint: time);
  final KShaders shaders;
  final Animation<double> time;
  final Offset focus;
  final Color ink;
  final double density, twist;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = shaders.shader('speed');
    if (shader == null) return;
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, focus.dx)
      ..setFloat(3, focus.dy)
      ..setFloat(4, time.value)
      ..setFloat(5, ink.r)
      ..setFloat(6, ink.g)
      ..setFloat(7, ink.b)
      ..setFloat(8, density)
      ..setFloat(9, twist);
    try {
      canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
    } catch (_) {
      // shader paint failed (e.g. canvaskit compile issue) — skip this layer
    }
  }

  @override
  bool shouldRepaint(_SpeedLinesPainter old) => old.focus != focus || old.ink != ink;
}
