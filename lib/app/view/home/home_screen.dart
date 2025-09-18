import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  final int index;

  const HomeScreen(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializar posición si no está inicializado
    if (controller.position.value != index) {
      controller.initialize(index);
    }

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: SafeArea(
          child: Obx(() => controller.tabList.isNotEmpty ? controller.tabList[controller.position.value] : const SizedBox()),
        ),
        bottomNavigationBar: bottomNavigationBar(controller),
      ),
      onWillPop: () async {
        controller.closeApp();
        return false;
      },
    );
  }

  Widget bottomNavigationBar(HomeController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      height: 100.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0.0, 4.0)),
          ],
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(controller.itemList.length, (index) {
          return GestureDetector(
            onTap: () => controller.changePosition(index),
            child: Obx(() => Container(
              decoration: BoxDecoration(
                  color: controller.position.value == index ? blueColor : Colors.transparent,
                  shape: BoxShape.circle),
              child: Padding(
                padding: EdgeInsets.all(13.h),
                child: getSvgImage(controller.itemList[index],
                    width: 24.h,
                    height: 24.h,
                    color: controller.position.value == index ? Colors.white : null),
              ),
            )),
          );
        }),
      ),
    );
  }
}
