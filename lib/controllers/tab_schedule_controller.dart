import 'package:get/get.dart';

class TabScheduleController extends GetxController {
  // Observable para mostrar/ocultar schedule
  RxBool schedule = false.obs;

  // Método para hacer schedule
  void makeSchedule() {
    schedule.value = true;
  }
}
