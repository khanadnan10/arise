import 'dart:io';

import 'package:test/test.dart';

void main() {
  test(
    'arise create --skip creates a valid Flutter project',
    () async {
      final tempDirectory = await Directory.systemTemp.createTemp(
        'arise_cli_integration_',
      );

      const projectName = 'arise_test_app';
      final projectPath = '${tempDirectory.path}/$projectName';

      try {
        final ariseRoot = Directory.current.path;

        final result = await Process.run('dart', [
          'run',
          '$ariseRoot/bin/arise.dart',
          'create',
          '--skip',
          projectName,
        ], workingDirectory: tempDirectory.path);

        expect(
          result.exitCode,
          0,
          reason:
              '''
Arise failed:

${result.stdout}
${result.stderr}
''',
        );

        expect(Directory(projectPath).existsSync(), isTrue);

        expect(File('$projectPath/pubspec.yaml').existsSync(), isTrue);

        expect(File('$projectPath/lib/main.dart').existsSync(), isTrue);

        final analyze = await Process.run('flutter', [
          'analyze',
        ], workingDirectory: projectPath);

        expect(
          analyze.exitCode,
          0,
          reason:
              '''
flutter analyze failed:

${analyze.stdout}
${analyze.stderr}
''',
        );

        final tests = await Process.run('flutter', [
          'test',
        ], workingDirectory: projectPath);

        expect(
          tests.exitCode,
          0,
          reason:
              '''
flutter test failed:

${tests.stdout}
${tests.stderr}
''',
        );
      } finally {
        if (await tempDirectory.exists()) {
          await tempDirectory.delete(recursive: true);
        }
      }
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
