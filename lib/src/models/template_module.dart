import 'template_hook.dart';
import 'template_package.dart';

class TemplateModule {
  const TemplateModule({
    required this.name,
    required this.category,
    required this.folders,
    required this.packages,
    this.description,
    this.version,
    this.author,
    this.requires = const [],
    this.conflicts = const [],
    this.variables = const {},
    this.hooks = const [],
    this.templateDir,
  });

  final String name;
  final String category;
  final String? description;
  final String? version;
  final String? author;

  final List<String> folders;
  final List<TemplatePackage> packages;

  final List<String> requires;
  final List<String> conflicts;
  final Map<String, String> variables;
  final List<TemplateHook> hooks;
  final String? templateDir;
}
