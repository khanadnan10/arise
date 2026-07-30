import 'package:arise/src/models/architecture.dart';
import 'package:arise/src/models/routing.dart';
import 'package:arise/src/models/state_management.dart';

class CreateConfig {
  CreateConfig({
    required this.projectName,
    required this.architecture,
    required this.stateManagement,
    required this.routing,
  });

  final String projectName;
  final StateManagement stateManagement;
  final Architecture architecture;
  final Routing routing;
}
