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
  bool isLoading = false;

  // Parámetros dinámicos
  late String actionType; // 'recover' o 'unlock'
  late String userName;
  late String ci;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VivenciaController>();

    // Obtener parámetros de la navegación
    actionType = Get.arguments?['actionType'] ?? 'recover';
    ci = Get.arguments?['ci'] ?? '';
    userName = Get.arguments?['userName'] ?? '';

    // Debug: imprimir los valores recibidos
    print(
        'ForgotPassword - actionType: $actionType, ci: $ci, userName: $userName');
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
        ? 'Necesitamos tu correo electrónico para enviar instrucciones de desbloqueo'
        : 'Necesitamos tu correo electrónico de registro para restablecer la contraseña';
  }

  String getButtonText() {
    return actionType == 'unlock' ? 'Enviar Solicitud' : 'Enviar';
  }

  Future<void> handleSubmit() async {
    final email = emailController.text.trim();

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
        data = await controller.sendUnblockRequest(email, ci);
      } else {
        // Recuperar contraseña
        data = await controller.sendRecoverPasswordRequest(email, ci);
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
                  // Mostrar información del usuario
                  if (userName.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(FetchPixels.getPixelWidth(12)),
                      decoration: BoxDecoration(
                        color: blueColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                            FetchPixels.getPixelHeight(10)),
                      ),
                      margin: EdgeInsets.only(
                          bottom: FetchPixels.getPixelHeight(20)),
                      child: Row(
                        children: [
                          Icon(Icons.person_outline,
                              color: blueColor,
                              size: FetchPixels.getPixelHeight(20)),
                          SizedBox(width: FetchPixels.getPixelWidth(10)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getCustomFont("Usuario", 12, Colors.grey, 1,
                                    fontWeight: FontWeight.w500),
                                getCustomFont(userName, 14, Colors.black, 1,
                                    fontWeight: FontWeight.w600),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  getDefaultTextFiledWithLabel(
                    context,
                    "Correo Electrónico",
                    emailController,
                    Colors.grey,
                    function: () {},
                    height: FetchPixels.getPixelHeight(60),
                    isEnable: true,
                    withprefix: true,
                    image: "message.svg",
                    imageWidth: FetchPixels.getPixelWidth(19),
                    imageHeight: FetchPixels.getPixelHeight(17.66),
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
    super.dispose();
  }
}
