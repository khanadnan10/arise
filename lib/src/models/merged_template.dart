import 'template_file.dart';
import 'template_hook.dart';
import 'template_package.dart';

class MergedTemplate {
  const MergedTemplate({
    required this.folders,
    required this.packages,
    required this.files,
    this.variables = const {},
    this.hooks = const [],
  });

  final List<String> folders;
  final List<TemplatePackage> packages;
  final List<TemplateFile> files;
  final Map<String, String> variables;
  final List<TemplateHook> hooks;
}
