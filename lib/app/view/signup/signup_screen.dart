import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../../controllers/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
      builder: (controller) => WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  getVerSpace(26.h),
                  gettoolbarMenu(
                    context,
                    "back.svg",
                    controller.back,
                  ),
                  getVerSpace(22.h),
                  getCustomFont(
                    "Sign Up",
                    24,
                    Colors.black,
                    1,
                    fontWeight: FontWeight.w800,
                  ),
                  getVerSpace(10.h),
                  getCustomFont(
                      "Enter your detail for sign up!", 16, Colors.black, 1,
                      fontWeight: FontWeight.w400),
                  getVerSpace(30.h),
                  getDefaultTextFiledWithLabel(
                    context,
                    "Name",
                    controller.nameController,
                    Colors.grey,
                    function: () {},
                    height: 60.h,
                    isEnable: false,
                    withprefix: true,
                    image: "user.svg",
                  ),
                  getVerSpace(20.h),
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
                  GestureDetector(
                      onTap: controller.goToSelectCountry,
                      child: getCountryTextField(
                          context,
                          "Phone Number",
                          controller.phoneController,
                          textColor,
                          "+1", // Placeholder, ajustar con prefs si necesario
                          function: () {},
                          height: 60.h,
                          isEnable: false,
                          minLines: true,
                          image: "image_albania.jpg", // Placeholder
                          inputFormatters: [controller.phoneMaskFormatter])),
                  getVerSpace(20.h),
                  Obx(() => getDefaultTextFiledWithLabel(
                      context, "Password", controller.passwordController, Colors.grey,
                      function: () {},
                      height: 60.h,
                      isEnable: false,
                      withprefix: true,
                      image: "lock.svg",
                      isPass: controller.isPassVisible.value,
                      imageWidth: 19.w,
                      imageHeight: 17.66.h,
                      withSufix: true,
                      suffiximage: "eye.svg", imagefunction: controller.togglePasswordVisibility)),
                  getVerSpace(30.h),
                  Row(
                    children: [
                      Obx(() => GestureDetector(
                        onTap: controller.toggleAgree,
                        child: Container(
                          height: 24.h,
                          width: 24.h,
                          decoration: BoxDecoration(
                              color: (controller.agree.value) ? blueColor : backGroundColor,
                              border: (controller.agree.value)
                                  ? null
                                  : Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(6.h)),
                          padding: EdgeInsets.symmetric(
                              vertical: 6.h,
                              horizontal: 4.w),
                          child: (controller.agree.value) ? getSvgImage("done.svg") : null,
                        ),
                      )),
                      getHorSpace(10.w),
                      getCustomFont(
                          "I agree with Terms & Privacy", 16, Colors.black, 1,
                          fontWeight: FontWeight.w400)
                    ],
                  ),
                  getVerSpace(50.h),
                  getButton(context, blueColor, "Sign Up", Colors.white, controller.signUp, 18,
                      weight: FontWeight.w600,
                      buttonHeight: 60.h,
                      borderRadius: BorderRadius.circular(15.h)),
                  getVerSpace(30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getCustomFont(
                        "Already have an account?",
                        14,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w400,
                      ),
                      GestureDetector(
                        onTap: controller.goToLogin,
                        child: getCustomFont(" Login", 16, blueColor, 1,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          controller.back();
          return false;
        }),
    );
  }
}

