import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/features/{{feature_name}}/viewmodel/{{feature_name}}_viewmodel.dart';

void main() {
  test('{{feature_name_pascal}}ViewModel loads item', () async {
    final viewModel = {{feature_name_pascal}}ViewModel();

    await viewModel.load();

    expect(viewModel.isLoading, isFalse);
    expect(viewModel.item?.title, '{{feature_name_title}}');
  });
}
