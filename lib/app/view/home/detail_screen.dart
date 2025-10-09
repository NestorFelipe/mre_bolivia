import 'package:mi_cancilleria/app/models/consulado/model_servicio.dart';
import 'package:mi_cancilleria/base/constant.dart';
import 'package:mi_cancilleria/base/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/consulado/tab_home_controller.dart';

import '../../../base/color_data.dart';

class DetailScreen extends GetView<TabHomeController> {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Asegurar que el controlador esté disponible
    Get.lazyPut(() => TabHomeController());

    return _DetailScreenWidget();
  }
}

class _DetailScreenWidget extends StatefulWidget {
  @override
  State<_DetailScreenWidget> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<_DetailScreenWidget> {
  Servicio? servicio;
  Set<int> expandedCards = {};

  @override
  void initState() {
    super.initState();
  }

  // Acceso al controlador
  TabHomeController get controller => Get.find<TabHomeController>();

  Widget _getPaddingWidget(EdgeInsets padding, Widget child) => Padding(
        padding: padding,
        child: child,
      );

  Widget _getCustomFont(
    String text,
    double fontSize,
    Color color,
    int maxLines, {
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
            child: _getCustomFont(
              titulo,
              24,
              const Color.fromARGB(255, 51, 51, 51),
              2,
              fontWeight: FontWeight.w800,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    servicio = controller.selectedServicio.value;

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
              top: -50,
              left: -50,
              child:
                  getAssetImage("chakanagris.png", 150, 150, fit: BoxFit.cover),
            ),
            // Imagen de fondo inferior derecha
            Positioned(
              bottom: -50,
              right: -50,
              child: Transform.rotate(
                angle: 3.14159,
                child: getAssetImage("chakanagris.png", 150, 150,
                    fit: BoxFit.cover),
              ),
            ),
            // Contenido original
            Column(
              children: [
                getVerSpace(35.w),
                _getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 18.w),
                  _getToolbar(servicio!.titulo),
                ),
                Expanded(
                  flex: 1,
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      _getPaddingWidget(
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
                                        servicio!.descripcion),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      getVerSpace(16.w),
                      // Información adicional
                      _getPaddingWidget(
                        EdgeInsets.symmetric(horizontal: 20.w),
                        _getCustomFont("Información Adicional", 18,
                            const Color.fromARGB(255, 53, 53, 53), 1,
                            fontWeight: FontWeight.w800),
                      ),
                      getVerSpace(16.w),

                      // Tarjetas de información
                      _getPaddingWidget(
                        EdgeInsets.symmetric(horizontal: 20.w),
                        Column(
                          children: [
                            if (servicio!.detalle.isNotEmpty)
                              ...servicio!.detalle.asMap().entries.map((entry) {
                                int index = entry.key;
                                var detalle = entry.value;
                                return Column(
                                  children: [
                                    // Verificar si es un enlace
                                    detalle.tipo == "link"
                                        ? _buildLinkCard(
                                            detalle.titulo,
                                            detalle.descripcion ?? "",
                                            index % 3 == 0
                                                ? blueColor
                                                : (index % 3 == 1
                                                    ? Colors.green
                                                    : Colors.orange),
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
                                    if (index < servicio!.detalle.length - 1)
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
                  _getCustomFont(title, 14, Colors.grey[600]!, 1,
                      fontWeight: FontWeight.w500),
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

  Widget _buildLinkCard(String title, String url, Color iconColor) {
    return GestureDetector(
      onTap: () async {
        try {
          // Verificar si la URL es válida y agregarle protocolo si es necesario
          String finalUrl = url;
          if (!url.startsWith('http://') && !url.startsWith('https://')) {
            finalUrl = 'https://$url';
          }

          final Uri uri = Uri.parse(finalUrl);

          // Intentar abrir la URL
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            // Si no se puede abrir, mostrar mensaje de error
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No se puede abrir el enlace: $url'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } catch (e) {
          // Manejo de errores
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al abrir el enlace: $url'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
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
                  _getCustomFont(title, 14, Colors.grey[600]!, 1,
                      fontWeight: FontWeight.w500),
                  SizedBox(height: 4.h),
                  _getCustomFont(
                    "Toca para abrir enlace",
                    12,
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
}

