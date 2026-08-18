// Waves — flowing ink waves for empty states and the loading veil.
// Painted behind content; alpha describes where waves live.
#version 460 core
precision highp float;

layout(location = 0) out vec4 fragColor;

uniform vec2 uSize;
uniform float uTime;
uniform vec3 uColorA;
uniform vec3 uColorB;

float wave(vec2 uv, float baseY, float amp, float freq, float speed, float phase) {
  float w = sin(uv.x * freq + uTime * speed + phase);
  float d = abs(uv.y - (baseY + amp * w));
  return 1.0 - smoothstep(0.0, 0.045, d);
}

void main() {
  vec2 uv = gl_FragCoord.xy / uSize;

  float w1 = wave(uv, 0.32, 0.06, 6.0, 1.6, 0.0);
  float w2 = wave(uv, 0.47, 0.09, 9.0, 2.2, 2.1);
  float w3 = wave(uv, 0.66, 0.07, 7.5, 1.9, 4.2);

  float m = w1 + w2 * 0.8 + w3 * 0.6;
  vec3 col = mix(uColorA, uColorB, smoothstep(0.0, 2.4, m));
  float a = clamp(m, 0.0, 1.0) * 0.85;
  fragColor = vec4(col * a, a);
}
