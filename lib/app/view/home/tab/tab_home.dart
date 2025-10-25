import 'package:mre_bolivia/app/data/data_file.dart';
import 'package:mre_bolivia/app/models/consulado/model_regiones.dart';
import 'package:mre_bolivia/app/models/consulado/model_servicio.dart';
import 'package:mre_bolivia/app/ui/pages/components/image_cache.dart';
import 'package:mre_bolivia/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../base/utils/utils.dart';
import '../../../../controllers/consulado/tab_home_controller.dart';

class TabHome extends StatelessWidget {
  const TabHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Forzar pantalla completa
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return GetBuilder<TabHomeController>(
      init: TabHomeController(),
      builder: (controller) => Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              primary: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                getPaddingWidget(
                  EdgeInsets.only(left: 15.w, right: 15.w, top: 0, bottom: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getAssetImage("logo-bicentenario.webp", 160.w, 50.h,
                          fit: BoxFit.contain),
                      getAssetImage("logo_mre.webp", 220.w, 65.h,
                          fit: BoxFit.contain),
                    ],
                  ),
                ),
                SizedBox(
                  height: 230.h,
                  child: VisibilityDetector(
                    key: const Key('pageview-slider'),
                    onVisibilityChanged: controller.onVisibilityChanged,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Obx(() {
                        // Estado 1: Cargando
                        if (controller.isLoadingConsultado) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 198, 198, 198),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(color: blueColor),
                                  getCustomFont("Cargando información...", 16,
                                      Colors.black, 1,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                            ),
                          );
                        }

                        // Estado 2: Error
                        if (controller.hasConsultadoError) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE6E6),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline,
                                      color: Colors.red[400], size: 48.w),
                                  getVerSpace(8),
                                  getCustomFont(
                                      "Error al cargar datos,\nverifica tu conexión a internet.",
                                      16,
                                      Colors.red,
                                      2,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.center),
                                  getVerSpace(8),
                                  getButton(context, blueColor, "Reintentar",
                                      Colors.white, () {
                                    controller.consultadoController
                                        ?.refreshData();
                                  }, 12,
                                      weight: FontWeight.w600,
                                      buttonWidth: 100,
                                      borderRadius: BorderRadius.circular(8.r),
                                      insetsGeometrypadding:
                                          EdgeInsets.symmetric(vertical: 8.h)),
                                ],
                              ),
                            ),
                          );
                        }

                        // Estado 3: Datos disponibles
                        try {
                          final definiciones =
                              controller.getSliderDefiniciones();

                          // Estado 4: Sin datos
                          if (definiciones.isEmpty) {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.info_outline,
                                        color: Colors.grey[600], size: 48.w),
                                    getVerSpace(8),
                                    getCustomFont(
                                        "No hay información disponible",
                                        16,
                                        Colors.grey,
                                        1,
                                        fontWeight: FontWeight.w600),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Estado 5: Mostrar datos
                          return PageView.builder(
                            controller: controller.pageController,
                            onPageChanged: controller.changePage,
                            itemCount: definiciones.length,
                            itemBuilder: (context, index) {
                              final definicion = definiciones[index];

                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 380.w,
                                    height: 180.h,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 236, 236, 236),
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 0.2),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Columna izquierda - 190.w (mitad del contenedor)
                                        SizedBox(
                                          width: 190.w,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 16.h),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getMultilineCustomFont(
                                                    definicion.titulo,
                                                    18,
                                                    const Color.fromARGB(
                                                        255, 47, 47, 47),
                                                    fontWeight: FontWeight.w800,
                                                    txtHeight: 1.2),
                                                getVerSpace(20.h),
                                                getButton(
                                                    context,
                                                    blueColor,
                                                    "Ver Más ...",
                                                    Colors.white, () {
                                                  controller
                                                      .goToDefinicionDetail(
                                                          definicion, index);
                                                }, 14,
                                                    weight: FontWeight.w800,
                                                    buttonWidth: 108,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    insetsGeometrypadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12.h)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Columna derecha - 190.w (mitad del contenedor)
                                        Container(
                                          width: 190.w,
                                          height: 180.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20.r),
                                              bottomRight:
                                                  Radius.circular(20.r),
                                              topLeft: Radius.circular(20.r),
                                              bottomLeft: Radius.circular(20.r),
                                            ),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: CustomCacheImage(
                                            imageUrl: definicion.imagen,
                                            width: 190.w,
                                            height: 180.h,
                                            fit: BoxFit.contain,
                                            fallbackAssetImage:
                                                "assets/images/chakanagris.png",
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          // Capturar cualquier error inesperado
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE6E6),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline,
                                      color: Colors.red[400], size: 48.w),
                                  getVerSpace(8),
                                  getCustomFont(
                                      "Error inesperado", 16, Colors.red, 2,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                  ),
                ),
                Obx(() {
                  try {
                    // Verificar estados primero
                    if (controller.isLoadingConsultado ||
                        controller.hasConsultadoError) {
                      return const SizedBox.shrink();
                    }

                    final definiciones = controller.getSliderDefiniciones();
                    if (definiciones.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 8.h,
                        width: (definiciones.length * 18).w,
                        alignment: Alignment.center,
                        child: ListView.builder(
                          primary: false,
                          itemCount: definiciones.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return getPaddingWidget(
                              EdgeInsets.only(right: 10.w),
                              Container(
                                width: 8.h,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: controller.selectedPage.value == index
                                      ? blueColor
                                      : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } catch (e) {
                    return const SizedBox.shrink();
                  }
                }),
                getVerSpace(20),
                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getCustomFont("Consulados", 20, Colors.black, 1,
                          fontWeight: FontWeight.w800),
                    ],
                  ),
                ),
                getVerSpace(18),
                SizedBox(
                  height: 132.h,
                  child: Obx(() {
                    try {
                      // Verificar si hay error o está cargando
                      if (controller.isLoadingConsultado ||
                          controller.hasConsultadoError) {
                        return const SizedBox.shrink();
                      }

                      final List<Region> regions = controller.getPaisregion();

                      // Verificar si hay regiones disponibles
                      if (regions.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return ListView.builder(
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: regions.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final region = regions[index];

                          return GestureDetector(
                            onTap: () => controller.goToRegion(region),
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: index == 0 ? 20.w : 0,
                                  right: 20.w,
                                  bottom: 28.h),
                              padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
                              width: 91.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0.0, 4.0)),
                                  ],
                                  borderRadius: BorderRadius.circular(12.r)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getAssetImage("${region.nombre}.png", 44, 44),
                                  getVerSpace(10),
                                  getCustomFont(
                                      region.nombre, 14, Colors.black, 1,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } catch (e) {
                      return const SizedBox.shrink();
                    }
                  }),
                ),
                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getCustomFont("Servicios", 20, Colors.black, 1,
                          fontWeight: FontWeight.w800),
                      GestureDetector(
                        onTap: controller.goToCategories,
                        child: getCustomFont("Ver Todos", 14, blueColor, 1,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                getVerSpace(16),
                SizedBox(
                  height: 215.h,
                  child: Obx(() {
                    try {
                      // Verificar si hay error o está cargando
                      if (controller.isLoadingConsultado ||
                          controller.hasConsultadoError) {
                        return const SizedBox.shrink();
                      }

                      final List<Servicio> servicios =
                          controller.getServicios();

                      // Verificar si hay servicios disponibles
                      if (servicios.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.grey[600], size: 48.w),
                              getVerSpace(8),
                              getCustomFont("No hay servicios disponibles", 16,
                                  Colors.grey, 1,
                                  fontWeight: FontWeight.w600),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        primary: false,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: servicios.length > 3 ? 3 : servicios.length,
                        itemBuilder: (context, index) {
                          // Verificación de seguridad adicional
                          if (index >= servicios.length) {
                            return const SizedBox.shrink();
                          }

                          Servicio service = servicios[index];

                          // Verificación de seguridad para DataFile.popularServiceList
                          final fallbackImage =
                              index < DataFile.popularServiceList.length
                                  ? DataFile.popularServiceList[index].image
                                  : null;

                          return GestureDetector(
                            onTap: () => controller.goToServicio(service),
                            child: Container(
                              width: 177.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0.0, 4.0)),
                                  ],
                                  borderRadius: BorderRadius.circular(12.r)),
                              padding: EdgeInsets.all(12.w),
                              margin: EdgeInsets.only(
                                  left: index == 0 ? 20.w : 0,
                                  bottom: 24.h,
                                  right: 20.w),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Hero(
                                      tag: index <
                                              DataFile.popularServiceList.length
                                          ? DataFile.popularServiceList[index]
                                          : "service_$index",
                                      child: Container(
                                        width: 150.w,
                                        height: 122.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: CustomCacheImage(
                                          imageUrl: service.imagen,
                                          width: 140.w,
                                          height: 120.h,
                                          fit: BoxFit.fill,
                                          fallbackAssetImage: fallbackImage,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 153.w,
                                    height: 30.h,
                                    child: getCustomFont(service.titulo, 11,
                                        Colors.grey[600]!, 2,
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  // SizedBox(
                                  //   width: 153.w,
                                  //   child: Align(
                                  //       alignment: Alignment.topLeft,
                                  //       child: getCustomFont(
                                  //         service.descripcion,
                                  //         12,
                                  //         Colors.grey[600]!,
                                  //         1,
                                  //         fontWeight: FontWeight.w400,
                                  //       )),
                                  // )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } catch (e) {
                      return const SizedBox.shrink();
                    }
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
