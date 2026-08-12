# Arise

A modular CLI for bootstrapping production-ready Flutter projects.

Arise helps you create Flutter projects with your preferred architecture, state management, routing, networking, storage, and other project-level tooling without manually setting up the same structure every time.

## Why Arise?

Starting a Flutter project is easy.

Setting up a consistent project structure isn't.

Arise handles the repetitive setup while keeping the generated project transparent and fully under your control.

With Arise, you can:

- Create Flutter projects through an interactive CLI
- Choose your preferred project architecture
- Configure state management, routing, networking
- Generate architecture-aware feature scaffolds inside existing projects
- Skip configuration when you just need a standard Flutter project
- Keep project configuration in `.arise.yaml` for future Arise commands

## Quick Start

Activate Arise:

```bash
dart pub global activate arise
```

## Supported Setup

### Architecture
- Clean Architecture
- MVVM
- MVC
- MVP
- None

### State Management
- Riverpod
- Provider
- Bloc
- GetX
- None

### Routing
- GoRouter
- AutoRoute
- None

### Networking
- Dio
- None

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

Creates a new Flutter project.

```bash
arise create
```

Starts the interactive project setup.

You can also skip the configuration:

```bash
arise create --skip my_app
```

Use the command help for all available options:

```bash
arise create --help
```

### `arise generate feature`

Generates a feature scaffold inside an existing Arise project.

Run from the **project root** (where `.arise.yaml` exists):

```bash
arise generate feature auth
```

Arise reads `.arise.yaml` to determine the architecture and creates the matching layer structure:

```text
# Clean Architecture
lib/features/auth/
├── data/
├── domain/
└── presentation/

# MVVM
lib/features/auth/
├── model/
├── view/
└── viewmodel/
```

Feature names are normalised automatically:

```bash
arise generate feature User-Profile
# → creates lib/features/user_profile/
```

If the feature directory already exists, Arise refuses to overwrite it by default:

```bash
arise generate feature auth
# Feature "auth" already exists at lib/features/auth.
# Use --force to overwrite.

arise generate feature auth --force   # explicit overwrite
```

Use `--template` to select an alternative variant when available (default: `minimal`):

```bash
arise generate feature auth --template minimal
```

> **Note:** Only the `minimal` template is available in v1.1. Additional templates (`standard`, `full`) are planned for future releases.

List available feature templates and highlight active project architecture:

```bash
arise generate feature --list
```

See all options:

```bash
arise generate feature --help
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