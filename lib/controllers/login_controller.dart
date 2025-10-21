import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_routes.dart';
import '../base/pref_data.dart';

class LoginController extends GetxController {
  // Controladores de texto
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Observable para mostrar/ocultar password
  RxBool isPassVisible = true.obs;

  // Método para alternar visibilidad de password
  void togglePasswordVisibility() {
    isPassVisible.value = !isPassVisible.value;
  }

  // Método de login
  void login() {
    // Lógica de autenticación (aquí solo simular)
    PrefData.setLogIn(true);
    // Navegar a home usando GetX
    Get.offAllNamed(Routes.signupRoute);
  }

  // Navegación a forgot password
  void goToForgotPassword() {
    Get.toNamed(Routes.forgotRoute);
  }

  // Navegación a sign up
  void goToSignUp() {
    Get.toNamed(Routes.signupRoute);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
