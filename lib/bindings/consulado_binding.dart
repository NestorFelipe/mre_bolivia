import 'package:mre_bolivia/controllers/consulado/tab_home_controller.dart';
import 'package:get/get.dart';
import '../controllers/consulado/consulado_controller.dart';
import '../controllers/consulado/regiones_controller.dart';
import '../services/consulado_service.dart';
import '../services/regiones_service.dart';

class ConsultadoBinding extends Bindings {
  @override
  void dependencies() {
    // Registrar servicios
    Get.lazyPut<ConsuladoService>(() => ConsuladoService());
    Get.lazyPut<RegionesService>(() => RegionesService());

    if (!Get.isRegistered<ConsuladoController>()) {
      Get.lazyPut<ConsuladoController>(() => ConsuladoController());
    }

    if (!Get.isRegistered<RegionesController>()) {
      Get.lazyPut<RegionesController>(() => RegionesController());
    }

    if (!Get.isRegistered<TabHomeController>()) {
      Get.lazyPut<TabHomeController>(() => TabHomeController());
    }
  }
}

