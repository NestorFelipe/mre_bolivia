import 'package:mre_bolivia/app/models/consulado/model_servicio.dart';
import 'package:mre_bolivia/app/ui/pages/components/image_cache.dart';
import 'package:mre_bolivia/base/utils/utils.dart';
import 'package:mre_bolivia/controllers/consulado/consulado_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';

class CategoryScreen extends GetView<ConsuladoController> {
  const CategoryScreen({super.key});

  Widget _getToolbarMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: controller.goBack,
          child: getSvgImage("back.svg", height: 24, width: 24),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: getCustomFont("Servicios", 24, Colors.black, 1,
                fontWeight: FontWeight.w800),
          ),
        ),
        Container(width: 24.w), // Spacer para balancear
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
              getVerSpace(18),
              Expanded(
                flex: 1,
                child: _categoryView(),
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

  Widget _categoryView() {
    return Obx(() => AnimationLimiter(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            primary: true,
            itemCount: controller.servicios.length,
            itemBuilder: (context, index) {
              Servicio modelServicio = controller.servicios[index];

              return GestureDetector(
                onTap: () => controller.navigateToServicioDetail(modelServicio),
                child: AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 600),
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              offset: Offset(0.0, 4.0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize
                              .min, // Importante: ajustar al contenido
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.r)),
                              child: CustomCacheImage(
                                imageUrl: modelServicio.imagen,
                                height: 100,
                                width: 150,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                                height:
                                    8.h), // Espaciado fijo entre imagen y texto
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Center(
                                  child: Text(
                                    modelServicio.titulo,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color:
                                          const Color.fromARGB(255, 43, 43, 43),
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 3, // Máximo 3 líneas
                                    overflow: TextOverflow
                                        .ellipsis, // Truncar con "..." si es necesario
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 18.w,
              mainAxisSpacing: 20.h,
              childAspectRatio: 1.0, // Permite más altura para el contenido
            ),
          ),
        ));
  }
}
