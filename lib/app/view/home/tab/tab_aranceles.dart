import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mre_bolivia/app/models/consulado/model_arancel_consulado.dart';
import 'package:mre_bolivia/app/models/consulado/model_arancel_contacto_seccion.dart';
import 'package:mre_bolivia/app/models/consulado/model_paises.dart';
import 'package:mre_bolivia/app/models/consulado/model_seccion.dart';
import 'package:mre_bolivia/base/color_data.dart';
import 'package:mre_bolivia/base/utils/utils.dart';
import 'package:mre_bolivia/controllers/consulado/consulado_controller.dart';

class Aranceles extends GetView<ConsuladoController> {
  const Aranceles({super.key});

  @override
  Widget build(BuildContext context) {
    final Rxn<String> selectedPaisId = Rxn<String>();
    final RxString selectedPaisNombre = ''.obs;
    final Rxn<ItemConsulado> selectedConsulado = Rxn<ItemConsulado>();
    final Rxn<SeccionArancel> selectedSeccion = Rxn<SeccionArancel>();

    // Cargar datos si no están disponibles
    if (!controller.hasData) {
      controller.loadConsultadoData();
      controller.loadConsultadoForArancel();
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: backGroundColor,
        body: SafeArea(
          child: Obx(() {
            // Si hay una sección seleccionada, mostrar vista de aranceles
            if (selectedSeccion.value != null &&
                selectedConsulado.value != null) {
              return _buildArancelesView(
                selectedConsulado.value!,
                selectedSeccion.value!,
                selectedPaisNombre.value,
                () {
                  selectedSeccion.value = null;
                },
              );
            }

            // Si hay un consulado seleccionado, mostrar vista de secciones
            if (selectedConsulado.value != null) {
              return _buildSeccionesView(
                selectedConsulado.value!,
                selectedPaisNombre.value,
                (seccion) {
                  selectedSeccion.value = seccion;
                },
                () {
                  selectedConsulado.value = null;
                },
              );
            }

            // Si hay un país seleccionado, mostrar vista de consulados
            if (selectedPaisId.value != null) {
              return _buildConsuladosView(
                selectedPaisId.value!,
                selectedPaisNombre.value,
                (consulado) {
                  selectedConsulado.value = consulado;
                },
                () {
                  selectedPaisId.value = null;
                  selectedPaisNombre.value = '';
                },
              );
            }

            // Vista de países (vista principal)
            return _buildPaisesView(
              (pais) {
                selectedPaisId.value = pais.id;
                selectedPaisNombre.value = pais.nombre;
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPaisesView(Function(Pais) onPaisSelected) {
    final TextEditingController searchController = TextEditingController();
    final RxString searchQuery = ''.obs;

    return Column(
      children: [
        // Header
        getPaddingWidget(
          EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getCustomFont(
                "Aranceles Consulares",
                24,
                const Color.fromARGB(255, 51, 51, 51),
                2,
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // Search Bar
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                searchQuery.value = value;
              },
              decoration: InputDecoration(
                hintText: 'Buscar país...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: const Color(0xFF14357D),
                  size: 22.sp,
                ),
                suffixIcon: Obx(() {
                  if (searchQuery.value.isNotEmpty) {
                    return IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey.shade400,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        searchController.clear();
                        searchQuery.value = '';
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
              ),
            ),
          ),
        ),

        // Lista de países
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFF14357D),
                ),
              );
            }

            if (controller.hasError.value) {
              return _buildErrorView();
            }

            // Obtener países filtrados
            List<Pais> paises;
            if (searchQuery.value.isEmpty) {
              paises = controller.getAllPaises();
            } else {
              paises = controller.getPaisesByNombre(searchQuery.value);
            }

            if (paises.isEmpty) {
              return _buildEmptyView(searchQuery.value);
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              itemCount: paises.length,
              itemBuilder: (context, index) {
                final pais = paises[index];
                return _buildPaisItem(pais, onPaisSelected);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildConsuladosView(String paisId, String paisNombre,
      Function(ItemConsulado) onConsuladoSelected, VoidCallback onBack) {
    return Column(
      children: [
        // Header con botón de regreso
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF14357D),
                  size: 24.sp,
                ),
                onPressed: onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: getCustomFont(
                  "Aranceles Consulares\n$paisNombre",
                  18,
                  const Color.fromARGB(255, 69, 69, 69),
                  2,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 24.w),
            ],
          ),
        ),

        // Lista de consulados
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFF14357D),
                ),
              );
            }

            final paisIdInt = int.tryParse(paisId) ?? 0;
            final consulados =
                controller.getConsuladoForArancelByPais(paisIdInt);

            if (consulados.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off,
                      size: 60.sp,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No hay consulados disponibles',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'para $paisNombre',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              itemCount: consulados.length,
              itemBuilder: (context, index) {
                final consulado = consulados[index];
                return _buildConsuladoItem(consulado, onConsuladoSelected);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPaisItem(Pais pais, Function(Pais) onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => onTap(pais),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Icono del país
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF14357D), Color(0xFF1E4FA0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.public,
                      color: Colors.white,
                      size: 26.sp,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // Información del país
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pais.nombre,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF14357D),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'ID: ${pais.id}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icono de flecha
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18.sp,
                  color: const Color(0xFF14357D),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConsuladoItem(
      ItemConsulado consulado, Function(ItemConsulado) onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => onTap(consulado),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    // Icono del consulado
                    Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: consulado.id! % 3 == 0
                                ? blueColor.withOpacity(0.2)
                                : (consulado.id! % 3 == 1
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.orange.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: consulado.id! % 3 == 0
                                ? blueColor
                                : (consulado.id! % 3 == 1
                                    ? Colors.green
                                    : Colors.orange),
                            size: 24.w,
                          ),
                        ),
                        SizedBox(width: 16.w),
                      ],
                    ),

                    // Información del consulado
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getCustomFont(consulado.ciudadNombre ?? '', 12,
                              const Color.fromARGB(255, 58, 58, 58), 3,
                              fontWeight: FontWeight.w800),
                          getCustomFont(consulado.nombre!, 12,
                              const Color.fromARGB(255, 128, 128, 128), 3,
                              fontWeight: FontWeight.w800),
                        ],
                      ),
                    ),

                    SizedBox(width: 10.w),
                    // Icono de flecha
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18.sp,
                      color: const Color(0xFF14357D),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Divider(color: Colors.grey.shade300),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                            "📍 Dirección:", consulado.direccion ?? ''),
                        getVerSpace(4.h),
                        _buildInfoRow(
                            "📞 Teléfono:", consulado.telefonoOficina ?? ''),
                        getVerSpace(4.h),
                        _buildInfoRow("📞 Emergencias:",
                            consulado.telefonoEmergencia ?? ''),
                        getVerSpace(4.h),
                        _buildInfoRow(
                            "🕒 Horarios:", consulado.horarioAtencion ?? ''),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeccionesView(ItemConsulado consulado, String paisNombre,
      Function(SeccionArancel) onSeccionSelected, VoidCallback onBack) {
    return Column(
      children: [
        // Header con botón de regreso
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF14357D),
                  size: 24.sp,
                ),
                onPressed: onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: getCustomFont(
                  "Aranceles Consulares\n$paisNombre",
                  18,
                  const Color.fromARGB(255, 69, 69, 69),
                  2,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 24.w),
            ],
          ),
        ),

        // Consulado seleccionado
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    // Icono del consulado
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: consulado.id! % 3 == 0
                            ? blueColor.withOpacity(0.2)
                            : (consulado.id! % 3 == 1
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: consulado.id! % 3 == 0
                            ? blueColor
                            : (consulado.id! % 3 == 1
                                ? Colors.green
                                : Colors.orange),
                        size: 24.w,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Información del consulado
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getCustomFont(consulado.ciudadNombre ?? '', 12,
                              const Color.fromARGB(255, 58, 58, 58), 3,
                              fontWeight: FontWeight.w800),
                          getCustomFont(consulado.nombre!, 12,
                              const Color.fromARGB(255, 128, 128, 128), 3,
                              fontWeight: FontWeight.w800),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Divider(color: Colors.grey.shade300),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                              "📍 Dirección:", consulado.direccion ?? ''),
                          getVerSpace(4.h),
                          _buildInfoRow(
                              "📞 Teléfono:", consulado.telefonoOficina ?? ''),
                          getVerSpace(4.h),
                          _buildInfoRow("📞 Emergencias:",
                              consulado.telefonoEmergencia ?? ''),
                          getVerSpace(4.h),
                          _buildInfoRow(
                              "🕒 Horarios:", consulado.horarioAtencion ?? ''),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(color: Colors.grey.shade300),

        // Título de secciones
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
          Row(
            children: [
              getCustomFont(
                "SELECCIONE UN GRUPO DE ARANCEL",
                14,
                const Color.fromARGB(255, 12, 46, 126),
                1,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey.shade300),
        // Lista de secciones
        Expanded(
          child: Obx(() {
            final secciones = controller.seccionArancel;

            if (secciones.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_off,
                      size: 60.sp,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No hay secciones disponibles',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
              itemCount: secciones.length,
              itemBuilder: (context, index) {
                final seccion = secciones[index];
                return _buildSeccionItem(seccion, consulado, onSeccionSelected);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSeccionItem(SeccionArancel seccion, ItemConsulado consulado,
      Function(SeccionArancel) onTap) {
    // Mapeo de iconos de string a IconData
    IconData iconData;
    switch (seccion.icono) {
      case 'description':
        iconData = Icons.description;
        break;
      case 'gavel':
        iconData = Icons.gavel;
        break;
      case 'translate':
        iconData = Icons.translate;
        break;
      case 'security':
        iconData = Icons.security;
        break;
      case 'card_travel':
        iconData = Icons.card_travel;
        break;
      case 'money_off':
        iconData = Icons.money_off;
        break;
      case 'book':
        iconData = Icons.book;
        break;
      default:
        iconData = Icons.folder;
    }

    // Colores dinámicos basados en el ID
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.indigo,
      Colors.green,
    ];
    final color = colors[seccion.id % colors.length];

    return Container(
      margin: EdgeInsets.only(bottom: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () async {
            // Cargar aranceles y navegar
            print('Sección seleccionada: ${seccion.nombre}');
            print('Consulado ID: ${consulado.id}, Sección ID: ${seccion.id}');

            // Cargar datos de aranceles
            await controller.loadArancelesData(
              consulado.id.toString(),
              seccion.id.toString(),
            );

            // Navegar a la vista de aranceles
            onTap(seccion);
          },
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                // Icono de la sección
                Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    iconData,
                    color: color,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                // Información de la sección
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seccion.nombre,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF14357D),
                        ),
                      ),
                      if (seccion.descripcion != null &&
                          seccion.descripcion!.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          seccion.descripcion!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                    ],
                  ),
                ),
                // Icono de flecha
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18.sp,
                  color: const Color(0xFF14357D),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArancelesView(ItemConsulado consulado, SeccionArancel seccion,
      String paisNombre, VoidCallback onBack) {
    return Column(
      children: [
        // Header con botón de regreso
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF14357D),
                  size: 24.sp,
                ),
                onPressed: onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: getCustomFont(
                  "Aranceles Consulares\n$paisNombre",
                  18,
                  const Color.fromARGB(255, 69, 69, 69),
                  2,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 24.w),
            ],
          ),
        ),

        // Consulado y Sección seleccionados
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF14357D), Color(0xFF1E4FA0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF14357D).withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del consulado
                Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.location_city,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            consulado.ciudadNombre ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            consulado.nombre ?? '',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Divider(color: Colors.white.withOpacity(0.3), height: 1),
                SizedBox(height: 12.h),
                // Información de la sección
                Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        _getIconData(seccion.icono),
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            seccion.nombre,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          if (seccion.descripcion != null &&
                              seccion.descripcion!.isNotEmpty)
                            Text(
                              seccion.descripcion!,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Título de aranceles
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          Row(
            children: [
              Icon(
                Icons.attach_money,
                color: const Color(0xFF14357D),
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              getCustomFont(
                "Lista de Aranceles",
                16,
                const Color.fromARGB(255, 51, 51, 51),
                1,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),

        // Lista de aranceles
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: const Color(0xFF14357D),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Cargando aranceles...',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (controller.hasError.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60.sp,
                      color: Colors.red.shade300,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Error al cargar aranceles',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final aranceles = controller.aranceles;

            if (aranceles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 60.sp,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No hay aranceles disponibles',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'para ${seccion.nombre}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
              itemCount: aranceles.length,
              itemBuilder: (context, index) {
                final arancel = aranceles[index];
                return _buildArancelItem(arancel, index);
              },
            );
          }),
        ),
      ],
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'description':
        return Icons.description;
      case 'gavel':
        return Icons.gavel;
      case 'translate':
        return Icons.translate;
      case 'security':
        return Icons.security;
      case 'card_travel':
        return Icons.card_travel;
      case 'money_off':
        return Icons.money_off;
      case 'book':
        return Icons.book;
      default:
        return Icons.folder;
    }
  }

  Widget _buildArancelItem(Arancel arancel, int index) {
    // Formatear precios
    String formatearPrecio(num? precio) {
      if (precio == null) return 'N/A';

      // Formatear con punto como separador de miles y coma como separador de decimales
      final String precioStr = precio.toStringAsFixed(2);
      final parts = precioStr.split('.');
      final entero = parts[0];
      final decimal = parts[1];

      // Agregar puntos como separador de miles
      String enteroFormateado = '';
      int contador = 0;
      for (int i = entero.length - 1; i >= 0; i--) {
        if (contador == 3) {
          enteroFormateado = '.$enteroFormateado';
          contador = 0;
        }
        enteroFormateado = entero[i] + enteroFormateado;
        contador++;
      }

      return '$enteroFormateado,$decimal';
    }

    // Color alternado para mejor legibilidad
    final isEven = index % 2 == 0;
    final bgColor = isEven ? Colors.white : Colors.grey.shade50;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Descripción del servicio
            Text(
              arancel.descripcion ?? 'Sin descripción',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 51, 51, 51),
                height: 1.3,
              ),
            ),

            SizedBox(height: 12.h),
            Divider(color: Colors.grey.shade300, height: 1),
            SizedBox(height: 12.h),

            // Información de costos
            Row(
              children: [
                // Costo en dólares
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            getSvgImage('money.svg',
                                width: 18.w, color: Colors.green.shade700),
                            SizedBox(width: 4.w),
                            Text(
                              'Costo Bs.',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          textAlign: TextAlign.right,
                          formatearPrecio(arancel.costo),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 10.w),

                // Costo en moneda local
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            getSvgImage('money.svg',
                                width: 18.w, color: Colors.blue.shade700),
                            SizedBox(width: 4.w),
                            Text(
                              'Costo Moneda Local',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          formatearPrecio(arancel.costoML),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Tipo de cambio si está disponible
            if (arancel.tipoCambio != null && arancel.tipoCambio! > 0) ...[
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: Colors.orange.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.currency_exchange,
                      size: 14.sp,
                      color: Colors.orange.shade700,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'T/C: ${arancel.tipoCambio!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60.sp,
            color: Colors.red.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error al cargar datos',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              controller.loadConsultadoData();
              controller.loadConsultadoForArancel();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF14357D),
              padding: EdgeInsets.symmetric(
                horizontal: 32.w,
                vertical: 12.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Reintentar',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(String searchTerm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            searchTerm.isEmpty ? Icons.public_off : Icons.search_off,
            size: 60.sp,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            searchTerm.isEmpty
                ? 'No hay países disponibles'
                : 'No se encontraron países',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          if (searchTerm.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              'Intenta con otro término de búsqueda',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.w,
          child: getCustomFont(
              label, 11, const Color.fromARGB(255, 85, 85, 85), 2,
              fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: getCustomFont(value.isNotEmpty ? value : "No disponible", 11,
              value.isNotEmpty ? Colors.black87 : Colors.grey[500]!, 3,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
