import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_cancilleria/app/models/consulado/model_jwt.dart';
import 'package:mi_cancilleria/app/models/consulado/model_lista_vivencia.dart';
import 'package:mi_cancilleria/app/models/consulado/model_periodos_vigente.dart';
import 'package:mi_cancilleria/app/models/consulado/model_response_auth.dart';
import 'package:mi_cancilleria/app/routes/app_routes.dart';
import 'package:mi_cancilleria/base/pref_data.dart';
import 'package:mi_cancilleria/services/vivencias_service.dart';

class VivenciaController extends GetxController {
  // Observable para verificar si el usuario está logueado
  RxBool isLoggedIn = false.obs;
  RxBool isDetalle = false.obs;
  Rx<Vivencia?> selectedVivencia = null.obs;

  // Controladores de texto
  TextEditingController ciController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Observable para mostrar/ocultar password
  RxBool isPassVisible = true.obs;
  RxBool isNewCertificado = false.obs;

  RxList<Vivencia> vivencias = <Vivencia>[].obs;
  RxList<Periodo> periodos = <Periodo>[].obs;
  Rx<Periodo?> selectedPeriodo = Periodo().obs;
  RxString usuario = ''.obs;
  RxString cedula = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Verificar estado de login al inicializar
    checkLoginStatus();
  }

  // Verificar si el usuario está logueado
  Future<void> checkLoginStatus() async {
    bool loggedIn = await PrefData.isLogIn();
    isLoggedIn.value = loggedIn;

    // Si está logueado, verificar que tenga datos de usuario
    if (loggedIn) {
      final usuarioGuardado = await PrefData.getUsuario();
      final ciGuardada = await PrefData.getCi();

      // Si no hay usuario o CI guardados, hacer logout
      if (usuarioGuardado.isEmpty || ciGuardada.isEmpty) {
        logout();
        return;
      }

      // Cargar datos del usuario
      usuario.value = usuarioGuardado;
      cedula.value = ciGuardada;
    }
  }

  // Método para alternar visibilidad de password
  void togglePasswordVisibility() {
    isPassVisible.value = !isPassVisible.value;
  }

  // Método de login
  Future<ModelResponseAuth> login() async {
    final ci = ciController.text.trim();
    final password = passwordController.text;

    try {
      final result = await VivenciasService().authVivencia(ci, password);

      if (result.token == "" || result.token == null) {
        Get.snackbar('Error',
            'Credenciales inválidas, por favor verifique el nro de CI y contraseña y vuelva a intentar.',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        final jwt = parseJwt(result.token!);

        await PrefData.setCi(ci);
        await PrefData.setToken(result.token!);
        await PrefData.setIdPersona(jwt.idPersona);
        await PrefData.setExpire(result.expiration!);
        isDetalle.value = false;
        isNewCertificado.value = false;

        cedula.value = ci;
      }

      return result;
    } catch (e) {
      // Propagar el error para que la UI lo maneje
      rethrow;
    }
  }

  Future<ListaVivenciaResponse> getUserInfo() async {
    final idPersona = await PrefData.getIdPersona();
    final token = await PrefData.getToken();

    try {
      final result = await VivenciasService().getInfoUser(token, idPersona);

      if (!result.existosa!) {
        Get.snackbar('Información',
            'No se encontró información de vivencia para el usuario.',
            backgroundColor: const Color.fromARGB(255, 1, 49, 88),
            colorText: Colors.white);
      }

      PrefData.setReg(result.paginado!.totalRegistros);

      if (result.lista != null && result.lista!.isNotEmpty) {
        PrefData.setUsuario(result.lista!.first.nombreCompleto);
        usuario.value = result.lista!.first.nombreCompleto;
      }

      return result;
    } catch (e) {
      // Propagar el error para que la UI lo maneje
      rethrow;
    }
  }

  Future<ModelPeriodosVigente> getPeriodoVigente() async {
    final idPersona = await PrefData.getIdPersona();
    final token = await PrefData.getToken();

    try {
      final result =
          await VivenciasService().getPeriodoVigente(token, idPersona);

      if (result.lista.isEmpty) {
        Get.snackbar('Información',
            'No se encontró información de periodo vigente para el usuario.',
            backgroundColor: const Color.fromARGB(255, 1, 49, 88),
            colorText: Colors.white);
      }

      if (result.lista.isNotEmpty) {
        periodos.value = result.lista;
      }

      await PrefData.setLogIn(true);
      isLoggedIn.value = true;

      return result;
    } catch (e) {
      // Propagar el error para que la UI lo maneje
      rethrow;
    }
  }

  Future<ListaVivenciaResponse> getListaVivencia() async {
    final idPersona = await PrefData.getIdPersona();
    final token = await PrefData.getToken();
    final reg = await PrefData.getReg();

    try {
      final result =
          await VivenciasService().getLitaVivencia(reg, token, idPersona);

      if (!result.existosa!) {
        Get.snackbar('Información',
            'No se encontró información de vivencia para el usuario.',
            backgroundColor: const Color.fromARGB(255, 1, 49, 88),
            colorText: Colors.white);
      }

      if (result.lista != null && result.lista!.isNotEmpty) {
        vivencias.value = result.lista!;
        isDetalle.value = true;
      }

      return result;
    } catch (e) {
      // Propagar el error para que la UI lo maneje
      rethrow;
    }
  }

  // Método de logout
  void logout() {
    PrefData.setLogIn(false);
    isLoggedIn.value = false;
    ciController.clear();
    passwordController.clear();
    PrefData.clearPref();
  }

  Future<String> getCi() async {
    return await PrefData.getCi();
  }

  Future<String> getUsuario() async {
    return await PrefData.getUsuario();
  }

  // Navegación a forgot password
  void goToForgotPassword() {
    Get.toNamed(Routes.forgotRoute);
  }

  // Navegación a sign up
  void goToSignUp() {
    Get.toNamed(Routes.signupRoute);
  }

  Future<void> setSelectPeriodo(Periodo periodo) async {
    selectedPeriodo.value = periodo;

    // Verificar si hay vivencias, si no, cargarlas primero
    if (vivencias.isEmpty) {
      try {
        await getListaVivencia();
      } catch (e) {
        Get.snackbar(
          'Error',
          'No se pudieron cargar los certificados previos. Intente nuevamente.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // No mostrar el formulario si falla la carga
      }
    }

    // Mostrar el formulario solo después de verificar/cargar las vivencias
    isNewCertificado.value = true;
  }

  @override
  void onClose() {
    ciController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void setIsDetalle(bool value) {
    isDetalle.value = value;
  }

  void setSelectedVivencia(Vivencia vivencia) {
    selectedVivencia.value = vivencia;
  }

  void setIsNewCertificado(bool value) {
    isNewCertificado.value = value;
  }

  // Método para parsear JWT y retornar JwtModel
  JwtModel parseJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid JWT');
      }
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decoded);
      return JwtModel.fromJson(json);
    } catch (e) {
      throw Exception('Error parsing JWT: $e');
    }
  }
}
