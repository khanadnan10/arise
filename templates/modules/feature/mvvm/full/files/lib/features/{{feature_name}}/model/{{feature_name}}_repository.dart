import '{{feature_name}}_model.dart';

/// Repository supplying {{feature_name_title}} data.
class {{feature_name_pascal}}Repository {
  const {{feature_name_pascal}}Repository();

  Future<{{feature_name_pascal}}Model> fetch{{feature_name_pascal}}() async {
    return const {{feature_name_pascal}}Model(
      id: '1',
      title: '{{feature_name_title}}',
    );
  }
}
