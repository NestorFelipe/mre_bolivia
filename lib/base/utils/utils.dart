import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mre_bolivia/base/color_data.dart';
import 'package:url_launcher/url_launcher.dart';
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
        fontSize: FontSize(16.0),
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
        margin: Margins.only(bottom: 2),
        lineHeight: LineHeight.em(1),
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

Future<bool> showExternalLinkDialog(String url, BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.open_in_new,
                  color: blueColor,
                  size: 24.w,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: getCustomFont(
                    'Salir a sistema externo',
                    16,
                    Colors.black87,
                    2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCustomFont(
                  'Está a punto de ser redirigido a un sitio web externo:',
                  14,
                  Colors.black87,
                  3,
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: url));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('URL copiada al portapapeles'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: getCustomFont(
                      url,
                      12,
                      blueColor,
                      3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                getCustomFont(
                  '¿Desea continuar?',
                  14,
                  Colors.black54,
                  1,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                ),
                child: getCustomFont(
                  'Cancelar',
                  14,
                  Colors.grey[600]!,
                  1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: getCustomFont(
                  'Abrir enlace',
                  14,
                  Colors.white,
                  1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
      ) ??
      false;
}

Widget buildLinkCard(String title, String url, Color iconColor,
    BuildContext context, bool mounted) {
  return GestureDetector(
    onTap: () async {
      try {
        // Validar que la URL no esté vacía
        if (url.trim().isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('URL no válida o vacía'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }

        // Verificar si la URL es válida y agregarle protocolo si es necesario
        String finalUrl = url.trim();
        if (!finalUrl.startsWith('http://') &&
            !finalUrl.startsWith('https://')) {
          finalUrl = 'https://$finalUrl';
        }

        // Mostrar diálogo de confirmación
        final bool confirmed = await showExternalLinkDialog(finalUrl, context);

        if (!confirmed) {
          print('❌ Usuario canceló la apertura del enlace');
          return;
        }

        // Debug: Imprimir la URL final
        print('🔗 Intentando abrir URL: $finalUrl');

        final Uri uri = Uri.parse(finalUrl);

        // Validar que el URI sea válido
        if (!uri.hasScheme || uri.host.isEmpty) {
          print('❌ URI inválido - Scheme: ${uri.hasScheme}, Host: ${uri.host}');
          if (mounted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('URL no válida: $url'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          return;
        }

        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (launched) {
          print('✅ URL lanzada exitosamente');
        } else {
          print('❌ No se pudo lanzar la URL');
          // Si no se puede abrir, mostrar mensaje de error
          if (mounted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No se puede abrir el enlace: $url'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Copiar',
                  textColor: Colors.white,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: finalUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('URL copiada al portapapeles'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        }
      } catch (e) {
        // Manejo de errores
        print('❌ Error al abrir el enlace: $e');
        if (mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al abrir el enlace: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Copiar',
                textColor: Colors.white,
                onPressed: () {
                  String finalUrl = url.trim();
                  if (!finalUrl.startsWith('http://') &&
                      !finalUrl.startsWith('https://')) {
                    finalUrl = 'https://$finalUrl';
                  }
                  Clipboard.setData(ClipboardData(text: finalUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('URL copiada al portapapeles'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          );
        }
      }
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 8, offset: Offset(0.0, 2.0)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.link,
              color: iconColor,
              size: 24.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // getCustomFont(title, 14, Colors.grey[600]!, 1,
                //     fontWeight: FontWeight.w500),
                renderHtmlContent(title),
                SizedBox(height: 4.h),
                getCustomFont(
                  url, // Mostrar la URL real en lugar de texto genérico
                  11,
                  iconColor,
                  1,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          // Icono de enlace externo
          Icon(
            Icons.open_in_new,
            color: iconColor,
            size: 20.w,
          ),
        ],
      ),
    ),
  );
}

Widget buildLinkInfo(
    String url, Color iconColor, BuildContext context, bool mounted) {
  return GestureDetector(
    onTap: () async {
      try {
        // Validar que la URL no esté vacía
        if (url.trim().isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('URL no válida o vacía'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }

        // Verificar si la URL es válida y agregarle protocolo si es necesario
        String finalUrl = url.trim();
        if (!finalUrl.startsWith('http://') &&
            !finalUrl.startsWith('https://')) {
          finalUrl = 'https://$finalUrl';
        }

        // Mostrar diálogo de confirmación
        final bool confirmed = await showExternalLinkDialog(finalUrl, context);

        if (!confirmed) {
          print('❌ Usuario canceló la apertura del enlace');
          return;
        }

        final Uri uri = Uri.parse(finalUrl);

        // Validar que el URI sea válido
        if (!uri.hasScheme || uri.host.isEmpty) {
          print('❌ URI inválido - Scheme: ${uri.hasScheme}, Host: ${uri.host}');
          if (mounted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('URL no válida: $url'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          return;
        }

        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (launched) {
          print('✅ URL lanzada exitosamente');
        } else {
          print('❌ No se pudo lanzar la URL');
          // Si no se puede abrir, mostrar mensaje de error
          if (mounted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No se puede abrir el enlace: $url'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Copiar',
                  textColor: Colors.white,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: finalUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('URL copiada al portapapeles'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        }
      } catch (e) {
        // Manejo de errores
        print('❌ Error al abrir el enlace: $e');
        if (mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al abrir el enlace: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Copiar',
                textColor: Colors.white,
                onPressed: () {
                  String finalUrl = url.trim();
                  if (!finalUrl.startsWith('http://') &&
                      !finalUrl.startsWith('https://')) {
                    finalUrl = 'https://$finalUrl';
                  }
                  Clipboard.setData(ClipboardData(text: finalUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('URL copiada al portapapeles'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          );
        }
      }
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 8, offset: Offset(0.0, 2.0)),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.link,
            color: iconColor,
            size: 24.w,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCustomFont(
                  url, // Mostrar la URL real en lugar de texto genérico
                  11,
                  iconColor,
                  1,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          // Icono de enlace externo
          Icon(
            Icons.open_in_new,
            color: iconColor,
            size: 20.w,
          ),
        ],
      ),
    ),
  );
}
