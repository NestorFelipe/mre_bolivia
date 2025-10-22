import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mre_bolivia/app/data/data_file.dart';
import 'package:mre_bolivia/app/models/consulado/model_ciudad.dart';
import 'package:mre_bolivia/app/models/consulado/model_departamento.dart';
import 'package:mre_bolivia/app/models/consulado/model_residencia.dart';
import 'package:mre_bolivia/app/models/consulado/model_resposevalidafoto.dart';
import 'package:mre_bolivia/app/models/consulado/model_vivencia_save.dart';
import 'package:mre_bolivia/controllers/consulado/vivencia_controller.dart';
import 'package:mre_bolivia/base/pref_data.dart';
import 'package:mre_bolivia/services/api_service.dart';

import '../../../base/color_data.dart';
import '../../../base/utils/utils.dart';

class NuevoCertificado extends StatefulWidget {
  const NuevoCertificado({super.key, required this.controller});
  final VivenciaController controller;

  @override
  State<NuevoCertificado> createState() => _NuevoCertificadoState();
}

class _NuevoCertificadoState extends State<NuevoCertificado> {
  // Controladores de texto
  final TextEditingController apoderadoController = TextEditingController();
  final TextEditingController niApoderadoController = TextEditingController();
  final TextEditingController direccionApoderadoController =
      TextEditingController();

  // Variables para los dropdowns
  Residencia? selectedResidencia;
  Departamento? selectedDepartamento;
  Ciudad? selectedCiudad;

  // Variables para almacenar la imagen capturada
  String? capturedImagePath;
  String? capturedImageBase64; // Imagen en formato base64
  bool isProcessing = false;

  final ImagePicker _picker = ImagePicker();

  // Datos estáticos
  final List<Residencia> residencias = DataFile.residencia;
  final List<Departamento> departamentos = DataFile.departamento;
  final List<Ciudad> ciudades = DataFile.ciudad;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  void _cargarDatosIniciales() {
    // Obtener el último certificado si existe
    if (widget.controller.vivencias.isNotEmpty) {
      final ultimaVivencia = widget.controller.vivencias.first;

      // Rellenar los campos con los datos del último certificado
      apoderadoController.text = ultimaVivencia.apoderado;
      niApoderadoController.text = ultimaVivencia.niApoderado;
      direccionApoderadoController.text = ultimaVivencia.direccionApoderado;

      // Seleccionar residencia por defecto
      if (ultimaVivencia.idTipoResidencia > 0) {
        selectedResidencia = residencias.firstWhereOrNull(
          (r) => r.idresidencia == ultimaVivencia.idTipoResidencia,
        );
      }

      // Seleccionar departamento por defecto si existe en los datos
      if (ultimaVivencia.departamentoApoderado.isNotEmpty) {
        selectedDepartamento = departamentos.firstWhereOrNull(
          (d) =>
              d.descripcion.toLowerCase() ==
              ultimaVivencia.departamentoApoderado.toLowerCase(),
        );
      }
    }

    // Seleccionar valores por defecto si no hay datos previos
    selectedResidencia ??= residencias.first;
    selectedDepartamento ??= departamentos.first;
    selectedCiudad ??= ciudades.first;
  }

  @override
  void dispose() {
    apoderadoController.dispose();
    niApoderadoController.dispose();
    direccionApoderadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                      widget.controller.setIsNewCertificado(false);
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
                          "Nuevo Certificado",
                          18,
                          const Color(0xFF14357D),
                          1,
                          fontWeight: FontWeight.w700,
                        ),
                        getCustomFont(
                          "Complete el formulario",
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

            // Información del periodo seleccionado
            Obx(() {
              final periodo = widget.controller.selectedPeriodo.value;
              return Container(
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
                  child: Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomFont(
                              "Periodo Seleccionado",
                              12,
                              Colors.white.withOpacity(0.8),
                              1,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: 4.h),
                            getCustomFont(
                              periodo?.descripcion ?? "No seleccionado",
                              16,
                              Colors.white,
                              1,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            // Formulario
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tipo de Residencia
                    _buildSectionTitle("Tipo de Residencia"),
                    _buildDropdownField<Residencia>(
                      value: selectedResidencia,
                      items: residencias,
                      hintText: "Seleccione tipo de residencia",
                      displayText: (residencia) => residencia.descripcion,
                      onChanged: (value) {
                        setState(() {
                          selectedResidencia = value;
                        });
                      },
                    ),

                    SizedBox(height: 20.h),

                    // Datos del Apoderado
                    _buildSectionTitle("Datos del Apoderado"),
                    SizedBox(height: 10.h),

                    _buildTextField(
                      controller: apoderadoController,
                      label: "Nombre del Apoderado",
                      hint: "Ingrese nombre completo",
                      icon: Icons.person_outline,
                    ),

                    SizedBox(height: 15.h),

                    _buildTextField(
                      controller: niApoderadoController,
                      label: "NI del Apoderado",
                      hint: "Ingrese número de identificación",
                      icon: Icons.badge_outlined,
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(height: 20.h),

                    // Ubicación
                    _buildSectionTitle("Ubicación"),
                    SizedBox(height: 10.h),
                    getCustomFont(
                      "Dpto. Apoderado",
                      14,
                      Colors.grey.shade700,
                      1,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 8.h),
                    _buildDropdownField<Departamento>(
                      value: selectedDepartamento,
                      items: departamentos,
                      hintText: "Seleccione departamento",
                      displayText: (dept) => dept.descripcion,
                      onChanged: (value) {
                        setState(() {
                          selectedDepartamento = value;
                        });
                      },
                    ),

                    SizedBox(height: 15.h),
                    getCustomFont(
                      "Deseo recoger mi factura en oficina de:",
                      14,
                      Colors.grey.shade700,
                      1,
                      fontWeight: FontWeight.w600,
                    ),
                    _buildDropdownField<Ciudad>(
                      value: selectedCiudad,
                      items: ciudades,
                      hintText: "Seleccione ciudad",
                      displayText: (ciudad) => ciudad.descripcion,
                      onChanged: (value) {
                        setState(() {
                          selectedCiudad = value;
                        });
                      },
                    ),

                    SizedBox(height: 15.h),

                    _buildTextField(
                      controller: direccionApoderadoController,
                      label: "Dirección",
                      hint: "Ingrese dirección completa",
                      icon: Icons.location_on_outlined,
                      maxLines: 3,
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),

            // Botones de acción
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Botón Cancelar
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isProcessing
                          ? null
                          : () {
                              widget.controller.setIsNewCertificado(false);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.grey.shade700,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.close, size: 20),
                          SizedBox(width: 8.w),
                          Text(
                            "Cancelar",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  // Botón Guardar
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: isProcessing ? null : _guardarCertificado,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14357D),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 2,
                      ),
                      child: isProcessing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  "Procesando...",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.save, size: 20),
                                SizedBox(width: 8.w),
                                Text(
                                  "Guardar Certificado",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: const Color(0xFF14357D),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        getCustomFont(
          title,
          16,
          const Color(0xFF14357D),
          1,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCustomFont(
          label,
          14,
          Colors.grey.shade700,
          1,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF14357D),
                size: 20.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required List<T> items,
    required String hintText,
    required String Function(T) displayText,
    required void Function(T?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.arrow_drop_down_circle_outlined,
            color: const Color(0xFF14357D),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              displayText(item),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: Colors.white,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: const Color(0xFF14357D),
        ),
      ),
    );
  }

  void _guardarCertificado() async {
    try {
      if (!_validarDatos()) {
        return;
      }

      setState(() {
        isProcessing = true;
      });

      final datosParaGuardar = ModelVivenciaSave(
        idperiodo: widget.controller.selectedPeriodo.value?.id,
        idresidencia: selectedResidencia?.idresidencia,
        apoderado: apoderadoController.text.trim(),
        niapoderado: niApoderadoController.text.trim(),
        dptoapoderado: selectedDepartamento?.iddepartamento.toString(),
        direccionapoderado: direccionApoderadoController.text.trim(),
        iddepartamental: selectedCiudad?.idciudad,
      );

      // Capturar selfie y validar  y registro de certificado con el servicio
      final imagenValidada = await _capturarYValidarSelfie(datosParaGuardar);

      if (imagenValidada == null) {
        setState(() {
          isProcessing = false;
        });
        return;
      }

      Get.snackbar(
        'Éxito',
        'Certificado guardado correctamente',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      setState(() {
        isProcessing = false;
      });

      Future.delayed(const Duration(seconds: 2), () {
        widget.controller.setIsNewCertificado(false);
      });
    } catch (e) {
      setState(() {
        isProcessing = false;
      });

      Get.snackbar(
        'Error',
        'Error al guardar el certificado: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Valida todos los campos del formulario
  bool _validarDatos() {
    // Validar tipo de residencia
    if (selectedResidencia == null) {
      Get.snackbar(
        'Error de Validación',
        'Debe seleccionar un tipo de residencia',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    }

    // Validar nombre del apoderado
    if (apoderadoController.text.trim().isEmpty) {
      Get.snackbar(
        'Error de Validación',
        'Debe ingresar el nombre del apoderado',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    }

    // Validar que el nombre tenga al menos 3 caracteres
    if (apoderadoController.text.trim().length < 3) {
      Get.snackbar(
        'Error de Validación',
        'El nombre del apoderado debe tener al menos 3 caracteres',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    }

    // Validar NI del apoderado
    if (niApoderadoController.text.trim().isEmpty) {
      Get.snackbar(
        'Error de Validación',
        'Debe ingresar el NI del apoderado',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    }

    // Validar que el NI tenga formato correcto (solo números y longitud mínima)
    if (niApoderadoController.text.trim().length < 5) {
      Get.snackbar(
        'Error de Validación',
        'El NI del apoderado debe tener al menos 5 caracteres',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    }

    // Validar departamento
    if (selectedDepartamento == null) {
      Get.snackbar(
        'Error de Validación',
        'Debe seleccionar un departamento',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    }

    // Validar ciudad
    if (selectedCiudad == null) {
      Get.snackbar(
        'Error de Validación',
        'Debe seleccionar una ciudad',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    }

    // Validar dirección
    if (direccionApoderadoController.text.trim().isEmpty) {
      Get.snackbar(
        'Error de Validación',
        'Debe ingresar la dirección del apoderado',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    }

    // Validar que la dirección tenga longitud mínima
    if (direccionApoderadoController.text.trim().length < 10) {
      Get.snackbar(
        'Error de Validación',
        'La dirección debe tener al menos 10 caracteres',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    }

    // Todas las validaciones pasaron
    return true;
  }

  /// Captura la selfie del usuario usando la cámara
  Future<String?> _capturarSelfie() async {
    // Ocultar el teclado primero para evitar overflow
    FocusScope.of(context).unfocus();

    // Esperar a que el teclado se oculte completamente
    await Future.delayed(const Duration(milliseconds: 300));

    // Mostrar diálogo de instrucciones antes de abrir la cámara
    final bool? continuar = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.camera_alt,
                size: 60.sp,
                color: const Color(0xFF14357D),
              ),
              SizedBox(height: 16.h),
              getCustomFont(
                "Captura de Selfie",
                20,
                const Color(0xFF14357D),
                1,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 16.h),
              Text(
                'Para completar el registro, necesitamos capturar una fotografía de su rostro.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recomendaciones:',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF14357D),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildInstructionItem('Busque buena iluminación natural'),
                    _buildInstructionItem('Centre su rostro en el marco'),
                    _buildInstructionItem('Mire directamente a la cámara'),
                    _buildInstructionItem('Mantenga una expresión neutral'),
                    _buildInstructionItem('Retire lentes, gorras o accesorios'),
                    _buildInstructionItem(
                        'Asegúrese de que su rostro sea claramente visible'),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(result: false),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14357D),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Abrir Cámara',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    if (continuar != true) {
      return null;
    }

    // Mostrar diálogo de carga mientras se abre la cámara
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: const Color(0xFF14357D),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Abriendo cámara...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    String? imageDataUri;
    bool hasError = false;
    String errorMessage = '';

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
        maxWidth: 1280,
        maxHeight: 1280,
      );

      if (photo != null) {
        // Mostrar preview de la imagen capturada con opción de confirmar o reintentar
        final bool? confirmar = await _mostrarPreviewImagen(photo.path);

        if (confirmar == true) {
          // Leer la imagen y convertirla a base64
          final bytes = await File(photo.path).readAsBytes();
          final base64Image = base64Encode(bytes);
          imageDataUri = 'data:image/jpeg;base64,$base64Image';

          setState(() {
            capturedImagePath = photo.path;
            capturedImageBase64 = imageDataUri;
          });
        } else {
          // Usuario quiere reintentar - cerrar diálogo primero
          if (Get.isDialogOpen == true) {
            Get.back();
          }
          return await _capturarSelfie();
        }
      }
    } catch (e) {
      hasError = true;
      errorMessage = 'Error al acceder a la cámara: ${e.toString()}';
    } finally {
      // SIEMPRE cerrar el diálogo primero
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Dar un pequeño delay para que el diálogo se cierre completamente
      await Future.delayed(const Duration(milliseconds: 100));

      // Mostrar error si ocurrió
      if (hasError) {
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
      }
    }

    return imageDataUri;
  }

  /// Muestra un item de instrucción con viñeta
  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h, right: 8.w),
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: const Color(0xFF14357D),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _mostrarPreviewImagen(String imagePath) async {
    return await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getCustomFont(
                "Verificar Imagen",
                18,
                const Color(0xFF14357D),
                1,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 12.h),
              Text(
                'Asegúrese de que su rostro sea claramente visible',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 16.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFF14357D),
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'La imagen será validada para verificar la identidad',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(result: false),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Tomar Otra',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14357D),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Validar Imagen',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Captura la selfie y la valida con el servicio inmediatamente
  Future<String?> _capturarYValidarSelfie(ModelVivenciaSave pVivencia) async {
    // Capturar la imagen
    final imagenBase64 = await _capturarSelfie();

    if (imagenBase64 == null) {
      Get.snackbar(
        'Cancelado',
        'La captura de selfie fue cancelada',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return null;
    }

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: const Color(0xFF14357D),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Validando imagen...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Verificando que el rostro sea visible',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final idPersona = await PrefData.getIdPersona();
      final token = await PrefData.getToken();

      if (idPersona.isEmpty) {
        throw Exception('No se encontró el ID de persona');
      }

      final tokenAS = base64Encode(utf8.encode(idPersona));

      // Enviar foto al servicio de validación
      final photoPayload = {
        'photos': [imagenBase64],
        'token': '1',
        'tokenAS': tokenAS,
        'personId': idPersona,
        'vivencia': pVivencia.toJson(),
      };

      final photoResponse = await ApiService.post()
          .body(photoPayload)
          .header("Authorization", "Bearer $token")
          .end("/Apostilla/vivencia/agrega/certificado")
          .runAsync();

      final modelResponse = PhotoUploadResponse.fromJson(photoResponse.data);

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (modelResponse.status != "1") {
        // Mostrar error y permitir reintentar
        final bool? reintentar = await Get.dialog<bool>(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60.sp,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.h),
                  getCustomFont(
                    "Validación Fallida",
                    18,
                    Colors.red,
                    1,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    photoResponse.mensaje.isNotEmpty
                        ? photoResponse.mensaje
                        : 'No se pudo validar el rostro en la imagen',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Por favor, asegúrese de:',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade900,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        _buildInstructionItem(
                            'Su rostro está completamente visible'),
                        _buildInstructionItem('Hay suficiente iluminación'),
                        _buildInstructionItem('No hay sombras sobre el rostro'),
                        _buildInstructionItem(
                            'Está mirando directamente a la cámara'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Get.back(result: false),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14357D),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 18.sp),
                              SizedBox(width: 8.w),
                              Text(
                                'Reintentar',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );

        if (reintentar == true) {
          return await _capturarYValidarSelfie(pVivencia);
        }

        return null;
      }

      Get.snackbar(
        'Validación Exitosa',
        'Verificación facial completada correctamente. El nuevo certificado se registró en el sistema.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 2),
      );

      return imagenBase64;
    } catch (e) {
      // Cerrar diálogo si está abierto
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Mostrar error y opción de reintentar
      final bool? reintentar = await Get.dialog<bool>(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off,
                  size: 60.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                getCustomFont(
                  "Error de Conexión",
                  18,
                  Colors.red,
                  1,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 12.h),
                Text(
                  'No se pudo validar la imagen. Verifique su conexión a internet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(result: false),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => Get.back(result: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF14357D),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Reintentar',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      if (reintentar == true) {
        return await _capturarYValidarSelfie(pVivencia);
      }

      return null;
    }
  }
}
