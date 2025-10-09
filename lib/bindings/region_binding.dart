import 'package:mi_cancilleria/controllers/consulado/tab_home_controller.dart';
import 'package:get/get.dart';

class RegionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabHomeController>(() => TabHomeController());
  }
}

