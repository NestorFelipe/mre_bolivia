import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../app/routes/app_routes.dart';

class SignUpController extends GetxController {
  // Controladores de texto
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Formateador para teléfono
  var phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+## (###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Observables
  RxBool agree = false.obs;
  RxBool isPassVisible = true.obs;

  // Método para alternar visibilidad de password
  void togglePasswordVisibility() {
    isPassVisible.value = !isPassVisible.value;
  }

  // Método para alternar agree
  void toggleAgree() {
    agree.value = !agree.value;
  }

  // Método para sign up
  void signUp() {
    // Lógica de registro (aquí simular)
    // Para poder ver el home, ir directamente a homeScreenRoute
    Get.offAllNamed(Routes.homeScreenRoute);
  }

  // Navegación a select country
  void goToSelectCountry() {
    Get.toNamed(Routes.selectCountryRoute);
  }

  // Navegación a login
  void goToLogin() {
    Get.back();
  }

  // Back
  void back() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}