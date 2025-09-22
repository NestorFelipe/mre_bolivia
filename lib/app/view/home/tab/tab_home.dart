import 'package:fix_store/app/data/data_file.dart';
import 'package:fix_store/app/models/model_category.dart';
import 'package:fix_store/app/models/model_popular_service.dart';
import 'package:fix_store/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../controllers/tab_home_controller.dart';
import '../../../../base/constant.dart';

class TabHome extends StatelessWidget {
  const TabHome({super.key});

  // Helper functions usando flutter_screenutil
  Widget _getVerSpace(double height) => SizedBox(height: height.h);
  Widget _getHorSpace(double width) => SizedBox(width: width.w);
  
  Widget _getPaddingWidget(EdgeInsets padding, Widget child) => Padding(
    padding: padding,
    child: child,
  );

  Widget _getSvgImage(String imageName, {double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      "${Constant.assetImagePath}$imageName",
      width: width?.w,
      height: height?.h,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  Widget _getAssetImage(String imageName, double width, double height, {BoxFit fit = BoxFit.cover}) {
    return Image.asset(
      "${Constant.assetImagePath}$imageName",
      width: width.w,
      height: height.h,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width.w,
          height: height.h,
          color: Colors.grey[300],
          child: Icon(
            Icons.image_not_supported,
            size: 32.w,
            color: Colors.grey[600],
          ),
        );
      },
    );
  }

  Widget _getCustomFont(String text, double fontSize, Color color, int maxLines, {
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    double? height,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize.sp,
        color: color,
        fontWeight: fontWeight,
        fontFamily: Constant.fontsFamily,
        height: height,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  Widget _getMultilineCustomFont(String text, double fontSize, Color color, {
    FontWeight fontWeight = FontWeight.normal,
    double? txtHeight,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize.sp,
        color: color,
        fontWeight: fontWeight,
        fontFamily: Constant.fontsFamily,
        height: txtHeight,
      ),
    );
  }

  Widget _getButton(BuildContext context, Color bgColor, String text, Color textColor, 
      VoidCallback onPressed, double fontSize, {
    FontWeight weight = FontWeight.bold,
    double? buttonWidth,
    BorderRadius? borderRadius,
    EdgeInsets? insetsGeometrypadding,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: buttonWidth?.w,
        padding: insetsGeometrypadding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: _getCustomFont(text, fontSize, textColor, 1, 
            fontWeight: weight, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabHomeController>(
      init: TabHomeController(),
      builder: (controller) => Column(
        children: [
          _getVerSpace(21),
          _getPaddingWidget(
            EdgeInsets.symmetric(horizontal: 20.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getSvgImage("menu.svg", height: 24, width: 24),
                Column(
                  children: [
                    Obx(() => controller.isPrefsReady.value
                        ? _getCustomFont("Hola ${controller.sharedController.userName.value}", 14, Colors.black, 1,
                            fontWeight: FontWeight.w400)
                        : const Text("Cargando...")),
                    Row(
                      children: [
                        _getSvgImage("location.svg"),
                        _getHorSpace(4),
                        _getCustomFont("Shiloh, Hawaii", 14, Colors.black, 1,
                            fontWeight: FontWeight.w400)
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: controller.goToNotifications,
                  child: _getSvgImage("notification.svg",
                      height: 24, width: 24),
                ),
              ],
            ),
          ),
          _getVerSpace(20),
          Expanded(
            flex: 1,
            child: ListView(
              primary: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(
                  height: 184.h,
                  child: Obx(() {
                    // Verificar estado de los datos del consulado
                    if (controller.isLoadingConsultado) {
                      // Estado de carga
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
                              _getVerSpace(16),
                              _getCustomFont("Cargando información...", 16, Colors.black, 1,
                                  fontWeight: FontWeight.w600),
                            ],
                          ),
                        ),
                      );
                    }

                    if (controller.hasConsultadoError) {
                      // Estado de error
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
                              Icon(Icons.error_outline, color: Colors.red[400], size: 48.w),
                              _getVerSpace(8),
                              _getCustomFont("Error al cargar datos", 16, Colors.red, 1,
                                  fontWeight: FontWeight.w600),
                              _getVerSpace(8),
                              _getButton(context, blueColor, "Reintentar", Colors.white, () {
                                controller.consultadoController?.refreshData();
                              }, 12,
                                  weight: FontWeight.w600,
                                  buttonWidth: 100,
                                  borderRadius: BorderRadius.circular(8.r),
                                  insetsGeometrypadding: EdgeInsets.symmetric(vertical: 8.h)),
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
                              Icon(Icons.info_outline, color: Colors.grey[600], size: 48.w),
                              _getVerSpace(8),
                              _getCustomFont("No hay información disponible", 16, Colors.grey, 1,
                                  fontWeight: FontWeight.w600),
                              _getVerSpace(8),
                              _getButton(context, blueColor, "Ver Consulado", Colors.white, () {
                                controller.goToConsulado();
                              }, 12,
                                  weight: FontWeight.w600,
                                  buttonWidth: 120,
                                  borderRadius: BorderRadius.circular(8.r),
                                  insetsGeometrypadding: EdgeInsets.symmetric(vertical: 8.h)),
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
                                  color: const Color.fromARGB(255, 243, 243, 243),
                                  borderRadius: BorderRadius.circular(20.r)),
                              alignment: Alignment.center,
                            ),
                            Positioned(
                                child: SizedBox(
                              height: 180.h,
                              width: 374.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _getPaddingWidget(
                                    EdgeInsets.only(
                                        left: 20.w,
                                        top: 20.h,
                                        bottom: 20.h),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: 150.w,
                                            child: _getMultilineCustomFont(
                                                definicion.titulo ?? "Sin título",
                                                18,
                                                const Color.fromARGB(255, 47, 47, 47),
                                                fontWeight: FontWeight.w800,
                                                txtHeight: 1.2)),
                                        // _getVerSpace(2),
                                        // SizedBox(
                                        //   width: 200.w,
                                        //   child: _getCustomFont(definicion.valor ?? "Sin descripción", 13,
                                        //       Colors.black, 3,
                                        //       fontWeight: FontWeight.w400),
                                        // ),
                                        // _getVerSpace(16),
                                        _getButton(context, blueColor, "Ver Más",
                                            Colors.white, () {
                                          controller.goToDefinicionDetail(definicion, index);
                                        }, 14,
                                            weight: FontWeight.w600,
                                            buttonWidth: 108,
                                            borderRadius: BorderRadius.circular(10.r),
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
                                      child: _getAssetImage("out-${definicion.funcionId}.png", 132, 165, fit: BoxFit.contain),
                              )],
                              ),
                            ))
                          ],
                        );
                      },
                    );
                  }),
                ),
                _getVerSpace(14),
                Obx(() {
                  final definiciones = controller.getSliderDefiniciones();
                  if (definiciones.isEmpty || controller.isLoadingConsultado || controller.hasConsultadoError) {
                    return const SizedBox.shrink(); // No mostrar indicadores si no hay datos
                  }
                  
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 8.h,
                      width: (definiciones.length * 18).w, // Ancho dinámico basado en número de definiciones
                      alignment: Alignment.center,
                      child: ListView.builder(
                        primary: false,
                        itemCount: definiciones.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return _getPaddingWidget(
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
                _getVerSpace(24),
                _getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _getCustomFont("Categories", 20, Colors.black, 1,
                          fontWeight: FontWeight.w800),
                      GestureDetector(
                        onTap: controller.goToCategories,
                        child: _getCustomFont("View All", 14, blueColor, 1,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                _getVerSpace(16),
                SizedBox(
                  height: 132.h,
                  child: ListView.builder(
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      ModelCategory modelCategory = DataFile.categoryList[index];
                      return GestureDetector(
                        onTap: () => controller.goToCategoryDetail(),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: index == 0 ? 20.w : 0,
                              right: 20.w,
                              bottom: 28.h),
                          padding: EdgeInsets.only(
                              top: 16.h, bottom: 12.h),
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
                              _getSvgImage(modelCategory.image ?? "",
                                  width: 44, height: 44),
                              _getVerSpace(10),
                              _getCustomFont(
                                  modelCategory.name ?? "", 14, Colors.black, 1,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _getCustomFont("Popular Services", 20, Colors.black, 1,
                          fontWeight: FontWeight.w800),
                      _getCustomFont("View All", 14, blueColor, 1,
                          fontWeight: FontWeight.w600)
                    ],
                  ),
                ),
                _getVerSpace(16),
                SizedBox(
                  height: 215.h,
                  child: ListView.builder(
                    primary: false,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: DataFile.popularServiceList.length,
                    itemBuilder: (context, index) {
                      ModelPopularService modelPopularService =
                          DataFile.popularServiceList[index];
                      return GestureDetector(
                        onTap: () => controller.goToDetail(index),
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
                          padding: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                              top: 10.h,
                              bottom: 10.h),
                          margin: EdgeInsets.only(
                              left: index == 0 ? 20.w : 0,
                              bottom: 24.h,
                              right: 20.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Hero(
                                tag: DataFile.popularServiceList[index],
                                child: _getAssetImage(
                                    modelPopularService.image ?? "",
                                    157,
                                    115),
                              ),
                              _getVerSpace(10),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: _getCustomFont(
                                      modelPopularService.name ?? "",
                                      14,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w800)),
                              _getVerSpace(4),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: _getCustomFont(
                                      modelPopularService.category ?? "",
                                      14,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
