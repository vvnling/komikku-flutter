# Comicko

**Komikku, rewritten in Flutter.** A free, open-source manga reader with a
hand-crafted design language — no Material, no Cupertino.

Comicko reimplements the feature set of
[komikku-app/komikku](https://github.com/komikku-app/komikku) (a
Mihon/TachiyomiSY fork) from scratch in Dart/Flutter: library management,
source-based browsing, a fully custom reader, downloads, trackers, backups,
library updates, migration across sources and much more — on Android, iOS,
Web, Windows, Linux and macOS.

> **Design constraint.** Every pixel is drawn from foundational Flutter
> primitives: `Container`, `CustomPainter`, `ShaderMask`, `BackdropFilter`,
> `ClipPath`, `FragmentProgram` and Rive state machines. Material 3 and
> Cupertino widgets are not used anywhere in the app — see
> [DESIGN.md](DESIGN.md).

---

## Features

### Library
- Grid / list layouts, categories (incl. **hidden categories**), sorting by
  added / title / last read / last updated / unread / chapters / source
- Filters: downloaded, unread, started, tracked, not tracked
- Advanced search (terms, exclusions), continue-reading shortcut
- Bulk selection: merge entries, categorize, mark read/unread, remove
- **Merge multiple entries** into one
- Long-press to add/remove everywhere

### Browse & Sources
- Source framework with **MangaDex** (anonymous API), **Local storage**
  (folders, CBZ, ZIP) and the offline **Comicko Demo** source whose covers
  and pages are generated procedurally at runtime
- Feed of the latest entries per source, saved searches as chips
- Search across any source, per-manga **suggestions**

### Reader (custom-built, no Material)
- Paged LTR / RTL, Vertical (webtoon) and continuous viewers
- Page transitions: slide, cover, fade, depth — all spring-driven
- One-gesture-arena design: flip, pinch-zoom, double-tap zoom, tap zones
- Autoscroll with tunable speed, vertical scrubber
- Smart background (auto-tint from the page), webtoon auto-detection
- Per-chapter progress, edge-swipes into next/previous chapter

### Downloads, Updates, Data
- Queue-based downloader (progress, cancel, clear), pages stored under
  `downloads/` for offline reading
- Scheduled library updates; grouped **Updates** tab; in-app progress banner
- JSON backup/restore of library, categories, history, tracks, settings
- AniList tracker (OAuth pin flow) + fully local tracking
- Migration between sources, per-manga source remap

### Design system (COMICKO)
- "Paper & Ink, Living Color": manga panel frames, halftone screens,
  speed-line veils, ink ripples
- 8 color palettes, light/dark per palette, **auto tint from cover art**
- Fragment shaders: aurora fields, liquid sheen, ink ripples, waves,
  scanline ambience, speed lines (native platforms; web degrades to
  flat surfaces)
- Rive state machines (liquid download, rocket, blinko)
- Spring-physics motion language, staggered reveals, parallax navigation

---

## Screenshots

Running the app locally (any platform):

```sh
flutter run
```

The web build boots to an empty library; tap **Add demo entries** to seed
12 procedurally-drawn manga with chapters and pages — everything works
offline.

---

## Project layout

```
lib/
  core/design/     design tokens, palettes, motion, shaders, motifs
  core/data/       settings (SharedPreferences)
  core/            app scope (dependency container), theme controller
  data/db/         drift schema + repositories (SQLite, web via wasm)
  data/models/     domain models
  data/services/   library, downloads, updates, backups, trackers, covers
  data/sources/    source framework + MangaDex, Local, Demo
  ui/screens/      library, browse, updates, history, more, manga,
                   reader (paged + webtoon engines), search, migration,
                   extensions, backup, trackers, settings
  ui/shell/        navigation shell (bottom bar / rail)
  ui/widgets/      the COMICKO component kit (no Material)
shaders/           GLSL fragment shaders
web/               web entry + drift worker + sqlite3.wasm
test/              design-system, widget and integration tests
```

## Build

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs  # drift codegen
flutter test
flutter build apk --release                              # Android
flutter build web --release                              # Web
flutter build linux --release                            # Linux
flutter build windows --release                          # Windows
flutter build macos --release                            # macOS
flutter build ios --release                              # iOS (macOS host)
```

Web builds require `web/drift_worker.js` (a compiled drift wasm worker) and
`web/sqlite3.wasm`; both are committed. Regenerate the worker with:

```sh
dart compile js web/drift_worker.dart -o web/drift_worker.js -O4
```

## CI / CD

- `.github/workflows/ci.yml` — analyze + tests on every push/PR.
- `.github/workflows/release.yml` — on tag `v*`: builds Android APK
  (signed from repository secrets `KEYSTORE_B64`, `KEYSTORE_PASSWORD`,
  `KEY_ALIAS`, `KEY_PASSWORD`), Web, Linux and Windows artifacts and
  publishes a GitHub Release with them.

Create a release:

```sh
git tag v0.1.0
git push origin v0.1.0
```

## Trackers

AniList requires a developer client id (anilist.co/settings/developer) —
paste it in **More → Trackers**, then log in through the pin flow and paste
the access token. The built-in **Comicko** tracker works fully offline for
status, score and progress.

## License

Apache License 2.0 — see [LICENSE](LICENSE). The Rive example assets
(`liquid_download.riv`, `rocket.riv`, `blinko.riv`) are from the
[rive-flutter](https://github.com/rive-app/rive-flutter) repository
(MIT).