part of '{{feature_name}}_bloc.dart';

/// State emitted by [{{feature_name_pascal}}Bloc].
class {{feature_name_pascal}}State {
  const {{feature_name_pascal}}State({this.isLoading = false});

  final bool isLoading;

  {{feature_name_pascal}}State copyWith({bool? isLoading}) {
    return {{feature_name_pascal}}State(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
