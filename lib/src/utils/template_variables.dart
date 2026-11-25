/// Utilities for expanding template variables with case variants.
class TemplateVariables {
  /// Converts a snake_case or kebab-case identifier into `PascalCase`.
  static String toPascalCase(String input) {
    return _splitWords(input)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join();
  }

  /// Converts a snake_case or kebab-case identifier into `camelCase`.
  static String toCamelCase(String input) {
    final pascal = toPascalCase(input);
    if (pascal.isEmpty) return '';
    return pascal[0].toLowerCase() + pascal.substring(1);
  }

  /// Converts a snake_case or kebab-case identifier into `Title Case`.
  static String toTitleCase(String input) {
    return _splitWords(input)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  /// Expands known identifier variables (`project_name`, `feature_name`) with
  /// `_pascal`, `_camel`, and `_title` variants without overwriting explicit keys.
  static Map<String, String> expand(Map<String, String> variables) {
    final expanded = Map<String, String>.from(variables);

    for (final key in ['project_name', 'feature_name']) {
      final value = variables[key];
      if (value == null || value.isEmpty) continue;

      expanded.putIfAbsent('${key}_pascal', () => toPascalCase(value));
      expanded.putIfAbsent('${key}_camel', () => toCamelCase(value));
      expanded.putIfAbsent('${key}_title', () => toTitleCase(value));
    }

    return expanded;
  }

  static List<String> _splitWords(String input) {
    return input
        .trim()
        .split(RegExp(r'[_\-\s]+'))
        .where((w) => w.isNotEmpty)
        .toList();
  }
}
