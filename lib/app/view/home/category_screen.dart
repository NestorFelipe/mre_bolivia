import 'package:fix_store/app/models/model_category.dart';
import 'package:fix_store/base/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../controllers/category_controller.dart';

class CategoryScreen extends GetView<CategoryController> {
  const CategoryScreen({super.key});

  // Helper functions usando flutter_screenutil
  Widget _getVerSpace(double height) => SizedBox(height: height.h);
  
  Widget _getPaddingWidget(EdgeInsets padding, Widget child) => Padding(
    padding: padding,
    child: child,
  );

  Widget _getSvgImage(String imageName, {double? width, double? height}) {
    return SvgPicture.asset(
      "${Constant.assetImagePath}$imageName",
      width: width?.w,
      height: height?.h,
    );
  }

  Widget _getCustomFont(String text, double fontSize, Color color, int maxLines, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize.sp,
        color: color,
        fontWeight: fontWeight,
        fontFamily: Constant.fontsFamily,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _getToolbarMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: controller.goBack,
          child: _getSvgImage("back.svg", height: 24, width: 24),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: _getCustomFont(
              "Categories", 
              24, 
              Colors.black, 
              1,
              fontWeight: FontWeight.w800
            ),
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
              _getVerSpace(20),
              _getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.w),
                _getToolbarMenu(),
              ),
              _getVerSpace(32),
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
        itemCount: controller.categoryList.length,
        itemBuilder: (context, index) {
          ModelCategory modelCategory = controller.categoryList[index];
          return GestureDetector(
            onTap: () => controller.goToCategoryDetail(index),
            child: AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 300),
              columnCount: controller.numberOfColumns.value,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 24.h,
                      bottom: 16.h,
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
                        _getSvgImage(
                          modelCategory.image ?? "",
                          width: 44,
                          height: 44,
                        ),
                        _getVerSpace(15),
                        _getCustomFont(
                          modelCategory.name ?? '',
                          14,
                          Colors.black,
                          1,
                          fontWeight: FontWeight.w400,
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
          crossAxisCount: controller.numberOfColumns.value,
          crossAxisSpacing: 19.w,
          mainAxisSpacing: 20.h,
          mainAxisExtent: 121.h,
        ),
      ),
    ));
  }
}
