import 'package:arise/src/models/architecture.dart';
import 'package:arise/src/models/networking.dart';
import 'package:arise/src/models/routing.dart';
import 'package:arise/src/models/state_management.dart';

class CreateConfig {
  CreateConfig({
    required this.projectName,
    required this.architecture,
    required this.stateManagement,
    required this.routing,
    required this.networking,
  });

  final String projectName;
  final Architecture architecture;
  final StateManagement stateManagement;
  final Routing routing;
  final Networking networking;
}
