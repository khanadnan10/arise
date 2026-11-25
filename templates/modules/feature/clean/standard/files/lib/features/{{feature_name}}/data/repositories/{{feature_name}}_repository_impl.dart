import '../../domain/entities/{{feature_name}}_entity.dart';
import '../../domain/repositories/{{feature_name}}_repository.dart';

/// Default implementation of [{{feature_name_pascal}}Repository].
class {{feature_name_pascal}}RepositoryImpl implements {{feature_name_pascal}}Repository {
  const {{feature_name_pascal}}RepositoryImpl();

  @override
  Future<{{feature_name_pascal}}Entity> get{{feature_name_pascal}}() async {
    return const {{feature_name_pascal}}Entity(
      id: '1',
      title: '{{feature_name_title}}',
    );
  }
}
