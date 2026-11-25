import 'package:arise/src/models/architecture.dart';
import 'package:arise/src/models/dependency_injection.dart';
import 'package:arise/src/models/lint.dart';
import 'package:arise/src/models/networking.dart';
import 'package:arise/src/models/routing.dart';
import 'package:arise/src/models/state_management.dart';
import 'package:arise/src/models/storage.dart';

import '../models/create_config.dart';
import '../utils/prompt.dart';

class CreateWizard {
  Future<CreateConfig> run({
    required bool skip,
    String? projectName,
    Architecture? architecture,
    StateManagement? stateManagement,
    Routing? routing,
    Networking? networking,
    DependencyInjection? dependencyInjection,
    Storage? storage,
    Lint? lint,
  }) async {
    if (skip) {
      if (projectName == null || projectName.isEmpty) {
        throw ArgumentError('Project name is required when using --skip.');
      }

      return CreateConfig(
        projectName: projectName,
        architecture: architecture ?? Architecture.none,
        stateManagement: stateManagement ?? StateManagement.none,
        routing: routing ?? Routing.none,
        networking: networking ?? Networking.none,
        dependencyInjection: dependencyInjection ?? DependencyInjection.none,
        storage: storage ?? Storage.none,
        lint: lint ?? Lint.none,
      );
    }

    final name = (projectName != null && projectName.isNotEmpty)
        ? projectName
        : Prompt.ask('Project name');

    final selectedArchitecture = architecture ??
        Prompt.select<Architecture>(
          'Select Architecture',
          Architecture.values,
          (item) => item.label,
        );
    final selectedStateManagement = stateManagement ??
        Prompt.select<StateManagement>(
          'Select State Management',
          StateManagement.values,
          (item) => item.label,
        );
    final selectedRouting = routing ??
        Prompt.select<Routing>(
          'Select Routing',
          Routing.values,
          (item) => item.label,
        );
    final selectedNetworking = networking ??
        Prompt.select<Networking>(
          'Select Networking',
          Networking.values,
          (item) => item.label,
        );
    final selectedDi = dependencyInjection ??
        Prompt.select<DependencyInjection>(
          'Select Dependency Injection',
          DependencyInjection.values,
          (item) => item.label,
        );
    final selectedStorage = storage ??
        Prompt.select<Storage>(
          'Select Local Storage',
          Storage.values,
          (item) => item.label,
        );
    final selectedLint = lint ??
        Prompt.select<Lint>(
          'Select Linting',
          Lint.values,
          (item) => item.label,
        );

    return CreateConfig(
      projectName: name,
      architecture: selectedArchitecture,
      stateManagement: selectedStateManagement,
      routing: selectedRouting,
      networking: selectedNetworking,
      dependencyInjection: selectedDi,
      storage: selectedStorage,
      lint: selectedLint,
    );
  }
}
