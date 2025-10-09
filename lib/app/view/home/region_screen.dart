import 'package:mi_cancilleria/app/models/consulado/model_paises.dart';
import 'package:mi_cancilleria/base/color_data.dart';
import 'package:mi_cancilleria/base/widget_utils.dart';
import 'package:mi_cancilleria/controllers/consulado/tab_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class RegionScreen extends GetView<TabHomeController> {
  const RegionScreen({super.key});

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
            child: getCustomFont(
                controller.selectedRegion.value!.nombre, 24, Colors.black, 1,
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
              getVerSpace(32),
              Expanded(
                flex: 1,
                child: _paisesView(),
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

  Widget _paisesView() {
    return Obx(() => AnimationLimiter(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            primary: true,
            itemCount: controller.selectedRegion.value!.paises.length,
            itemBuilder: (context, index) {
              Pais modelPaises = controller.selectedRegion.value!.paises[index];

              return GestureDetector(
                onTap: () => controller.goToConsulado(modelPaises),
                child: AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 600),
                  columnCount: 3,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 14.h,
                          bottom: 18.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0.0, 4.0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.r),
                                topRight: Radius.circular(12.r),
                              ),
                              child: getFlagAssets(
                                  "${modelPaises.alpha2}@3x.png", 64.w, 32.h),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Center(
                                child: getCustomFont(
                                  modelPaises.nombre,
                                  10,
                                  const Color.fromARGB(255, 43, 43, 43),
                                  2,
                                  fontWeight: FontWeight.w800,
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
              crossAxisCount: 3,
              crossAxisSpacing: 19.w,
              mainAxisSpacing: 20.h,
              mainAxisExtent: 100.h,
            ),
          ),
        ));
  }
}

