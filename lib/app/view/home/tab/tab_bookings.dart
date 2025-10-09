import 'package:mi_cancilleria/app/view/bookings/active_booking_screen.dart';
import 'package:mi_cancilleria/app/view/bookings/cancel_booking_screen.dart';
import 'package:mi_cancilleria/app/view/bookings/complete_booking_screen.dart';
import 'package:mi_cancilleria/base/color_data.dart';
import 'package:mi_cancilleria/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../controllers/tab_bookings_controller.dart';

class TabBookings extends StatelessWidget {
  const TabBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabBookingsController>(
      init: TabBookingsController(),
      builder: (controller) => Column(
        children: [
          getVerSpace(20.h),
          getPaddingWidget(
            EdgeInsets.symmetric(horizontal: 20.w),
            withoutleftIconToolbar(context,
                isrightimage: true,
                title: "Bookings",
                weight: FontWeight.w800,
                textColor: Colors.black,
                fontsize: 24,
                istext: true,
                rightimage: "notification.svg"),
          ),
          getVerSpace(30.h),
          tabbar(controller),
          getVerSpace(10.h),
          pageViewer(controller)
        ],
      ),
    );
  }

  Expanded pageViewer(TabBookingsController controller) {
    return Expanded(
      child: PageView(
        physics: const BouncingScrollPhysics(),
        controller: controller.pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: controller.changePage,
        children: const [
          // ConsuladosScreen(),
          ActiveBookingScreen(),
          CompleteBookingScreen(),
          CancelBookingScreen()
        ],
      ),
    );
  }

  Widget tabbar(TabBookingsController controller) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.w),
      TabBar(
        indicatorColor: Colors.transparent,
        physics: const BouncingScrollPhysics(),
        controller: controller.tabController,
        labelPadding: EdgeInsets.zero,
        onTap: controller.changeTab,
        tabs: [
          Tab(
            child: Container(
                alignment: Alignment.center,
                child: Obx(() => Column(
                      children: [
                        getCustomFont(
                            "All",
                            16,
                            controller.position.value == 0
                                ? blueColor
                                : Colors.black,
                            1,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.visible),
                        getVerSpace(7.h),
                        Container(
                          height: 2.h,
                          color: controller.position.value == 0
                              ? blueColor
                              : const Color(0xFFE5E8F1),
                        )
                      ],
                    ))),
          ),
          Tab(
            child: Container(
                alignment: Alignment.center,
                child: Obx(() => Column(
                      children: [
                        getCustomFont(
                            "Active",
                            16,
                            controller.position.value == 1
                                ? blueColor
                                : Colors.black,
                            1,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.visible),
                        getVerSpace(7.h),
                        Container(
                          height: 2.h,
                          color: controller.position.value == 1
                              ? blueColor
                              : const Color(0xFFE5E8F1),
                        )
                      ],
                    ))),
          ),
          Tab(
            child: Container(
                alignment: Alignment.center,
                child: Obx(() => Column(
                      children: [
                        getCustomFont(
                            "Completed",
                            16,
                            controller.position.value == 2
                                ? blueColor
                                : Colors.black,
                            1,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.visible),
                        getVerSpace(7.h),
                        Container(
                          height: 2.h,
                          color: controller.position.value == 2
                              ? blueColor
                              : const Color(0xFFE5E8F1),
                        )
                      ],
                    ))),
          ),
          Tab(
            child: Container(
                alignment: Alignment.center,
                child: Obx(() => Column(
                      children: [
                        getCustomFont(
                            "Cancelled",
                            16,
                            controller.position.value == 3
                                ? blueColor
                                : Colors.black,
                            1,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.visible),
                        getVerSpace(7.h),
                        Container(
                          height: 2.h,
                          color: controller.position.value == 3
                              ? blueColor
                              : const Color(0xFFE5E8F1),
                        )
                      ],
                    ))),
          )
        ],
      ),
    );
  }
}
