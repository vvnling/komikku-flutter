// SpeedLines — konpa-style concentration lines radiating from a focus
// point. Used as a focus veil behind dialogs and the reader chapter
// transition. uFocus in normalized coordinates.
#version 460 core
precision highp float;

layout(location = 0) out vec4 fragColor;

uniform vec2 uSize;
uniform vec2 uFocus;
uniform float uTime;
uniform vec3 uInk;    // line color
uniform float uDensity; // 0..1
uniform float uTwist;   // 0..1 rotation swirl

void main() {
  vec2 uv = gl_FragCoord.xy / uSize;
  vec2 v = uv - uFocus;
  float r = length(v);
  float ang = atan(v.y, v.x);

  // spiral twist near focus
  ang += uTwist * (1.0 - smoothstep(0.0, 0.5, r)) * uTime * 0.35;

  // radial spokes
  float spokes = 64.0 * (1.0 + uDensity * 3.0);
  float s = 0.5 + 0.5 * sin(ang * spokes);
  float line = smoothstep(0.82, 1.0, s);

  // fade in from focus; clamp far
  float reach = smoothstep(0.0, 0.28, r) * smoothstep(1.25, 0.9, r);
  // soft core glow
  float core = smoothstep(0.12, 0.0, r);

  float a = clamp(line * reach * 0.55 + core * 0.25, 0.0, 1.0);
  fragColor = vec4(uInk * a, a);
}
