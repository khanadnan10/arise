import 'dart:io';

class Prompt {
  static String ask(String message) {
    stdout.write('$message: ');
    return stdin.readLineSync()?.trim() ?? '';
  }

  static bool confirm(String message, {bool defaultValue = true}) {
    final defaultOption = defaultValue ? 'Y/n' : 'y/N';

    stdout.write('$message [$defaultOption]: ');

    final input = stdin.readLineSync()?.trim().toLowerCase();

    if (input == null || input.isEmpty) {
      return defaultValue;
    }

    return input == 'y' || input == 'yes';
  }

  static T select<T>(String title, List<T> options, String Function(T) label) {
    var cursor = 0;

    stdout.writeln(title);
    stdout.writeln('\x1B[2m↑/↓ to navigate  Space/Enter to select\x1B[0m');

    _renderMenu(options, label, cursor);

    stdin.echoMode = false;
    stdin.lineMode = false;

    try {
      while (true) {
        final byte = stdin.readByteSync();

        if (byte == 27) {
          // ESC sequence — read next two bytes for arrow keys
          final second = stdin.readByteSync();
          if (second == 91) {
            final arrow = stdin.readByteSync();
            if (arrow == 65 && cursor > 0) {
              // ↑
              cursor--;
              _rerender(options, label, cursor);
            } else if (arrow == 66 && cursor < options.length - 1) {
              // ↓
              cursor++;
              _rerender(options, label, cursor);
            }
          }
        } else if (byte == 32 || byte == 10 || byte == 13) {
          // Space or Enter — confirm selection
          _clearMenu(options.length);
          stdout.writeln(
            '${_cyan("?")} $title  ${_bold(label(options[cursor]))}',
          );
          return options[cursor];
        }
      }
    } finally {
      stdin.echoMode = true;
      stdin.lineMode = true;
    }
  }

  // ─── Private ────────────────────────────────────────────────────────────────

  static void _renderMenu<T>(
    List<T> options,
    String Function(T) label,
    int cursor,
  ) {
    for (var i = 0; i < options.length; i++) {
      if (i == cursor) {
        stdout.writeln('  ${_cyan("❯")} ${_bold(label(options[i]))}');
      } else {
        stdout.writeln('    ${label(options[i])}');
      }
    }
  }

  static void _rerender<T>(
    List<T> options,
    String Function(T) label,
    int cursor,
  ) {
    // Move cursor up N lines then clear to end of screen
    stdout.write('\x1B[${options.length}A\x1B[0J');
    _renderMenu(options, label, cursor);
  }

  static void _clearMenu(int count) {
    // +1 for the hint line
    stdout.write('\x1B[${count + 1}A\x1B[0J');
  }

  static String _cyan(String s) => '\x1B[36m$s\x1B[0m';
  static String _bold(String s) => '\x1B[1m$s\x1B[0m';
}
