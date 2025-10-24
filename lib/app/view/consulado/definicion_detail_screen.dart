import 'package:mre_bolivia/app/models/consulado/model_intro.dart';
import 'package:mre_bolivia/base/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
          child: _getCustomFont(text, fontSize, textColor, 1,
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
            child: _getCustomFont(
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
                      _getPaddingWidget(
                        EdgeInsets.symmetric(horizontal: 20.w),
                        _getCustomFont(
                            "Información Adicional", 18, Colors.black, 1,
                            fontWeight: FontWeight.w800),
                      ),
                      getVerSpace(16),

                      // Tarjetas de información
                      _getPaddingWidget(
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
                  _getCustomFont(title, 18, Colors.grey[900]!, 1,
                      fontWeight: FontWeight.w700),
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

  /// Mostrar diálogo de confirmación antes de abrir enlace externo
  Future<bool> _showExternalLinkDialog(String url) async {
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
                    child: _getCustomFont(
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
                  _getCustomFont(
                    'Está a punto de ser redirigido a un sitio web externo:',
                    14,
                    Colors.black87,
                    3,
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: _getCustomFont(
                      url,
                      12,
                      blueColor,
                      3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _getCustomFont(
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
                  child: _getCustomFont(
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
                  child: _getCustomFont(
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

  Widget _buildLinkCard(String title, String url, Color iconColor) {
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
          final bool confirmed = await _showExternalLinkDialog(finalUrl);

          if (!confirmed) {
            print('❌ Usuario canceló la apertura del enlace');
            return;
          }

          // Debug: Imprimir la URL final
          print('🔗 Intentando abrir URL: $finalUrl');

          final Uri uri = Uri.parse(finalUrl);

          // Validar que el URI sea válido
          if (!uri.hasScheme || uri.host.isEmpty) {
            print(
                '❌ URI inválido - Scheme: ${uri.hasScheme}, Host: ${uri.host}');
            if (mounted) {
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

          print('✅ URI válido - Verificando si se puede lanzar...');

          // Intentar lanzar directamente sin verificar canLaunchUrl
          // ya que canLaunchUrl puede fallar incluso cuando launchUrl funciona
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
                  _getCustomFont(title, 14, Colors.grey[600]!, 1,
                      fontWeight: FontWeight.w500),
                  SizedBox(height: 4.h),
                  _getCustomFont(
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
}
