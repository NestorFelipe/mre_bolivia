import 'package:fix_store/app/routes/app_routes.dart';
import 'package:fix_store/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              child: Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  gettoolbarMenu(context, "back.svg", () {
                    Constant.backToPrev(context);
                  },
                      istext: true,
                      title: "Settings",
                      weight: FontWeight.w800,
                      fontsize: 24,
                      textColor: Colors.black),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  notificationButton(context),
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  helpButton(context),
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  privacyButton(context),
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  securityButton(context),
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  termOfServiceButton(context),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Constant.backToPrev(context);
          return false;
        });
  }

  Widget termOfServiceButton(BuildContext context) {
    return getButtonWithIcon(
        context, Colors.white, "Terms of Service", Colors.black, () {
      Constant.sendToNext(context, Routes.termOfServiceRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "documnet.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget securityButton(BuildContext context) {
    return getButtonWithIcon(context, Colors.white, "Security", Colors.black,
        () {
      Constant.sendToNext(context, Routes.securityRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "lock.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget privacyButton(BuildContext context) {
    return getButtonWithIcon(
        context, Colors.white, "Privacy Policy", Colors.black, () {
      Constant.sendToNext(context, Routes.privacyRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "privacy.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget helpButton(BuildContext context) {
    return getButtonWithIcon(
        context, Colors.white, "Help & Support", Colors.black, () {
      Constant.sendToNext(context, Routes.helpRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "info.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget notificationButton(BuildContext context) {
    return getButtonWithIcon(
        context, Colors.white, "Notifications", Colors.black, () {
      Constant.sendToNext(context, Routes.notificationRoutes);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "notification_unselected.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }
}
