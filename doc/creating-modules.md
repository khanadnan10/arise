# Creating Modules

Arise is designed so new integrations can be added primarily through template modules rather than changes to the core generator.

This guide explains how to add a new module.

## 1. Choose a Category

Modules are grouped by responsibility under:

```text
templates/modules/
```

Current categories include:

```text
architecture/
state_management/
routing/
networking/
```

For example, a new state management integration called `example_state` would live at:

```text
templates/modules/state_management/example_state/
```

## 2. Create the Module

Create:

```text
example_state/
├── config.yaml
└── files/
```

The `files/` directory can be omitted if the module does not generate files.

## 3. Configure the Module

Create:

```text
example_state/config.yaml
```

Example:

```yaml
name: Example State

folders: []

packages:
  - name: example_state
```

Keep the configuration limited to what the module actually requires.

## 4. Add Template Files

If the integration requires generated code, mirror the destination project structure inside `files/`.

For example:

```text
files/
└── lib/
    └── core/
        └── example_state.dart
```

Arise will copy it to:

```text
lib/core/example_state.dart
```

inside the generated Flutter project.

## 5. Use Template Variables

Never hardcode the generated project's package name.

Avoid:

```dart
import 'package:my_app/app.dart';
```

Use:

```dart
import 'package:{{project_name}}/app.dart';
```

Arise resolves the variable during generation.

## 6. Expose the Module

Adding a template directory alone does not necessarily make it selectable from the interactive CLI.

If the module belongs to a wizard-controlled category, update the relevant configuration/options so users can select it.

Keep this change limited to exposing the module. Technology-specific generation logic should remain inside the template whenever possible.

## 7. Add Tests

Every new module must be tested.

At minimum, verify:

```bash
dart analyze
dart test
```

The generated Flutter project must also pass:

```bash
flutter analyze
flutter test
```

For modules that interact with other modules, add the integration to the module-combination test matrix.

## 8. Test From the CLI

Don't test only `TemplateService`.

Generate a project through Arise:

```bash
arise create
```

Select the new module and verify the generated project.

This catches problems in:

```text
Wizard
   ↓
Configuration
   ↓
Template resolution
   ↓
Generation
```

## Module Checklist

Before submitting a module:

- `config.yaml` is valid
- Package requirements are minimal
- No project names are hardcoded
- Generated files use supported template variables
- No unnecessary core-generator branching was introduced
- Unit/integration tests pass
- Generated project passes `flutter analyze`
- Generated project passes `flutter test`
- Documentation is updated

## Design Rule

If adding a new integration requires a large `switch` statement or multiple technology-specific conditions inside the generation engine, reconsider the implementation.

Arise's core should know **how to apply a module**, not **how each technology works**.
