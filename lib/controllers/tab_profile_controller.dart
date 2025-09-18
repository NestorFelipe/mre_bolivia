import 'package:get/get.dart';
import '../../../base/constant.dart';
import '../../app/routes/app_routes.dart';

class TabProfileController extends GetxController {
  // Navegación a perfil
  void goToProfile() {
    Get.toNamed(Routes.profileRoute);
  }

  // Navegación a tarjetas
  void goToCards() {
    Get.toNamed(Routes.cardRoute);
  }

  // Navegación a dirección
  void goToAddress() {
    Get.toNamed(Routes.myAddressRoute);
  }

  // Navegación a configuración
  void goToSettings() {
    Get.toNamed(Routes.settingRoute);
  }

  // Logout
  void logout() {
    Constant.closeApp();
  }
}