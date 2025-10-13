import 'package:get/get.dart';
import 'package:mi_cancilleria/controllers/consulado/consulado_controller.dart';

class ArancelesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsuladoController>(() => ConsuladoController());
  }
}
