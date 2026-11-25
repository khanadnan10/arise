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

        final result = await Process.run(
          'dart',
          ['run', '$ariseRoot/bin/arise.dart', 'create', '--skip', projectName],
          workingDirectory: tempDirectory.path,
        );

        expect(result.exitCode, 0, reason: result.stderr.toString());

        expect(Directory(projectPath).existsSync(), isTrue);
        expect(File('$projectPath/pubspec.yaml').existsSync(), isTrue);
        expect(File('$projectPath/lib/main.dart').existsSync(), isTrue);

        final analyze = await Process.run(
          'flutter',
          ['analyze'],
          workingDirectory: projectPath,
        );

        expect(analyze.exitCode, 0, reason: analyze.stderr.toString());

        final tests = await Process.run(
          'flutter',
          ['test'],
          workingDirectory: projectPath,
        );

        expect(tests.exitCode, 0, reason: tests.stderr.toString());
      } finally {
        if (await tempDirectory.exists()) {
          await tempDirectory.delete(recursive: true);
        }
      }
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'arise create with non-interactive flags generates a valid wired project',
    () async {
      final tempDirectory = await Directory.systemTemp.createTemp(
        'arise_cli_flags_integration_',
      );

      const projectName = 'arise_flags_app';
      final projectPath = '${tempDirectory.path}/$projectName';

      try {
        final ariseRoot = Directory.current.path;

        final result = await Process.run(
          'dart',
          [
            'run',
            '$ariseRoot/bin/arise.dart',
            'create',
            projectName,
            '--arch',
            'clean',
            '--state',
            'riverpod',
            '--route',
            'go_router',
            '--network',
            'dio',
            '--di',
            'get_it',
            '--storage',
            'shared_preferences',
            '--lint',
            'none',
          ],
          workingDirectory: tempDirectory.path,
        );

        expect(result.exitCode, 0, reason: result.stderr.toString());
        expect(
          File('$projectPath/lib/core/network/dio_client.dart').existsSync(),
          isTrue,
        );
        expect(
          File('$projectPath/lib/core/router/app_router.dart').existsSync(),
          isTrue,
        );
        expect(
          File('$projectPath/lib/core/state/app_provider.dart').existsSync(),
          isTrue,
        );
        expect(
          File('$projectPath/lib/core/di/injection.dart').existsSync(),
          isTrue,
        );
        expect(
          File('$projectPath/lib/core/storage/local_storage.dart').existsSync(),
          isTrue,
        );
        expect(
          await File('$projectPath/lib/main.dart').readAsString(),
          allOf(
            contains('ProviderScope'),
            contains('configureDependencies'),
          ),
        );
        expect(
          await File('$projectPath/lib/app.dart').readAsString(),
          contains('MaterialApp.router'),
        );

        final analyze = await Process.run(
          'flutter',
          ['analyze'],
          workingDirectory: projectPath,
        );
        expect(analyze.exitCode, 0, reason: analyze.stderr.toString());

        final tests = await Process.run(
          'flutter',
          ['test'],
          workingDirectory: projectPath,
        );
        expect(tests.exitCode, 0, reason: tests.stderr.toString());

        // Verify `arise add <pkg>` installs from pub.dev without altering .arise.yaml
        final manifestBefore =
            await File('$projectPath/.arise.yaml').readAsString();
        final addPkg = await Process.run(
          'dart',
          ['run', '$ariseRoot/bin/arise.dart', 'add', 'equatable'],
          workingDirectory: projectPath,
        );
        expect(addPkg.exitCode, 0, reason: addPkg.stderr.toString());
        expect(
          await File('$projectPath/pubspec.yaml').readAsString(),
          contains('equatable'),
        );
        expect(
          await File('$projectPath/.arise.yaml').readAsString(),
          manifestBefore,
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
