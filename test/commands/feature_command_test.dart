import 'dart:io';

import 'package:arise/src/models/project_manifest.dart';
import 'package:arise/src/services/manifest_service.dart';
import 'package:test/test.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Absolute path to the Arise repo root, resolved once for all tests.
final String _ariseRoot = Directory.current.path;

/// Runs `dart run bin/arise.dart generate feature <args>` from [workingDirectory].
Future<ProcessResult> _runFeature(
  List<String> args, {
  required String workingDirectory,
}) {
  return Process.run(
    'dart',
    ['run', '$_ariseRoot/bin/arise.dart', 'generate', 'feature', ...args],
    workingDirectory: workingDirectory,
  );
}

/// Seeds a minimal `.arise.yaml` so the command sees an Arise project.
Future<void> _seedManifest(
  String projectPath, {
  String architecture = 'clean',
}) async {
  await ManifestService().save(
    projectPath: projectPath,
    manifest: ProjectManifest(
      version: 1,
      projectName: 'test_app',
      architecture: architecture,
      stateManagement: 'none',
      routing: 'none',
      networking: 'none',
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // Argument validation — these are caught before any I/O
  // -------------------------------------------------------------------------
  group('FeatureCommand — argument validation', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('arise_cmd_args_');
      await _seedManifest(tempDir.path);
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('no feature name → exit 64', () async {
      final result = await _runFeature([], workingDirectory: tempDir.path);
      expect(result.exitCode, 64);
    });

    test('path traversal (../auth) → exit 64 with message', () async {
      final result = await _runFeature(
        ['../auth'],
        workingDirectory: tempDir.path,
      );
      expect(result.exitCode, 64);
      expect(result.stderr, contains('Invalid feature name'));
    });

    test('starts with digit (2fa) → exit 64 with message', () async {
      final result = await _runFeature(
        ['2fa'],
        workingDirectory: tempDir.path,
      );
      expect(result.exitCode, 64);
      expect(result.stderr, contains('Invalid feature name'));
    });

    test('special characters (@auth) → exit 64 with message', () async {
      final result = await _runFeature(
        ['@auth'],
        workingDirectory: tempDir.path,
      );
      expect(result.exitCode, 64);
      expect(result.stderr, contains('Invalid feature name'));
    });

    test('slash in name (auth/foo) → exit 64 with message', () async {
      final result = await _runFeature(
        ['auth/foo'],
        workingDirectory: tempDir.path,
      );
      expect(result.exitCode, 64);
      expect(result.stderr, contains('Invalid feature name'));
    });

    test('space in name (auth feature) → exit 64 with message', () async {
      final result = await _runFeature(
        ['auth feature'],
        workingDirectory: tempDir.path,
      );
      expect(result.exitCode, 64);
      expect(result.stderr, contains('Invalid feature name'));
    });
  });

  // -------------------------------------------------------------------------
  // Input normalization — valid after normalize(), must not exit 64
  // -------------------------------------------------------------------------
  group('FeatureCommand — input normalization', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('arise_cmd_norm_');
      await _seedManifest(tempDir.path);
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('uppercase input (Auth) → generates auth/', () async {
      final result = await _runFeature(
        ['Auth'],
        workingDirectory: tempDir.path,
      );
      expect(result.exitCode, 0, reason: result.stderr.toString());
      expect(
        Directory('${tempDir.path}/lib/features/auth').existsSync(),
        isTrue,
      );
    });

    test('hyphenated input (user-profile) → generates user_profile/', () async {
      final result = await _runFeature(
        ['user-profile'],
        workingDirectory: tempDir.path,
      );
      expect(result.exitCode, 0, reason: result.stderr.toString());
      expect(
        Directory('${tempDir.path}/lib/features/user_profile').existsSync(),
        isTrue,
      );
    });

    test('mixed case hyphen (User-Profile) → generates user_profile/', () async {
      final result = await _runFeature(
        ['User-Profile'],
        workingDirectory: tempDir.path,
      );
      expect(result.exitCode, 0, reason: result.stderr.toString());
      expect(
        Directory('${tempDir.path}/lib/features/user_profile').existsSync(),
        isTrue,
      );
    });
  });

  // -------------------------------------------------------------------------
  // Manifest detection
  // -------------------------------------------------------------------------
  group('FeatureCommand — manifest detection', () {
    test('no .arise.yaml → exit 1 with clear message', () async {
      final dir = await Directory.systemTemp.createTemp('arise_no_manifest_');
      addTearDown(() => dir.delete(recursive: true));

      final result = await _runFeature(
        ['auth'],
        workingDirectory: dir.path,
      );
      expect(result.exitCode, 1);
      expect(result.stderr, contains('No Arise project found'));
      expect(result.stderr, contains('created with Arise'));
    });
  });

  // -------------------------------------------------------------------------
  // Template resolution
  // -------------------------------------------------------------------------
  group('FeatureCommand — template resolution', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('arise_cmd_tmpl_');
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('unsupported architecture → exit 1 with "not found" message', () async {
      await _seedManifest(tempDir.path, architecture: 'viper');

      final result = await _runFeature(
        ['auth'],
        workingDirectory: tempDir.path,
      );
      expect(result.exitCode, 1);
      expect(result.stderr, contains('not found'));
    });

    test('unknown --template value → exit 1, lists available templates',
        () async {
      await _seedManifest(tempDir.path);

      final result = await _runFeature(
        ['auth', '--template', 'full'],
        workingDirectory: tempDir.path,
      );
      expect(result.exitCode, 1);
      expect(result.stderr, contains('not found'));
      expect(result.stderr, contains('Available:'));
      expect(result.stderr, contains('minimal'));
    });
  });

  // -------------------------------------------------------------------------
  // Happy path — end-to-end through the real CLI binary
  // -------------------------------------------------------------------------
  group('FeatureCommand — happy path', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('arise_cmd_happy_');
      await _seedManifest(tempDir.path);
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('generates clean feature with data / domain / presentation', () async {
      final result = await _runFeature(
        ['auth'],
        workingDirectory: tempDir.path,
      );

      expect(result.exitCode, 0, reason: result.stderr.toString());
      expect(result.stdout, contains('✅'));

      final root = '${tempDir.path}/lib/features/auth';
      expect(Directory('$root/data').existsSync(), isTrue);
      expect(Directory('$root/domain').existsSync(), isTrue);
      expect(Directory('$root/presentation').existsSync(), isTrue);
    });

    test('explicit --template minimal behaves same as default', () async {
      final result = await _runFeature(
        ['auth', '--template', 'minimal'],
        workingDirectory: tempDir.path,
      );
      expect(result.exitCode, 0, reason: result.stderr.toString());
      expect(
        Directory('${tempDir.path}/lib/features/auth').existsSync(),
        isTrue,
      );
    });

    test('output includes architecture name and template name', () async {
      final result = await _runFeature(
        ['auth'],
        workingDirectory: tempDir.path,
      );
      expect(result.stdout, contains('clean'));
      expect(result.stdout, contains('minimal'));
    });

    test('second run on same feature name is idempotent (exit 0)', () async {
      for (var i = 0; i < 2; i++) {
        final result = await _runFeature(
          ['auth'],
          workingDirectory: tempDir.path,
        );
        expect(result.exitCode, 0, reason: 'Run ${i + 1} failed');
      }
    });

    for (final arch in ['mvvm', 'mvc', 'mvp']) {
      test('$arch architecture generates correct layers', () async {
        final dir = await Directory.systemTemp.createTemp('arise_cmd_${arch}_');
        addTearDown(() => dir.delete(recursive: true));
        await _seedManifest(dir.path, architecture: arch);

        final result = await _runFeature(
          ['auth'],
          workingDirectory: dir.path,
        );
        expect(result.exitCode, 0, reason: result.stderr.toString());

        final featureRoot = '${dir.path}/lib/features/auth';
        final expectedLayers = switch (arch) {
          'mvvm' => ['model', 'view', 'viewmodel'],
          'mvc'  => ['model', 'view', 'controller'],
          'mvp'  => ['model', 'view', 'presenter'],
          _      => <String>[],
        };

        for (final layer in expectedLayers) {
          expect(
            Directory('$featureRoot/$layer').existsSync(),
            isTrue,
            reason: '$arch feature missing $layer/',
          );
        }
      });
    }
  });
}
