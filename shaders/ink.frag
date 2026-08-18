// InkRipple — press feedback ripple. uTime goes 0→1 over the ripple life.
#version 460 core
precision highp float;

layout(location = 0) out vec4 fragColor;

uniform vec2 uSize;
uniform vec2 uCenter;   // in px
uniform float uTime;    // 0..1
uniform vec3 uColor;
uniform float uMaxRadius;

void main() {
  vec2 uv = gl_FragCoord.xy / uSize;
  float r = distance(uv, uCenter / uSize);

  float t = uTime;
  float radius = uMaxRadius * (0.25 + 0.75 * t);

  // leading ring
  float ring = 1.0 - smoothstep(0.0, 0.12, abs(r - radius));
  // trailing fill
  float fill = 1.0 - smoothstep(0.0, radius, r);
  // fade everything as t → 1
  float fade = 1.0 - smoothstep(0.55, 1.0, t);

  float a = (ring * 0.55 + fill * 0.30) * fade;
  fragColor = vec4(uColor, a);
}
