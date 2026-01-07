import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../../controllers/consulado/vivencia_controller.dart';
import '../../../app/models/consulado/model_response_auth.dart';

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
  bool _isLoginInProgress = false;
  bool _showSnackbar = false;

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

  void _showSnackbarWithDelay(
      String title, String message, Color backgroundColor, Duration duration) {
    setState(() {
      _showSnackbar = true;
    });

    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: duration,
      snackPosition: title == 'Error' || title == 'Error de Autenticación'
          ? SnackPosition.TOP
          : SnackPosition.TOP,
      margin: EdgeInsets.all(16.w),
    );

    // Esperar a que se cierre el snackbar y resetear el flag
    Future.delayed(duration, () {
      if (mounted) {
        setState(() {
          _showSnackbar = false;
        });
      }
    });
  }

  Future<void> _handleLogin() async {
    // Prevenir múltiples clics simultáneos
    if (_isLoginInProgress || _showSnackbar) {
      return;
    }

    _isLoginInProgress = true;
    setState(() {});

    try {
      // Cerrar cualquier snackbar anterior
      try {
        ScaffoldMessenger.of(context).clearSnackBars();
      } catch (e) {
        print('Error cerrando snackbars: $e');
      }

      if (!mounted) {
        _isLoginInProgress = false;
        return;
      }

      // 1. Intentar login
      ModelResponseAuth loginResult;
      try {
        loginResult = await widget.controller.login();
      } catch (e) {
        print('Error en login: $e');
        if (mounted) {
          _showSnackbarWithDelay(
            'Error',
            'Error de conexión. Verifique su internet e intente nuevamente.',
            Colors.red,
            const Duration(seconds: 3),
          );
        }
        return;
      }

      // Si la cuenta está bloqueada, no mostrar snackbar (mostrar el widget bloqueado)
      if (loginResult.isBlocked == true) {
        // El widget de cuenta bloqueada se mostrará automáticamente via Obx
        return;
      }

      // Si el login falló (sin token), mostrar error y salir
      if (loginResult.token == null || loginResult.token!.isEmpty) {
        if (mounted) {
          _showSnackbarWithDelay(
            'Error de Autenticación',
            'Credenciales inválidas, por favor verifique el nro de CI y contraseña y vuelva a intentar.',
            Colors.red,
            const Duration(seconds: 3),
          );
        }
        return;
      }

      // Login exitoso, obtener información adicional
      final userInfoResult = await widget.controller.getUserInfo();
      final periodosResult = await widget.controller.getPeriodoVigente();

      // Mostrar mensaje apropiado
      if (mounted) {
        if (userInfoResult == null && periodosResult == null) {
          _showSnackbarWithDelay(
            'Información',
            'Bienvenido. No se encontró información de vivencias ni periodos vigentes asociados a su cuenta.',
            const Color.fromARGB(255, 1, 49, 88),
            const Duration(seconds: 5),
          );
        } else if (userInfoResult == null && periodosResult != null) {
          _showSnackbarWithDelay(
            'Información',
            'Bienvenido. No se encontró información de vivencias previas.',
            const Color.fromARGB(255, 1, 49, 88),
            const Duration(seconds: 4),
          );
        } else if (userInfoResult != null && periodosResult == null) {
          _showSnackbarWithDelay(
            'Información',
            'Bienvenido ${widget.controller.usuario.value}. No se encontraron periodos vigentes para solicitar certificados.',
            const Color.fromARGB(255, 1, 49, 88),
            const Duration(seconds: 5),
          );
        }
      }
    } finally {
      _isLoginInProgress = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Mensaje de bloqueo en la parte superior (si existe)
            Obx(
              () => widget.controller.isAccountLocked.value
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(color: Colors.red, width: 1.5),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      margin: EdgeInsets.all(12.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lock_outline,
                                  color: Colors.red, size: 24.sp),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  "Tu cuenta está bloqueada",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[800],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    widget.controller.isAccountLocked.value =
                                        false;
                                  },
                                  child: Icon(Icons.close,
                                      color: Colors.red, size: 24.sp)),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                "Por motivos de seguridad, tu cuenta ha sido temporalmente bloqueada. Solicita el desbloqueo de tu cuenta para continuar.",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                widget.controller.goToUnblockAccount();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                "Solicitar Desbloqueo",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            // Contenido principal del login
            Expanded(
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
                              image:
                                  AssetImage("assets/images/log_sin_fondo.png"),
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
                              obscureText:
                                  !widget.controller.isPassVisible.value,
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
                                  onPressed: widget
                                      .controller.togglePasswordVisibility,
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
                            onPressed: (_isLoginInProgress || _showSnackbar)
                                ? null
                                : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (_isLoginInProgress || _showSnackbar)
                                      ? Colors.grey[400]
                                      : const Color(0xFF14357D),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 2,
                            ),
                            child: (_isLoginInProgress || _showSnackbar)
                                ? SizedBox(
                                    height: 20.h,
                                    width: 20.h,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white.withOpacity(0.8),
                                      ),
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    "Iniciar Sesión",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Botón "Olvidé mi contraseña"
                        Center(
                          child: TextButton(
                            onPressed: widget.controller.goToForgotPassword,
                            child: Text(
                              "Olvidé mi contraseña",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF14357D),
                                fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }
}
