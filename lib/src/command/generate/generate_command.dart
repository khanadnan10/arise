import 'package:args/command_runner.dart';

import 'feature_command.dart';

class GenerateCommand extends Command<int> {
  GenerateCommand() {
    addSubcommand(FeatureCommand());
  }

  @override
  String get name => 'generate';

  @override
  String get description => 'Generate project resources.';

  @override
  Future<int> run() async => 0;
}
