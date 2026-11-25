# Arise Example

Arise is a command-line tool for bootstrapping and managing Flutter projects.

## Install

```bash
dart pub global activate arise
```

## Create a project

Start the interactive project wizard:

```bash
arise create
```

Create a project non-interactively with flags:

```bash
arise create my_app --arch clean --state riverpod --route go_router --network dio --di get_it --storage shared_preferences
```

Or create a default Flutter project:

```bash
arise create --skip my_app
```

## Generate features & add modules

```bash
cd my_app
arise gen feature auth --template full
arise add very_good_analysis
arise info
arise doctor
```

## Run the generated project

```bash
flutter pub get
flutter run
```

For all available options:

```bash
arise --help
```
