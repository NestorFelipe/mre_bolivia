import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mre_bolivia/app/models/consulado/model_jwt.dart';
import 'package:mre_bolivia/app/models/consulado/model_lista_vivencia.dart';
import 'package:mre_bolivia/app/models/consulado/model_periodos_vigente.dart';
import 'package:mre_bolivia/app/models/consulado/model_response_auth.dart';
import 'package:mre_bolivia/app/routes/app_routes.dart';
import 'package:mre_bolivia/base/pref_data.dart';
import 'package:mre_bolivia/services/vivencias_service.dart';

class VivenciaController extends GetxController {
  RxBool isLoggedIn = false.obs;
  RxBool isDetalle = false.obs;
  Rx<Vivencia?> selectedVivencia = null.obs;

  TextEditingController ciController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isPassVisible = true.obs;
  RxBool isNewCertificado = false.obs;

  RxList<Vivencia> vivencias = <Vivencia>[].obs;
  RxList<Periodo> periodos = <Periodo>[].obs;
  Rx<Periodo?> selectedPeriodo = Periodo().obs;
  RxString usuario = ''.obs;
  RxString cedula = ''.obs;

  // Nuevos flags para controlar el estado de la UI
  RxBool hasUserInfo = false.obs;
  RxBool hasPeriodos = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Verificar estado de login al inicializar
    checkLoginStatus();
  }

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

  void togglePasswordVisibility() {
    isPassVisible.value = !isPassVisible.value;
  }

  Future<ModelResponseAuth> login() async {
    final ci = ciController.text.trim();
    final password = passwordController.text;

    try {
      final result = await VivenciasService().authVivencia(ci, password);

      if (result.token == "" || result.token == null) {
        // NO mostrar Get.snackbar aquí porque la UI ya maneja el error
        return result; // Devolver resultado para que la UI lo maneje
      } else {
        final jwt = parseJwt(result.token!);

        await PrefData.setCi(ci);
        await PrefData.setToken(result.token!);
        await PrefData.setIdPersona(jwt.idPersona);
        await PrefData.setExpire(result.expiration!);
        await PrefData.setLogIn(true);
        isLoggedIn.value = true;
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

  Future<ListaVivenciaResponse?> getUserInfo() async {
    final idPersona = await PrefData.getIdPersona();
    final token = await PrefData.getToken();

    try {
      final result = await VivenciasService().getInfoUser(token, idPersona);

      if (!result.existosa! || result.lista == null || result.lista!.isEmpty) {
        // No hay información del usuario, pero el login fue exitoso
        hasUserInfo.value = false;
        usuario.value = '';
        return null;
      }

      // Hay información del usuario
      PrefData.setReg(result.paginado!.totalRegistros);
      PrefData.setUsuario(result.lista!.first.nombreCompleto);
      usuario.value = result.lista!.first.nombreCompleto;
      hasUserInfo.value = true;

      return result;
    } catch (e) {
      // Error en la llamada, no hay información del usuario
      hasUserInfo.value = false;
      usuario.value = '';
      return null;
    }
  }

  Future<ModelPeriodosVigente?> getPeriodoVigente() async {
    final idPersona = await PrefData.getIdPersona();
    final token = await PrefData.getToken();

    try {
      final result =
          await VivenciasService().getPeriodoVigente(token, idPersona);

      if (result.lista.isEmpty) {
        // No hay periodos vigentes
        periodos.value = [];
        hasPeriodos.value = false;

        // Guardar el estado de login de todas formas
        await PrefData.setLogIn(true);
        isLoggedIn.value = true;

        return null;
      }

      // Hay periodos vigentes
      periodos.value = result.lista;
      hasPeriodos.value = true;

      await PrefData.setLogIn(true);
      isLoggedIn.value = true;

      return result;
    } catch (e) {
      // Error en la llamada
      periodos.value = [];
      hasPeriodos.value = false;

      // Guardar el estado de login de todas formas
      await PrefData.setLogIn(true);
      isLoggedIn.value = true;

      return null;
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
      // Mostrar error específico para debugging
      print('❌ Error en getListaVivencia: $e');
      Get.snackbar(
        'Error de Conexión',
        'No se pudieron cargar los certificados. Verifique su conexión a internet.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      // Propagar el error para que la UI lo maneje
      rethrow;
    }
  }

  void logout() {
    PrefData.setLogIn(false);
    isLoggedIn.value = false;
    hasUserInfo.value = false;
    hasPeriodos.value = false;
    ciController.clear();
    passwordController.clear();
    vivencias.clear();
    periodos.clear();
    usuario.value = '';
    cedula.value = '';
    PrefData.clearPref();
  }

  Future<String> getCi() async {
    return await PrefData.getCi();
  }

  Future<String> getUsuario() async {
    return await PrefData.getUsuario();
  }

  void goToForgotPassword() {
    Get.toNamed(Routes.forgotRoute);
  }

  void goToSignUp() {
    Get.toNamed(Routes.signupRoute);
  }

  Future<bool> getIsLogin() async {
    return await PrefData.isLogIn();
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
