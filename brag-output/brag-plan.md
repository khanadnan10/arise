# Brag Plan: Arise v1.2.0

## What is this app?
Arise (`v1.2.0`) is a modular Dart CLI for bootstrapping production-ready Flutter projects with wired architecture, state management, routing, networking, DI, storage, and linting, plus generating architecture- and state-aware feature scaffolds.

## The angle
Every Flutter developer knows the pain: `flutter create` is instant, and then you spend an hour wiring Clean Architecture, Riverpod, GoRouter, Dio, and GetIt. Arise `v1.2.0` turns that entire setup—and every feature you add after—into single-line CLI commands.

## Hook (first 2-3 seconds)
"Starting a Flutter project is easy. Setting up a consistent structure isn't." — bold developer typography on dark slate, cutting straight into `arise create`.

## Key moments (the middle)
- `arise create my_app --arch clean --state riverpod --route go_router --network dio --di get_it` typing into a live terminal, revealing wired `lib/main.dart`, `lib/app.dart`, `lib/core/` files, and `.arise.yaml`.
- `arise gen feature auth -t full` expanding into Clean Architecture's `data/`, `domain/`, `presentation/`, state-management overlay, and `test/features/auth/auth_test.dart`.
- `arise add equatable` (pub.dev fallback without touching `.arise.yaml`) + `arise doctor` green checkmarks.

## Outro / punchline
`Arise v1.2.0` — `dart pub global activate arise` — "114 tests passing • Zero boilerplate."

## User flow worth showing
`arise create my_app ...` → wired `main.dart` / `app.dart` / `core/` → `arise gen feature auth -t full` → `arise add equatable` & `arise doctor`.

## Tone
- Preset: `default`
- Creative direction: Crisp, modern developer-tool launch film
- Interpretation: Fast, confident entrances with generous settled holds so every CLI command and file tree line is effortless to read.

## Format: landscape — 1920x1080
## Duration: 20s

## Visual identity (from the project)
- Background: `#0B1120` (deep slate terminal canvas)
- Accent: `#38BDF8` (Flutter/Dart sky blue) and `#10B981` (emerald checkmarks)
- Text: `#F8FAFC` (crisp off-white) and `#94A3B8` (muted slate)
- Display font: `Inter, system-ui, sans-serif`
- Body font: `JetBrains Mono, ui-monospace, monospace`
- Strongest visual element: Interactive CLI command + live generated Flutter project file tree & `.arise.yaml` card.

## Share copy (draft)
Shipped Arise v1.2.0 for Flutter: wired main.dart/app.dart, DI & storage modules, standard/full state-aware feature scaffolds (`arise gen`), plus `arise add`, `info`, and `doctor`.

## Audio direction
- Role: warm upbeat tech bed with crisp UI/keyboard accents
- Music: `happy-beats-business-moves-vol-1-by-ende-dot-app.mp3`
- Music treatment: Start at 0s at volume 0.30, smooth fade-out over final 1.5s.
- Music cue guidance: Bundled preset (`happy-beats-business-moves-vol-1-by-ende-dot-app.music-cues.md`, 120.19 BPM). Target strong cues around 17.02s / 18.52s for the final outro landing, and beat grid (0.50s intervals) for sequential card/tree reveals.
- Audio-reactive treatment: subtle; soft radial glow behind the terminal card breathes with music energy (no waveform/equalizer graphics).
- SFX posture: moderate, motion-matched, low HF risk.
- Audio-coupled moments: key ticks during CLI typing, soft drop on file tree & module card reveals, deep bell on `Arise v1.2.0` outro reveal.
- Restraint rule: Never overlap loud SFX or drown out readable text transitions.

## Storyboard

### Scene 1 — The Hook — 3.0s
Dark slate canvas (`#0B1120`). First line slams in: "Starting a Flutter project is easy." Second line lands: "Setting up a consistent structure isn't." (`#38BDF8` accent).
Sequential/interaction: Two-beat headline reveal.
Audio intent: Establish clean rhythmic pulse.
Audio-coupled idea: Soft drop on second line reveal.
Music: `happy-beats-business-moves-vol-1-by-ende-dot-app.mp3`
Transition mood: clean → Scene 2

### Scene 2 — `arise create` Wired Stack — 6.0s
Terminal window types `arise create my_app --arch clean --state riverpod --route go_router --network dio --di get_it`. Below it, 4 wired output cards appear one by one: `lib/main.dart` (`ProviderScope` + `configureDependencies()`), `lib/app.dart` (`MaterialApp.router`), `lib/core/` (`dio_client.dart`, `app_router.dart`, `injection.dart`), and `.arise.yaml`.
Sequential/interaction: yes — CLI command types out, then 4 output cards reveal sequentially.
Audio intent: Crisp typing + tactile card arrivals.
Audio-coupled idea: Keyboard ticks while command types, soft drop on card arrivals.
Transition mood: clean → Scene 3

### Scene 3 — `arise gen` & `arise add` — 6.5s
Split view: Left shows `arise gen feature auth -t full` expanding into `lib/features/auth/` (`data/`, `domain/`, `presentation/`, `auth_provider.dart`) + `test/features/auth/auth_test.dart`. Right shows `arise add equatable` updating `pubspec.yaml` while leaving `.arise.yaml` untouched, plus `arise doctor` `[✓]` checks.
Sequential/interaction: yes — feature tree rows appear sequentially, then `arise doctor` checkmarks land.
Audio intent: Momentum building toward release payoff.
Audio-coupled idea: Subtle drop on tree reveal and doctor checks.
Transition mood: clean → Scene 4

### Scene 4 — Release Outro — 4.5s
Centered hero lockup: `Arise v1.2.0` (`#38BDF8` badge), command pill `dart pub global activate arise`, and footer `114 tests passing • Zero boilerplate`.
Sequential/interaction: none — clean settled lockup.
Audio intent: Confident resolution and music fade-out.
Audio-coupled idea: Deep bell (`impactBell_heavy_000.ogg`) on `Arise v1.2.0` reveal.
Transition mood: soft fade out.

**Music mood for this video:** upbeat
**Audio summary:** An energetic 120 BPM electronic bed with subtle key ticks, tactile card drops, and a resonant bell on the final `Arise v1.2.0` reveal.
