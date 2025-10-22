import 'package:get/get.dart';
import 'package:mre_bolivia/controllers/consulado/consulado_controller.dart';

class ArancelesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsuladoController>(() => ConsuladoController());
  }
}
