import 'package:mre_bolivia/base/color_data.dart';
import 'package:mre_bolivia/base/resizer/fetch_pixels.dart';
import 'package:mre_bolivia/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/constant.dart';
import '../../../controllers/consulado/vivencia_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late VivenciaController controller;
  TextEditingController emailController = TextEditingController();
  TextEditingController ciController = TextEditingController();
  bool isLoading = false;

  // Parámetros dinámicos
  late String actionType; // 'recover' o 'unlock'
  late String ciInitial;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VivenciaController>();

    // Obtener parámetros de la navegación
    actionType = Get.arguments?['actionType'] ?? 'recover';
    ciInitial = Get.arguments?['ci'] ?? '';

    // Pre-llenar el CI con el valor inicial si existe
    if (ciInitial.isNotEmpty) {
      ciController.text = ciInitial;
    }

    // Debug: imprimir los valores recibidos
    print('ForgotPassword - actionType: $actionType, ciInitial: $ciInitial');
  }

  void finish() {
    Constant.backToPrev(context);
  }

  String getTitle() {
    return actionType == 'unlock'
        ? 'Solicitar Desbloqueo de Cuenta'
        : 'Recuperar mi Contraseña';
  }

  String getSubtitle() {
    return actionType == 'unlock'
        ? 'Ingresa tu Carnet de Identidad y correo electrónico para recibir instrucciones de desbloqueo'
        : 'Ingresa tu Carnet de Identidad y correo electrónico para restablecer tu contraseña';
  }

  String getButtonText() {
    return actionType == 'unlock' ? 'Enviar Solicitud' : 'Enviar';
  }

  Future<void> handleSubmit() async {
    final email = emailController.text.trim();
    final ciValue = ciController.text.trim();

    if (ciValue.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor ingrese su Carnet de Identidad',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor ingrese su correo electrónico',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!email.contains('@')) {
      Get.snackbar(
        'Error',
        'Por favor ingrese un correo electrónico válido',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ignore: prefer_typing_uninitialized_variables
      var data;
      if (actionType == 'unlock') {
        // Solicitar desbloqueo
        data = await controller.sendUnblockRequest(email, ciValue);
      } else {
        // Recuperar contraseña
        data = await controller.sendRecoverPasswordRequest(email, ciValue);
      }

      // Verificar si la solicitud fue exitosa
      if (data.exitosa == true) {
        if (mounted) {
          Get.snackbar(
            'Éxito',
            data.mensaje,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );

          // Esperar a que se cierre el snackbar
          await Future.delayed(const Duration(seconds: 5));
          if (mounted) {
            // Resetear el estado de cuenta bloqueada
            controller.isAccountLocked.value = false;
            // Volver a la pantalla de login
            Constant.backToPrev(context);
          }
        }
      } else {
        // La solicitud falló
        if (mounted) {
          Get.snackbar(
            'Error',
            data.mensaje,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print('Error en handleSubmit: $e');
      if (mounted) {
        Get.snackbar(
          'Error',
          'No se pudo procesar la solicitud. Intente nuevamente.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getPixelWidth(20)),
              child: Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(26)),
                  gettoolbarMenu(
                    context,
                    "back.svg",
                    () {
                      finish();
                    },
                  ),
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  getCustomFont(getTitle(), 24, Colors.black, 1,
                      fontWeight: FontWeight.w800),
                  getVerSpace(FetchPixels.getPixelHeight(10)),
                  getPaddingWidget(
                      EdgeInsets.symmetric(
                          horizontal: FetchPixels.getPixelWidth(60)),
                      getMultilineCustomFont(getSubtitle(), 16, Colors.black,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                          txtHeight: FetchPixels.getPixelHeight(1.3))),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  // Campo Carnet de Identidad
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(FetchPixels.getPixelHeight(12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    margin:
                        EdgeInsets.only(bottom: FetchPixels.getPixelHeight(16)),
                    child: TextFormField(
                      controller: ciController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: FetchPixels.getPixelHeight(16),
                        color: Colors.black,
                      ),
                      cursorColor: blueColor,
                      cursorWidth: 2.0,
                      decoration: InputDecoration(
                        labelText: "Carnet de Identidad",
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: FetchPixels.getPixelHeight(14),
                        ),
                        prefixIcon: Padding(
                          padding:
                              EdgeInsets.all(FetchPixels.getPixelHeight(12)),
                          child: Icon(
                            Icons.credit_card,
                            color: blueColor,
                            size: FetchPixels.getPixelHeight(20),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(12)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(12)),
                          borderSide: BorderSide(
                            color: blueColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(12)),
                          borderSide: BorderSide(
                            color: Colors.grey[300] ?? Colors.grey,
                            width: 1,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: FetchPixels.getPixelWidth(16),
                          vertical: FetchPixels.getPixelHeight(16),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(FetchPixels.getPixelHeight(12)),
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
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: FetchPixels.getPixelHeight(16),
                        color: Colors.black,
                      ),
                      cursorColor: blueColor,
                      cursorWidth: 2.0,
                      decoration: InputDecoration(
                        labelText: "Correo Electrónico",
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: FetchPixels.getPixelHeight(14),
                        ),
                        prefixIcon: Padding(
                          padding:
                              EdgeInsets.all(FetchPixels.getPixelHeight(12)),
                          child: Icon(
                            Icons.email_outlined,
                            color: blueColor,
                            size: FetchPixels.getPixelHeight(20),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(12)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(12)),
                          borderSide: BorderSide(
                            color: blueColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(12)),
                          borderSide: BorderSide(
                            color: Colors.grey[300] ?? Colors.grey,
                            width: 1,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: FetchPixels.getPixelWidth(16),
                          vertical: FetchPixels.getPixelHeight(16),
                        ),
                      ),
                    ),
                  ),
                  getVerSpace(FetchPixels.getPixelHeight(50)),
                  SizedBox(
                    width: double.infinity,
                    height: FetchPixels.getPixelHeight(60),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(15)),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.8),
                                ),
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              getButtonText(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          finish();
          return false;
        });
  }

  @override
  void dispose() {
    emailController.dispose();
    ciController.dispose();
    super.dispose();
  }
}
