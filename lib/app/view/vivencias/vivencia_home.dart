import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mi_cancilleria/base/color_data.dart';
import 'package:mi_cancilleria/controllers/consulado/vivencia_controller.dart';

import '../../../base/utils/utils.dart';

class VivenciaHome extends StatelessWidget {
  const VivenciaHome({super.key, required this.controller});
  final VivenciaController controller;

  @override
  Widget build(BuildContext context) {
    // Verificar si el usuario está vacío y hacer logout si es necesario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.usuario.value.isEmpty || controller.cedula.value.isEmpty) {
        controller.logout();
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            getPaddingWidget(
              EdgeInsets.only(left: 15.w, right: 15.w, top: 0, bottom: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getCustomFont(
                    "Servicios Consulares - Vivencias",
                    20,
                    const Color.fromARGB(255, 51, 51, 51),
                    2,
                    fontWeight: FontWeight.w800,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            getAssetImage("logo.png", 280.h, 280.w, fit: BoxFit.cover),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getCustomFont(
                      "¡Bienvenido!",
                      20,
                      Colors.black,
                      1,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                    getVerSpace(5.h),
                    getCustomFont(
                      controller.usuario.value,
                      16,
                      Colors.black,
                      1,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),

                    getCustomFont(
                      "C.I. : ${controller.cedula.value}",
                      16,
                      Colors.black,
                      1,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                    getVerSpace(20.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.periodos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                bottom: 10.h, left: 15.w, right: 15.w),
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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12.r),
                                onTap: () async {
                                  // Mostrar indicador de carga si es necesario
                                  if (controller.vivencias.isEmpty) {
                                    Get.dialog(
                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.all(20.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(
                                                color: blueColor,
                                              ),
                                              SizedBox(height: 16.h),
                                              Text(
                                                'Cargando certificados...',
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
                                  }

                                  await controller.setSelectPeriodo(
                                      controller.periodos[index]);

                                  // Cerrar el diálogo si está abierto
                                  if (Get.isDialogOpen ?? false) {
                                    Get.back();
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          // Icono del certificado
                                          Container(
                                            width: 48.w,
                                            height: 48.w,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                            child: Icon(
                                              Icons.description,
                                              color: Colors.blue,
                                              size: 24.w,
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          // Información del periodo
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getCustomFont(
                                                  "Usted ya puede generar un certificado de vivencia.",
                                                  16,
                                                  Colors.black,
                                                  2,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                getCustomFont(
                                                  "Toque para generar el certificado.",
                                                  14,
                                                  Colors.grey,
                                                  1,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          // Icono de flecha
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18.sp,
                                            color: const Color(0xFF14357D),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.h),
                                      Divider(color: Colors.grey.shade300),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getCustomFont(
                                                  "Periodo: ${controller.periodos[index].descripcion}",
                                                  16.sp,
                                                  Colors.black,
                                                  1,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                // Agregar más información si es necesario
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    getVerSpace(20.h),
                    // Botón de logout para pruebas
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => controller.getListaVivencia(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blueColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40.w, vertical: 15.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.h),
                              ),
                            ),
                            child: Text(
                              "Ver Certificados",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => controller.logout(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40.w, vertical: 15.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.h),
                              ),
                            ),
                            child: Text(
                              "Cerrar Sesión",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
