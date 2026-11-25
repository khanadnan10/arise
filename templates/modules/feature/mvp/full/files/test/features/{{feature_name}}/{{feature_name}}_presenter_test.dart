import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/features/{{feature_name}}/model/{{feature_name}}_model.dart';
import 'package:{{project_name}}/features/{{feature_name}}/presenter/{{feature_name}}_presenter.dart';

class _Fake{{feature_name_pascal}}View implements {{feature_name_pascal}}ViewContract {
  {{feature_name_pascal}}Model? received;

  @override
  void show{{feature_name_pascal}}({{feature_name_pascal}}Model item) {
    received = item;
  }
}

void main() {
  test('{{feature_name_pascal}}Presenter delivers model to view', () async {
    final view = _Fake{{feature_name_pascal}}View();
    final presenter = {{feature_name_pascal}}Presenter(view);

    await presenter.load();

    expect(view.received?.id, '1');
    expect(view.received?.title, '{{feature_name_title}}');
  });
}
