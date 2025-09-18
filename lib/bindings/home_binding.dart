import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/shared_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Inicializar SharedController primero
    Get.put<SharedController>(SharedController(), permanent: true);
    // Después inicializar HomeController
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}