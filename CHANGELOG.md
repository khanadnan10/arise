# Changelog

All notable changes to Arise will be documented in this file.

## 1.2.0 - 2026-11-25

### Added

- Starter wiring files for existing `create` modules (`DioClient`, `GoRouter` `appRouter`, `AutoRoute` `AppRouter` + `HomePage`, Riverpod `appTitleProvider`, Bloc `AppBlocObserver`, Provider `AppState`, GetX `AppController`)
- Composable `main.dart` and `app.dart` bootstrap wiring across architectures, state management, routing, and dependency injection
- `standard` and `full` feature templates across Clean Architecture, MVVM, MVC, and MVP (with `standard` as the new default template, starter Dart files, and feature unit tests in `full`)
- State-management-aware feature overlays (`templates/modules/feature_state/`) for Riverpod, Bloc, Provider, and GetX driven by `.arise.yaml`
- Case-aware template variable expansion (`*_pascal`, `*_camel`, `*_title`) via `TemplateVariables`
- Dependency injection (`get_it`, `injectable`), local storage (`shared_preferences`), and lint (`very_good_analysis`) modules
- Non-interactive flags on `arise create`: `--arch`, `--state`, `--route`, `--network`, `--di`, `--storage`, `--lint`
- `gen` alias for `arise generate` (`arise gen feature <name>`)
- `arise add <module|package>` command (with `--dev` and `--list`) to add built-in Arise modules (updating `.arise.yaml`) or install any pub.dev package via `flutter pub add` without modifying `.arise.yaml`
- `arise info` command to inspect `.arise.yaml` configuration and generated features
- `arise doctor` command to verify Dart/Flutter SDKs, template integrity, and project manifest health
- `requires` and `conflicts` validation in `TemplateMerger`

### Fixed

- Run `auto_route` `build_runner` hook in `postPubGet` (after package installation) with `--delete-conflicting-outputs`
- Validate `flutter create` exit code and project package names in `arise create`

---

## 1.1.0 - 2026-08-08

### Added

- `arise generate feature <name>` — generates a feature scaffold using the project's architecture
- Architecture-aware feature templates: Clean Architecture, MVVM, MVC, MVP
- `--template` flag for `generate feature` (default: `minimal`)
- `--force` flag to overwrite an existing feature directory
- `--list` flag to view available architectures and templates
- Overwrite protection — duplicate feature generation is rejected unless `--force` is passed
- Feature name validation — normalises hyphens/uppercase, rejects unsafe names
- Project manifest (`.arise.yaml`) — persists architecture and module choices
- `ProjectManifest` typed model — replaces raw `Map<String, dynamic>` in `ManifestService`
- Networking selection in `arise create` (`Dio` or none)
- Exit code `64` for invalid CLI usage (replaces stack traces)
- Integration and command-level tests for feature generation across all four architectures

---

## 1.0.0 - 2026-08-03

### Added

- Interactive Flutter project creation with `arise create`
- `--skip` option for non-interactive project creation
- YAML-driven modular template system
- Recursive template directory generation
- Template variable rendering
- Clean Architecture, MVVM, MVC, MVP, and default Flutter architecture support
- Riverpod, Provider, Bloc, and GetX state management support
- GoRouter and AutoRoute routing support
- Dio networking support
- Automatic package and development dependency installation
- Architecture-aware generated Flutter tests
- Global Dart CLI activation support
- Unit and integration test coverage
- Architecture and module-combination integration tests
- Contributor, architecture, template, and module documentation