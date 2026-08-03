import '../models/merged_template.dart';
import '../models/template_hook.dart';
import '../models/template_package.dart';
import '../models/template_module.dart';

class TemplateMerger {
  MergedTemplate merge(List<TemplateModule> modules) {
    final folders = <String>{};
    final packages = <String, TemplatePackage>{};
    final templateDirectories = <String>[];
    final variables = <String, String>{};
    final hooks = <TemplateHook>[];

    for (final module in modules) {
      folders.addAll(module.folders);
      variables.addAll(module.variables);
      hooks.addAll(module.hooks);

      if (module.templateDir != null) {
        templateDirectories.add(module.templateDir!);
      }

      for (final package in module.packages) {
        packages[package.name] = package;
      }
    }

    return MergedTemplate(
      folders: folders.toList(),
      packages: packages.values.toList(),
      templateDirectories: templateDirectories,
      variables: variables,
      hooks: hooks,
    );
  }
}
