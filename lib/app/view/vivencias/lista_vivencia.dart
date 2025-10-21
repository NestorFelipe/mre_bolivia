import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_cancilleria/app/models/consulado/model_lista_vivencia.dart';
import 'package:mi_cancilleria/controllers/consulado/vivencia_controller.dart';

import '../../../base/color_data.dart';
import '../../../base/utils/utils.dart';

class ListaVivencia extends StatelessWidget {
  const ListaVivencia({super.key, required this.controller});
  final VivenciaController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: Column(
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
                    icon: Icon(Icons.arrow_back_ios, color: blueColor),
                    onPressed: () {
                      controller.setIsDetalle(false);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getCustomFont(
                          "Certificados de Vivencia",
                          18,
                          const Color(0xFF14357D),
                          1,
                          fontWeight: FontWeight.w700,
                        ),
                        getCustomFont(
                          "${controller.vivencias.length} certificado(s) encontrado(s)",
                          12,
                          Colors.grey,
                          1,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24.w),
                ],
              ),
            ),

            // Información del usuario
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF14357D), Color(0xFF1E5BA8)],
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
                    Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getCustomFont(
                                controller.usuario.value,
                                16,
                                Colors.white,
                                2,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(height: 4.h),
                              getCustomFont(
                                "C.I.: ${controller.cedula.value}",
                                14,
                                Colors.white.withOpacity(0.9),
                                1,
                                fontWeight: FontWeight.w400,
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

            // Título de la lista
            getPaddingWidget(
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              Row(
                children: [
                  Icon(
                    Icons.description,
                    color: const Color(0xFF14357D),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  getCustomFont(
                    "Lista de Certificados",
                    16,
                    const Color(0xFF14357D),
                    1,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),

            // Lista de vivencias
            Expanded(
              child: Obx(() {
                final vivencias = controller.vivencias;

                if (vivencias.isEmpty) {
                  return _buildEmptyView();
                }

                return ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  itemCount: vivencias.length,
                  itemBuilder: (context, index) {
                    final vivencia = vivencias[index];
                    return _buildVivenciaItem(vivencia, index);
                  },
                );
              }),
            ),

            // Botón de volver
          ],
        ),
      ),
    );
  }

  Widget _buildVivenciaItem(Vivencia vivencia, int index) {
    // Color alternado para mejor legibilidad
    final isEven = index % 2 == 0;
    final bgColor = isEven ? Colors.white : Colors.grey.shade50;

    // Color del estado
    Color getEstadoColor(String estado) {
      switch (estado.toLowerCase()) {
        case 'aprobado':
        case 'aprobada':
          return Colors.green;
        case 'pendiente':
          return Colors.orange;
        case 'rechazado':
        case 'rechazada':
          return Colors.red;
        default:
          return Colors.blue;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            controller.setSelectedVivencia(vivencia);
            // Aquí puedes navegar a los detalles si es necesario
            _showVivenciaDetails(vivencia);
          },
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado con icono y código
                Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF14357D).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: const Color(0xFF14357D),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getCustomFont(
                            "Código: ${vivencia.codTramite}",
                            14,
                            const Color(0xFF14357D),
                            1,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(height: 4.h),
                          getCustomFont(
                            vivencia.descripcion,
                            12,
                            Colors.grey.shade600,
                            2,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    // Badge de estado
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: getEstadoColor(vivencia.estado).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: getEstadoColor(vivencia.estado),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        vivencia.estado.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: getEstadoColor(vivencia.estado),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),
                Divider(color: Colors.grey.shade300, height: 1),
                SizedBox(height: 12.h),

                // Información principal
                _buildInfoRow("Entidad:", vivencia.entidad),
                SizedBox(height: 8.h),
                _buildInfoRow("Periodo:", vivencia.periodo),
                SizedBox(height: 8.h),
                _buildInfoRow("Gestión:", vivencia.gestionVivencia.toString()),
                SizedBox(height: 8.h),
                _buildInfoRow(
                    "Fecha Registro:", _formatFecha(vivencia.fechaRegistro)),

                // Información adicional colapsable
                if (vivencia.apoderado.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Divider(color: Colors.grey.shade300, height: 1),
                  SizedBox(height: 12.h),
                  _buildInfoRow("Apoderado:", vivencia.apoderado),
                  if (vivencia.niApoderado.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child:
                          _buildInfoRow("NI Apoderado:", vivencia.niApoderado),
                    ),
                ],

                if (vivencia.tipoResidencia.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  _buildInfoRow("Tipo Residencia:", vivencia.tipoResidencia),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110.w,
          child: getCustomFont(
            label,
            12,
            const Color.fromARGB(255, 85, 85, 85),
            1,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: getCustomFont(
            value.isNotEmpty ? value : "No disponible",
            12,
            value.isNotEmpty ? Colors.black87 : Colors.grey.shade500,
            3,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80.sp,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            'No hay certificados disponibles',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              'No se encontraron certificados de vivencia para mostrar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFecha(String fecha) {
    try {
      // Intentar parsear la fecha y formatearla
      final DateTime parsedDate = DateTime.parse(fecha);
      return "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
    } catch (e) {
      // Si hay error, devolver la fecha original
      return fecha;
    }
  }

  void _showVivenciaDetails(Vivencia vivencia) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF14357D).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.description,
                        color: const Color(0xFF14357D),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: getCustomFont(
                        "Detalle del Certificado",
                        18,
                        const Color(0xFF14357D),
                        2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Divider(color: Colors.grey.shade300),
                SizedBox(height: 16.h),

                // Información detallada
                _buildDetailRow("Código Trámite", vivencia.codTramite),
                _buildDetailRow("Descripción", vivencia.descripcion),
                _buildDetailRow("Entidad", vivencia.entidad),
                _buildDetailRow("Periodo", vivencia.periodo),
                _buildDetailRow("Gestión", vivencia.gestionVivencia.toString()),
                _buildDetailRow("Estado", vivencia.estado),
                _buildDetailRow(
                    "Fecha Registro", _formatFecha(vivencia.fechaRegistro)),
                _buildDetailRow(
                    "Fecha Local", _formatFecha(vivencia.fechaLocal)),

                if (vivencia.apoderado.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(height: 12.h),
                  getCustomFont(
                    "Información del Apoderado",
                    14,
                    const Color(0xFF14357D),
                    1,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 12.h),
                  _buildDetailRow("Nombre", vivencia.apoderado),
                  _buildDetailRow("NI", vivencia.niApoderado),
                  _buildDetailRow("Dirección", vivencia.direccionApoderado),
                  _buildDetailRow(
                      "Departamento", vivencia.departamentoApoderado),
                ],

                if (vivencia.tipoResidencia.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(height: 12.h),
                  _buildDetailRow(
                      "Tipo de Residencia", vivencia.tipoResidencia),
                ],

                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14357D),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Cerrar",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCustomFont(
            label,
            12,
            Colors.grey.shade600,
            1,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 4.h),
          getCustomFont(
            value.isNotEmpty ? value : "No disponible",
            14,
            value.isNotEmpty ? Colors.black87 : Colors.grey.shade400,
            3,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
