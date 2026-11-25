import '../models/{{feature_name}}_model.dart';

/// Remote data source contract and default stub for {{feature_name_title}}.
abstract interface class {{feature_name_pascal}}RemoteDataSource {
  Future<{{feature_name_pascal}}Model> fetch{{feature_name_pascal}}();
}

class {{feature_name_pascal}}RemoteDataSourceImpl
    implements {{feature_name_pascal}}RemoteDataSource {
  const {{feature_name_pascal}}RemoteDataSourceImpl();

  @override
  Future<{{feature_name_pascal}}Model> fetch{{feature_name_pascal}}() async {
    return const {{feature_name_pascal}}Model(
      id: '1',
      title: '{{feature_name_title}}',
    );
  }
}
