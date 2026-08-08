class FeatureName {
  static String normalize(String input) {
    return input.trim().toLowerCase().replaceAll('-', '_');
  }

  static bool isValid(String name) {
    return RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name);
  }
}
