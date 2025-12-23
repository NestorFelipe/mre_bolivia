import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mre_bolivia/app/models/consulado/model_genericresponse.dart';
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

  RxBool isPassVisible = false.obs;
  RxBool isNewCertificado = false.obs;
  RxBool isAccountLocked = false.obs;

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

    // Limpiar estado anterior
    isLoggedIn.value = false;
    hasUserInfo.value = false;
    hasPeriodos.value = false;
    usuario.value = '';
    vivencias.clear();
    periodos.clear();
    isAccountLocked.value = false;

    try {
      final result = await VivenciasService().authVivencia(ci, password);

      // Verificar si la cuenta está bloqueada según el mensaje
      final mensajeMinuscula = (result.mensaje ?? '').toLowerCase();
      if (mensajeMinuscula.contains('bloqueada') ||
          mensajeMinuscula.contains('bloqueado') ||
          mensajeMinuscula.contains('account locked') ||
          result.isBlocked == true) {
        isAccountLocked.value = true;
        return result;
      }

      // Si el login falló, devolver resultado sin cambios de estado
      if (result.token == "" || result.token == null) {
        return result;
      }

      // Login exitoso - guardar credenciales y token
      try {
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
      } catch (e) {
        // Error al procesar JWT, devolver el resultado sin estado
        print('Error procesando JWT: $e');
        return result;
      }

      return result;
    } catch (e) {
      // En caso de error de conexión, limpiar estado
      print('Error en login: $e');
      isLoggedIn.value = false;
      hasUserInfo.value = false;
      hasPeriodos.value = false;
      usuario.value = '';
      vivencias.clear();
      periodos.clear();
      rethrow;
    }
  }

  Future<ListaVivenciaResponse?> getUserInfo() async {
    final idPersona = await PrefData.getIdPersona();
    final token = await PrefData.getToken();

    // Si no tenemos token, no intentar llamada
    if (token.isEmpty) {
      hasUserInfo.value = false;
      usuario.value = '';
      return null;
    }

    try {
      final result = await VivenciasService().getInfoUser(token, idPersona);

      if (!result.existosa! || result.lista == null || result.lista!.isEmpty) {
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
      print('Error obteniendo info de usuario: $e');
      hasUserInfo.value = false;
      usuario.value = '';
      return null;
    }
  }

  Future<ModelPeriodosVigente?> getPeriodoVigente() async {
    final idPersona = await PrefData.getIdPersona();
    final token = await PrefData.getToken();

    // Si no tenemos token, no intentar llamada
    if (token.isEmpty) {
      periodos.value = [];
      hasPeriodos.value = false;
      return null;
    }

    try {
      final result =
          await VivenciasService().getPeriodoVigente(token, idPersona);

      if (result.lista.isEmpty) {
        periodos.value = [];
        hasPeriodos.value = false;
        await PrefData.setLogIn(true);
        isLoggedIn.value = true;
        return null;
      }

      periodos.value = result.lista;
      hasPeriodos.value = true;
      await PrefData.setLogIn(true);
      isLoggedIn.value = true;

      return result;
    } catch (e) {
      print('Error obteniendo periodos vigentes: $e');
      periodos.value = [];
      hasPeriodos.value = false;
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

  void goToRecoverPassword() {
    final ci = ciController.text.trim();
    Get.toNamed(Routes.forgotRoute, arguments: {
      'actionType': 'recover',
      'userName': ci,
      'ci': ci,
    });
  }

  void goToUnblockAccount() {
    final ci = ciController.text.trim();
    Get.toNamed(Routes.forgotRoute, arguments: {
      'actionType': 'unlock',
      'userName': ci,
      'ci': ci,
    });
  }

  void requestAccountUnblock() {
    // Navegar al formulario de desbloqueo
    goToUnblockAccount();
  }

  Future<ModelGenericResponse> sendRecoverPasswordRequest(
      String email, String ci) async {
    // Implementar la llamada al servicio para recuperación de contraseña
    // Esta función debe enviar email y ci al backend
    try {
      var data = await VivenciasService().authRecovery(email, ci);
      print('Solicitud de recuperación enviada: $email, $ci, $data');
      // Por ahora solo simulamos la solicitud
      await Future.delayed(const Duration(seconds: 1));
      return data;
    } catch (e) {
      print('Error enviando solicitud de recuperación: $e');
      rethrow;
    }
  }

  Future<ModelGenericResponse> sendUnblockRequest(
      String email, String ci) async {
    // Implementar la llamada al servicio para desbloqueo de cuenta
    // Esta función debe enviar email y ci al backend
    try {
      var data = await VivenciasService().authUnlock(email, ci);
      print('Solicitud de desbloqueo enviada: $email, $ci, $data');
      // Por ahora solo simulamos la solicitud
      await Future.delayed(const Duration(seconds: 1));
      return data;
    } catch (e) {
      print('Error enviando solicitud de desbloqueo: $e');
      rethrow;
    }
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
