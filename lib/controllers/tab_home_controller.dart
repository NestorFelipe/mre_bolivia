import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../base/constant.dart';
import '../../app/routes/app_routes.dart';
import '../controllers/shared_controller.dart';

class TabHomeController extends GetxController {
  // Observable para la página seleccionada en PageView
  RxInt selectedPage = 0.obs;

  // Controlador de PageView
  final PageController pageController = PageController(initialPage: 0);

  // SharedPreferences
  SharedPreferences? sharedPreferences;

  // Controlador de búsqueda
  TextEditingController searchController = TextEditingController();

  // Estado de carga para SharedPreferences
  RxBool isPrefsReady = false.obs;

  // Inyectar SharedController
  late SharedController sharedController;

  @override
  void onInit() {
    super.onInit();
    // Asegurar que SharedController esté disponible
    if (!Get.isRegistered<SharedController>()) {
      Get.put(SharedController(), permanent: true);
    }
    sharedController = Get.find<SharedController>();
    initializeSharedPreferences();
    update(); // Reconstruir inicialmente
  }

  // Inicializar SharedPreferences
  void initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isPrefsReady.value = true;
    update(); // Para notificar cambios si es necesario
  }

  // Cambiar página en PageView
  void changePage(int page) {
    selectedPage.value = page;
    update(); // Notificar cambios para GetBuilder
  }

  // Navegar a notificaciones
  void goToNotifications() {
    Constant.sendToNext(Get.context!, Routes.notificationRoutes);
  }

  // Navegar a búsqueda
  void goToSearch() {
    Constant.sendToNext(Get.context!, Routes.searchRoute);
  }

  // Navegar a categorías
  void goToCategories() {
    Constant.sendToNext(Get.context!, Routes.categoryRoute);
  }

  // Navegar a detalle de servicio
  void goToDetail(int index) {
    sharedPreferences?.setInt("index", index);
    Constant.sendToNext(Get.context!, Routes.detailRoute);
  }

  // Navegar a detalle de categoría
  void goToCategoryDetail() {
    sharedPreferences?.setInt("index", 1);
    Constant.sendToNext(Get.context!, Routes.detailRoute);
  }
}