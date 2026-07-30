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
}
