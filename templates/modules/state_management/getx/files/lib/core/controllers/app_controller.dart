import 'package:get/get.dart';

/// Root GetX controller for global application state.
class AppController extends GetxController {
  final isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
