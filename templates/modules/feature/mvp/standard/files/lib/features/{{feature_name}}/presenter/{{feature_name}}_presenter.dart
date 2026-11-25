import '../model/{{feature_name}}_model.dart';

/// Contract implemented by the {{feature_name_title}} view.
abstract interface class {{feature_name_pascal}}ViewContract {
  void show{{feature_name_pascal}}({{feature_name_pascal}}Model item);
}

/// Presenter coordinating data and view updates for {{feature_name_title}}.
class {{feature_name_pascal}}Presenter {
  const {{feature_name_pascal}}Presenter(this._view);

  final {{feature_name_pascal}}ViewContract _view;

  Future<void> load() async {
    const item = {{feature_name_pascal}}Model(
      id: '1',
      title: '{{feature_name_title}}',
    );
    _view.show{{feature_name_pascal}}(item);
  }
}
