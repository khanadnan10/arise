# Arise

A modular CLI for bootstrapping production-ready Flutter projects.

Arise helps you create Flutter projects with your preferred architecture, state management, routing, networking, storage, and other project-level tooling without manually setting up the same structure every time.

## Why Arise?

Starting a Flutter project is easy.

Setting up a consistent project structure isn't.

Arise handles the repetitive setup while keeping the generated project transparent and fully under your control.

With Arise, you can:

- Bootstrap Flutter projects interactively or with non-interactive CLI flags
- Wire architecture, state management, routing, networking, DI, storage, and linting out of the box
- Generate architecture- and state-aware feature scaffolds (`minimal`, `standard`, `full`)
- Add built-in Arise modules or any `pub.dev` package with `arise add`
- Inspect project configuration (`arise info`) and verify environment health (`arise doctor`)
- Persist project choices in `.arise.yaml` for future Arise commands

## Quick Start

Activate Arise:

```bash
dart pub global activate arise
```

## Supported Setup

| Category | Options |
| --- | --- |
| **Architecture** | Clean Architecture (`clean`), MVVM (`mvvm`), MVC (`mvc`), MVP (`mvp`), `none` |
| **State Management** | Riverpod (`riverpod`), Provider (`provider`), Bloc (`bloc`), GetX (`getx`), `none` |
| **Routing** | GoRouter (`go_router`), AutoRoute (`auto_route`), `none` |
| **Networking** | Dio (`dio`), `none` |
| **Dependency Injection** | GetIt (`get_it`), Injectable (`injectable`), `none` |
| **Local Storage** | SharedPreferences (`shared_preferences`), `none` |
| **Linting** | Very Good Analysis (`very_good_analysis`), `none` |

## Interactive Setup

Run:

```bash
arise create
```

Arise walks you through the project configuration and generates the Flutter project based on your selections.

Example flow:

```text
Project name: my_app

Architecture:
❯ Clean Architecture
  MVVM
  MVC
  MVP
  None

State Management:
❯ Riverpod
  Provider
  Bloc
  GetX
  None

Routing:
❯ GoRouter
  AutoRoute
  None
```

Only the project name is required. Other configuration options can be skipped by selecting `None`.

## Skip Setup

If you don't need Arise's project configuration, use:

```bash
arise create --skip my_app
```

This skips the interactive configuration and creates a standard Flutter project.

## Commands

### `arise create`

Creates a new Flutter project, generates the chosen folder structure and starter wiring (`lib/main.dart`, `lib/app.dart`, `lib/core/...`), installs all dependencies, runs codegen hooks (such as `build_runner`), and saves `.arise.yaml`.

**Interactive mode:**

```bash
arise create
```

**Non-interactive mode (great for scripts/CI):**

```bash
arise create my_app \
  --arch clean \
  --state riverpod \
  --route go_router \
  --network dio \
  --di get_it \
  --storage shared_preferences \
  --lint very_good_analysis
```

**Default Flutter project (skip Arise modules):**

```bash
arise create --skip my_app
```

See all options with `arise create --help`.

---

### `arise generate feature` (shorthand: `arise gen feature`)

Scaffolds a new feature inside an existing Arise project (run from the project root where `.arise.yaml` lives).

```bash
arise gen feature auth            # standard (default)
arise gen feature auth -t minimal  # empty layer folders only
arise gen feature auth -t full     # complete feature + unit test
```

What each `--template` (`-t`) generates (example for **Clean Architecture**):

| Template | What You Get |
| --- | --- |
| `-t minimal` | Empty architecture layer folders (`data/`, `domain/`, `presentation/`) with `.gitkeep` |
| `-t standard` *(default)* | Starter Dart classes per layer (Entity, Repository contract & impl, Page) + state-management files if configured in `.arise.yaml` (e.g. `AuthNotifier`, `AuthBloc`, `AuthProvider`, `AuthController`) |
| `-t full` | Everything in `standard` **plus** Data Model (`fromJson`/`toJson`), Remote DataSource, UseCase, reusable Widget, and a unit test under `test/features/<name>/` |

*(Works identically for `mvvm`, `mvc`, and `mvp`, mapping to each architecture's native layers.)*

**Other useful options:**

```bash
arise gen feature User-Profile          # normalises to lib/features/user_profile/
arise gen feature auth -t full --force  # overwrite an existing feature (-f)
arise gen feature --list                # list available templates & active architecture (-l)
```

---

### `arise add`

Adds either a **built-in Arise module** or **any package from `pub.dev`**:

```bash
arise add dio             # built-in module: adds DioClient, installs dio, updates .arise.yaml
arise add get_it          # built-in module: adds injection.dart, installs get_it, updates .arise.yaml
arise add intl            # pub.dev package: runs flutter pub add intl (.arise.yaml unchanged)
arise add -d mockito      # pub.dev dev dependency: runs flutter pub add --dev mockito
arise add --list          # list all built-in Arise modules (-l)
```

---

### `arise info`

Shows the current project's `.arise.yaml` configuration (architecture, state management, routing, networking, DI, storage, lint) and lists all features detected under `lib/features/`:

```bash
arise info
```

---

### `arise doctor`

Checks your environment and project health — Dart SDK, Flutter SDK, Arise template integrity, and `.arise.yaml` validity:

```bash
arise doctor
```

## Global Help

To see all available commands:

```bash
arise --help
```

## How It Works

Arise builds your project in a few steps:

```text
arise create
     ↓
Project Configuration
     ↓
Flutter Project Creation
     ↓
Template Selection
     ↓
Module Generation
     ↓
Package Installation
     ↓
Ready Flutter Project
```

Arise uses YAML-driven templates rather than hardcoding project structures into the CLI.

Each module can define its own folders, packages, and template files. This keeps the generator extensible while leaving the generated Flutter project fully editable.

## Template System

Templates are organized by module:

```text
templates/
└── modules/
    ├── architecture/
    ├── state_management/
    ├── routing/
    ├── networking/
    └── feature/
        ├── clean/
        │   └── minimal/
        ├── mvvm/
        │   └── minimal/
        ├── mvc/
        │   └── minimal/
        └── mvp/
            └── minimal/
```

A module contains its configuration and, when required, files that are copied into the generated project:

```text
module/
├── config.yaml
└── files/
```

For example:

```text
architecture/
└── clean/
    ├── config.yaml
    └── files/
        ├── lib/
        │   ├── main.dart
        │   └── app.dart
        └── test/
            └── widget_test.dart
```

Template variables such as:

```text
{{project_name}}
```

are resolved while the project is generated.

## Requirements

Before using Arise, make sure you have:

- Dart SDK
- Flutter SDK
- Flutter available in your system `PATH`

Verify your Flutter installation with:

```bash
flutter doctor
```

# Installation

## Requirements

Before installing Arise, make sure the following are available:

- Dart SDK
- Flutter SDK
- Git

Verify Flutter:

```bash
flutter doctor
```

Verify Dart:

```bash
dart --version
```

## Install Arise

Install Arise globally using Dart:

```bash
dart pub global activate arise
```

Verify the installation:

```bash
arise --help
```

## Command Not Found

If installation succeeds but your terminal reports:

```text
command not found: arise
```

Dart's global executable directory may not be in your `PATH`.

### macOS / Linux

Add the following to your shell configuration:

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

For Zsh:

```bash
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

For Bash:

```bash
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.bashrc
source ~/.bashrc
```

Then verify:

```bash
which arise
arise --help
```

## Create Your First Project

Interactive setup:

```bash
arise create
```

Or skip Arise configuration:

```bash
arise create --skip my_app
```

Then:

```bash
cd my_app
flutter run
```

## Update Arise

To install the latest available version:

```bash
dart pub global activate arise
```

## Uninstall

```bash
dart pub global deactivate arise
```