import 'package:fix_store/app/routes/app_routes.dart';
import 'package:fix_store/base/color_data.dart';
import 'package:fix_store/base/resizer/fetch_pixels.dart';
import 'package:fix_store/base/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../../base/constant.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  void finish() {
    Constant.backToPrev(context);
  }

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getPixelWidth(20)),
              child: Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(26)),
                  gettoolbarMenu(
                    context,
                    "back.svg",
                    () {
                      finish();
                    },
                  ),
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  getCustomFont("Forgot Password?", 24, Colors.black, 1,
                      fontWeight: FontWeight.w800),
                  getVerSpace(FetchPixels.getPixelHeight(10)),
                  getPaddingWidget(
                      EdgeInsets.symmetric(
                          horizontal: FetchPixels.getPixelWidth(60)),
                      getMultilineCustomFont(
                          "We need your registration email for reset password!",
                          16,
                          Colors.black,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                          txtHeight: FetchPixels.getPixelHeight(1.3))),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  getDefaultTextFiledWithLabel(
                      context, "Email", emailController, Colors.grey,
                      function: () {},
                      height: FetchPixels.getPixelHeight(60),
                      isEnable: false,
                      withprefix: true,
                      image: "message.svg",
                      imageWidth: FetchPixels.getPixelWidth(19),
                      imageHeight: FetchPixels.getPixelHeight(17.66)),
                  getVerSpace(FetchPixels.getPixelHeight(50)),
                  getButton(context, blueColor, "Submit", Colors.white, () {
                    Constant.sendToNext(context, Routes.resetRoute);
                  }, 18,
                      weight: FontWeight.w600,
                      buttonHeight: FetchPixels.getPixelHeight(60),
                      borderRadius: BorderRadius.circular(
                          FetchPixels.getPixelHeight(15))),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          finish();
          return false;
        });
  }
}
