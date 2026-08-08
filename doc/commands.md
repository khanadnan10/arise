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

## `arise generate feature`

Generates a feature scaffold inside an existing Arise project.

Run this command from the **project root** (where `.arise.yaml` exists).

```bash
arise generate feature auth
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

The default template is `minimal`. Use `--template` to select an alternative when available:

```bash
arise generate feature auth --template minimal
```

### Feature name rules

- Must start with a lowercase letter.
- May contain lowercase letters, digits, and underscores.
- Hyphens are automatically converted to underscores (`user-profile` → `user_profile`).
- Uppercase input is automatically lowercased (`Auth` → `auth`).

### Help

```bash
arise generate feature --help
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