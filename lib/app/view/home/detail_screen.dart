import 'package:mre_bolivia/app/models/consulado/model_servicio.dart';
import 'package:mre_bolivia/app/models/consulado/model_servicios_tramites.dart';
import 'package:mre_bolivia/base/constant.dart';
import 'package:mre_bolivia/base/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
  List<ServicioTramite> tramiteServicios = [];
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<ServicioTramite> get filteredTramiteServicios {
    if (searchQuery.isEmpty) {
      return tramiteServicios;
    }
    return tramiteServicios.where((tramite) {
      final nombre = tramite.nombre.toLowerCase();
      final entidad = tramite.entidadNombre.toLowerCase();
      final query = searchQuery.toLowerCase();
      return nombre.contains(query) || entidad.contains(query);
    }).toList();
  }

  // Acceso al controlador
  TabHomeController get controller => Get.find<TabHomeController>();

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
              16,
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
    tramiteServicios = controller.getTramiteServicios();

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:
            Colors.transparent, // Fondo transparente para mostrar la imagen
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fondos.png"),
              fit: BoxFit.cover, // Cubre toda la pantalla
            ),
          ),
          child: servicio!.detalle.isNotEmpty &&
                  servicio!.detalle[0].tipo == 'data'
              ? _renderServiceApi()
              : _renderScreenMain(),
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

  Widget _renderScreenMain() {
    return Column(
      children: [
        getVerSpace(55.h),
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 18.w),
          _getToolbar(servicio!.titulo),
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
                            child: renderHtmlContent(servicio!.descripcion),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              getVerSpace(16.w),
              // Información adicional
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.w),
                getCustomFont("Información Adicional", 18,
                    const Color.fromARGB(255, 53, 53, 53), 1,
                    fontWeight: FontWeight.w800),
              ),
              getVerSpace(16.w),

              // Tarjetas de información
              getPaddingWidget(
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
                                ? buildLinkCard(
                                    detalle.titulo,
                                    detalle.descripcion ?? "",
                                    index % 3 == 0
                                        ? blueColor
                                        : (index % 3 == 1
                                            ? Colors.green
                                            : Colors.orange),
                                    context,
                                    mounted)
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
    );
  }

  Widget _renderServiceApi() {
    return Column(
      children: [
        getVerSpace(50.w),
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 18.w),
          _getToolbar(servicio!.titulo),
        ),
        getVerSpace(16.w),
        // Campo de búsqueda
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 20.w),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0.0, 2.0),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  expandedCards.clear(); // Limpiar cards expandidas al buscar
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o entidad...',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[400],
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: blueColor,
                  size: 24.w,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[600],
                          size: 20.w,
                        ),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            searchQuery = "";
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
        getVerSpace(16.w),
        Expanded(
          flex: 1,
          child: filteredTramiteServicios.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64.w,
                        color: Colors.grey[400],
                      ),
                      getVerSpace(16.h),
                      getCustomFont(
                        'No se encontraron resultados',
                        16,
                        Colors.grey[600]!,
                        1,
                        fontWeight: FontWeight.w600,
                      ),
                      getVerSpace(8.h),
                      getCustomFont(
                        'Intenta con otra búsqueda',
                        14,
                        Colors.grey[500]!,
                        1,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  primary: true,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: filteredTramiteServicios.length,
                  itemBuilder: (context, index) {
                    ServicioTramite servicioTramite =
                        filteredTramiteServicios[index];
                    bool isExpanded = expandedCards.contains(index);

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
                        margin: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: isExpanded ? 12 : 8,
                                offset: Offset(0.0, isExpanded ? 4.0 : 2.0)),
                          ],
                          border: isExpanded
                              ? Border.all(
                                  color: (index % 3 == 0
                                          ? blueColor
                                          : (index % 3 == 1
                                              ? Colors.green
                                              : Colors.orange))
                                      .withOpacity(0.3),
                                  width: 1)
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row con ícono, título y flecha
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48.w,
                                  height: 48.w,
                                  decoration: BoxDecoration(
                                    color: index % 3 == 0
                                        ? blueColor.withOpacity(0.2)
                                        : (index % 3 == 1
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.orange.withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: index % 3 == 0
                                        ? blueColor
                                        : (index % 3 == 1
                                            ? Colors.green
                                            : Colors.orange),
                                    size: 24.w,
                                  ),
                                ),
                                getHorSpace(16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getCustomFont(
                                          servicioTramite.nombre,
                                          14,
                                          const Color.fromARGB(255, 58, 58, 58),
                                          3,
                                          fontWeight: FontWeight.w800),
                                      SizedBox(height: 4.h),
                                      getCustomFont(
                                          servicioTramite.entidadNombre,
                                          14,
                                          Colors.grey[600]!,
                                          1,
                                          fontWeight: FontWeight.w400),
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
                                    color: index % 3 == 0
                                        ? blueColor
                                        : (index % 3 == 1
                                            ? Colors.green
                                            : Colors.orange),
                                    size: 20.w,
                                  ),
                                ),
                              ],
                            ),
                            // Contenido expandido que ocupa todo el ancho
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: isExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild: const SizedBox.shrink(),
                              secondChild: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 12.h),
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: (index % 3 == 0
                                            ? blueColor
                                            : (index % 3 == 1
                                                ? Colors.green
                                                : Colors.orange))
                                        .withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (servicioTramite.descripcion !=
                                        null) ...[
                                      _buildInfoRow("📝 Descripción:",
                                          servicioTramite.descripcion!),
                                      getVerSpace(4.h),
                                    ],
                                    _buildInfoRow("🏢 Entidad:",
                                        servicioTramite.entidadNombre),
                                    getVerSpace(4.h),
                                    _buildInfoRow("💵 Monto:",
                                        "${servicioTramite.monto[0].monto.toStringAsFixed(2)} Bs."),
                                    getVerSpace(4.h),
                                    _buildInfoRow("💰 Cuenta:",
                                        servicioTramite.monto[0].cuenta),
                                    getVerSpace(10.h),
                                    buildLinkInfo(
                                        servicioTramite.url,
                                        index % 3 == 0
                                            ? blueColor
                                            : (index % 3 == 1
                                                ? Colors.green
                                                : Colors.orange),
                                        context,
                                        mounted)
                                    //_buildInfoRow("🔗 URL:", servicioTramite.url),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        )
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.w,
          child: getCustomFont(
              label, 14, const Color.fromARGB(255, 85, 85, 85), 2,
              fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: getCustomFont(value.isNotEmpty ? value : "No disponible", 14,
              value.isNotEmpty ? Colors.black87 : Colors.grey[500]!, 3,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
