import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mre_bolivia/app/view/vivencias/lista_vivencia.dart';
import 'package:mre_bolivia/app/view/vivencias/login_screen.dart';
import 'package:mre_bolivia/app/view/vivencias/nuevo_certificado.dart';
import 'package:mre_bolivia/app/view/vivencias/vivencia_home.dart';
import 'package:mre_bolivia/controllers/consulado/vivencia_controller.dart';

class VivenciaScreen extends StatelessWidget {
  const VivenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<VivenciaController>(
      init: VivenciaController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: controller.isLoggedIn.value
              ? (controller.isNewCertificado.value
                  ? _buildNewCertificadoWidget(context, controller)
                  : (controller.isDetalle.value
                      ? _buildListaDetalleWidget(context, controller)
                      : _buildLoggedInContent(context, controller)))
              : _buildLoginWidget(context, controller),
        );
      },
    );
  }

  // Widget cuando el usuario está logueado y NO está en detalle
  Widget _buildLoggedInContent(
      BuildContext context, VivenciaController controller) {
    return VivenciaHome(controller: controller);
  }

  // Widget de login cuando el usuario no está logueado
  Widget _buildLoginWidget(
      BuildContext context, VivenciaController controller) {
    return LoginWidget(controller: controller);
  }

  Widget _buildListaDetalleWidget(
      BuildContext context, VivenciaController controller) {
    return ListaVivencia(controller: controller);
  }

  Widget _buildNewCertificadoWidget(
      BuildContext context, VivenciaController controller) {
    return NuevoCertificado(controller: controller);
  }
}
