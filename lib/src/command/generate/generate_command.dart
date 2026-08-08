import 'package:args/command_runner.dart';
import 'package:arise/src/command/generate/feature_command.dart';

class GenerateCommand extends Command<int> {
  GenerateCommand() {
    addSubcommand(FeatureCommand());
  }

  @override
  String get name => 'generate';

  @override
  String get description => 'Generate project resources.';
}
