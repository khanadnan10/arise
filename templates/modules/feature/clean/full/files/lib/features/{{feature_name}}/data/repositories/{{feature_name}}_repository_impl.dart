import '../../domain/entities/{{feature_name}}_entity.dart';
import '../../domain/repositories/{{feature_name}}_repository.dart';
import '../datasources/{{feature_name}}_remote_datasource.dart';

/// Default implementation of [{{feature_name_pascal}}Repository].
class {{feature_name_pascal}}RepositoryImpl implements {{feature_name_pascal}}Repository {
  const {{feature_name_pascal}}RepositoryImpl(this._remoteDataSource);

  final {{feature_name_pascal}}RemoteDataSource _remoteDataSource;

  @override
  Future<{{feature_name_pascal}}Entity> get{{feature_name_pascal}}() {
    return _remoteDataSource.fetch{{feature_name_pascal}}();
  }
}
