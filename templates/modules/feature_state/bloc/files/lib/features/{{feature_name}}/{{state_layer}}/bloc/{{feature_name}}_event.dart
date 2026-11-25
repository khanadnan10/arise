part of '{{feature_name}}_bloc.dart';

/// Base event for [{{feature_name_pascal}}Bloc].
sealed class {{feature_name_pascal}}Event {
  const {{feature_name_pascal}}Event();
}

/// Triggers loading of {{feature_name_title}} data.
final class Load{{feature_name_pascal}} extends {{feature_name_pascal}}Event {
  const Load{{feature_name_pascal}}();
}
