import 'package:fix_store/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../base/color_data.dart';
import '../../../../controllers/tab_profile_controller.dart';

class TabProfile extends StatelessWidget {
  const TabProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabProfileController>(
      init: TabProfileController(),
      builder: (controller) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            getVerSpace(20.h),
            withoutleftIconToolbar(context,
                isrightimage: true,
                title: "Profile",
                weight: FontWeight.w800,
                textColor: Colors.black,
                fontsize: 24,
                istext: true,
                rightimage: "notification.svg"),
            getVerSpace(30.h),
            profilePictureView(context),
            getVerSpace(46.h),
            Expanded(
                flex: 1,
                child: ListView(
                  primary: true,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    myProfileButton(context, controller),
                    getVerSpace(20.h),
                    myCardButton(context, controller),
                    getVerSpace(20.h),
                    myAddressButton(context, controller),
                    getVerSpace(20.h),
                    settingButton(context, controller),
                    getVerSpace(30.h),
                    logoutButton(context, controller)
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget logoutButton(BuildContext context, TabProfileController controller) {
    return getButton(context, blueColor, "Logout", Colors.white, controller.logout, 18,
        weight: FontWeight.w600,
        borderRadius: BorderRadius.circular(14.r),
        buttonHeight: 60.h);
  }

  Widget settingButton(BuildContext context, TabProfileController controller) {
    return getButtonWithIcon(context, Colors.white, "Settings", Colors.black,
        controller.goToSettings, 16,
        weight: FontWeight.w400,
        buttonHeight: 60.h,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "setting.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget myAddressButton(BuildContext context, TabProfileController controller) {
    return getButtonWithIcon(context, Colors.white, "My Address", Colors.black,
        controller.goToAddress, 16,
        weight: FontWeight.w400,
        buttonHeight: 60.h,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "location.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget myCardButton(BuildContext context, TabProfileController controller) {
    return getButtonWithIcon(context, Colors.white, "My Cards", Colors.black,
        controller.goToCards, 16,
        weight: FontWeight.w400,
        buttonHeight: 60.h,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "wallet.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget myProfileButton(BuildContext context, TabProfileController controller) {
    return getButtonWithIcon(context, Colors.white, "My Profile", Colors.black,
        controller.goToProfile, 16,
        weight: FontWeight.w400,
        buttonHeight: 60.h,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "profile.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Stack profilePictureView(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 100.h,
          width: 100.h,
          decoration: BoxDecoration(
            image: getDecorationAssetImage(context, "profile_image.png"),
          ),
        ),
        Positioned(
            top: 68.h,
            left: 70.h,
            child: Container(
              height: 46.h,
              width: 46.h,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0.0, 4.0)),
                  ],
                  borderRadius: BorderRadius.circular(35.r)),
              child: getSvgImage("camera.svg", height: 24.h, width: 24.h),
            ))
      ],
    );
  }
}
