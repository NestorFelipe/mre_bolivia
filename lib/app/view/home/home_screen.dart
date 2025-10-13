import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../../controllers/consulado/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  final int index;

  const HomeScreen(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    // Forzar pantalla completa
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Inicializar posición si no está inicializado
    if (controller.position.value != index) {
      controller.initialize(index);
    }

    return WillPopScope(
      onWillPop: () async {
        controller.closeApp();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: Obx(() => controller.tabList.isNotEmpty
            ? controller.tabList[controller.position.value]
            : const SizedBox()),
        bottomNavigationBar: bottomNavigationBar(controller),
      ),
    );
  }

  Widget bottomNavigationBar(HomeController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      height: 90.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 2.0)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(controller.itemList.length, (index) {
          return GestureDetector(
            onTap: () => controller.changePosition(index),
            child: Obx(() => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: controller.position.value == index
                              ? blueColor
                              : Colors.transparent,
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: EdgeInsets.all(10.h),
                        child: getSvgImage(controller.itemList[index],
                            width: 24.h,
                            height: 24.h,
                            color: controller.position.value == index
                                ? Colors.white
                                : null),
                      ),
                    ),
                    getCustomFont(
                        controller.itemLabel[index], 14.sp, blueColor, 1)
                  ],
                )),
          );
        }),
      ),
    );
  }
}
