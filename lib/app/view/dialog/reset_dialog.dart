import 'package:fix_store/app/routes/app_routes.dart';
import 'package:fix_store/base/color_data.dart';
import 'package:fix_store/base/constant.dart';
import 'package:fix_store/base/resizer/fetch_pixels.dart';
import 'package:fix_store/base/widget_utils.dart';
import 'package:flutter/material.dart';

class ResetDialog extends StatefulWidget {
  const ResetDialog({super.key});

  @override
  State<ResetDialog> createState() => _ResetDialogState();
}

class _ResetDialogState extends State<ResetDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20))),
      backgroundColor: backGroundColor,
      content: Builder(
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getVerSpace(FetchPixels.getPixelHeight(20)),
              getSvgImage("reset_image.svg"),
              getVerSpace(FetchPixels.getPixelHeight(30)),
              getCustomFont("Reset Password", 22, Colors.black, 1,
                  fontWeight: FontWeight.w800),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              getMultilineCustomFont(
                  "Your password has been successfully changed!",
                  16,
                  Colors.black,
                  fontWeight: FontWeight.w400,
                  txtHeight: 1.3,
                  textAlign: TextAlign.center),
              getVerSpace(FetchPixels.getPixelHeight(30)),
              getButton(context, blueColor, "Ok", Colors.white, () {
                Constant.sendToNext(context, Routes.loginRoute);
              }, 18,
                  weight: FontWeight.w600,
                  buttonHeight: FetchPixels.getPixelHeight(60),
                  borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(15))),
              getVerSpace(FetchPixels.getPixelHeight(20)),
            ],
          );
        },
      ),
    );
  }
}
