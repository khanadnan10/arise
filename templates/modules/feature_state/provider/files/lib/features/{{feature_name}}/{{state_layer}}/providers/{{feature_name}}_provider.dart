import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

/// ChangeNotifier managing state for {{feature_name_title}}.
class {{feature_name_pascal}}Provider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }
}

/// Creates a [ChangeNotifierProvider] scoped to [{{feature_name_pascal}}Provider].
ChangeNotifierProvider<{{feature_name_pascal}}Provider>
    create{{feature_name_pascal}}Provider() {
  return ChangeNotifierProvider<{{feature_name_pascal}}Provider>(
    create: (_) => {{feature_name_pascal}}Provider(),
  );
}
