import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/features/{{feature_name}}/controller/{{feature_name}}_controller.dart';

void main() {
  test('{{feature_name_pascal}}Controller loads model', () async {
    const controller = {{feature_name_pascal}}Controller();

    final item = await controller.load();

    expect(item.id, '1');
    expect(item.title, '{{feature_name_title}}');
  });
}
