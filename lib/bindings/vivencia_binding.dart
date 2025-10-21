import 'package:get/get.dart';
import '../controllers/consulado/vivencia_controller.dart';

class VivenciaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VivenciaController>(() => VivenciaController());
  }
}
