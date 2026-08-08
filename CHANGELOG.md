# Changelog

All notable changes to Arise will be documented in this file.

## 1.1.0 - 2026-08-08

### Added

- `arise generate feature <name>` — generates a feature scaffold using the project's architecture
- Architecture-aware feature templates: Clean Architecture, MVVM, MVC, MVP
- `--template` flag for `generate feature` (default: `minimal`)
- Feature name validation — normalizes hyphens/uppercase, rejects unsafe names
- Project manifest (`.arise.yaml`) — persists architecture and module choices
- `ProjectManifest` typed model — replaces raw `Map<String, dynamic>` in `ManifestService`
- Networking selection in `arise create` (`Dio` or none)
- Exit code `64` for invalid CLI usage (replaces stack traces)
- Integration tests for feature generation across all four architectures

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