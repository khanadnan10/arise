import '../model/{{feature_name}}_model.dart';
import '../model/{{feature_name}}_repository.dart';

/// Contract implemented by the {{feature_name_title}} view.
abstract interface class {{feature_name_pascal}}ViewContract {
  void show{{feature_name_pascal}}({{feature_name_pascal}}Model item);
}

/// Presenter coordinating data and view updates for {{feature_name_title}}.
class {{feature_name_pascal}}Presenter {
  const {{feature_name_pascal}}Presenter(
    this._view, {
    {{feature_name_pascal}}Repository repository =
        const {{feature_name_pascal}}Repository(),
  }) : _repository = repository;

  final {{feature_name_pascal}}ViewContract _view;
  final {{feature_name_pascal}}Repository _repository;

  Future<void> load() async {
    final item = await _repository.fetch{{feature_name_pascal}}();
    _view.show{{feature_name_pascal}}(item);
  }
}
