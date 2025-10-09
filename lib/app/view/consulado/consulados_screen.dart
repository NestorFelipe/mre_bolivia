// ignore_for_file: prefer_const_constructors

import 'package:mi_cancilleria/app/models/consulado/model_consulados.dart';
import 'package:mi_cancilleria/base/color_data.dart';
import 'package:mi_cancilleria/base/widget_utils.dart';
import 'package:mi_cancilleria/controllers/consulado/tab_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class ConsuladosScreen extends GetView<TabHomeController> {
  const ConsuladosScreen({super.key});

  Widget _getToolbarMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: controller.goBack,
          child: getSvgImage("back.svg", height: 24, width: 24),
        ),
        Expanded(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 3,
                        offset: Offset(0, 4.5),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/paises/${controller.selectedPais.value!.alpha2}@2x.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                getHorSpace(10.w),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 180.w),
                  child: IntrinsicWidth(
                    child: getCustomFont(controller.selectedPais.value!.nombre,
                        17, const Color.fromARGB(255, 52, 52, 52), 2,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: SafeArea(
          child: Column(
            children: [
              getVerSpace(20),
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.w),
                _getToolbarMenu(),
              ),
              getVerSpace(20),
              Expanded(
                flex: 1,
                child: _consuladosView(),
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        controller.goBack();
        return false;
      },
    );
  }

  Widget _consuladosView() {
    return ListView.builder(
      primary: true,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: controller.selectedPais.value!.consulados.length,
      itemBuilder: (context, index) {
        Consulado modelConsulado =
            controller.selectedPais.value!.consulados[index];

        return Obx(() {
          bool isExpanded = controller.expandedCards.contains(index);

          return GestureDetector(
            onTap: () {
              controller.toggleCardExpansion(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              margin: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: isExpanded ? 12 : 8,
                      offset: Offset(0.0, isExpanded ? 4.0 : 2.0)),
                ],
                border: isExpanded
                    ? Border.all(
                        color: (index % 3 == 0
                                ? blueColor
                                : (index % 3 == 1
                                    ? Colors.green
                                    : Colors.orange))
                            .withOpacity(0.3),
                        width: 1)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row con ícono, título y flecha
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: index % 3 == 0
                              ? blueColor.withOpacity(0.2)
                              : (index % 3 == 1
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: index % 3 == 0
                              ? blueColor
                              : (index % 3 == 1 ? Colors.green : Colors.orange),
                          size: 24.w,
                        ),
                      ),
                      getHorSpace(16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomFont(modelConsulado.nombre, 12,
                                const Color.fromARGB(255, 58, 58, 58), 3,
                                fontWeight: FontWeight.w800),
                            SizedBox(height: 4.h),
                            getCustomFont(
                                modelConsulado.tipo, 12, Colors.grey[600]!, 1,
                                fontWeight: FontWeight.w400),
                          ],
                        ),
                      ),
                      // Icono indicador de expansión
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: index % 3 == 0
                              ? blueColor
                              : (index % 3 == 1 ? Colors.green : Colors.orange),
                          size: 20.w,
                        ),
                      ),
                    ],
                  ),
                  // Contenido expandido que ocupa todo el ancho
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox.shrink(),
                    secondChild: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 12.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: (index % 3 == 0
                                  ? blueColor
                                  : (index % 3 == 1
                                      ? Colors.green
                                      : Colors.orange))
                              .withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                              "📍 Dirección:", modelConsulado.direccion),
                          getVerSpace(4.h),
                          _buildInfoRow(
                              "📞 Teléfono:", modelConsulado.telefono),
                          getVerSpace(4.h),
                          _buildInfoRow("� Emergencias:",
                              modelConsulado.telefonoEmergencia),
                          getVerSpace(4.h),
                          _buildInfoRow(
                              "📧 Email:", modelConsulado.correoElectronico),
                          getVerSpace(4.h),
                          _buildInfoRow("🌐 Web:", modelConsulado.paginaWeb),
                          getVerSpace(4.h),
                          _buildInfoRow(
                              "🕒 Horarios:", modelConsulado.horariosAtencion),
                          getVerSpace(4.h),
                          _buildInfoRow("🏛️ Circunscripción:",
                              modelConsulado.circunscripcion),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.w,
          child: getCustomFont(
              label, 11, const Color.fromARGB(255, 85, 85, 85), 2,
              fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: getCustomFont(value.isNotEmpty ? value : "No disponible", 11,
              value.isNotEmpty ? Colors.black87 : Colors.grey[500]!, 3,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

