import 'package:fix_store/app/data/data_file.dart';
import 'package:fix_store/app/models/model_category.dart';
import 'package:fix_store/base/constant.dart';
import 'package:fix_store/base/device_util.dart';
import 'package:fix_store/base/resizer/fetch_pixels.dart';
import 'package:fix_store/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../base/color_data.dart';
import '../../routes/app_routes.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static List<ModelCategory> categoryLists = DataFile.categoryList;

  var noOfGrid = 3;

  @override
  Widget build(BuildContext context) {
    if (DeviceUtil.isTablet) {
      noOfGrid = 6;
    }
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Column(
              children: [
                getVerSpace(FetchPixels.getPixelHeight(20)),
                getPaddingWidget(
                  EdgeInsets.symmetric(
                      horizontal: FetchPixels.getPixelWidth(20)),
                  gettoolbarMenu(context, "back.svg", () {
                    Constant.backToPrev(context);
                  },
                      istext: true,
                      title: "Categories",
                      fontsize: 24,
                      weight: FontWeight.w800,
                      textColor: Colors.black),
                ),
                getVerSpace(FetchPixels.getPixelHeight(32)),
                Expanded(
                  flex: 1,
                  child: categoryView(),
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          Constant.backToPrev(context);
          return false;
        });
  }

  AnimationLimiter categoryView() {
    return AnimationLimiter(
      child: GridView.builder(
        padding:
            EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        primary: true,
        itemCount: categoryLists.length,
        itemBuilder: (context, index) {
          ModelCategory modelCategory = categoryLists[index];
          return GestureDetector(
            onTap: () {
              // showModalBottomSheet(
              //     backgroundColor: backGroundColor,
              //     isDismissible: false,
              //     isScrollControlled: true,
              //     context: context,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.vertical(
              //         top: Radius.circular(FetchPixels.getPixelHeight(40)),
              //       ),
              //     ),
              //     builder: (context) {
              //       return CategoryDialog();
              //     });
              Constant.sendToNext(context, Routes.detailRoute);
            },
            child: AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 300),
              columnCount: noOfGrid,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: FetchPixels.getPixelHeight(24),
                        bottom: FetchPixels.getPixelHeight(16)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0.0, 4.0)),
                        ],
                        borderRadius: BorderRadius.circular(
                            FetchPixels.getPixelHeight(12))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getSvgImage(modelCategory.image ?? "",
                            width: FetchPixels.getPixelHeight(44),
                            height: FetchPixels.getPixelHeight(44)),
                        getVerSpace(FetchPixels.getPixelHeight(15)),
                        getCustomFont(
                            modelCategory.name ?? '', 14, Colors.black, 1,
                            fontWeight: FontWeight.w400)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: noOfGrid,
            crossAxisSpacing: FetchPixels.getPixelWidth(19),
            mainAxisSpacing: FetchPixels.getPixelHeight(20),
            mainAxisExtent: FetchPixels.getPixelHeight(121)),
      ),
    );
  }
}
