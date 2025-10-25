import 'package:mre_bolivia/app/models/consulado/model_intro.dart';
import 'package:mre_bolivia/base/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';

class DefinicionDetailScreen extends StatefulWidget {
  const DefinicionDetailScreen({super.key});

  @override
  State<DefinicionDetailScreen> createState() => _DefinicionDetailScreenState();
}

class _DefinicionDetailScreenState extends State<DefinicionDetailScreen> {
  Intro? definicion;
  int? definicionIndex;
  Set<int> expandedCards = {}; // Para controlar qué tarjetas están expandidas

  @override
  void initState() {
    super.initState();

    // Obtener los argumentos pasados desde la navegación
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      definicion = arguments['definicion'] as Intro?;
      definicionIndex = arguments['index'] as int?;
    }
  }

  Widget _getButton(
    BuildContext context,
    Color bgColor,
    String text,
    Color textColor,
    VoidCallback onPressed,
    double fontSize, {
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
          child: getCustomFont(text, fontSize, textColor, 1,
              fontWeight: weight, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  /// Toolbar personalizado sin dependencia de FetchPixels
  Widget _getToolbar(String titulo) {
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
              width: 32.w,
              height: 32.w,
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: getCustomFont(
              titulo,
              24,
              const Color.fromARGB(255, 51, 51, 51),
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
              getVerSpace(16),
              getCustomFont("Error: No se encontraron datos", 18, Colors.red, 1,
                  fontWeight: FontWeight.w600),
              getVerSpace(24),
              _getButton(context, blueColor, "Volver", Colors.white, () {
                Get.back();
              }, 16,
                  weight: FontWeight.w600,
                  buttonWidth: 120,
                  buttonHeight: 48,
                  borderRadius: BorderRadius.circular(12.r),
                  insetsGeometrypadding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h)),
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
        body: Stack(
          children: [
            // Imagen de fondo superior izquierda
            Positioned(
              top: 50,
              left: 0,
              child:
                  getAssetImage("chakanagris.png", 150, 150, fit: BoxFit.cover),
            ),
            // Imagen de fondo inferior derecha
            Positioned(
              bottom: 50,
              right: 0,
              child: Transform.rotate(
                angle: 3.14159,
                child: getAssetImage("chakanagris.png", 150, 150,
                    fit: BoxFit.cover),
              ),
            ),
            // Contenido original
            Column(
              children: [
                getVerSpace(25),
                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 18.w),
                  _getToolbar(definicion!.titulo),
                ),
                Expanded(
                  flex: 1,
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      getPaddingWidget(
                        EdgeInsets.symmetric(horizontal: 20.w),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0.0, 4.0)),
                            ],
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width: 4.w,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.red, // Rojo
                                        Colors.yellow, // Amarillo
                                        Colors.green, // Verde
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: renderHtmlContent(
                                        definicion!.descripcion),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      getVerSpace(15),

                      // Información adicional
                      getPaddingWidget(
                        EdgeInsets.symmetric(horizontal: 20.w),
                        getCustomFont(
                            "Información Adicional", 18, Colors.black, 1,
                            fontWeight: FontWeight.w800),
                      ),
                      getVerSpace(16),

                      // Tarjetas de información
                      getPaddingWidget(
                        EdgeInsets.symmetric(horizontal: 20.w),
                        Column(
                          children: [
                            if (definicion!.detalle.isNotEmpty)
                              ...definicion!.detalle
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                var detalle = entry.value;
                                return Column(
                                  children: [
                                    // Verificar si es un enlace
                                    detalle.tipo == "link"
                                        ? buildLinkCard(
                                            detalle.titulo,
                                            detalle.descripcion ?? "",
                                            index % 3 == 0
                                                ? blueColor
                                                : (index % 3 == 1
                                                    ? Colors.green
                                                    : Colors.orange),
                                            context,
                                            mounted,
                                          )
                                        : _buildInfoCard(
                                            detalle.titulo,
                                            detalle.descripcion ?? "",
                                            Icons.info_outline,
                                            index % 3 == 0
                                                ? blueColor
                                                : (index % 3 == 1
                                                    ? Colors.green
                                                    : Colors.orange),
                                            index),
                                    if (index < definicion!.detalle.length - 1)
                                      getVerSpace(12.w),
                                  ],
                                );
                              })
                            else
                              _buildInfoCard(
                                  "Sin detalles",
                                  "No hay información adicional disponible",
                                  Icons.info_outline,
                                  Colors.grey,
                                  0),
                          ],
                        ),
                      ),
                      getVerSpace(40.w),

                      // Botón de contacto/más información
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, IconData icon, Color iconColor, int index) {
    bool isExpanded = expandedCards.contains(index);

    // Limpiar el texto de caracteres de salto de línea y convertirlos a HTML
    String cleanValue = value
        .replaceAll('\r\n', '<br>')
        .replaceAll('\r', '<br>')
        .replaceAll('\n', '<br>');

    String displayValue = cleanValue;

    // Si no está expandido y el texto es más largo que 20 caracteres, truncar
    if (!isExpanded && cleanValue.length > 20) {
      // Buscar el texto sin las etiquetas HTML para el conteo
      String textWithoutHtml = cleanValue.replaceAll(RegExp(r'<[^>]*>'), '');
      if (textWithoutHtml.length > 20) {
        displayValue = '${textWithoutHtml.substring(0, 20)}...';
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isExpanded) {
            expandedCards.remove(index);
          } else {
            expandedCards.add(index);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  renderHtmlContent(title),
                  SizedBox(height: 4.h),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(isExpanded),
                      child: isExpanded
                          ? renderHtmlContent(cleanValue)
                          : renderHtmlContent(displayValue),
                    ),
                  ),
                ],
              ),
            ),
            // Icono indicador de expansión
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: iconColor,
                size: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
