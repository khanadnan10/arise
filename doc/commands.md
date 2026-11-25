# Commands

Arise provides commands for creating Flutter projects and generating project resources.

## `arise`

Displays the available commands.

```bash
arise
```

or:

```bash
arise --help
```

---

## `arise create`

Creates a new Flutter project.

```bash
arise create
```

The interactive setup asks for the project name and available project configuration options:

- Architecture (Clean, MVVM, MVC, MVP, or default Flutter)
- State management (Riverpod, Provider, Bloc, GetX, or none)
- Routing (GoRouter, AutoRoute, or none)
- Networking (Dio, or none)

### Non-interactive flags

You can configure a project directly via flags without interactive prompts:

```bash
arise create my_app --arch clean --state riverpod --route go_router --network dio
```

Available flags:

- `--arch` / `-a`: `clean`, `mvvm`, `mvc`, `mvp`, `none`
- `--state`: `riverpod`, `provider`, `bloc`, `getx`, `none`
- `--route` / `-r`: `go_router`, `auto_route`, `none`
- `--network` / `-n`: `dio`, `none`
- `--di`: `get_it`, `injectable`, `none`
- `--storage`: `shared_preferences`, `none`
- `--lint`: `very_good_analysis`, `none`

### Skip interactive setup

```bash
arise create --skip my_app
```

When `--skip` is used, Arise skips the configuration wizard and creates the project using the default Flutter setup.

### Help

```bash
arise create --help
```

---

## `arise generate feature` (alias: `arise gen feature`)

Generates a feature scaffold inside an existing Arise project.

Run this command from the **project root** (where `.arise.yaml` exists).

```bash
arise generate feature auth
arise gen feature auth
```

Arise reads `.arise.yaml` to determine the project architecture and generates the matching layer structure under `lib/features/<name>/`.

**Clean Architecture output:**

```text
lib/features/auth/
├── data/
├── domain/
└── presentation/
```

**MVVM output:**

```text
lib/features/auth/
├── model/
├── view/
└── viewmodel/
```

**MVC output:**

```text
lib/features/auth/
├── controller/
├── model/
└── view/
```

**MVP output:**

```text
lib/features/auth/
├── model/
├── presenter/
└── view/
```

### Template selection

The default template is `standard`. Use `--template` (or `-t`) to choose `minimal`, `standard`, or `full`:

```bash
arise gen feature auth -t minimal
arise gen feature auth -t standard
arise gen feature auth -t full
```

- `minimal` — creates the architecture's layer directories with `.gitkeep`
- `standard` — generates core starter Dart classes for each layer (plus state-management files when configured in `.arise.yaml`)
- `full` — includes everything in `standard` plus models, data sources/services, widgets, and starter unit tests

### Overwrite protection

If a feature directory already exists, Arise will not overwrite it:

```bash
arise generate feature auth
# Feature "auth" already exists at lib/features/auth.
# Use --force to overwrite.
```

To regenerate an existing feature:

```bash
arise generate feature auth --force
```

### Feature name rules

- Must start with a lowercase letter.
- May contain lowercase letters, digits, and underscores.
- Hyphens are automatically converted to underscores (`user-profile` → `user_profile`).
- Uppercase input is automatically lowercased (`Auth` → `auth`).

### Listing available templates

List all supported feature architectures and template variants:

```bash
arise generate feature --list
```

When run inside an Arise project, it highlights your project's current architecture:

```text
Available feature templates:

  clean  ← current project
    • minimal
  mvc
    • minimal
  mvp
    • minimal
  mvvm
    • minimal
```

### Help

```bash
arise generate feature --help
```

---

## `arise add`

Adds a built-in Arise module or any `pub.dev` package to the current project:

- If the argument matches a built-in Arise module, Arise checks for conflicts, generates the module's files, installs its dependencies, runs hooks, and updates `.arise.yaml`.
- Otherwise, Arise falls back to `flutter pub add` in the background (supporting `--dev` / `-d` and multiple packages) and updates `pubspec.yaml` without modifying `.arise.yaml`.

```bash
arise add dio
arise add get_it
arise add intl
arise add --dev mockito
arise add --list
```

---

## `arise info`

Displays the configuration stored in `.arise.yaml` and lists features detected under `lib/features/`:

```bash
arise info
```

---

## `arise doctor`

Verifies Dart SDK, Flutter SDK, Arise template availability, and `.arise.yaml` validity:

```bash
arise doctor
```

---

## Exit Codes

Arise uses standard process exit codes:

| Code | Meaning |
| --- | --- |
| `0` | Command completed successfully |
| `1` | Command failed |
| `64` | Invalid command-line usage |

This allows Arise commands to be used in scripts and CI pipelines.