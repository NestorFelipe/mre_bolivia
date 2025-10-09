import 'package:get/get.dart';

class SharedController extends GetxController {
  // Estado compartido, e.g., usuario logueado
  RxString userName = 'Usuario'.obs;
  RxBool hasNotifications = false.obs;

  void updateUser(String name) {
    userName.value = name;
  }

  void toggleNotifications() {
    hasNotifications.value = !hasNotifications.value;
  }
}
