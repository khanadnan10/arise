import '{{feature_name}}_model.dart';

/// Service fetching data for {{feature_name_title}}.
class {{feature_name_pascal}}Service {
  const {{feature_name_pascal}}Service();

  Future<{{feature_name_pascal}}Model> fetch{{feature_name_pascal}}() async {
    return const {{feature_name_pascal}}Model(
      id: '1',
      title: '{{feature_name_title}}',
    );
  }
}
