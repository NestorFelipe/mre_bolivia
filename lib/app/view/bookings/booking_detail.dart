import 'package:fix_store/base/resizer/fetch_pixels.dart';
import 'package:fix_store/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';

class BookingDetail extends StatefulWidget {
  const BookingDetail({super.key});

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  SharedPreferences? booking;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      booking = sp;
      setState(() {});
    });
  }

  String? name;
  String? date;
  String? rating;
  String? tag;
  String? owner;
  double? price;
  Color? color;

  @override
  Widget build(BuildContext context) {
    name = booking!.getString("name");
    date = booking!.getString("date");
    rating = booking!.getString("rating");
    tag = booking!.getString("tag");
    owner = booking!.getString("owner");
    price = booking!.getDouble("price");
    if (tag == "Active") {
      tag = "Booking Activated";
      color = success;
    } else if (tag == "Completed") {
      tag = "Booking Completed";
      color = completed;
    } else if (tag == "Cancelled") {
      tag = "Booking Cancelled";
      color = error;
    }
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Column(
              children: [
                getVerSpace(FetchPixels.getPixelHeight(20)),
                getPaddingWidget(
                  EdgeInsets.symmetric(
                      horizontal: FetchPixels.getPixelWidth(20)),
                  gettoolbarMenu(context, "back.svg", () {
                    Constant.backToPrev(context);
                  },
                      title: name,
                      fontsize: 24,
                      weight: FontWeight.w800,
                      textColor: Colors.black,
                      istext: true),
                ),
                getVerSpace(FetchPixels.getPixelHeight(30)),
                Expanded(
                  flex: 1,
                    child: ListView(
                      primary: true,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getPaddingWidget(
                          EdgeInsets.symmetric(
                              horizontal: FetchPixels.getPixelWidth(20)),
                          Container(
                            padding: EdgeInsets.only(
                                top: FetchPixels.getPixelHeight(16),
                                bottom: FetchPixels.getPixelHeight(16),
                                left: FetchPixels.getPixelWidth(16),
                                right: FetchPixels.getPixelWidth(16)),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    getCustomFont(date!, 14, textColor, 1,
                                        fontWeight: FontWeight.w400),
                                    getSvgImage("question.svg",
                                        width: FetchPixels.getPixelHeight(24),
                                        height: FetchPixels.getPixelHeight(24))
                                  ],
                                ),
                                getVerSpace(FetchPixels.getPixelHeight(6)),
                                Row(
                                  children: [
                                    getSvgImage("star.svg",
                                        width: FetchPixels.getPixelHeight(16),
                                        height: FetchPixels.getPixelHeight(16)),
                                    getHorSpace(FetchPixels.getPixelWidth(6)),
                                    getCustomFont(rating!, 14, Colors.black, 1,
                                        fontWeight: FontWeight.w400)
                                  ],
                                ),
                                getVerSpace(FetchPixels.getPixelHeight(20)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        getSvgImage("check_complete.svg",
                                            width:
                                                FetchPixels.getPixelHeight(24),
                                            height:
                                                FetchPixels.getPixelHeight(24)),
                                        getHorSpace(
                                            FetchPixels.getPixelWidth(6)),
                                        getCustomFont(tag!, 16, color!, 1,
                                            fontWeight: FontWeight.w600)
                                      ],
                                    ),
                                    getCustomFont("\$$price", 16, blueColor, 1,
                                        fontWeight: FontWeight.w800)
                                  ],
                                ),
                                getVerSpace(FetchPixels.getPixelHeight(20)),
                                getDivider(dividerColor, 0, 1),
                                getVerSpace(FetchPixels.getPixelHeight(20)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height:
                                              FetchPixels.getPixelHeight(42),
                                          width: FetchPixels.getPixelHeight(42),
                                          decoration: BoxDecoration(
                                              image: getDecorationAssetImage(
                                                  context,
                                                  "booking_owner.png")),
                                        ),
                                        getHorSpace(
                                            FetchPixels.getPixelWidth(9)),
                                        getCustomFont(owner!, 14, textColor, 1,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                    Container(
                                      height: FetchPixels.getPixelHeight(42),
                                      width: FetchPixels.getPixelHeight(42),
                                      decoration: BoxDecoration(
                                          image: getDecorationAssetImage(
                                              context, "call_bg.png")),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        getPaddingWidget(
                          EdgeInsets.symmetric(
                              horizontal: FetchPixels.getPixelWidth(20)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getVerSpace(FetchPixels.getPixelHeight(30)),
                              getCustomFont(
                                  "Finding Pro Cleaner", 20, Colors.black, 1,
                                  fontWeight: FontWeight.w800),
                              getVerSpace(FetchPixels.getPixelHeight(10)),
                              getMultilineCustomFont(
                                  "An cleaner will be assigned 60 minutes before booking time.",
                                  16,
                                  Colors.black,
                                  fontWeight: FontWeight.w400,
                                  txtHeight: FetchPixels.getPixelHeight(1.3)),
                              getVerSpace(FetchPixels.getPixelHeight(16)),
                              getButtonWithIcon(context, Colors.white,
                                  "Assigning Pro", blueColor, () {}, 18,
                                  weight: FontWeight.w600,
                                  buttonHeight: FetchPixels.getPixelHeight(60),
                                  borderRadius: BorderRadius.circular(
                                      FetchPixels.getPixelHeight(12)),
                                  boxShadow: [
                                    const BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0.0, 4.0)),
                                  ],
                                  sufixIcon: true,
                                  suffixImage: "arrow_right.svg"),
                              getVerSpace(FetchPixels.getPixelHeight(30)),
                              getCustomFont(
                                  "About Your Service", 20, Colors.black, 1,
                                  fontWeight: FontWeight.w800),
                              getVerSpace(FetchPixels.getPixelHeight(10)),
                              getButtonWithIcon(context, Colors.white,
                                  "Fixstore Care", Colors.black, () {}, 16,
                                  weight: FontWeight.w800,
                                  buttonHeight: FetchPixels.getPixelHeight(72),
                                  borderRadius: BorderRadius.circular(
                                      FetchPixels.getPixelHeight(12)),
                                  boxShadow: [
                                    const BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0.0, 4.0)),
                                  ],
                                  prefixIcon: true,
                                  prefixImage: "headset.svg",
                                  sufixIcon: true,
                                  suffixImage: "arrow_right.svg"),
                              getVerSpace(FetchPixels.getPixelHeight(20)),
                              getButtonWithIcon(context, Colors.white,
                                  "UC Warrenty", Colors.black, () {}, 16,
                                  weight: FontWeight.w800,
                                  buttonHeight: FetchPixels.getPixelHeight(72),
                                  borderRadius: BorderRadius.circular(
                                      FetchPixels.getPixelHeight(12)),
                                  boxShadow: [
                                    const BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0.0, 4.0)),
                                  ],
                                  prefixIcon: true,
                                  prefixImage: "safe.svg",
                                  sufixIcon: true,
                                  suffixImage: "arrow_right.svg"),
                              getVerSpace(FetchPixels.getPixelHeight(20)),
                              getButtonWithIcon(context, Colors.white,
                                  "Standard Rate Card", Colors.black, () {}, 16,
                                  weight: FontWeight.w800,
                                  buttonHeight: FetchPixels.getPixelHeight(72),
                                  borderRadius: BorderRadius.circular(
                                      FetchPixels.getPixelHeight(12)),
                                  boxShadow: [
                                    const BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0.0, 4.0)),
                                  ],
                                  prefixIcon: true,
                                  prefixImage: "starts.svg",
                                  sufixIcon: true,
                                  suffixImage: "arrow_right.svg"),
                            ],
                          ),
                        ),
                        getVerSpace(FetchPixels.getPixelHeight(30)),
                        Container(
                          color: const Color(0xFFF2F4F8),
                          padding: EdgeInsets.only(
                              left: FetchPixels.getPixelWidth(20),
                              right: FetchPixels.getPixelWidth(20),
                              top: FetchPixels.getPixelHeight(20),
                              bottom: FetchPixels.getPixelHeight(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: FetchPixels.getPixelHeight(52),
                                    width: FetchPixels.getPixelHeight(52),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          FetchPixels.getPixelHeight(35)),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            offset: Offset(0.0, 4.0)),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(
                                        FetchPixels.getPixelHeight(14)),
                                    child: getSvgImage("wallet.svg"),
                                  ),
                                  getHorSpace(FetchPixels.getPixelWidth(15)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getCustomFont("Know about cleaning", 16,
                                          Colors.black, 1,
                                          fontWeight: FontWeight.w800),
                                      getVerSpace(
                                          FetchPixels.getPixelHeight(4)),
                                      getCustomFont("Cleaning Service Required",
                                          16, Colors.black, 1,
                                          fontWeight: FontWeight.w400)
                                    ],
                                  )
                                ],
                              ),
                              getSvgImage("arrow_right.svg")
                            ],
                          ),
                        ),
                        getPaddingWidget(
                          EdgeInsets.symmetric(
                              horizontal: FetchPixels.getPixelWidth(20)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getVerSpace(FetchPixels.getPixelHeight(30)),
                              getCustomFont("Need Help?", 20, Colors.black, 1,
                                  fontWeight: FontWeight.w800),
                              getVerSpace(FetchPixels.getPixelHeight(10)),
                              getButtonWithIcon(
                                  context,
                                  Colors.white,
                                  "Professional not assigned",
                                  Colors.black, () {
                                // Constant.sendToNext(context, Routes.profileRoute);
                              }, 16,
                                  weight: FontWeight.w400,
                                  buttonHeight: FetchPixels.getPixelHeight(56),
                                  borderRadius: BorderRadius.circular(
                                      FetchPixels.getPixelHeight(12)),
                                  boxShadow: [
                                    const BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0.0, 4.0)),
                                  ],
                                  sufixIcon: true,
                                  suffixImage: "arrow_right.svg"),
                              getVerSpace(FetchPixels.getPixelHeight(20)),
                              getButtonWithIcon(
                                  context,
                                  Colors.white,
                                  "I’m unhappy with my booking experience",
                                  Colors.black, () {
                                // Constant.sendToNext(context, Routes.profileRoute);
                              }, 16,
                                  weight: FontWeight.w400,
                                  buttonHeight: FetchPixels.getPixelHeight(56),
                                  borderRadius: BorderRadius.circular(
                                      FetchPixels.getPixelHeight(12)),
                                  boxShadow: [
                                    const BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0.0, 4.0)),
                                  ],
                                  sufixIcon: true,
                                  suffixImage: "arrow_right.svg"),
                              getVerSpace(FetchPixels.getPixelHeight(20)),
                              getButtonWithIcon(
                                  context,
                                  Colors.white,
                                  "Need help with other issues",
                                  Colors.black, () {
                                // Constant.sendToNext(context, Routes.profileRoute);
                              }, 16,
                                  weight: FontWeight.w400,
                                  buttonHeight: FetchPixels.getPixelHeight(56),
                                  borderRadius: BorderRadius.circular(
                                      FetchPixels.getPixelHeight(12)),
                                  boxShadow: [
                                    const BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0.0, 4.0)),
                                  ],
                                  sufixIcon: true,
                                  suffixImage: "arrow_right.svg"),
                              getVerSpace(FetchPixels.getPixelHeight(30)),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
        onWillPop: () async {
          Constant.backToPrev(context);
          return false;
        });
  }
}
