import 'package:mre_bolivia/app/data/data_file.dart';
import 'package:mre_bolivia/app/models/model_notification.dart';
import 'package:mre_bolivia/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../base/color_data.dart';
import '../../base/constant.dart';
import '../../base/widget_utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<ModelNotification> notificationLists = DataFile.notificationList;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getPixelWidth(20)),
              child: Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  gettoolbarMenu(context, "back.svg", () {
                    Constant.backToPrev(context);
                  },
                      istext: true,
                      title: "Notifications",
                      weight: FontWeight.w800,
                      fontsize: 24,
                      textColor: Colors.black),
                  notificationLists.isEmpty
                      ? nullListView(context)
                      : notificationList()
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

  Expanded notificationList() {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getVerSpace(FetchPixels.getPixelHeight(30)),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          itemCount: notificationLists.length,
          itemBuilder: (context, index) {
            ModelNotification modelNOtification = notificationLists[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0 || index == 2
                    ? getCustomFont(
                        modelNOtification.date ?? '', 16, Colors.black, 1,
                        fontWeight: FontWeight.w400)
                    : Container(),
                getVerSpace(FetchPixels.getPixelHeight(20)),
                Container(
                  margin:
                      EdgeInsets.only(bottom: FetchPixels.getPixelHeight(20)),
                  padding: EdgeInsets.only(
                      top: FetchPixels.getPixelHeight(20),
                      bottom: FetchPixels.getPixelHeight(20),
                      right: FetchPixels.getPixelWidth(20),
                      left: FetchPixels.getPixelWidth(20)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(12)),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0.0, 4.0)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: FetchPixels.getPixelHeight(50),
                        width: FetchPixels.getPixelHeight(50),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE4ECFF),
                            borderRadius: BorderRadius.circular(
                                FetchPixels.getPixelHeight(12))),
                        padding: EdgeInsets.all(FetchPixels.getPixelHeight(13)),
                        child: getSvgImage("clock.svg"),
                      ),
                      getHorSpace(FetchPixels.getPixelWidth(14)),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomFont(modelNOtification.name ?? "", 16,
                                    Colors.black, 1,
                                    fontWeight: FontWeight.w800),
                                getCustomFont(modelNOtification.time ?? "", 14,
                                    textColor, 1,
                                    fontWeight: FontWeight.w400)
                              ],
                            ),
                            getVerSpace(FetchPixels.getPixelHeight(7)),
                            getCustomFont(modelNOtification.description ?? "",
                                16, Colors.black, 2,
                                fontWeight: FontWeight.w400)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        )
      ],
    ));
  }

  Expanded nullListView(BuildContext context) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: FetchPixels.getPixelHeight(124),
          width: FetchPixels.getPixelHeight(124),
          decoration: BoxDecoration(
            image: getDecorationAssetImage(context, "bell.png"),
          ),
        ),
        getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("No Notifications Yet!", 20, Colors.black, 1,
            fontWeight: FontWeight.w800),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
            "We’ll notify you when something arrives.", 16, Colors.black, 1,
            fontWeight: FontWeight.w400)
      ],
    ));
  }
}

