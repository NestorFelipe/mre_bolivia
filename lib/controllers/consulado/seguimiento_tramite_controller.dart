// filepath: d:\SourceCancilleria\fronted_flutter_upgrade\lib\controllers\consulado\seguimiento_tramite_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/models/consulado/model_tipo_tramite.dart';
import '../../app/models/consulado/model_tramite_asistenciaconsular.dart';
import '../../app/models/consulado/model_tramite_passaportes.dart';
import '../../app/models/consulado/model_tramite_poderes.dart';
import '../../app/models/consulado/model_tramite_visas.dart';
import '../../app/models/consulado/model_tramite_vivencias.dart';
import '../../services/seguimiento_tramite.dart';

class SeguimientoTramiteController extends GetxController {
  final SeguimientoTramiteService _service = SeguimientoTramiteService();

  late final TextEditingController codigoTramiteController;

  RxList<TipoTramite> tiposTramite = <TipoTramite>[].obs;

  Rx<TipoTramite?> selectedTipo = Rx<TipoTramite?>(null);

  RxInt processTrackerNum = 0.obs;

  RxString codigoTramite = ''.obs;

  RxBool isfinishSearch = false.obs;

  // Variables observables para el trámite seleccionado de cada tipo
  Rx<TramiteVisasResponse?> tramiteVisas = Rx<TramiteVisasResponse?>(null);
  Rx<TramitePoderesResponse?> tramitePoderes =
      Rx<TramitePoderesResponse?>(null);
  Rx<TramitePassaportesResponse?> tramitePassaportes =
      Rx<TramitePassaportesResponse?>(null);
  Rx<TramiteVivenciasResponse?> tramiteVivencias =
      Rx<TramiteVivenciasResponse?>(null);
  Rx<TramiteAsistenciaConsularResponse?> tramiteAsistenciaConsular =
      Rx<TramiteAsistenciaConsularResponse?>(null);

  @override
  void onInit() {
    super.onInit();

    codigoTramiteController = TextEditingController();

    codigoTramiteController.addListener(() {
      codigoTramite.value = codigoTramiteController.text;
    });

    cargarTiposTramite();
  }

  @override
  void onClose() {
    codigoTramiteController.dispose();
    super.onClose();
  }

  // Método para cargar la lista de tipos de trámite desde el servicio
  Future<void> cargarTiposTramite() async {
    try {
      final response = await _service.obtenerTiposTramite();
      tiposTramite.assignAll(response.data);
    } catch (e) {
      // Manejar error, por ejemplo, mostrar snackbar
      Get.snackbar('Alerta', 'listado de tramites inaccesible: $e',
          backgroundColor: const Color.fromARGB(255, 204, 173, 125));
    }
  }

  // Método para obtener el seguimiento de un trámite específico basado en tipo e ID y tipo
  Future<void> obtenerTramite(String tipoTramite, String idTramite) async {
    try {
      limpiarTramiteSeleccionado();

      final response =
          await _service.obtenerSeguimientoTramite(tipoTramite, idTramite);
      // Asignar al correspondiente basado en tipo
      switch (tipoTramite) {
        case '1': // Visas
          tramiteVisas.value = response as TramiteVisasResponse?;
          break;
        case '2': // Poderes
          tramitePoderes.value = response as TramitePoderesResponse?;
          break;
        case '3': // Pasaporte
          tramitePassaportes.value = response as TramitePassaportesResponse?;
          break;
        case '4': // Vivencias
          tramiteVivencias.value = response as TramiteVivenciasResponse?;
          break;
        case '5': // AsistenciaConsular
          tramiteAsistenciaConsular.value =
              response as TramiteAsistenciaConsularResponse?;
          break;
        default:
          throw Exception('Tipo de trámite no reconocido: $tipoTramite');
      }
    } catch (e) {
      // Manejar error
      Get.snackbar(
          'Alerta', 'No se encontro informacion del tramite : $idTramite',
          backgroundColor: const Color.fromARGB(255, 255, 177, 61),
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.warning, color: Color.fromARGB(255, 0, 0, 0)),
          colorText: Colors.black);
    }
  }

  // Método para seleccionar un tipo de trámite
  void seleccionarTipo(TipoTramite tipo) {
    selectedTipo.value = tipo;
  }

  void avanzarProceso() {
    if (processTrackerNum.value < 2) {
      processTrackerNum.value++;
    }
  }

  void setIsFinishSearch(bool value) {
    isfinishSearch.value = value;
  }

  void retrocederProceso() {
    if (processTrackerNum.value > 0) {
      processTrackerNum.value--;
    }
  }

  void reiniciarProceso() {
    processTrackerNum.value = 0;
    selectedTipo.value = null;
    codigoTramite.value = '';
    codigoTramiteController.clear();
    isfinishSearch.value = false;
    limpiarTramiteSeleccionado();
  }

  void limpiarTramiteSeleccionado() {
    tramiteVisas.value = null;
    tramitePoderes.value = null;
    tramitePassaportes.value = null;
    tramiteVivencias.value = null;
    tramiteAsistenciaConsular.value = null;
  }
}
