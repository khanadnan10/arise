import 'package:flutter_bloc/flutter_bloc.dart';

part '{{feature_name}}_event.dart';
part '{{feature_name}}_state.dart';

/// BLoC managing events and state for {{feature_name_title}}.
class {{feature_name_pascal}}Bloc
    extends Bloc<{{feature_name_pascal}}Event, {{feature_name_pascal}}State> {
  {{feature_name_pascal}}Bloc() : super(const {{feature_name_pascal}}State()) {
    on<Load{{feature_name_pascal}}>((event, emit) {
      emit(state.copyWith(isLoading: false));
    });
  }
}
