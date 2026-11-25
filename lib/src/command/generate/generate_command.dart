import 'package:args/command_runner.dart';
import 'package:arise/src/command/generate/feature_command.dart';

class GenerateCommand extends Command<int> {
  GenerateCommand() {
    addSubcommand(FeatureCommand());
  }

  @override
  String get name => 'generate';

  @override
  List<String> get aliases => const ['gen'];

  @override
  String get description => 'Generate resources inside an Arise project.\n'
      '\n'
      'Example:\n'
      '  arise generate feature auth\n'
      '  arise gen feature auth';
}
