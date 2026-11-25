import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Immutable UI state for {{feature_name_title}}.
class {{feature_name_pascal}}State {
  const {{feature_name_pascal}}State({this.isLoading = false});

  final bool isLoading;

  {{feature_name_pascal}}State copyWith({bool? isLoading}) {
    return {{feature_name_pascal}}State(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Riverpod notifier managing {{feature_name_title}} state.
class {{feature_name_pascal}}Notifier extends Notifier<{{feature_name_pascal}}State> {
  @override
  {{feature_name_pascal}}State build() => const {{feature_name_pascal}}State();

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }
}

final {{feature_name_camel}}Provider =
    NotifierProvider<{{feature_name_pascal}}Notifier, {{feature_name_pascal}}State>(
  {{feature_name_pascal}}Notifier.new,
);
