import 'package:get/get.dart';
import '../controllers/consulado_controller.dart';
import '../services/consulado_service.dart';

class ConsultadoBinding extends Bindings {
  @override
  void dependencies() {
    // Registrar el servicio
    Get.lazyPut<ConsultadoService>(() => ConsultadoService());
    
    // Registrar el controlador
    Get.lazyPut<ConsultadoController>(() => ConsultadoController());
  }
}