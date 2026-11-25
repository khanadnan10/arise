import 'package:flutter/foundation.dart';

import '../model/{{feature_name}}_model.dart';
import '../model/{{feature_name}}_repository.dart';

/// ViewModel managing state for the {{feature_name_title}} feature.
class {{feature_name_pascal}}ViewModel extends ChangeNotifier {
  {{feature_name_pascal}}ViewModel({
    {{feature_name_pascal}}Repository repository =
        const {{feature_name_pascal}}Repository(),
  }) : _repository = repository;

  final {{feature_name_pascal}}Repository _repository;

  {{feature_name_pascal}}Model? _item;
  bool _isLoading = false;

  {{feature_name_pascal}}Model? get item => _item;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _item = await _repository.fetch{{feature_name_pascal}}();
    _isLoading = false;
    notifyListeners();
  }
}
