import '../model/{{feature_name}}_model.dart';
import '../model/{{feature_name}}_service.dart';

/// Controller handling interactions for {{feature_name_title}}.
class {{feature_name_pascal}}Controller {
  const {{feature_name_pascal}}Controller({
    {{feature_name_pascal}}Service service = const {{feature_name_pascal}}Service(),
  }) : _service = service;

  final {{feature_name_pascal}}Service _service;

  Future<{{feature_name_pascal}}Model> load() {
    return _service.fetch{{feature_name_pascal}}();
  }
}
