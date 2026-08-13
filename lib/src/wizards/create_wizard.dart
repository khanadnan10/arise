import 'package:arise/src/models/architecture.dart';
import 'package:arise/src/models/networking.dart';
import 'package:arise/src/models/routing.dart';
import 'package:arise/src/models/state_management.dart';

import '../models/create_config.dart';
import '../utils/prompt.dart';

class CreateWizard {
  Future<CreateConfig> run({required bool skip, String? projectName}) async {
    if (skip) {
      if (projectName == null || projectName.isEmpty) {
        throw ArgumentError('Project name is required when using --skip.');
      }

      return CreateConfig(
        projectName: projectName,
        architecture: Architecture.none,
        stateManagement: StateManagement.none,
        routing: Routing.none,
        networking: Networking.none,
      );
    }

    final name = Prompt.ask('Project name');

    final architecture = Prompt.select(
      'Select Architecture',
      Architecture.values,
      (architecture) => architecture.label,
    );
    final stateManagement = Prompt.select(
      'Select State Management',
      StateManagement.values,
      (state) => state.label,
    );
    final routing = Prompt.select(
      'Select Routing',
      Routing.values,
      (routing) => routing.label,
    );
    final networking = Prompt.select(
      'Select Networking',
      Networking.values,
      (networking) => networking.label,
    );

    return CreateConfig(
      projectName: name,
      architecture: architecture,
      stateManagement: stateManagement,
      routing: routing,
      networking: networking,
    );
  }
}
