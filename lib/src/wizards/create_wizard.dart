import '../models/create_config.dart';
import '../utils/prompt.dart';

class CreateWizard {
  Future<CreateConfig> run({required bool skip, String? projectName}) async {
    if (skip) {
      if (projectName == null || projectName.isEmpty) {
        throw ArgumentError('Project name is required when using --skip.');
      }

      return CreateConfig(projectName: projectName, architecture: 'None');
    }
    final name = Prompt.ask('Project name');

    final architecture = Prompt.select('Select Architecture', [
      'None',
      'Clean Architecture',
      'MVC',
      'MVVM',
    ]);

    return CreateConfig(projectName: name, architecture: architecture);
  }
}
