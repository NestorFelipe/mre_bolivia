import 'package:mi_cancilleria/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../base/color_data.dart';
import '../../../../controllers/tab_schedule_controller.dart';

class TabSchedule extends StatelessWidget {
  const TabSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabScheduleController>(
      init: TabScheduleController(),
      builder: (controller) => Column(
        children: [
          getVerSpace(20.h),
          getPaddingWidget(
            EdgeInsets.symmetric(horizontal: 20.w),
            withoutleftIconToolbar(context,
                isrightimage: true,
                title: "Schedule",
                weight: FontWeight.w800,
                textColor: Colors.black,
                fontsize: 24,
                istext: true,
                rightimage: "notification.svg"),
          ),
          Obx(() => controller.schedule.value ? Container() : nullScheduleView(context, controller)),
          Obx(() => controller.schedule.value
              ? Expanded(
                  flex: 1,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      getVerSpace(30.h),
                      calendar(),
                      getVerSpace(30.h),
                      addReminderButton(context),
                      getVerSpace(20.h),
                      getPaddingWidget(
                        EdgeInsets.symmetric(horizontal: 20.w),
                        Align(
                            alignment: Alignment.topLeft,
                            child: getCustomFont(
                                "8 Jul, 2022, Tuesday ", 16, textColor, 1,
                                fontWeight: FontWeight.w400)),
                      ),
                      getVerSpace(10.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0.0, 4.0)),
                            ],
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 91.h,
                                      width: 91.h,
                                      decoration: BoxDecoration(
                                        image: getDecorationAssetImage(
                                            context, "booking1.png"),
                                      ),
                                    ),
                                    getHorSpace(16.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getCustomFont(
                                            "Cleaning", 16, Colors.black, 1,
                                            fontWeight: FontWeight.w800),
                                        getVerSpace(6.h),
                                        getCustomFont("08 July, 2022, 11:00 am",
                                            14, textColor, 1,
                                            fontWeight: FontWeight.w400),
                                        getVerSpace(6.h),
                                        Row(
                                          children: [
                                            getSvgImage("star.svg",
                                                height: 16.h, width: 16.h),
                                            getHorSpace(6.w),
                                            getCustomFont(
                                                "4.3", 14, Colors.black, 1,
                                                fontWeight: FontWeight.w400),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: getSvgImage("trash.svg",
                                          width: 20.h, height: 20.h),
                                    ),
                                    getVerSpace(43.h),
                                    getCustomFont("\$20.00", 16, blueColor, 1,
                                        fontWeight: FontWeight.w800)
                                  ],
                                )
                              ],
                            ),
                            getVerSpace(16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    getAssetImage("dot.png", 8.h, 8.h),
                                    getHorSpace(8.w),
                                    getCustomFont(
                                        "By Mendy Wilson", 14, textColor, 1,
                                        fontWeight: FontWeight.w400),
                                  ],
                                ),
                                Wrap(
                                  children: [
                                    getButton(context, const Color(0xFFEEFCF0),
                                        "Active", success, () {}, 16,
                                        weight: FontWeight.w600,
                                        borderRadius: BorderRadius.circular(37.r),
                                        insetsGeometrypadding:
                                            EdgeInsets.symmetric(
                                                vertical: 6.h, horizontal: 12.w))
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      getVerSpace(20.h),
                      getPaddingWidget(
                        EdgeInsets.symmetric(horizontal: 20.w),
                        Align(
                            alignment: Alignment.topLeft,
                            child: getCustomFont(
                                "25 Jul, 2022, Friday ", 16, textColor, 1,
                                fontWeight: FontWeight.w400)),
                      ),
                      getVerSpace(10.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0.0, 4.0)),
                            ],
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 91.h,
                                      width: 91.h,
                                      decoration: BoxDecoration(
                                        image: getDecorationAssetImage(
                                            context, "booking2.png"),
                                      ),
                                    ),
                                    getHorSpace(16.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getCustomFont(
                                            "Painting", 16, Colors.black, 1,
                                            fontWeight: FontWeight.w800),
                                        getVerSpace(6.h),
                                        getCustomFont("22 April, 2022, 08:00 am",
                                            14, textColor, 1,
                                            fontWeight: FontWeight.w400),
                                        getVerSpace(6.h),
                                        Row(
                                          children: [
                                            getSvgImage("star.svg",
                                                height: 16.h, width: 16.h),
                                            getHorSpace(6.w),
                                            getCustomFont(
                                                "4.2", 14, Colors.black, 1,
                                                fontWeight: FontWeight.w400),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: getSvgImage("trash.svg",
                                          width: 20.h, height: 20.h),
                                    ),
                                    getVerSpace(43.h),
                                    getCustomFont("\$50.00", 16, blueColor, 1,
                                        fontWeight: FontWeight.w800)
                                  ],
                                )
                              ],
                            ),
                            getVerSpace(16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    getAssetImage("dot.png", 8.h, 8.h),
                                    getHorSpace(8.w),
                                    getCustomFont(
                                        "By Jenny Winget", 14, textColor, 1,
                                        fontWeight: FontWeight.w400),
                                  ],
                                ),
                                Wrap(
                                  children: [
                                    getButton(context, const Color(0xFFEEFCF0),
                                        "Active", success, () {}, 16,
                                        weight: FontWeight.w600,
                                        borderRadius: BorderRadius.circular(37.r),
                                        insetsGeometrypadding:
                                            EdgeInsets.symmetric(
                                                vertical: 6.h, horizontal: 12.w))
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      getVerSpace(20.h),
                    ],
                  ),
                )
              : Container())
        ],
      ),
    );
  }

  Widget addReminderButton(BuildContext context) {
    return getButton(context, const Color(0xFFF2F4F8), "+ Add Reminder",
        blueColor, () {}, 18,
        weight: FontWeight.w600,
        borderRadius: BorderRadius.circular(14.r),
        buttonHeight: 60.h,
        insetsGeometry: EdgeInsets.symmetric(horizontal: 95.w));
  }

  Container calendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      height: 363.h,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0.0, 4.0)),
          ],
          borderRadius: BorderRadius.circular(20.r)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: SfDateRangePicker(
          monthViewSettings: const DateRangePickerMonthViewSettings(
            dayFormat: "EEE",
          ),
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {},
          selectionShape: DateRangePickerSelectionShape.circle,
          showNavigationArrow: true,
          backgroundColor: Colors.white,
          rangeSelectionColor: Colors.white,
          rangeTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
          startRangeSelectionColor: blueColor,
          endRangeSelectionColor: blueColor,
          monthCellStyle: DateRangePickerMonthCellStyle(
              todayCellDecoration: BoxDecoration(
                  border: Border.all(color: blueColor), shape: BoxShape.circle),
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
              todayTextStyle: TextStyle(
                  color: blueColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400)),
          selectionTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
          selectionMode: DateRangePickerSelectionMode.range,
          headerStyle: DateRangePickerHeaderStyle(
              textAlign: TextAlign.start,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16.sp)),
        ),
      ),
    );
  }

  Expanded nullScheduleView(BuildContext context, TabScheduleController controller) {
    return Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 124.h,
              width: 124.h,
              decoration: BoxDecoration(
                image: getDecorationAssetImage(context, "schedule.png"),
              ),
            ),
            getVerSpace(40.h),
            getCustomFont("No Schedule Yet!", 20, Colors.black, 1,
                fontWeight: FontWeight.w800),
            getVerSpace(10.h),
            getCustomFont(
                "Make Schedule for better services. ", 16, Colors.black, 1,
                fontWeight: FontWeight.w400),
            getVerSpace(30.h),
            getButton(context, backGroundColor, "Make Schedule", blueColor, controller.makeSchedule, 18,
                weight: FontWeight.w600,
                buttonHeight: 60.h,
                insetsGeometry: EdgeInsets.symmetric(horizontal: 118.w),
                borderRadius: BorderRadius.circular(14.r),
                isBorder: true,
                borderColor: blueColor,
                borderWidth: 1.5)
          ],
        ));
  }
}

