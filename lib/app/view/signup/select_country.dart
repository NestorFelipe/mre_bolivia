import 'package:mi_cancilleria/app/data/data_file.dart';
import 'package:mi_cancilleria/app/models/model_country.dart';
import 'package:mi_cancilleria/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({super.key});

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  void finishView() {
    Constant.backToPrev(context);
  }

  TextEditingController searchController = TextEditingController();
  List<ModelCountry> newCountryList = List.from(DataFile.countryList);

  onItemChanged(String value) {
    setState(() {
      newCountryList = DataFile.countryList
          .where((string) =>
              string.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  SharedPreferences? selection;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      selection = sp;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Column(
              children: [
                getVerSpace(FetchPixels.getPixelHeight(26)),
                getPaddingWidget(
                  EdgeInsets.symmetric(
                      horizontal: FetchPixels.getPixelWidth(20)),
                  gettoolbarMenu(context, "back.svg", () {
                    finishView();
                  },
                      istext: true,
                      title: "Select Country",
                      weight: FontWeight.w800,
                      fontsize: 24,
                      textColor: Colors.black),
                ),
                getVerSpace(FetchPixels.getPixelHeight(18)),
                getPaddingWidget(
                  EdgeInsets.symmetric(
                      horizontal: FetchPixels.getPixelWidth(20)),
                  getSearchWidget(
                      context, searchController, () {}, onItemChanged,
                      withPrefix: true),
                ),
                getVerSpace(FetchPixels.getPixelHeight(30)),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: FetchPixels.getPixelWidth(20)),
                    scrollDirection: Axis.vertical,
                    itemCount: newCountryList.length,
                    itemBuilder: (context, index) {
                      ModelCountry modelCountry = newCountryList[index];
                      return GestureDetector(
                        onTap: () {
                          selection!.setString(
                              "country", newCountryList[index].image ?? "");
                          selection!.setString("code", modelCountry.code ?? "");
                          finishView();
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: FetchPixels.getPixelHeight(20)),
                          height: FetchPixels.getPixelHeight(56),
                          padding: EdgeInsets.symmetric(
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
                                  FetchPixels.getPixelHeight(15))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  getAssetImage(
                                      modelCountry.image ?? '',
                                      FetchPixels.getPixelWidth(40),
                                      FetchPixels.getPixelHeight(28)),
                                  getHorSpace(FetchPixels.getPixelWidth(12)),
                                  getCustomFont(modelCountry.name ?? "", 14,
                                      Colors.black, 1,
                                      fontWeight: FontWeight.w800),
                                ],
                              ),
                              Row(
                                children: [
                                  getCustomFont(modelCountry.code ?? "", 14,
                                      Colors.black, 1,
                                      fontWeight: FontWeight.w800)
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          finishView();
          return false;
        });
  }
}

