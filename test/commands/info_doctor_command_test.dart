import 'dart:io';

import 'package:arise/src/models/project_manifest.dart';
import 'package:arise/src/services/manifest_service.dart';
import 'package:test/test.dart';

final String _ariseRoot = Directory.current.path;

Future<ProcessResult> _runArise(
  List<String> args, {
  required String workingDirectory,
}) {
  return Process.run(
    'dart',
    ['run', '$_ariseRoot/bin/arise.dart', ...args],
    workingDirectory: workingDirectory,
  );
}

void main() {
  group('InfoCommand', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('arise_info_cmd_');
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('exits 1 when no .arise.yaml exists', () async {
      final result = await _runArise(['info'], workingDirectory: tempDir.path);
      expect(result.exitCode, 1);
      expect(result.stderr, contains('No Arise project found'));
    });

    test('prints project config and detected features', () async {
      await ManifestService().save(
        projectPath: tempDir.path,
        manifest: const ProjectManifest(
          version: 1,
          projectName: 'shop_app',
          architecture: 'clean',
          stateManagement: 'riverpod',
          routing: 'go_router',
          networking: 'dio',
        ),
      );
      await Directory('${tempDir.path}/lib/features/auth')
          .create(recursive: true);
      await Directory('${tempDir.path}/lib/features/cart')
          .create(recursive: true);

      final result = await _runArise(['info'], workingDirectory: tempDir.path);

      expect(result.exitCode, 0, reason: result.stderr.toString());
      expect(result.stdout, contains('shop_app'));
      expect(result.stdout, contains('clean'));
      expect(result.stdout, contains('riverpod'));
      expect(result.stdout, contains('go_router'));
      expect(result.stdout, contains('dio'));
      expect(result.stdout, contains('Features (2):'));
      expect(result.stdout, contains('auth, cart'));
    });
  });

  group('DoctorCommand', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('arise_doctor_cmd_');
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('passes outside an Arise project when toolchain is healthy', () async {
      final result = await _runArise(
        ['doctor'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 0, reason: result.stderr.toString());
      expect(result.stdout, contains('Dart SDK:'));
      expect(result.stdout, contains('Templates loaded'));
    });

    test('validates .arise.yaml when present', () async {
      await ManifestService().save(
        projectPath: tempDir.path,
        manifest: const ProjectManifest(
          version: 1,
          projectName: 'demo_app',
          architecture: 'mvvm',
          stateManagement: 'bloc',
          routing: 'go_router',
          networking: 'dio',
        ),
      );

      final result = await _runArise(
        ['doctor'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 0, reason: result.stderr.toString());
      expect(result.stdout, contains('Arise project "demo_app"'));
    });

    test('exits 1 when .arise.yaml references unknown architecture', () async {
      await ManifestService().save(
        projectPath: tempDir.path,
        manifest: const ProjectManifest(
          version: 1,
          projectName: 'broken_app',
          architecture: 'viper',
          stateManagement: 'none',
          routing: 'none',
          networking: 'none',
        ),
      );

      final result = await _runArise(
        ['doctor'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 1);
      expect(result.stdout, contains('unknown architecture "viper"'));
    });
  });

  group('CreateCommand — flags and validation', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('arise_create_flags_');
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('--help lists non-interactive options', () async {
      final result = await _runArise(
        ['create', '--help'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 0);
      expect(result.stdout, contains('--arch'));
      expect(result.stdout, contains('--state'));
      expect(result.stdout, contains('--route'));
      expect(result.stdout, contains('--network'));
      expect(result.stdout, contains('--di'));
      expect(result.stdout, contains('--storage'));
      expect(result.stdout, contains('--lint'));
    });

    test('--skip without project name exits 64', () async {
      final result = await _runArise(
        ['create', '--skip'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 64);
    });

    test('invalid --arch value exits 64', () async {
      final result = await _runArise(
        ['create', 'my_app', '--arch', 'viper'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 64);
    });

    test('invalid project name exits 64', () async {
      final result = await _runArise(
        ['create', '--skip', '../bad_name'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 64);
      expect(result.stderr, contains('Invalid project name'));
    });

    test('extra positional argument exits 64', () async {
      final result = await _runArise(
        ['create', 'my_app', 'extra_arg'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 64);
      expect(result.stderr, contains('Unexpected argument'));
    });
  });

  group('GenerateCommand — gen alias', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('arise_gen_alias_');
      await ManifestService().save(
        projectPath: tempDir.path,
        manifest: const ProjectManifest(
          version: 1,
          projectName: 'alias_app',
          architecture: 'clean',
          stateManagement: 'none',
          routing: 'none',
          networking: 'none',
        ),
      );
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('arise gen feature auth works as shorthand for generate', () async {
      final result = await _runArise(
        ['gen', 'feature', 'auth'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 0, reason: result.stderr.toString());
      expect(
        Directory('${tempDir.path}/lib/features/auth').existsSync(),
        isTrue,
      );
    });
  });

  group('AddCommand', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('arise_add_cmd_');
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('--list lists available modules', () async {
      final result = await _runArise(
        ['add', '--list'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 0, reason: result.stderr.toString());
      expect(result.stdout, contains('get_it'));
      expect(result.stdout, contains('shared_preferences'));
      expect(result.stdout, contains('very_good_analysis'));
    });

    test('rejects conflicting module against .arise.yaml', () async {
      await ManifestService().save(
        projectPath: tempDir.path,
        manifest: const ProjectManifest(
          version: 1,
          projectName: 'conflict_app',
          architecture: 'clean',
          stateManagement: 'none',
          routing: 'go_router',
          networking: 'none',
        ),
      );

      final result = await _runArise(
        ['add', 'auto_route'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 1);
      expect(result.stderr, contains('conflicts'));
    });

    test('falls back to pub.dev and requires pubspec.yaml for non-module args',
        () async {
      final result = await _runArise(
        ['add', 'equatable'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 1);
      expect(result.stderr, contains('No pubspec.yaml found'));
    });

    test('built-in module still requires .arise.yaml', () async {
      final result = await _runArise(
        ['add', 'dio'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 1);
      expect(result.stderr, contains('No Arise project found'));
    });
  });
}
