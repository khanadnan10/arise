import 'package:args/command_runner.dart';

class FeatureCommand extends Command<int> {
  FeatureCommand() {
    argParser.addOption('name', abbr: 'n', help: 'Feature name');
  }

  @override
  String get name => 'feature';

  @override
  String get description => 'Generate a feature.';

  @override
  Future<int> run() async {
    final featureName = argResults?.rest.firstOrNull;

    if (featureName == null) {
      throw UsageException('Feature name is required.', usage);
    }

    print('Generating feature: $featureName');

    return 0;
  }
}
