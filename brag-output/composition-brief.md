# Hyperframes Composition Brief: Arise v1.2.0

## Objective
Create a 20-second launch-style brag video for **Arise v1.2.0**.

## Output
- Composition directory: `brag-output/composition/`
- Rendered video: `brag-output/brag.mp4`
- Format: landscape — `1920x1080` at 30fps
- Duration: `20` seconds

## Source Material
- Project root: `/Users/storm/project/arise/arise`
- Primary files read: `README.md`, `CHANGELOG.md`, `pubspec.yaml`, `lib/src/command/*`
- Product name: `Arise v1.2.0`
- Tagline / strongest claim: "Starting a Flutter project is easy. Setting up a consistent project structure isn't."
- Key UI or visual moment to recreate: Terminal running `arise create`, `arise gen feature auth -t full`, `arise add equatable`, and `arise doctor` alongside the real generated Dart file tree.
- Copy that must appear verbatim:
  - `Starting a Flutter project is easy.`
  - `Setting up a consistent project structure isn't.`
  - `arise create my_app --arch clean --state riverpod --route go_router --network dio --di get_it`
  - `arise gen feature auth -t full`
  - `arise add equatable`
  - `dart pub global activate arise`

## Creative Direction
- Tone preset: `default`
- Creative direction: Crisp, modern developer-tool launch film
- Interpretation: Snappy entrances with generous settled holds so every CLI command, file path, and badge is effortlessly readable.
- Angle: `flutter create` gets you started, and Arise `v1.2.0` wires the architecture, state management, routing, networking, DI, storage, and feature scaffolds in seconds.
- Hook: "Starting a Flutter project is easy. Setting up a consistent project structure isn't."
- Outro / punchline: `Arise v1.2.0` — `dart pub global activate arise` — `114 tests passing • Zero boilerplate`
- Avoid: Generic SaaS language, abstract filler visuals, waveform bars.

## Visual Identity
- Background: `#0B1120`
- Text: `#F8FAFC` (primary), `#CBD5E1` (secondary)
- Accent: `#38BDF8` (sky blue), `#10B981` (emerald green)
- Display font: `Inter, -apple-system, BlinkMacSystemFont, sans-serif`
- Body font: `JetBrains Mono, ui-monospace, SFMono-Regular, monospace`
- Visual references from the project: Terminal CLI flows and Clean Architecture tree from `README.md`.

## Storyboard
1. **The Hook** — `3.0s` — Opening two-line contrast on dark slate.
2. **`arise create` Wired Stack** — `6.0s` — CLI command typing + 4 wired output cards (`main.dart`, `app.dart`, `core/`, `.arise.yaml`).
3. **`arise gen` & `arise add`** — `6.5s` — `arise gen feature auth -t full` file tree + `arise add equatable` & `arise doctor` checks.
4. **Release Outro** — `4.5s` — `Arise v1.2.0`, `dart pub global activate arise`, `114 tests passing • Zero boilerplate`.

## Audio
- Audio role: warm upbeat tech bed with crisp keyboard and UI accents
- Music: `assets/music/happy-beats-business-moves-vol-1-by-ende-dot-app.mp3`
- Music treatment: `data-start="0"`, `data-duration="20"`, `data-volume="0.30"`, fade out over last 1.5s.
- Music cue guidance: 120.19 BPM preset (`17.02s` / `18.52s` strong cues for outro).
- Audio-reactive treatment: none/subtle (keep timeline deterministic and seek-safe).
- SFX files copied into `brag-output/composition/assets/sfx/`:
  - `assets/sfx/keyboard/keypress-001.wav` .. `keypress-004.wav`
  - `assets/sfx/interface/drop_001.ogg`
  - `assets/sfx/impact/impactBell_heavy_000.ogg`
