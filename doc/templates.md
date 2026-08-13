# Template System

Arise uses YAML-driven template modules to build Flutter projects.

Templates are stored under:

```text
templates/modules/
```

## Module Structure

A module follows this structure:

```text
module_name/
├── config.yaml
└── files/
```

For example:

```text
templates/modules/state_management/riverpod/
├── config.yaml
└── files/
```

The `files/` directory is optional when a module only needs configuration or package dependencies.

## `config.yaml`

A basic module configuration looks like:

```yaml
name: Riverpod

folders: []

packages:
  - name: flutter_riverpod
```

### Name

```yaml
name: Riverpod
```

A human-readable name for the module.

### Folders

Modules can request directories to be created:

```yaml
folders:
  - lib/core
  - lib/features
```

Nested directories are created automatically.

If no additional directories are required:

```yaml
folders: []
```

### Packages

Packages required by the module are declared using:

```yaml
packages:
  - name: flutter_riverpod
```

Multiple packages can be specified:

```yaml
packages:
  - name: flutter_bloc
  - name: bloc
```

### Development Dependencies

A package can be marked as a development dependency:

```yaml
packages:
  - name: build_runner
    dev: true
```

### Package Versions

When a specific version is required:

```yaml
packages:
  - name: example_package
    version: ^1.0.0
```

Avoid pinning package versions unless the template requires a specific compatible version.

## Template Files

The `files/` directory mirrors the generated Flutter project's structure.

For example:

```text
files/
├── lib/
│   ├── main.dart
│   └── app.dart
└── test/
    └── widget_test.dart
```

will generate:

```text
my_app/
├── lib/
│   ├── main.dart
│   └── app.dart
└── test/
    └── widget_test.dart
```

This avoids maintaining individual source-to-destination mappings.

## Template Variables

Text files can contain template variables.

For example:

```dart
import 'package:{{project_name}}/app.dart';
```

When generating a project named `shop_app`, Arise renders:

```dart
import 'package:shop_app/app.dart';
```

Currently supported variables should be kept minimal and documented when added.

## Architecture Templates

Architecture modules live under:

```text
templates/modules/architecture/
```

Each architecture owns the project structure it needs.

## State Management Templates

State management modules live under:

```text
templates/modules/state_management/
```

## Routing Templates

Routing modules live under:

```text
templates/modules/routing/
```

## Networking Templates

Networking modules live under:

```text
templates/modules/networking/
```

## Feature Templates

Feature templates live under:

```text
templates/modules/feature/<architecture>/<template>/
```

For example:

```text
templates/modules/feature/clean/minimal/
├── config.yaml
└── files/
    └── lib/
        └── features/
            └── {{feature_name}}/
                ├── data/
                │   └── .gitkeep
                ├── domain/
                │   └── .gitkeep
                └── presentation/
                    └── .gitkeep
```

The `{{feature_name}}` placeholder is substituted in **both file contents and
directory names** at generation time.

Available feature templates in v1.1:

| Architecture | Template | Layers |
| --- | --- | --- |
| `clean` | `minimal` | `data/` `domain/` `presentation/` |
| `mvvm` | `minimal` | `model/` `view/` `viewmodel/` |
| `mvc` | `minimal` | `model/` `view/` `controller/` |
| `mvp` | `minimal` | `model/` `view/` `presenter/` |

## Template Rules

When adding or modifying templates:

1. Keep modules independent where possible.
2. Do not hardcode project names.
3. Use `{{project_name}}` when referencing the generated package.
4. Avoid unnecessary package dependencies.
5. Ensure generated Dart code passes `flutter analyze`.
6. Ensure generated tests pass `flutter test`.
7. Do not add technology-specific logic to the core generator when the behavior can be represented by a template.

## Testing Templates

After modifying a template, run:

```bash
dart test
```

For manual verification, generate a project and run:

```bash
flutter analyze
flutter test
```

A template should not be merged if it causes either command to fail.