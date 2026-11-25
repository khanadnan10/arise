import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Base application-level [ChangeNotifier] for shared UI state.
class AppState extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }
}

/// Wraps [child] with the root application providers.
Widget withAppProviders({required Widget child}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppState()),
    ],
    child: child,
  );
}
