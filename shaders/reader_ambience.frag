// ReaderAmbience — scanlines + vignette + color grade for the reader
// backdrop. Painted UNDER or OVER page art depending on the mode.
#version 460 core
precision highp float;

layout(location = 0) out vec4 fragColor;

uniform vec2 uSize;
uniform float uTime;
uniform vec3 uTint;      // color grade (page warm/cool)
uniform float uScan;     // 0..1 scanline strength
uniform float uVignette; // 0..1 vignette strength
uniform float uBreath;   // slow luminance breathing 0..1

void main() {
  vec2 uv = gl_FragCoord.xy / uSize;

  float line = 0.5 + 0.5 * sin(uv.y * 380.0 * 3.14159265);
  float scan = mix(1.0, line, uScan);

  float d = length(uv - 0.5);
  float vig = 1.0 - smoothstep(0.42, 1.15, d) * uVignette;

  float breath = 1.0 + 0.035 * sin(uTime * 1.1) * uBreath;

  vec3 col = uTint * scan * vig * breath;
  fragColor = vec4(col, 1.0);
}
