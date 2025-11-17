import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../../controllers/consulado/vivencia_controller.dart';

// Widget interno de login
class LoginWidget extends StatefulWidget {
  final VivenciaController controller;

  const LoginWidget({super.key, required this.controller});

  @override
  State<LoginWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  final FocusNode _ciFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey _ciKey = GlobalKey();
  final GlobalKey _passwordKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _ciFocus.addListener(() {
      if (_ciFocus.hasFocus) {
        _ensureVisible(_ciKey);
      }
    });
    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) {
        _ensureVisible(_passwordKey);
      }
    });
  }

  @override
  void dispose() {
    _ciFocus.dispose();
    _passwordFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _ensureVisible(GlobalKey key) {}

  Future<void> _handleLogin() async {
    // Mostrar indicador de carga usando Get.dialog en lugar de showDialog del contexto
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: blueColor,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Iniciando sesión...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      // 1. Intentar login
      final loginResult = await widget.controller.login();

      // Si el login falló, salir (el controlador ya mostró el mensaje)
      if (loginResult.token == null || loginResult.token!.isEmpty) {
        // CERRAR DIALOG INMEDIATAMENTE
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        // Dar un pequeño delay antes de mostrar el snackbar
        await Future.delayed(const Duration(milliseconds: 150));

        // Mostrar mensaje de credenciales incorrectas
        if (mounted) {
          Get.snackbar(
            'Error de Autenticación',
            'Credenciales inválidas, por favor verifique el nro de CI y contraseña y vuelva a intentar.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
        return;
      }

      // 2. Token válido, intentar obtener información del usuario
      final userInfoResult = await widget.controller.getUserInfo();

      // 3. Intentar obtener periodos vigentes
      final periodosResult = await widget.controller.getPeriodoVigente();

      // CERRAR DIALOG ANTES DE MOSTRAR SNACKBARS
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // 4. Mostrar mensajes informativos según el resultado
      if (mounted) {
        if (userInfoResult == null && periodosResult == null) {
          // No tiene ni userInfo ni periodos
          Get.snackbar(
            'Información',
            'Bienvenido. No se encontró información de vivencias ni periodos vigentes asociados a su cuenta.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 1, 49, 88),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        } else if (userInfoResult == null && periodosResult != null) {
          // Tiene periodos pero no userInfo
          Get.snackbar(
            'Información',
            'Bienvenido. No se encontró información de vivencias previas.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 1, 49, 88),
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        } else if (userInfoResult != null && periodosResult == null) {
          // Tiene userInfo pero no periodos
          Get.snackbar(
            'Información',
            'Bienvenido ${widget.controller.usuario.value}. No se encontraron periodos vigentes para solicitar certificados.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 1, 49, 88),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        }
        // Si tiene ambos, no mostrar mensaje (login exitoso completo)
      }
    } catch (e) {
      print('Error en login: $e');
      // CERRAR DIALOG INMEDIATAMENTE EN CATCH
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Dar un pequeño delay antes de mostrar el snackbar
      await Future.delayed(const Duration(milliseconds: 150));

      if (mounted) {
        Get.snackbar(
          'Error de Autenticación',
          'Error de conexión. Verifique su internet e intente nuevamente.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo del gobierno
                  Container(
                    height: 120.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/log_sin_fondo.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Título
                  Text("Ministerio de Relaciones",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Exteriores de ",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87)),
                      Text("BOLIVIA",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  ),
                  getVerSpace(60.h),
                  getCustomFont(
                    "Iniciar Sesión",
                    28,
                    const Color(0xFF14357D),
                    1,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Acceda a su cuenta de vivencias",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  // Campo CI
                  Container(
                    key: _ciKey,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: widget.controller.ciController,
                      focusNode: _ciFocus,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 16.sp),
                      decoration: InputDecoration(
                        labelText: "Carnet de Identidad",
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: const Color(0xFF14357D),
                          size: 20.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                      onFieldSubmitted: (_) {
                        _passwordFocus.requestFocus();
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Campo Contraseña
                  Container(
                    key: _passwordKey,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(
                      () => TextFormField(
                        controller: widget.controller.passwordController,
                        focusNode: _passwordFocus,
                        obscureText: !widget.controller.isPassVisible.value,
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: const Color(0xFF14357D),
                            size: 20.sp,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              widget.controller.isPassVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[600],
                              size: 20.sp,
                            ),
                            onPressed:
                                widget.controller.togglePasswordVisibility,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                        ),
                        onFieldSubmitted: (_) => _handleLogin(),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Botón de login
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14357D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
