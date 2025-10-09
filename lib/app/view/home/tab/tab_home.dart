import 'package:mi_cancilleria/app/data/data_file.dart';
import 'package:mi_cancilleria/app/models/consulado/model_regiones.dart';
import 'package:mi_cancilleria/app/models/consulado/model_servicio.dart';
import 'package:mi_cancilleria/app/ui/pages/components/image_cache.dart';
import 'package:mi_cancilleria/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          getVerSpace(23),
          getPaddingWidget(
            EdgeInsets.only(left: 15.w, right: 15.w, top: 0.h, bottom: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getAssetImage("logo-bicentenario.webp", 150.w, 50.h,
                    fit: BoxFit.contain),
                getAssetImage("logo_mre.webp", 210.w, 65.h,
                    fit: BoxFit.contain),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              primary: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(
                  height: 170.h,
                  child: Obx(() {
                    if (controller.isLoadingConsultado) {
                      return Container(
                        width: 374.w,
                        height: 184.h,
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
                    if (controller.hasConsultadoError) {
                      return Container(
                        width: 374.w,
                        height: 184.h,
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
                                  "Error al cargar datos", 16, Colors.red, 1,
                                  fontWeight: FontWeight.w600),
                              getVerSpace(8),
                              getButton(context, blueColor, "Reintentar",
                                  Colors.white, () {
                                controller.consultadoController?.refreshData();
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
                    // Obtener definiciones desde la API
                    final definiciones = controller.getSliderDefiniciones();

                    if (definiciones.isEmpty) {
                      // Sin datos disponibles
                      return Container(
                        width: 374.w,
                        height: 184.h,
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
                              getCustomFont("No hay información disponible", 16,
                                  Colors.grey, 1,
                                  fontWeight: FontWeight.w600),
                            ],
                          ),
                        ),
                      );
                    }

                    // Mostrar datos de la API
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
                              width: 374.w,
                              height: 184.h,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 243, 243, 243),
                                  borderRadius: BorderRadius.circular(20.r)),
                              alignment: Alignment.center,
                            ),
                            Positioned(
                                child: SizedBox(
                              height: 180.h,
                              width: 374.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getPaddingWidget(
                                    EdgeInsets.only(
                                        left: 20.w, top: 30.h, bottom: 25.h),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: 150.w,
                                            child: getMultilineCustomFont(
                                                definicion.titulo,
                                                18,
                                                const Color.fromARGB(
                                                    255, 47, 47, 47),
                                                fontWeight: FontWeight.w800,
                                                txtHeight: 1.2)),
                                        getButton(context, blueColor, "Ver Más",
                                            Colors.white, () {
                                          controller.goToDefinicionDetail(
                                              definicion, index);
                                        }, 14,
                                            weight: FontWeight.w600,
                                            buttonWidth: 108,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            insetsGeometrypadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12.h)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 5.w),
                                    height: 185.h,
                                    width: 185.w,
                                    color: Colors.transparent,
                                    child: getAssetImage(
                                        definicion.imagen?.isNotEmpty == true
                                            ? definicion.imagen!
                                            : "out-${definicion.orden}.png",
                                        132,
                                        165,
                                        fit: BoxFit.contain),
                                  )
                                ],
                              ),
                            ))
                          ],
                        );
                      },
                    );
                  }),
                ),
                getVerSpace(16),
                Obx(() {
                  final definiciones = controller.getSliderDefiniciones();
                  if (definiciones.isEmpty ||
                      controller.isLoadingConsultado ||
                      controller.hasConsultadoError) {
                    return const SizedBox
                        .shrink(); // No mostrar indicadores si no hay datos
                  }

                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 8.h,
                      width: (definiciones.length * 18)
                          .w, // Ancho dinámico basado en número de definiciones
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
                }),
                getVerSpace(24),
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
                    final List<Region> regions = controller.getPaisregion();

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        child: getCustomFont("Ver Más", 14, blueColor, 1,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                getVerSpace(16),
                SizedBox(
                  height: 215.h,
                  child: Obx(() {
                    final List<Servicio> servicios = controller.getServicios();

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
                      itemCount: servicios.length > 3
                          ? 3
                          : servicios
                              .length, // Limitar a máximo 4 o los disponibles
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        width: 150.w,
                                        height: 120.h,
                                        fallbackAssetImage: fallbackImage,
                                      ),
                                    )),
                                SizedBox(
                                  width: 153
                                      .w, // Limitar el ancho disponible (177 - 24 padding)
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: getCustomFont(
                                          service.titulo, 14, Colors.black, 1,
                                          fontWeight: FontWeight.w800)),
                                ),
                                SizedBox(
                                  width: 153
                                      .w, // Limitar el ancho disponible (177 - 24 padding)
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: getCustomFont(
                                        service.descripcion,
                                        12,
                                        Colors.grey[600]!,
                                        1, // Permitir máximo 2 líneas
                                        fontWeight: FontWeight.w400,
                                      )),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
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

