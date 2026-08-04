# Arise Example

Arise is a command-line tool for bootstrapping Flutter projects.

## Install

```bash
dart pub global activate arise
```

## Create a project

Start the interactive project wizard:

```bash
arise create
```

Or create a project non-interactively using the default configuration:

```bash
arise create --skip my_app
```

## Run the generated project

```bash
cd my_app
flutter pub get
flutter run
```

For all available options:

```bash
arise --help
```
