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
    stdout.writeln(title);

    for (var i = 0; i < options.length; i++) {
      stdout.writeln('${i + 1}. ${label(options[i])}');
    }

    while (true) {
      stdout.write('Choice: ');

      final input = stdin.readLineSync()?.trim();
      final choice = int.tryParse(input ?? '');

      if (choice != null && choice >= 1 && choice <= options.length) {
        return options[choice - 1];
      }

      stderr.writeln('Invalid choice. Try again.');
    }
  }
}
