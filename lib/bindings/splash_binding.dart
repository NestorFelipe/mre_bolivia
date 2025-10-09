import 'package:get/get.dart';
import '../controllers/consulado/splash_controller.dart';
import '../services/consulado_service.dart';
import '../services/regiones_service.dart';
import '../controllers/consulado/consulado_controller.dart';
import '../controllers/consulado/regiones_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Registrar servicios
    Get.lazyPut<ConsuladoService>(() => ConsuladoService());
    Get.lazyPut<RegionesService>(() => RegionesService());

    // Registrar controladores de datos de manera permanente
    // para que persistan durante toda la aplicación
    Get.put<ConsuladoController>(ConsuladoController(), permanent: true);
    Get.put<RegionesController>(RegionesController(), permanent: true);

    // Registrar controlador de splash
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

