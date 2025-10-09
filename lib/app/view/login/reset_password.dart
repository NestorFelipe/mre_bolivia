import 'package:mi_cancilleria/app/view/dialog/reset_dialog.dart';
import 'package:mi_cancilleria/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  void finish() {
    Constant.backToPrev(context);
  }

  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  bool oldpass = true;
  bool newpass = true;
  bool confirmpass = true;

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
                  getCustomFont("Reset Password", 24, Colors.black, 1,
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
                  getVerSpace(FetchPixels.getPixelHeight(36)),
                  getDefaultTextFiledWithLabel(
                      context, "Old Password", oldController, textColor,
                      function: () {},
                      height: FetchPixels.getPixelHeight(60),
                      isEnable: false,
                      withprefix: true,
                      image: "lock.svg",
                      withSufix: true,
                      isPass: oldpass,
                      suffiximage: "eye.svg", imagefunction: () {
                    setState(() {
                      oldpass = !oldpass;
                    });
                  }),
                  getVerSpace(FetchPixels.getPixelHeight(14)),
                  getDefaultTextFiledWithLabel(
                      context, "New Password", newController, textColor,
                      function: () {},
                      height: FetchPixels.getPixelHeight(60),
                      isEnable: false,
                      withprefix: true,
                      image: "lock.svg",
                      withSufix: true,
                      isPass: newpass,
                      suffiximage: "eye.svg", imagefunction: () {
                    setState(() {
                      newpass = !newpass;
                    });
                  }),
                  getVerSpace(FetchPixels.getPixelHeight(14)),
                  getDefaultTextFiledWithLabel(
                      context, "Confirm Password", confirmController, textColor,
                      function: () {},
                      height: FetchPixels.getPixelHeight(60),
                      isEnable: false,
                      withprefix: true,
                      image: "lock.svg",
                      withSufix: true,
                      isPass: confirmpass,
                      suffiximage: "eye.svg", imagefunction: () {
                    setState(() {
                      confirmpass = !confirmpass;
                    });
                  }),
                  getVerSpace(FetchPixels.getPixelHeight(50)),
                  getButton(context, blueColor, "Submit", Colors.white, () {
                    showDialog(
                        barrierDismissible: false,
                        builder: (context) {
                          return const ResetDialog();
                        },
                        context: context);
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

