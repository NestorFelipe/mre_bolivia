import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/data/data_file.dart';
import '../../app/routes/app_routes.dart';

class IntroController extends GetxController {
  // Observable para la página seleccionada
  RxInt selectedPage = 0.obs;

  // Controlador de PageView
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  // Método para cambiar página
  void onPageChanged(int value) {
    selectedPage.value = value;
  }

  // Método para ir a la siguiente página o login
  void nextPage(BuildContext context, int currentIndex) {
    if (currentIndex == DataFile.introList.length - 1) {
      // Ir a login
      Get.toNamed(Routes.loginRoute);
    } else {
      // Siguiente página
      pageController.animateToPage(
        currentIndex + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInSine,
      );
    }
  }

  // Método para saltar a login
  void skipToLogin(BuildContext context) {
    Get.toNamed(Routes.loginRoute);
  }

  // Método para volver atrás
  void backClick(BuildContext context) {
    Get.back();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
