import 'package:get/get.dart';

/// GetX controller managing reactive state for {{feature_name_title}}.
class {{feature_name_pascal}}Controller extends GetxController {
  final isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
