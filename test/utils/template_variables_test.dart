import 'package:arise/src/utils/template_variables.dart';
import 'package:test/test.dart';

void main() {
  group('TemplateVariables', () {
    test('toPascalCase converts snake_case and kebab-case', () {
      expect(TemplateVariables.toPascalCase('auth'), 'Auth');
      expect(TemplateVariables.toPascalCase('user_profile'), 'UserProfile');
      expect(TemplateVariables.toPascalCase('user-profile'), 'UserProfile');
    });

    test('toCamelCase converts identifiers', () {
      expect(TemplateVariables.toCamelCase('auth'), 'auth');
      expect(TemplateVariables.toCamelCase('user_profile'), 'userProfile');
    });

    test('toTitleCase converts identifiers', () {
      expect(TemplateVariables.toTitleCase('auth'), 'Auth');
      expect(TemplateVariables.toTitleCase('user_profile'), 'User Profile');
    });

    test('expand adds pascal, camel, and title variants', () {
      final result = TemplateVariables.expand({
        'project_name': 'my_app',
        'feature_name': 'user_profile',
      });

      expect(result['project_name_pascal'], 'MyApp');
      expect(result['project_name_camel'], 'myApp');
      expect(result['project_name_title'], 'My App');
      expect(result['feature_name_pascal'], 'UserProfile');
      expect(result['feature_name_camel'], 'userProfile');
      expect(result['feature_name_title'], 'User Profile');
    });

    test('expand preserves explicit overrides', () {
      final result = TemplateVariables.expand({
        'feature_name': 'auth',
        'feature_name_title': 'Authentication',
      });

      expect(result['feature_name_title'], 'Authentication');
      expect(result['feature_name_pascal'], 'Auth');
    });
  });
}
