// Grain — animated film grain. Composited over the reader and covers
// for a tactile "printed page" feel. Output alpha is premultiplied-ish;
// use with BlendMode.srcOver at low opacity.
#version 460 core
precision highp float;

layout(location = 0) out vec4 fragColor;

uniform vec2 uSize;
uniform float uTime;
uniform float uAmount;   // 0..1 grain intensity
uniform float uOpacity;  // overall alpha

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void main() {
  vec2 uv = gl_FragCoord.xy / uSize;
  float t = uTime * 60.0;
  float g1 = hash(gl_FragCoord.xy + fract(t) * 37.0);
  float g2 = hash(gl_FragCoord.xy * 1.71 + fract(t * 0.63) * 61.0);
  float g = mix(g1, g2, 0.5);
  g = (g - 0.5) * uAmount + 0.5;
  float a = uOpacity * (0.35 + 0.65 * smoothstep(0.0, 1.0, g));
  fragColor = vec4(vec3(g), a);
}
