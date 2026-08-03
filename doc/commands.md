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

The interactive setup asks for the project name and available project configuration options.

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

## `arise generate`

Generates resources inside a project.

```bash
arise generate --help
```

Available generators are shown by the CLI.

---

## Exit Codes

Arise uses standard process exit codes:

| Code | Meaning |
| --- | --- |
| `0` | Command completed successfully |
| `1` | Command failed |

This allows Arise commands to be used in scripts and CI pipelines.