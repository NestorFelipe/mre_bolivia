import 'package:dots_indicator/dots_indicator.dart';
import 'package:fix_store/app/data/data_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fix_store/base/resizer/fetch_pixels.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../../controllers/intro_controller.dart';
import '../../models/model_intro.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FetchPixels(context); // Inicializar FetchPixels para getAssetImage
    return GetBuilder<IntroController>(
      init: IntroController(),
      builder: (controller) => WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: DataFile.introList.length,
              itemBuilder: (context, index) {
                ModelIntro introModel = DataFile.introList[index];
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      color: introModel.color,
                      child: Column(
                        children: [
                          getVerSpace(55.h),
                          getAssetImage(
                              introModel.image ?? "",
                              277.w,
                              435.h)
                        ],
                      ),
                    ),
                    Positioned(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            child: getAssetImage(
                                "shape.png",
                                1.sw,
                                460.h,
                                boxFit: BoxFit.fill),
                          ),
                          Positioned(
                            top: 50.h,
                            width: 1.sw,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 263.w,
                                  child: getMultilineCustomFont(
                                      introModel.title ?? "", 34, Colors.black,
                                      fontWeight: FontWeight.w800,
                                      textAlign: TextAlign.center,
                                      txtHeight: 1.3),
                                ),
                                getVerSpace(10.h),
                                getPaddingWidget(
                                  EdgeInsets.symmetric(horizontal: 20.w),
                                  getMultilineCustomFont(
                                      introModel.description ?? "",
                                      16,
                                      Colors.black,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.center,
                                      txtHeight: 1.3),
                                ),
                                getVerSpace(51.h),
                                DotsIndicator(
                                    dotsCount: 3,
                                    position: index.toDouble(),
                                    decorator: DotsDecorator(
                                        size: Size.square(8.h),
                                        activeSize: Size.square(8.h),
                                        activeColor: blueColor,
                                        color: blueColor.withOpacity(0.2),
                                        spacing: EdgeInsets.symmetric(horizontal: 5.w))),
                                getVerSpace(29.h),
                                getButton(
                                    context, blueColor, "Next", Colors.white,
                                    () => controller.nextPage(context, index), 18,
                                    weight: FontWeight.w600,
                                    buttonHeight: 60.h,
                                    insetsGeometry: EdgeInsets.symmetric(horizontal: 20.w),
                                    borderRadius: BorderRadius.circular(15.h)),
                                getVerSpace(16.h),
                                index == 2
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () => controller.skipToLogin(context),
                                        child: getCustomFont(
                                          "Skip",
                                          19,
                                          blueColor,
                                          1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
        onWillPop: () async {
          controller.backClick(context);
          return false;
        }),
    );
  }
}
