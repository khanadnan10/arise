import '../models/template_module.dart';
import 'template_loader.dart';

class TemplateRegistry {
  final _loader = TemplateLoader();

  Future<List<TemplateModule>> loadModules({
    required List<String> paths,
  }) async {
    final modules = <TemplateModule>[];

    for (final path in paths) {
      modules.add(await _loader.load(path));
    }

    return modules;
  }
}
