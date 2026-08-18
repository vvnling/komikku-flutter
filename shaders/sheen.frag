// Sheen — liquid light sweep that travels diagonally across covers and
// hero art. Sits on top of an image; alpha blends the highlight in.
#version 460 core
precision highp float;

layout(location = 0) out vec4 fragColor;

uniform vec2 uSize;
uniform float uTime;
uniform vec3 uTint;
uniform float uStrength;
uniform float uSpeed;
uniform float uPhase;    // manual phase offset (staggered reveals)
uniform float uSweepCount; // 1..4 bands

void main() {
  vec2 uv = gl_FragCoord.xy / uSize;

  // diagonal coordinate
  float d = (uv.x + uv.y * 0.62) + uPhase;
  float bands = sin(d * 6.28318 * uSweepCount - uTime * 2.0 * uSpeed);

  // travel wave
  float travel = sin(d * 3.14159 * 0.5 - uTime * 1.4 * uSpeed);
  float band = smoothstep(0.62, 1.0, bands);
  float wave = smoothstep(0.25, 0.95, travel) * (1.0 - smoothstep(0.95, 1.15, travel));

  // edge falloff so the sheen never hard-cuts at borders
  float edge = smoothstep(0.0, 0.18, uv.x) * smoothstep(1.0, 0.82, uv.x);
  edge *= smoothstep(0.0, 0.18, uv.y) * smoothstep(1.0, 0.82, uv.y);

  float a = band * wave * uStrength * edge;
  fragColor = vec4(uTint * a, a);
}
