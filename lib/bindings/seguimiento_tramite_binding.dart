import 'package:mre_bolivia/controllers/consulado/seguimiento_tramite_controller.dart';
import 'package:get/get.dart';

class SeguimientoTramiteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeguimientoTramiteController>(
        () => SeguimientoTramiteController());
  }
}
