# Arise Architecture

Arise is designed around a modular, YAML-driven project generation system.

The CLI itself should not need to understand the implementation details of Riverpod, GoRouter, Dio, or individual Flutter architectures. Those details belong to templates.

## Generation Flow

```text
CLI
 │
 ▼
Command
 │
 ▼
Configuration / Wizard
 │
 ▼
Template Registry
 │
 ▼
Template Loader
 │
 ▼
Template Merger
 │
 ▼
Template Service
 │
 ▼
Flutter Project
```

## Commands

Commands are responsible for handling CLI input and coordinating the generation process.

```text
lib/src/command/
```

Commands should contain as little generation logic as possible.

## Wizards

Wizards collect configuration from the user during interactive commands.

For example, `arise create` can collect:

- Project name
- Architecture
- State management
- Routing
- Networking

The resulting configuration is passed to the generation layer.

## Template Loader

`TemplateLoader` reads a module's `config.yaml` and converts it into Arise's internal template model.

This keeps YAML parsing separate from project generation.

## Template Registry

`TemplateRegistry` loads the selected template modules.

A project may combine several modules, for example:

```text
Clean Architecture
+
Riverpod
+
GoRouter
+
Dio
```

## Template Merger

`TemplateMerger` combines module metadata and removes duplicate entries where appropriate.

This allows independent modules to contribute to the same generated project.

## Template Service

`TemplateService` applies templates to the Flutter project.

Its responsibilities include:

- Creating required directories
- Copying template directory trees
- Rendering template variables
- Applying module configuration

## Template Modules

Templates live under:

```text
templates/modules/
```

For example:

```text
templates/modules/
├── architecture/
├── state_management/
├── routing/
└── networking/
```

A typical module looks like:

```text
riverpod/
├── config.yaml
└── files/
```

`config.yaml` contains module metadata and package requirements.

`files/` mirrors the structure that should be copied into the generated Flutter project.

## Template Variables

Template files may contain variables:

```text
{{project_name}}
```

During generation, Arise replaces them with values from the current project.

For example:

```dart
import 'package:{{project_name}}/app.dart';
```

can become:

```dart
import 'package:my_app/app.dart';
```

## Design Principle

Arise's generation engine should remain generic.

Adding another supported technology should primarily involve adding or updating a template module rather than adding technology-specific branching throughout the CLI.

This separation keeps the core small and makes templates easier to extend and test.
