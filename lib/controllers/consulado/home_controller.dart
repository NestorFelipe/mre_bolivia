import 'package:mi_cancilleria/app/view/home/tab/tab_aranceles.dart';
import 'package:mi_cancilleria/app/view/home/tab/tab_seguimiento_tramite.dart';
import 'package:mi_cancilleria/app/view/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../base/constant.dart';
import '../shared_controller.dart';
import '../../../app/view/home/tab/tab_home.dart';

class HomeController extends GetxController {
  // Observable para la posición seleccionada
  RxInt position = 0.obs;

  // Lista de tabs (se pasa desde el widget)
  RxList<Widget> tabList = <Widget>[].obs;

  // Lista de íconos
  List<String> itemList = [
    "home.svg",
    "chat.svg",
    "paint_roller.svg",
    "profile.svg"
  ];

  List<String> itemLabel = ["Inicio", "Aranceles", "Seguimiento", "Vivencia"];

  // Inyectar SharedController
  late SharedController sharedController;
  late SeguimientoTramite seguimientoTramiteController;

  @override
  void onInit() {
    super.onInit();

    // Asegurar que SharedController esté disponible
    if (!Get.isRegistered<SharedController>()) {
      Get.put(SharedController(), permanent: true);
    }
    sharedController = Get.find<SharedController>();

    if (!Get.isRegistered<SeguimientoTramite>()) {
      Get.put(SeguimientoTramite(), permanent: true);
    }
    seguimientoTramiteController = Get.find<SeguimientoTramite>();

    // Inicializar tabList aquí para reactividad
    tabList.assignAll([
      const TabHome(),
      const Aranceles(),
      const SeguimientoTramite(),
      const LoginScreen(),
    ]);

    update(); // Forzar actualización inicial
  }

  // Inicializar con índice
  void initialize(int initialIndex) {
    position.value = initialIndex;
    // tabList ya asignado en onInit
  }

  // Cambiar posición
  void changePosition(int newPosition) {
    position.value = newPosition;
  }

  // Cerrar app
  void closeApp() {
    Constant.closeApp();
  }
}
