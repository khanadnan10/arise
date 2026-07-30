import 'package:arise/src/models/architecture.dart';
import 'package:arise/src/models/state_management.dart';

class CreateConfig {
  CreateConfig({
    required this.projectName,
    required this.architecture,
    required this.stateManagement,
  });

  final String projectName;
  final StateManagement stateManagement;
  final Architecture architecture;
}
