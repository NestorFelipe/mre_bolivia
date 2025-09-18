import 'package:dotted_line/dotted_line.dart';
import 'package:fix_store/app/routes/app_routes.dart';
import 'package:fix_store/base/resizer/fetch_pixels.dart';
import 'package:fix_store/base/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../data/data_file.dart';
import '../../models/model_address.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  var horspace = FetchPixels.getPixelWidth(20);
  List<ModelAddress> addressLists = DataFile.addressList;
  int select = 0;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          bottomNavigationBar: continueButton(context),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: horspace),
              child: Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  gettoolbarMenu(context, "back.svg", () {
                    Constant.backToPrev(context);
                  },
                      title: "Proceed",
                      weight: FontWeight.w800,
                      istext: true,
                      fontsize: 24,
                      textColor: Colors.black),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  processTracker(),
                  Expanded(
                      flex: 1,
                      child: ListView(
                        primary: true,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          getVerSpace(FetchPixels.getPixelHeight(30)),
                          ListView.builder(
                            itemCount: addressLists.length,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              ModelAddress modelAddress = addressLists[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    select = index;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: FetchPixels.getPixelHeight(20)),
                                  width: FetchPixels.getPixelWidth(374),
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
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                FetchPixels.getPixelHeight(16),
                                            horizontal:
                                                FetchPixels.getPixelWidth(16)),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: getCustomFont(
                                                  modelAddress.name ?? "",
                                                  16,
                                                  Colors.black,
                                                  1,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            getVerSpace(
                                                FetchPixels.getPixelHeight(10)),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: SizedBox(
                                                  width:
                                                      FetchPixels.getPixelWidth(
                                                          280),
                                                  child: getMultilineCustomFont(
                                                      modelAddress.address ??
                                                          "",
                                                      16,
                                                      Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      txtHeight: 1.4)),
                                            ),
                                            getVerSpace(
                                                FetchPixels.getPixelHeight(10)),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: getCustomFont(
                                                  modelAddress.phone ?? '',
                                                  16,
                                                  Colors.black,
                                                  1,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        child: getPaddingWidget(
                                          EdgeInsets.only(
                                              right: FetchPixels.getPixelHeight(
                                                  16),
                                              top: FetchPixels.getPixelHeight(
                                                  16)),
                                          getSvgImage(
                                              select == index
                                                  ? "selected.svg"
                                                  : "unselected.svg",
                                              width: FetchPixels.getPixelHeight(
                                                  24),
                                              height:
                                                  FetchPixels.getPixelHeight(
                                                      24)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          getVerSpace(FetchPixels.getPixelHeight(30)),
                          getPaddingWidget(
                              EdgeInsets.symmetric(
                                  horizontal: FetchPixels.getPixelWidth(75)),
                              newAddressButton(context))
                        ],
                      ))
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

  Container continueButton(BuildContext context) {
    return Container(
      color: backGroundColor,
      padding: EdgeInsets.only(
          left: FetchPixels.getPixelWidth(20),
          right: FetchPixels.getPixelWidth(20),
          bottom: FetchPixels.getPixelHeight(30)),
      child: getButton(context, blueColor, "Continue", Colors.white, () {
        Constant.sendToNext(context, Routes.dateTimeRoute);
      }, 18,
          weight: FontWeight.w600,
          buttonHeight: FetchPixels.getPixelHeight(60),
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14))),
    );
  }

  Widget newAddressButton(BuildContext context) {
    return getButton(
        context, const Color(0xFFF2F4F8), "+ Add New Address", blueColor, () {
      Constant.sendToNext(context, Routes.editAddressRoute);
    }, 18,
        weight: FontWeight.w600,
        // buttonWidth: FetchPixels.getPixelWidth(224),
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)));
  }

  Row processTracker() {
    return Row(
      children: [
        Container(
          height: FetchPixels.getPixelHeight(52),
          width: FetchPixels.getPixelHeight(52),
          padding: EdgeInsets.all(FetchPixels.getPixelHeight(14)),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0.0, 4.0)),
              ],
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(50))),
          child: getSvgImage("location.svg"),
        ),
        Expanded(
          child: DottedLine(
            dashColor: const Color(0xFFBEC4D3),
            lineThickness: FetchPixels.getPixelHeight(1),
          ),
        ),
        Container(
          height: FetchPixels.getPixelHeight(52),
          width: FetchPixels.getPixelHeight(52),
          padding: EdgeInsets.all(FetchPixels.getPixelHeight(14)),
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E8F1), width: 1),
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(50))),
          child: getSvgImage("wallet.svg"),
        ),
        Expanded(
          child: DottedLine(
            dashColor: const Color(0xFFBEC4D3),
            lineThickness: FetchPixels.getPixelHeight(1),
          ),
        ),
        Container(
          height: FetchPixels.getPixelHeight(52),
          width: FetchPixels.getPixelHeight(52),
          padding: EdgeInsets.all(FetchPixels.getPixelHeight(14)),
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E8F1), width: 1),
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(50))),
          child: getSvgImage("check.svg"),
        ),
      ],
    );
  }
}
