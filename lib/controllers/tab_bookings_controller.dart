import 'package:get/get.dart';
import 'package:flutter/material.dart';

class TabBookingsController extends GetxController with GetSingleTickerProviderStateMixin {
  // Observable para la posición seleccionada
  RxInt position = 0.obs;

  // Controladores
  late TabController tabController;
  final PageController pageController = PageController(initialPage: 0);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    pageController.dispose();
    super.onClose();
  }

  // Cambiar página
  void changePage(int value) {
    tabController.animateTo(value);
    position.value = value;
  }

  // Cambiar tab
  void changeTab(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    position.value = index;
  }
}
