import 'package:get/get.dart';
import '../controllers/consulado/home_controller.dart';
import '../../controllers/shared_controller.dart';
import '../controllers/consulado/consulado_controller.dart';
import '../../services/consulado_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Inicializar SharedController primero
    Get.put<SharedController>(SharedController(), permanent: true);

    // Registrar el servicio de consulado
    Get.lazyPut<ConsuladoService>(() => ConsuladoService());

    // Registrar el controlador de consulado
    Get.lazyPut<ConsuladoController>(() => ConsuladoController());

    // Después inicializar HomeController
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}

