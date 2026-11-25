import '../models/merged_template.dart';
import '../models/template_hook.dart';
import '../models/template_package.dart';
import '../models/template_module.dart';

class TemplateMerger {
  MergedTemplate merge(List<TemplateModule> modules) {
    final loadedIds = <String>{
      for (final module in modules) ..._moduleIdentifiers(module),
    };

    for (final module in modules) {
      for (final conflict in module.conflicts) {
        if (loadedIds.contains(conflict.toLowerCase())) {
          throw StateError(
            'Module "${module.name}" conflicts with "$conflict".',
          );
        }
      }

      for (final requirement in module.requires) {
        if (!loadedIds.contains(requirement.toLowerCase())) {
          throw StateError(
            'Module "${module.name}" requires "$requirement".',
          );
        }
      }
    }

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

  Iterable<String> _moduleIdentifiers(TemplateModule module) sync* {
    yield module.name.toLowerCase();
    final dir = module.templateDir;
    if (dir != null && dir.isNotEmpty) {
      final segments = dir.split(RegExp(r'[/\\]')).where((s) => s.isNotEmpty);
      if (segments.isNotEmpty) {
        yield segments.last.toLowerCase();
      }
    }
  }
}
