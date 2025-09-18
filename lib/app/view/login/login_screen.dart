import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) => WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ListView(
                primary: true,
                shrinkWrap: true,
                children: [
                  getVerSpace(70.h),
                  Align(
                    alignment: Alignment.topCenter,
                    child: getCustomFont(
                      "Login",
                      24,
                      Colors.black,
                      1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  getVerSpace(10.h),
                  Align(
                    alignment: Alignment.topCenter,
                    child: getCustomFont(
                      "Glad to meet you again! ",
                      16,
                      Colors.black,
                      1,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  getVerSpace(30.h),
                  getDefaultTextFiledWithLabel(
                    context,
                    "Email",
                    controller.emailController,
                    Colors.grey,
                    function: () {},
                    height: 60.h,
                    isEnable: false,
                    withprefix: true,
                    image: "message.svg",
                  ),
                  getVerSpace(20.h),
                  Obx(() => getDefaultTextFiledWithLabel(
                      context, "Password", controller.passwordController, Colors.grey,
                      function: () {},
                      height: 60.h,
                      isEnable: false,
                      withprefix: true,
                      image: "lock.svg",
                      isPass: controller.isPassVisible.value,
                      withSufix: true,
                      suffiximage: "eye.svg", imagefunction: () {
                    controller.togglePasswordVisibility();
                  })),
                  getVerSpace(19.h),
                  Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: controller.goToForgotPassword,
                        child: getCustomFont(
                            "Forgot Password?", 16, blueColor, 1,
                            fontWeight: FontWeight.w800,),
                      )),
                  getVerSpace(49.h),
                  getButton(context, blueColor, "Login", Colors.white, controller.login, 18,
                      weight: FontWeight.w600,
                      buttonHeight: 60.h,
                      borderRadius: BorderRadius.circular(15.h)),
                  getVerSpace(30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getCustomFont(
                          "Don’t have an account?", 14, Colors.black, 1,
                          fontWeight: FontWeight.w400,),
                      GestureDetector(
                        onTap: controller.goToSignUp,
                        child: getCustomFont(" Sign Up", 16, blueColor, 1,
                            fontWeight: FontWeight.w800,),
                      )
                    ],
                  ),
                  getVerSpace(50.h),
                  getDivider(dividerColor, 1.h, 1),
                  getVerSpace(50.h),
                  getButton(
                    context,
                    Colors.white,
                    "Login with Google",
                    Colors.black,
                    () {},
                    18,
                    weight: FontWeight.w600,
                    isIcon: true,
                    image: "google.svg",
                    buttonHeight: 60.h,
                    borderRadius: BorderRadius.circular(15.h),
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0.0, 4.0)),
                    ],
                  ),
                  getVerSpace(20.h),
                  getButton(context, Colors.white, "Login with Facebook",
                      Colors.black, () {}, 18,
                      weight: FontWeight.w600,
                      isIcon: true,
                      image: "facebook.svg",
                      buttonHeight: 60.h,
                      borderRadius: BorderRadius.circular(15.h),
                      boxShadow: [
                        const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0.0, 4.0)),
                      ]),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Constant.closeApp();
          return false;
        }),
    );
  }
}
