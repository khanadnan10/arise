# Contributing to Arise

Thanks for your interest in contributing to Arise.

Contributions are welcome, including bug fixes, documentation improvements, new templates, tests, and improvements to the CLI.

## Development Setup

### 1. Fork and clone the repository

```bash
git clone <your-fork>
cd arise
```

### 2. Install dependencies

```bash
dart pub get
```

### 3. Run Arise locally

```bash
dart run bin/arise.dart --help
```

To test the CLI as a globally activated executable:

```bash
dart pub global activate --source path .
```

Then:

```bash
arise --help
```

## Project Structure

```text
arise/
├── bin/
├── lib/
│   └── src/
├── templates/
│   └── modules/
├── test/
├── docs/
├── README.md
└── pubspec.yaml
```

The core generation logic lives under `lib/src/`.

Project templates live under:

```text
templates/modules/
```

## Before Making Changes

Keep changes focused.

If you're fixing a bug, avoid unrelated refactors in the same pull request.

If you're adding a new integration, first determine whether it can be implemented as a template module instead of adding technology-specific logic to the core generator.

## Adding a Module

See:

```text
docs/creating-modules.md
```

A new module should include:

- Valid module configuration
- Required template files
- Required package dependencies
- Tests
- Documentation updates

## Code Quality

Format the project before submitting changes:

```bash
dart format .
```

Check static analysis:

```bash
dart analyze
```

There should be no analyzer issues.

## Testing

Run the complete test suite:

```bash
dart test
```

Changes to templates should also be verified against generated Flutter projects.

Generated projects must pass:

```bash
flutter analyze
flutter test
```

## Pull Request Checklist

Before opening a pull request:

- Code is formatted
- `dart analyze` passes
- `dart test` passes
- New behavior has tests
- Generated Flutter projects remain valid
- Documentation is updated where necessary
- No unrelated changes are included

## Commit Messages

Use clear, scoped commit messages.

Examples:

```text
feat: add new routing module
fix: resolve template package path
test: add module integration coverage
docs: document template system
refactor: simplify template generation
```

Prefer these common prefixes:

```text
feat:
fix:
docs:
test:
refactor:
chore:
```

## Reporting Bugs

When reporting a bug, include:

- Arise version
- Flutter version
- Dart version
- Operating system
- Command executed
- Expected behavior
- Actual behavior
- Relevant terminal output

For generation issues, include the configuration you selected when creating the project.

## Feature Requests

Feature requests should explain the problem being solved rather than only proposing an implementation.

For new integrations, explain:

- What integration should be supported
- Why it belongs in Arise
- Which existing modules it interacts with
- Whether it can be implemented entirely as a template module

## Design Philosophy

Keep the Arise core generic.

The engine should understand how to load, merge, and apply modules. Individual technologies should remain represented by templates whenever possible.
