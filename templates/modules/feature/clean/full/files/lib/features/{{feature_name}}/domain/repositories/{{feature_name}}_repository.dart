import '../entities/{{feature_name}}_entity.dart';

/// Repository contract for {{feature_name_title}}.
abstract interface class {{feature_name_pascal}}Repository {
  Future<{{feature_name_pascal}}Entity> get{{feature_name_pascal}}();
}
