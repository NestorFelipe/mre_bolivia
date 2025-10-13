import 'package:get/get.dart';
import '../controllers/consulado/home_controller.dart';
import '../../controllers/shared_controller.dart';
import '../controllers/consulado/consulado_controller.dart';
import '../../services/consulado_service.dart';
import '../controllers/consulado/seguimiento_tramite_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Inicializar SharedController primero
    Get.put<SharedController>(SharedController(), permanent: true);

    // Registrar el servicio de consulado
    Get.lazyPut<ConsuladoService>(() => ConsuladoService());

    // Registrar el controlador de consulado
    Get.lazyPut<ConsuladoController>(() => ConsuladoController());

    // Registrar el controlador de seguimiento de trámites
    if (!Get.isRegistered<SeguimientoTramiteController>()) {
      Get.lazyPut<SeguimientoTramiteController>(
          () => SeguimientoTramiteController());
    }

    // Después inicializar HomeController
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}
