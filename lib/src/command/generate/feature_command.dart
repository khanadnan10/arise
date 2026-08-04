import 'package:args/command_runner.dart';

class FeatureCommand extends Command<int> {
  @override
  String get name => 'feature';

  @override
  String get description => 'Generate a feature.';

  @override
  Future<int> run() async {
    final arguments = argResults?.rest ?? [];

    if (arguments.isEmpty) {
      usageException('A feature name is required.');
    }

    final featureName = arguments.first;

    print('Generating feature: $featureName');

    return 0;
  }
}
