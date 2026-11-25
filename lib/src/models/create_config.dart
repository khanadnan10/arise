import 'package:arise/src/models/architecture.dart';
import 'package:arise/src/models/dependency_injection.dart';
import 'package:arise/src/models/lint.dart';
import 'package:arise/src/models/networking.dart';
import 'package:arise/src/models/routing.dart';
import 'package:arise/src/models/state_management.dart';
import 'package:arise/src/models/storage.dart';

class CreateConfig {
  CreateConfig({
    required this.projectName,
    required this.architecture,
    required this.stateManagement,
    required this.routing,
    required this.networking,
    this.dependencyInjection = DependencyInjection.none,
    this.storage = Storage.none,
    this.lint = Lint.none,
  });

  final String projectName;
  final Architecture architecture;
  final StateManagement stateManagement;
  final Routing routing;
  final Networking networking;
  final DependencyInjection dependencyInjection;
  final Storage storage;
  final Lint lint;
}
