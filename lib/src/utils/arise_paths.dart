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
      throw StateError('Unable to locate the Arise package.');
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

  /// Absolute path to a networking config.yaml.
  static String networkingTemplate(String name) {
    return '$packageRoot/templates/modules/networking/$name/config.yaml';
  }

  /// Absolute path to a dependency-injection config.yaml.
  static String dependencyInjectionTemplate(String name) {
    return '$packageRoot/templates/modules/dependency_injection/$name/config.yaml';
  }

  /// Absolute path to a storage config.yaml.
  static String storageTemplate(String name) {
    return '$packageRoot/templates/modules/storage/$name/config.yaml';
  }

  /// Absolute path to a lint config.yaml.
  static String lintTemplate(String name) {
    return '$packageRoot/templates/modules/lint/$name/config.yaml';
  }

  /// Supported addable module categories in `arise add`.
  static const List<String> addableCategories = [
    'state_management',
    'routing',
    'networking',
    'dependency_injection',
    'storage',
    'lint',
  ];

  /// Lists available modules per addable category on disk.
  static Map<String, List<String>> availableModulesByCategory() {
    final result = <String, List<String>>{};
    for (final category in addableCategories) {
      final dir = Directory('$packageRoot/templates/modules/$category');
      if (!dir.existsSync()) continue;
      final modules = dir
          .listSync()
          .whereType<Directory>()
          .where((d) => File('${d.path}/config.yaml').existsSync())
          .map((d) => d.uri.pathSegments.where((s) => s.isNotEmpty).last)
          .toList()
        ..sort();
      if (modules.isNotEmpty) {
        result[category] = modules;
      }
    }
    return result;
  }

  /// Resolves a module name to `(category, configPath)` if it exists on disk.
  static ({String category, String configPath})? findModule(String name) {
    for (final category in addableCategories) {
      final configPath =
          '$packageRoot/templates/modules/$category/$name/config.yaml';
      if (File(configPath).existsSync()) {
        return (category: category, configPath: configPath);
      }
    }
    return null;
  }

  /// Absolute path to a feature config.yaml.
  static String featureTemplate(
    String architecture, [
    String template = 'standard',
  ]) {
    return '$packageRoot/templates/modules/feature/$architecture/$template/config.yaml';
  }

  /// Absolute path to a state-management feature overlay config.yaml.
  static String featureStateTemplate(String stateManagement) {
    return '$packageRoot/templates/modules/feature_state/$stateManagement/config.yaml';
  }

  /// Lists available template names for a given architecture by reading
  /// the template directory on disk — never hardcoded.
  static List<String> featureTemplates(String architecture) {
    final root = Directory(
      '$packageRoot/templates/modules/feature/$architecture',
    );

    if (!root.existsSync()) return [];

    return root
        .listSync()
        .whereType<Directory>()
        .map((d) => d.uri.pathSegments.where((s) => s.isNotEmpty).last)
        .toList()
      ..sort();
  }

  /// Lists available feature architectures by reading the template
  /// directory on disk — never hardcoded.
  static List<String> featureArchitectures() {
    final root = Directory('$packageRoot/templates/modules/feature');

    if (!root.existsSync()) return [];

    return root
        .listSync()
        .whereType<Directory>()
        .map((d) => d.uri.pathSegments.where((s) => s.isNotEmpty).last)
        .toList()
      ..sort();
  }
}
