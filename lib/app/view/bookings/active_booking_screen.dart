import 'package:mi_cancilleria/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../data/data_file.dart';
import '../../models/model_booking.dart';
import '../../routes/app_routes.dart';

class ActiveBookingScreen extends StatefulWidget {
  const ActiveBookingScreen({super.key});

  @override
  State<ActiveBookingScreen> createState() => _ActiveBookingScreenState();
}

class _ActiveBookingScreenState extends State<ActiveBookingScreen> {
  List<ModelBooking> bookingLists = DataFile.bookingList;

  SharedPreferences? booking;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      booking = sp;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Container(
      color: backGroundColor,
      child: bookingLists.isEmpty ? nullListView(context) : activeBookingList(),
    );
  }

  ListView activeBookingList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
      itemCount: bookingLists.length,
      itemBuilder: (context, index) {
        ModelBooking modelBooking = bookingLists[index];
        return modelBooking.tag == "Active"
            ? GestureDetector(
                onTap: () {
                  booking!.setString("name", modelBooking.name ?? "");
                  booking!.setString("date", modelBooking.date ?? "");
                  booking!.setString("rating", modelBooking.rating ?? "");
                  booking!.setString("tag", modelBooking.tag ?? "");
                  booking!.setDouble("price", modelBooking.price ?? 0.0);
                  booking!.setString("owner", modelBooking.owner ?? "");
                  Constant.sendToNext(context, Routes.bookingRoute);
                },
                child: Container(
                  margin:
                      EdgeInsets.only(bottom: FetchPixels.getPixelHeight(20)),
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
                                      context, modelBooking.image ?? ""),
                                ),
                              ),
                              getHorSpace(FetchPixels.getPixelWidth(16)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getCustomFont(modelBooking.name ?? "", 16,
                                      Colors.black, 1,
                                      fontWeight: FontWeight.w800),
                                  getVerSpace(FetchPixels.getPixelHeight(6)),
                                  getCustomFont(
                                      modelBooking.date ?? "", 14, textColor, 1,
                                      fontWeight: FontWeight.w400),
                                  getVerSpace(FetchPixels.getPixelHeight(6)),
                                  Row(
                                    children: [
                                      getSvgImage("star.svg",
                                          height:
                                              FetchPixels.getPixelHeight(16),
                                          width:
                                              FetchPixels.getPixelHeight(16)),
                                      getHorSpace(FetchPixels.getPixelWidth(6)),
                                      getCustomFont(modelBooking.rating ?? "",
                                          14, Colors.black, 1,
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
                                onTap: () {
                                  setState(() {
                                    bookingLists.removeAt(index);
                                  });
                                },
                                child: getSvgImage("trash.svg",
                                    width: FetchPixels.getPixelHeight(20),
                                    height: FetchPixels.getPixelHeight(20)),
                              ),
                              getVerSpace(FetchPixels.getPixelHeight(43)),
                              getCustomFont(
                                  "\$${modelBooking.price}", 16, blueColor, 1,
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
                                  modelBooking.owner ?? "", 14, textColor, 1,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                          Wrap(
                            children: [
                              getButton(
                                  context,
                                  Color(modelBooking.bgColor!.toInt()),
                                  modelBooking.tag ?? "",
                                  modelBooking.textColor,
                                  () {},
                                  16,
                                  weight: FontWeight.w600,
                                  borderRadius: BorderRadius.circular(
                                      FetchPixels.getPixelHeight(37)),
                                  insetsGeometrypadding: EdgeInsets.symmetric(
                                      vertical: FetchPixels.getPixelHeight(6),
                                      horizontal:
                                          FetchPixels.getPixelWidth(12)))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Column nullListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getSvgImage("clipboard.svg",
            height: FetchPixels.getPixelHeight(124),
            width: FetchPixels.getPixelHeight(124)),
        getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("No Bookings Yet!", 20, Colors.black, 1,
            fontWeight: FontWeight.w800),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
            "Go to services and book the best services. ", 16, Colors.black, 1,
            fontWeight: FontWeight.w400),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        getButton(
            context, backGroundColor, "Go to Service", blueColor, () {}, 18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            insetsGeometry: EdgeInsets.symmetric(
                horizontal: FetchPixels.getPixelWidth(106)),
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
            isBorder: true,
            borderColor: blueColor,
            borderWidth: 1.5)
      ],
    );
  }
}

