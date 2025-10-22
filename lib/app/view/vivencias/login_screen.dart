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
    // Mostrar indicador de carga
    Get.dialog(
      Center(
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
      barrierDismissible: false,
    );

    try {
      final result = await widget.controller.login();

      if (result.token!.isEmpty == false) {
        await widget.controller.getUserInfo();
        // await widget.controller.fTest();
        await widget.controller.getPeriodoVigente();
      }
    } catch (e) {
      print(e);
    } finally {
      // SIEMPRE cerrar el diálogo primero, antes de cualquier otra acción
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Dar un pequeño delay para que el diálogo se cierre completamente
      await Future.delayed(const Duration(milliseconds: 100));

      // Verificar si hubo error (el login falló si no está logueado)
      if (!widget.controller.isLoggedIn.value) {
        Get.snackbar(
          'Error',
          'Ocurrió un error en la conexión. Por favor, reintente más tarde.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
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
