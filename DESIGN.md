# COMICKO — Design System

"Paper & Ink, Living Color". The visual language is a manga-reading
instrument: ink strokes, paper grain, halftone screens and speed lines,
rendered with liquid aurora color fields and iridescent sheen.

## Constraints

1. **No Material 3, no Cupertino.** `Scaffold`, `AppBar`, `Card`,
   `ListTile`, `ElevatedButton`, `BottomNavigationBar`, `TextField`,
   `Switch`, `Slider`, `TabBar`, `Dialog`, `SnackBar`, `InkWell`,
   `Divider`, `RefreshIndicator` are banned. Everything is composed from
   `Container`, `CustomPainter`, `CustomClipper`, `ShaderMask`,
   `BackdropFilter`, `ClipPath`, `Transform`, `FragmentProgram` and Rive.
   The app root is a plain `WidgetsApp`.
2. **Tokens first.** Never hardcode colors/radii/type outside
   `lib/core/design/tokens.dart`. Pull from `context.kTheme`.
3. **Motion language.** All animations use the springs/curves in
   `lib/core/design/motion.dart`. Tactile things spring; entrances
   stagger; navigation parallaxes.
4. **Shaders are enhancement.** Fragment shaders (aurora, grain, sheen,
   ink ripple, waves, scanline ambience, speed lines) load resiliently and
   are skipped on the web (canvaskit runtime compilation is unreliable).
   Flat-surface fallbacks must look intentional.

## Tokens

- **Palettes** — 8 shipped (`aurora`, `komikku`, `midnight`, `sakura`,
  `mint`, `sunset`, `ink`, `forest`), each with light + dark surface sets.
- **Type** — Space Grotesk (bundled) with a 9-step scale.
- **Geometry** — 4 px base spacing; radius scale; panel-stroke widths.
- **Signatures** — double-stroke panel frames with corner accents,
  halftone dots, speed rings, the "panel + ink stroke" app mark.

## Component kit (`lib/ui/widgets`)

`KPressable` (ink-ripple shader + spring scale) is the interaction base.
On top: `KButton`, `KIconButton`, `KCard`, `KListTile`, `KSwitch`,
`KSlider`, `KCheckbox`, `KSegmented`, `KChip`, `KTag`, `KBadge`,
`KTextField` (raw `EditableText`), `KSearchField`, `KTabBar`, `KAppBar`
(frosted), `KSheet`, `KDialog`, `KToast`, `KMenuButton`, `KRefresh`,
`KCover`, `KProgressRing`, `KProgressBar`, `KSkeleton`, `KEmpty`,
`KRoute` (custom page transitions) and `KPage` (the Scaffold replacement).

## Reader

One gesture arena drives the paged viewer (flip / pinch-zoom /
double-tap / tap zones / edge chapter switches); the webtoon viewer is a
continuous vertical strip with natural-aspect lazy pages, autoscroll and a
draggable scrubber. Progress persists per chapter; the background can
sample the page color automatically.

## Testing

`flutter test` covers the token system, the widget kit's interactive
contracts, and integration flows (library, merges, hidden categories,
downloads, backup roundtrip, update groups, trackers, demo chapter
pages, full app boot) against an in-memory SQLite database.