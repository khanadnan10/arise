import '../entities/{{feature_name}}_entity.dart';
import '../repositories/{{feature_name}}_repository.dart';

/// Fetches {{feature_name_title}} data through [{{feature_name_pascal}}Repository].
class Get{{feature_name_pascal}} {
  const Get{{feature_name_pascal}}(this._repository);

  final {{feature_name_pascal}}Repository _repository;

  Future<{{feature_name_pascal}}Entity> call() {
    return _repository.get{{feature_name_pascal}}();
  }
}
