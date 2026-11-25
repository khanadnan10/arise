import 'package:flutter/foundation.dart';

import '../model/{{feature_name}}_model.dart';

/// ViewModel managing state for the {{feature_name_title}} feature.
class {{feature_name_pascal}}ViewModel extends ChangeNotifier {
  {{feature_name_pascal}}Model? _item;
  bool _isLoading = false;

  {{feature_name_pascal}}Model? get item => _item;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _item = const {{feature_name_pascal}}Model(
      id: '1',
      title: '{{feature_name_title}}',
    );
    _isLoading = false;
    notifyListeners();
  }
}
