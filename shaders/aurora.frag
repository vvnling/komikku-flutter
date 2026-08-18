// Aurora — layered fbm color fields. Ambient backdrop of the app.
// Driven by CustomPaint; uniforms are set explicitly each frame.
#version 460 core
precision highp float;

layout(location = 0) out vec4 fragColor;

uniform vec2 uSize;
uniform float uTime;
uniform vec3 uColorA; // palette-driven field color 1
uniform vec3 uColorB; // palette-driven field color 2
uniform vec3 uColorC; // palette-driven field color 3
uniform float uSpeed;
uniform float uIntensity;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  f = f * f * (3.0 - 2.0 * f);
  return mix(
    mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
    mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x),
    f.y
  );
}

float fbm(vec2 p) {
  float v = 0.0;
  float a = 0.5;
  for (int i = 0; i < 5; i++) {
    v += a * noise(p);
    p = p * 2.03 + vec2(11.7, 5.3);
    a *= 0.5;
  }
  return v;
}

void main() {
  vec2 uv = gl_FragCoord.xy / uSize;
  vec2 p = uv;
  p.x += uTime * 0.045 * uSpeed;
  p.y -= uTime * 0.028 * uSpeed;

  float n1 = fbm(p * 2.4);
  float n2 = fbm(p * 4.6 + 3.7);
  float n3 = fbm(p * 7.0 + 9.2);

  vec3 col = mix(uColorA, uColorB, smoothstep(0.0, 1.0, n1));
  col = mix(col, uColorC, smoothstep(0.35, 1.0, n2) * 0.55);
  col = mix(col, uColorA, smoothstep(0.6, 1.0, n3) * 0.35);

  // radial glow lift
  float glow = smoothstep(1.1, 0.15, length(uv - 0.5));
  col = mix(col, col * 1.35, glow * 0.35);

  float vig = smoothstep(1.35, 0.35, length(uv - 0.5));
  col *= mix(0.62, 1.0, vig);

  fragColor = vec4(col * uIntensity, 1.0);
}
