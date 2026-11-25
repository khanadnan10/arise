import '../../domain/entities/{{feature_name}}_entity.dart';

/// Data transfer model for [{{feature_name_pascal}}Entity].
class {{feature_name_pascal}}Model extends {{feature_name_pascal}}Entity {
  const {{feature_name_pascal}}Model({
    required super.id,
    required super.title,
  });

  factory {{feature_name_pascal}}Model.fromJson(Map<String, dynamic> json) {
    return {{feature_name_pascal}}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
