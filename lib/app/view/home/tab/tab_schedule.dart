import 'package:fix_store/base/resizer/fetch_pixels.dart';
import 'package:fix_store/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../base/color_data.dart';

class TabSchedule extends StatefulWidget {
  const TabSchedule({super.key});

  @override
  State<TabSchedule> createState() => _TabScheduleState();
}

class _TabScheduleState extends State<TabSchedule> {
  bool schedule = false;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Column(
      children: [
        getVerSpace(FetchPixels.getPixelHeight(20)),
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
          withoutleftIconToolbar(context,
              isrightimage: true,
              title: "Schedule",
              weight: FontWeight.w800,
              textColor: Colors.black,
              fontsize: 24,
              istext: true,
              rightimage: "notification.svg"),
        ),
        schedule == true ? Container() : nullScheduleView(context),
        schedule == true
            ? Expanded(
                flex: 1,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  primary: true,
                  shrinkWrap: true,
                  children: [
                    getVerSpace(FetchPixels.getPixelHeight(30)),
                    calendar(),
                    getVerSpace(FetchPixels.getPixelHeight(30)),
                    addReminderButton(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    getPaddingWidget(
                      EdgeInsets.symmetric(
                          horizontal: FetchPixels.getPixelWidth(20)),
                      Align(
                          alignment: Alignment.topLeft,
                          child: getCustomFont(
                              "8 Jul, 2022, Tuesday ", 16, textColor, 1,
                              fontWeight: FontWeight.w400)),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: FetchPixels.getPixelWidth(20)),
                      padding: EdgeInsets.symmetric(
                          vertical: FetchPixels.getPixelHeight(16),
                          horizontal: FetchPixels.getPixelWidth(16)),
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: FetchPixels.getPixelHeight(91),
                                    width: FetchPixels.getPixelHeight(91),
                                    decoration: BoxDecoration(
                                      image: getDecorationAssetImage(
                                          context, "booking1.png"),
                                    ),
                                  ),
                                  getHorSpace(FetchPixels.getPixelWidth(16)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getCustomFont(
                                          "Cleaning", 16, Colors.black, 1,
                                          fontWeight: FontWeight.w800),
                                      getVerSpace(
                                          FetchPixels.getPixelHeight(6)),
                                      getCustomFont("08 July, 2022, 11:00 am",
                                          14, textColor, 1,
                                          fontWeight: FontWeight.w400),
                                      getVerSpace(
                                          FetchPixels.getPixelHeight(6)),
                                      Row(
                                        children: [
                                          getSvgImage("star.svg",
                                              height:
                                                  FetchPixels.getPixelHeight(
                                                      16),
                                              width: FetchPixels.getPixelHeight(
                                                  16)),
                                          getHorSpace(
                                              FetchPixels.getPixelWidth(6)),
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
                                        width: FetchPixels.getPixelHeight(20),
                                        height: FetchPixels.getPixelHeight(20)),
                                  ),
                                  getVerSpace(FetchPixels.getPixelHeight(43)),
                                  getCustomFont("\$20.00", 16, blueColor, 1,
                                      fontWeight: FontWeight.w800)
                                ],
                              )
                            ],
                          ),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  getAssetImage(
                                      "dot.png",
                                      FetchPixels.getPixelHeight(8),
                                      FetchPixels.getPixelHeight(8)),
                                  getHorSpace(FetchPixels.getPixelWidth(8)),
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
                                      borderRadius: BorderRadius.circular(
                                          FetchPixels.getPixelHeight(37)),
                                      insetsGeometrypadding:
                                          EdgeInsets.symmetric(
                                              vertical:
                                                  FetchPixels.getPixelHeight(6),
                                              horizontal:
                                                  FetchPixels.getPixelWidth(
                                                      12)))
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    getPaddingWidget(
                      EdgeInsets.symmetric(
                          horizontal: FetchPixels.getPixelWidth(20)),
                      Align(
                          alignment: Alignment.topLeft,
                          child: getCustomFont(
                              "25 Jul, 2022, Friday ", 16, textColor, 1,
                              fontWeight: FontWeight.w400)),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: FetchPixels.getPixelWidth(20)),
                      padding: EdgeInsets.symmetric(
                          vertical: FetchPixels.getPixelHeight(16),
                          horizontal: FetchPixels.getPixelWidth(16)),
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: FetchPixels.getPixelHeight(91),
                                    width: FetchPixels.getPixelHeight(91),
                                    decoration: BoxDecoration(
                                      image: getDecorationAssetImage(
                                          context, "booking2.png"),
                                    ),
                                  ),
                                  getHorSpace(FetchPixels.getPixelWidth(16)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getCustomFont(
                                          "Painting", 16, Colors.black, 1,
                                          fontWeight: FontWeight.w800),
                                      getVerSpace(
                                          FetchPixels.getPixelHeight(6)),
                                      getCustomFont("22 April, 2022, 08:00 am",
                                          14, textColor, 1,
                                          fontWeight: FontWeight.w400),
                                      getVerSpace(
                                          FetchPixels.getPixelHeight(6)),
                                      Row(
                                        children: [
                                          getSvgImage("star.svg",
                                              height:
                                                  FetchPixels.getPixelHeight(
                                                      16),
                                              width: FetchPixels.getPixelHeight(
                                                  16)),
                                          getHorSpace(
                                              FetchPixels.getPixelWidth(6)),
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
                                        width: FetchPixels.getPixelHeight(20),
                                        height: FetchPixels.getPixelHeight(20)),
                                  ),
                                  getVerSpace(FetchPixels.getPixelHeight(43)),
                                  getCustomFont("\$50.00", 16, blueColor, 1,
                                      fontWeight: FontWeight.w800)
                                ],
                              )
                            ],
                          ),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  getAssetImage(
                                      "dot.png",
                                      FetchPixels.getPixelHeight(8),
                                      FetchPixels.getPixelHeight(8)),
                                  getHorSpace(FetchPixels.getPixelWidth(8)),
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
                                      borderRadius: BorderRadius.circular(
                                          FetchPixels.getPixelHeight(37)),
                                      insetsGeometrypadding:
                                          EdgeInsets.symmetric(
                                              vertical:
                                                  FetchPixels.getPixelHeight(6),
                                              horizontal:
                                                  FetchPixels.getPixelWidth(
                                                      12)))
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                  ],
                ),
              )
            : Container()
      ],
    );
  }

  Widget addReminderButton(BuildContext context) {
    return getButton(context, const Color(0xFFF2F4F8), "+ Add Reminder",
        blueColor, () {}, 18,
        weight: FontWeight.w600,
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
        buttonHeight: FetchPixels.getPixelHeight(60),
        insetsGeometry:
            EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(95)));
  }

  Container calendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
      height: FetchPixels.getPixelHeight(363),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0.0, 4.0)),
          ],
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20)),
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
              fontSize: FetchPixels.getPixelHeight(14),
              fontWeight: FontWeight.w400),
          startRangeSelectionColor: blueColor,
          endRangeSelectionColor: blueColor,
          monthCellStyle: DateRangePickerMonthCellStyle(
              todayCellDecoration: BoxDecoration(
                  border: Border.all(color: blueColor), shape: BoxShape.circle),
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: FetchPixels.getPixelHeight(14),
                  fontWeight: FontWeight.w400),
              todayTextStyle: TextStyle(
                  color: blueColor,
                  fontSize: FetchPixels.getPixelHeight(14),
                  fontWeight: FontWeight.w400)),
          selectionTextStyle: TextStyle(
              color: Colors.white,
              fontSize: FetchPixels.getPixelHeight(14),
              fontWeight: FontWeight.w400),
          selectionMode: DateRangePickerSelectionMode.range,
          headerStyle: DateRangePickerHeaderStyle(
              textAlign: TextAlign.start,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: FetchPixels.getPixelHeight(16))),
        ),
      ),
    );
  }

  Expanded nullScheduleView(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: FetchPixels.getPixelHeight(124),
              width: FetchPixels.getPixelHeight(124),
              decoration: BoxDecoration(
                image: getDecorationAssetImage(context, "schedule.png"),
              ),
            ),
            getVerSpace(FetchPixels.getPixelHeight(40)),
            getCustomFont("No Schedule Yet!", 20, Colors.black, 1,
                fontWeight: FontWeight.w800),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            getCustomFont(
                "Make Schedule for better services. ", 16, Colors.black, 1,
                fontWeight: FontWeight.w400),
            getVerSpace(FetchPixels.getPixelHeight(30)),
            getButton(context, backGroundColor, "Make Schedule", blueColor, () {
              setState(() {
                schedule = true;
              });
            }, 18,
                weight: FontWeight.w600,
                buttonHeight: FetchPixels.getPixelHeight(60),
                insetsGeometry: EdgeInsets.symmetric(
                    horizontal: FetchPixels.getPixelWidth(118)),
                borderRadius:
                    BorderRadius.circular(FetchPixels.getPixelHeight(14)),
                isBorder: true,
                borderColor: blueColor,
                borderWidth: 1.5)
          ],
        ));
  }
}
