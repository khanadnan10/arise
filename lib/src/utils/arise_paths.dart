import 'dart:io';
import 'dart:isolate';

class ArisePaths {
  /// Absolute path to the Arise package root.
  ///
  /// Resolves `package:arise/arise.dart` through the Dart package URI
  /// resolver — works in all invocation modes:
  ///   • `dart run bin/arise.dart`  (development)
  ///   • `dart pub global run arise` (global activation)
  ///   • compiled snapshot via `dart pub global activate`
  static String get packageRoot {
    final resolvedUri = Isolate.resolvePackageUriSync(
      Uri.parse('package:arise/arise.dart'),
    );

    if (resolvedUri == null) {
      throw StateError(
        'Unable to locate the Arise package.',
      );
    }

    // resolvedUri → file://.../arise/lib/arise.dart
    // parent      → lib/
    // parent      → package root
    final libDirectory = File.fromUri(resolvedUri).parent;
    return libDirectory.parent.path;
  }

  /// Absolute path to an architecture config.yaml.
  static String architectureTemplate(String architecture) {
    return '$packageRoot/templates/modules/architecture/'
        '$architecture/config.yaml';
  }

  /// Absolute path to a state-management config.yaml.
  static String stateManagementTemplate(String name) {
    return '$packageRoot/templates/modules/state_management/$name/config.yaml';
  }

  /// Absolute path to a routing config.yaml.
  static String routingTemplate(String name) {
    return '$packageRoot/templates/modules/routing/$name/config.yaml';
  }
}
