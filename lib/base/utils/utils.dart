import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constant.dart'; // Adjust the import path as needed for Constant

// Helper functions using flutter_screenutil
Widget getVerSpace(double height) => SizedBox(height: height.h);

Widget getPaddingWidget(EdgeInsets padding, Widget child) => Padding(
      padding: padding,
      child: child,
    );

Widget getSvgImage(String imageName,
    {double? width, double? height, Color? color}) {
  return SvgPicture.asset(
    "${Constant.assetImagePath}$imageName",
    width: width?.w,
    height: height?.h,
    colorFilter:
        color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
  );
}

Widget getAssetImage(String imageName, double width, double height,
    {BoxFit fit = BoxFit.cover}) {
  return Image.asset(
    "${Constant.assetImagePath}$imageName",
    width: width.w,
    height: height.h,
    fit: fit,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        width: width.w,
        height: height.h,
        color: Colors.grey[300],
        child: Icon(
          Icons.image_not_supported,
          size: 32.w,
          color: Colors.grey[600],
        ),
      );
    },
  );
}

Widget getCustomFont(String text, double fontSize, Color fontColor, int maxLine,
    {String fontFamily = Constant.fontsFamily,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    txtHeight}) {
  return Text(
    text,
    overflow: overflow,
    style: TextStyle(
        decoration: decoration,
        fontSize: fontSize,
        fontStyle: FontStyle.normal,
        color: fontColor,
        fontFamily: fontFamily,
        height: txtHeight,
        fontWeight: fontWeight),
    maxLines: maxLine,
    softWrap: true,
    textAlign: textAlign,
  );
}

Widget getMultilineCustomFont(
  String text,
  double fontSize,
  Color color, {
  FontWeight fontWeight = FontWeight.normal,
  double? txtHeight,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize.sp,
      color: color,
      fontWeight: fontWeight,
      fontFamily: Constant.fontsFamily,
      height: txtHeight,
    ),
  );
}

BoxDecoration getButtonDecoration(Color bgColor,
    {BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow> shadow = const [],
    DecorationImage? image}) {
  return BoxDecoration(
      color: bgColor,
      borderRadius: borderRadius,
      border: border,
      boxShadow: shadow,
      image: image);
}

DecorationImage getDecorationAssetImage(BuildContext buildContext, String image,
    {BoxFit fit = BoxFit.contain}) {
  return DecorationImage(
    image: AssetImage((Constant.assetImagePath) + image),
    fit: fit,
  );
}

Widget getButton(BuildContext context, Color bgColor, String text,
    Color textColor, Function function, double fontsize,
    {bool isBorder = false,
    EdgeInsetsGeometry? insetsGeometry,
    borderColor = Colors.transparent,
    FontWeight weight = FontWeight.bold,
    bool isIcon = false,
    String? image,
    Color? imageColor,
    double? imageWidth,
    double? imageHeight,
    bool smallFont = false,
    double? buttonHeight,
    double? buttonWidth,
    List<BoxShadow> boxShadow = const [],
    EdgeInsetsGeometry? insetsGeometrypadding,
    BorderRadius? borderRadius,
    double? borderWidth}) {
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      margin: insetsGeometry,
      padding: insetsGeometrypadding,
      width: buttonWidth,
      height: buttonHeight,
      decoration: getButtonDecoration(
        bgColor,
        borderRadius: borderRadius,
        shadow: boxShadow,
        border: (isBorder)
            ? Border.all(color: borderColor, width: borderWidth!)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (isIcon) ? getSvgImage(image!) : getHorSpace(0),
          (isIcon) ? getHorSpace(10.w) : getHorSpace(0),
          getCustomFont(text, fontsize, textColor, 1,
              textAlign: TextAlign.center,
              fontWeight: weight,
              fontFamily: Constant.fontsFamily)
        ],
      ),
    ),
  );
}

Widget getHorSpace(double verSpace) {
  return SizedBox(
    width: verSpace,
  );
}

Widget renderHtmlContent(String? htmlText) {
  if (htmlText == null || htmlText.isEmpty) {
    return getCustomFont("No hay descripción disponible para este elemento.",
        14, const Color.fromARGB(255, 37, 37, 37), 1);
  }

  return Html(
    data: htmlText,
    style: {
      "body": Style(
        fontSize: FontSize(14.0),
        lineHeight: LineHeight.em(1.4),
        fontFamily: Constant.fontsFamily,
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
      ),
      "p": Style(
        margin: Margins.only(bottom: 12),
        textAlign: TextAlign.justify,
      ),
      "ul": Style(
        margin: Margins.symmetric(vertical: 8),
        padding: HtmlPaddings.only(left: 16),
      ),
      "ol": Style(
        margin: Margins.symmetric(vertical: 8),
        padding: HtmlPaddings.only(left: 16),
      ),
      "li": Style(
        margin: Margins.only(bottom: 4),
        lineHeight: LineHeight.em(1.3),
      ),
      "h1, h2, h3, h4, h5, h6": Style(
        fontWeight: FontWeight.bold,
        margin: Margins.symmetric(vertical: 8),
      ),
      "strong, b": Style(
        fontWeight: FontWeight.bold,
      ),
      "em, i": Style(
        fontStyle: FontStyle.italic,
      ),
    },
  );
}
