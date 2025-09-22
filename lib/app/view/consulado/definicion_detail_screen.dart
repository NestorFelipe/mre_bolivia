import 'package:fix_store/app/models/model_consulado.dart';
import 'package:fix_store/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;

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

  /// Convierte HTML a texto plano eliminando todas las etiquetas
  String _parseHtmlToPlainText(String? htmlText) {
    if (htmlText == null || htmlText.isEmpty) {
      return "No hay descripción disponible para este elemento.";
    }
    
    try {
      // Parsear el HTML y extraer solo el texto
      var document = html_parser.parse(htmlText);
      String plainText = document.body?.text ?? htmlText;
      
      // Limpiar espacios en blanco extra y saltos de línea
      plainText = plainText.replaceAll(RegExp(r'\s+'), ' ').trim();
      
      return plainText.isNotEmpty ? plainText : "No hay descripción disponible para este elemento.";
    } catch (e) {
      // Si hay error al parsear, intentar una limpieza básica con RegExp
      return _cleanHtmlWithRegex(htmlText);
    }
  }

  /// Método alternativo para limpiar HTML usando expresiones regulares
  String _cleanHtmlWithRegex(String htmlText) {
    // Eliminar etiquetas HTML
    String cleanText = htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // Decodificar entidades HTML comunes
    cleanText = cleanText
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'");
    
    // Limpiar espacios en blanco extra
    cleanText = cleanText.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return cleanText.isNotEmpty ? cleanText : "No hay descripción disponible para este elemento.";
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

  Widget _getMultilineCustomFont(String text, double fontSize, Color color, {
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

  @override
  Widget build(BuildContext context) {
    if (definicion == null) {
      return Scaffold(
        backgroundColor: backGroundColor,
        body: SafeArea(
          child: Center(
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
        ),
      );
    }

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _getVerSpace(20),
              _getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.w),
                gettoolbarMenu(context, "back.svg", () {
                  Get.back();
                },
                    title: "Información del Consulado",
                    weight: FontWeight.w800,
                    textColor: Colors.black,
                    fontsize: 20,
                    istext: true,
                    isrightimage: false),
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
                        child: _getMultilineCustomFont(
                          _parseHtmlToPlainText(definicion!.valor),
                          16,
                          Colors.black87,
                          fontWeight: FontWeight.w400,
                          txtHeight: 1.4,
                        ),
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
      ),
      onWillPop: () async {
        Get.back();
        return false;
      },
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