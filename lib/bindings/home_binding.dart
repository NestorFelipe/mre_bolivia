import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/shared_controller.dart';
import '../../controllers/consulado_controller.dart';
import '../../services/consulado_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Inicializar SharedController primero
    Get.put<SharedController>(SharedController(), permanent: true);
    
    // Registrar el servicio de consulado
    Get.lazyPut<ConsultadoService>(() => ConsultadoService());
    
    // Registrar el controlador de consulado
    Get.lazyPut<ConsultadoController>(() => ConsultadoController());
    
    // Después inicializar HomeController
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}