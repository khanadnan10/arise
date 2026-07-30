import 'template_file.dart';
import 'template_hook.dart';
import 'template_package.dart';

class TemplateModule {
  const TemplateModule({
    required this.name,
    required this.category,
    required this.folders,
    required this.packages,
    required this.files,
    this.description,
    this.version,
    this.author,
    this.requires = const [],
    this.conflicts = const [],
    this.variables = const {},
    this.hooks = const [],
  });

  final String name;
  final String category;
  final String? description;
  final String? version;
  final String? author;

  final List<String> folders;
  final List<TemplatePackage> packages;
  final List<TemplateFile> files;

  final List<String> requires;
  final List<String> conflicts;
  final Map<String, String> variables;
  final List<TemplateHook> hooks;
}
