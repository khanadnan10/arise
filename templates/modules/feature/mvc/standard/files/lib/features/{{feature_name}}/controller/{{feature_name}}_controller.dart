import '../model/{{feature_name}}_model.dart';

/// Controller handling interactions for {{feature_name_title}}.
class {{feature_name_pascal}}Controller {
  const {{feature_name_pascal}}Controller();

  Future<{{feature_name_pascal}}Model> load() async {
    return const {{feature_name_pascal}}Model(
      id: '1',
      title: '{{feature_name_title}}',
    );
  }
}
