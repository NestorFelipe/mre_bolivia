import 'package:fix_store/app/models/model_consulado.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';

class DefinicionDetailScreen extends StatefulWidget {
  const DefinicionDetailScreen({super.key});

  @override
  State<DefinicionDetailScreen> createState() => _DefinicionDetailScreenState();
}

class _DefinicionDetailScreenState extends State<DefinicionDetailScreen> {
  ModelDefinicion? definicion;
  int? definicionIndex;

  @override
  void initState() {
    super.initState();
    
    // Obtener los argumentos pasados desde la navegación
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      definicion = arguments['definicion'] as ModelDefinicion?;
      definicionIndex = arguments['index'] as int?;
    }
  }



  /// Renderiza contenido HTML manteniendo el formato original
  Widget _renderHtmlContent(String? htmlText) {
    if (htmlText == null || htmlText.isEmpty) {
      return _getCustomFont("No hay descripción disponible para este elemento.", 16, Colors.black, 1);
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

  Widget _getVerSpace(double height) => SizedBox(height: height.h);
  
  Widget _getPaddingWidget(EdgeInsets padding, Widget child) => Padding(
    padding: padding,
    child: child,
  );

  Widget _getAssetImage(String imageName, double width, double height, {BoxFit fit = BoxFit.cover}) {
    return Image.asset(
      "${Constant.assetImagePath}$imageName",
      width: width.w,
      height: height.h,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width.w,
          height: height.h,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 48.w,
                color: Colors.grey[600],
              ),
              SizedBox(height: 8.h),
              Text(
                'Imagen no disponible',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                  fontFamily: Constant.fontsFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getCustomFont(String text, double fontSize, Color color, int maxLines, {
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    double? height,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize.sp,
        color: color,
        fontWeight: fontWeight,
        fontFamily: Constant.fontsFamily,
        height: height,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }



  Widget _getButton(BuildContext context, Color bgColor, String text, Color textColor, 
      VoidCallback onPressed, double fontSize, {
    FontWeight weight = FontWeight.bold,
    double? buttonWidth,
    double? buttonHeight,
    BorderRadius? borderRadius,
    EdgeInsets? insetsGeometrypadding,
    List<BoxShadow>? boxShadow,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: buttonWidth?.w,
        height: buttonHeight?.h,
        padding: insetsGeometrypadding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
        ),
        child: Center(
          child: _getCustomFont(text, fontSize, textColor, 1, 
            fontWeight: weight, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  /// Toolbar personalizado sin dependencia de FetchPixels
  Widget _getToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            child: SvgPicture.asset(
              "${Constant.assetImagePath}back.svg",
              width: 24.w,
              height: 24.w,
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: _getCustomFont(
              "Información del Consulado",
              20,
              Colors.black,
              1,
              fontWeight: FontWeight.w800,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(width: 40.w), // Espaciador para balancear
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Forzar pantalla completa
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    if (definicion == null) {
      return Scaffold(
        backgroundColor: backGroundColor,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.w, color: Colors.red),
                _getVerSpace(16),
                _getCustomFont("Error: No se encontraron datos", 18, Colors.red, 1,
                    fontWeight: FontWeight.w600),
                _getVerSpace(24),
                _getButton(context, blueColor, "Volver", Colors.white, () {
                  Get.back();
                }, 16,
                    weight: FontWeight.w600,
                    buttonWidth: 120,
                    buttonHeight: 48,
                    borderRadius: BorderRadius.circular(12.r),
                    insetsGeometrypadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h)),
              ],
            ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: Column(
            children: [
              _getVerSpace(20),
              _getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.w),
                _getToolbar(),
              ),
              _getVerSpace(20),
              Expanded(
                flex: 1,
                child: ListView(
                  primary: true,
                  shrinkWrap: true,
                  children: [
                    // Imagen principal
                    _getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 20.w),
                      Container(
                        height: 225.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: const Color(0xFFF0F0F0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: _getAssetImage(
                            "out-${definicion!.funcionId}.png", 
                            double.infinity, 
                            225,
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                    ),
                    _getVerSpace(24),
                    
                    // Título principal
                    _getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 20.w),
                      _getCustomFont(
                        definicion!.titulo ?? "Sin título", 
                        24, 
                        Colors.black, 
                        3,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                    _getVerSpace(16),
                    
                    // // ID de función (si está disponible)
                    // if (definicion!.funcionId != null)
                    //   _getPaddingWidget(
                    //     EdgeInsets.symmetric(horizontal: 20.w),
                    //     Container(
                    //       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    //       decoration: BoxDecoration(
                    //         color: blueColor.withOpacity(0.1),
                    //         borderRadius: BorderRadius.circular(8.r),
                    //       ),
                    //       child: _getCustomFont(
                    //         "ID: ${definicion!.funcionId}", 
                    //         14, 
                    //         blueColor, 
                    //         1,
                    //         fontWeight: FontWeight.w600
                    //       ),
                    //     ),
                    //   ),
                    // _getVerSpace(24),
                    
                    // Descripción/Valor
                    _getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 20.w),
                      _getCustomFont("Descripción", 18, Colors.black, 1,
                          fontWeight: FontWeight.w800),
                    ),
                    _getVerSpace(12),
                    _getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 20.w),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0.0, 4.0)
                            ),
                          ],
                        ),
                        child: _renderHtmlContent(definicion!.valor),
                      ),
                    ),
                    _getVerSpace(32),
                    
                    // Información adicional
                    _getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 20.w),
                      _getCustomFont("Información Adicional", 18, Colors.black, 1,
                          fontWeight: FontWeight.w800),
                    ),
                    _getVerSpace(16),
                    
                    // Tarjetas de información
                    _getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 20.w),
                      Column(
                        children: [
                          _buildInfoCard(
                            "Fuente", 
                            "Consulado de Bolivia", 
                            Icons.account_balance,
                            blueColor
                          ),
                          _getVerSpace(12),
                          _buildInfoCard(
                            "Categoría", 
                            "Servicios Consulares", 
                            Icons.category,
                            Colors.green
                          ),
                          _getVerSpace(12),
                          _buildInfoCard(
                            "Estado", 
                            "Información Oficial", 
                            Icons.verified,
                            Colors.orange
                          ),
                        ],
                      ),
                    ),
                    _getVerSpace(40),
                    
                    // Botón de contacto/más información
                  
                  ],
                ),
              )
            ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color iconColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0.0, 2.0)
          ),
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
              icon,
              color: iconColor,
              size: 24.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getCustomFont(title, 14, Colors.grey[600]!, 1,
                    fontWeight: FontWeight.w500),
                SizedBox(height: 4.h),
                _getCustomFont(value, 16, Colors.black, 2,
                    fontWeight: FontWeight.w600),
              ],
            ),
          ),
        ],
      ),
    );
  }
}