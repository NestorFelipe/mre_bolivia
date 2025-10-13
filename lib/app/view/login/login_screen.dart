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
                    getAssetImage("logo.png", 240.h, 240.w,
                        boxFit: BoxFit.cover),
                    getVerSpace(40.h),
                    Align(
                      alignment: Alignment.topCenter,
                      child: getCustomFont(
                        "Iniciar Sesión",
                        24,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: getCustomFont(
                        "Indentificate para continuar",
                        16,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    getVerSpace(20.h),
                    TextField(
                      controller: controller.emailController,
                      enabled: true,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: getSvgImage("email.svg"),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.h),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.h),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.h),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 20.h,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    getVerSpace(5.h),
                    Obx(() => TextField(
                          controller: controller.passwordController,
                          enabled: true,
                          obscureText: controller.isPassVisible.value,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: getSvgImage("lock.svg"),
                            ),
                            suffixIcon: IconButton(
                              icon: getSvgImage(controller.isPassVisible.value
                                  ? "eye.svg"
                                  : "eye.svg"),
                              onPressed: () {
                                controller.togglePasswordVisibility();
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.h),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.h),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.h),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 20.h,
                            ),
                          ),
                        )),
                    getVerSpace(20.h),
                    SizedBox(
                      height: 60.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.h),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    getVerSpace(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getCustomFont(
                          "¿No tienes una cuenta?",
                          14,
                          Colors.black,
                          1,
                          fontWeight: FontWeight.w400,
                        ),
                        GestureDetector(
                          onTap: controller.goToSignUp,
                          child: getCustomFont(
                            " Inscribirse",
                            16,
                            blueColor,
                            1,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      ],
                    ),
                    getVerSpace(20.h),
                    getDivider(dividerColor, 1.h, 1),
                    getVerSpace(20.h),
                    SizedBox(
                      height: 60.h,
                      width: double.infinity,
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.h),
                        elevation: 4,
                        shadowColor: Colors.black12,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(15.h),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getSvgImage("google.svg"),
                                SizedBox(width: 12.w),
                                Text(
                                  "Iniciar con Google",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
