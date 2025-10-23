import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
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
  double _lastViewInset = 0.0;

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
    bool showErrorSnackbar = false;
    String errorMessage = '';

    // Mostrar indicador de carga usando showDialog del contexto
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Center(
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
        );
      },
    );

    try {
      // 1. Intentar login
      final loginResult = await widget.controller.login();

      // Si el token no es válido, salir (el controlador ya mostró el mensaje)
      if (loginResult.token == null || loginResult.token!.isEmpty) {
        return;
      }

      // 2. Token válido, intentar obtener información del usuario
      final userInfoResult = await widget.controller.getUserInfo();

      // 3. Intentar obtener periodos vigentes
      final periodosResult = await widget.controller.getPeriodoVigente();

      // Cerrar el loading
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Dar un delay para que el diálogo se cierre
      await Future.delayed(const Duration(milliseconds: 150));

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
      showErrorSnackbar = true;
      errorMessage =
          'Ocurrió un error en la conexión. Por favor, reintente más tarde.';
    } finally {
      // SIEMPRE cerrar el diálogo sin importar qué pase
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Si hubo una excepción (error de red, servidor, etc), mostrar snackbar
      if (showErrorSnackbar) {
        // Dar un pequeño delay antes de mostrar el snackbar
        await Future.delayed(const Duration(milliseconds: 150));

        if (mounted) {
          Get.snackbar(
            'Error',
            errorMessage,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final double bottomPadding = keyboardInset > 0 ? keyboardInset : 0;

    if (keyboardInset != _lastViewInset) {
      final bool keyboardOpened = keyboardInset > 0 && _lastViewInset == 0;
      _lastViewInset = keyboardInset;

      if (keyboardOpened) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 400), () {
            if (_scrollController.hasClients && mounted) {
              final maxScroll = _scrollController.position.maxScrollExtent;
              if (maxScroll > 0) {
                _scrollController.animateTo(
                  maxScroll,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            }
          });
        });
      }
    }

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: backGroundColor,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: 20.h),
              primary: false,
              shrinkWrap: true,
              children: [
                getAssetImage("logo.png", 240.h, 240.w, boxFit: BoxFit.cover),
                Align(
                  alignment: Alignment.topCenter,
                  child: getCustomFont(
                    "Iniciar Sesión",
                    24,
                    Colors.black,
                    1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: getCustomFont(
                    "Indentificate para continuar",
                    16,
                    Colors.black,
                    1,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                getVerSpace(5.h),
                Container(
                  key: _ciKey,
                  child: TextField(
                    focusNode: _ciFocus,
                    controller: widget.controller.ciController,
                    enabled: true,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    decoration: InputDecoration(
                      labelText: "Cedula de identidad",
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.0),
                        child:
                            getSvgImage("info.svg", height: 16.h, width: 16.w),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.h),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.h),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.h),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                getVerSpace(15.h),
                Obx(() => Container(
                      key: _passwordKey,
                      child: TextField(
                        focusNode: _passwordFocus,
                        controller: widget.controller.passwordController,
                        enabled: true,
                        obscureText: widget.controller.isPassVisible.value,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          _handleLogin();
                        },
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: getSvgImage("lock.svg"),
                          ),
                          suffixIcon: IconButton(
                            icon: getSvgImage(
                                widget.controller.isPassVisible.value
                                    ? "eye.svg"
                                    : "eye.svg"),
                            onPressed: () {
                              widget.controller.togglePasswordVisibility();
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.h),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.h),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.h),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 20.h,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, bottomPadding),
          child: SizedBox(
            height: 60.h,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.h),
                ),
              ),
              child: Text(
                "Ingresar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        Constant.closeApp();
        return false;
      },
    );
  }
}
