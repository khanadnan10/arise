import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/features/{{feature_name}}/data/datasources/{{feature_name}}_remote_datasource.dart';
import 'package:{{project_name}}/features/{{feature_name}}/data/repositories/{{feature_name}}_repository_impl.dart';
import 'package:{{project_name}}/features/{{feature_name}}/domain/usecases/get_{{feature_name}}.dart';

void main() {
  test('Get{{feature_name_pascal}} returns entity from repository', () async {
    const dataSource = {{feature_name_pascal}}RemoteDataSourceImpl();
    const repository = {{feature_name_pascal}}RepositoryImpl(dataSource);
    const useCase = Get{{feature_name_pascal}}(repository);

    final entity = await useCase();

    expect(entity.id, '1');
    expect(entity.title, '{{feature_name_title}}');
  });
}
