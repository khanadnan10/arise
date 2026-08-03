import 'template_hook.dart';
import 'template_package.dart';

class MergedTemplate {
  const MergedTemplate({
    required this.folders,
    required this.packages,
    this.templateDirectories = const [],
    this.variables = const {},
    this.hooks = const [],
  });

  final List<String> folders;
  final List<TemplatePackage> packages;
  final List<String> templateDirectories;
  final Map<String, String> variables;
  final List<TemplateHook> hooks;
}
