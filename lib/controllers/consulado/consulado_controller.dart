import 'package:mi_cancilleria/app/models/consulado/model_arancel_consulado.dart';
import 'package:mi_cancilleria/app/models/consulado/model_arancel_contacto_seccion.dart';
import 'package:mi_cancilleria/app/models/consulado/model_definicion_detail.dart';
import 'package:mi_cancilleria/app/models/consulado/model_intro.dart';
import 'package:mi_cancilleria/app/models/consulado/model_paises.dart';
import 'package:mi_cancilleria/app/models/consulado/model_regiones.dart';
import 'package:mi_cancilleria/app/models/consulado/model_seccion.dart';
import 'package:mi_cancilleria/app/models/consulado/model_servicio.dart';
import 'package:mi_cancilleria/base/constant.dart';
import 'package:get/get.dart';

import '../../services/consulado_service.dart';
import 'tab_home_controller.dart';

class ConsuladoController extends GetxController {
  // Observables para el estado
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxList<Servicio> servicios = <Servicio>[].obs;
  RxList<Arancel> aranceles = <Arancel>[].obs;

  List<SeccionArancel> seccionArancel = [];
  // Datos del consulado
  List<Region>? consultadoData;
  List<ItemConsulado>? consultadoItemsArancel;

  /// Obtener todos los países de todas las regiones
  List<Pais> getAllPaises() {
    if (consultadoItemsArancel == null) return [];

    List<Pais> allPaises = [];
    Set<int> paisesIds = {};

    for (var item in consultadoItemsArancel!) {
      if (!paisesIds.contains(item.paisId)) {
        paisesIds.add(item.paisId!);
        // Buscar el país completo en consultadoData
        allPaises.add(Pais(
          id: item.paisId.toString(),
          nombre: item.paisNombre!,
          codigoPais: item.paisNombre!,
          alpha2: '',
          alpha3: '',
          subRegion: '',
          codigoNumerico: 0,
          consulados: [],
        ));
      }
    }

    // Ordenar alfabéticamente por nombre
    allPaises.sort((a, b) => a.nombre.compareTo(b.nombre));

    return allPaises;
  }

  /// Buscar países por nombre en todas las regiones
  List<Pais> getPaisesByNombre(String nombre) {
    List<Pais> filteredPaises = getAllPaises();

    if (filteredPaises.isEmpty || nombre.isEmpty) return [];

    List<Pais> paisesCoincidentes = [];
    String nombreBusqueda = nombre.toLowerCase();

    for (var item in filteredPaises) {
      if (item.nombre.toLowerCase().contains(nombreBusqueda)) {
        paisesCoincidentes.add(item);
      }
    }

    return paisesCoincidentes;
  }

  List<ItemConsulado> getConsuladoForArancelByPais(int idpais) {
    if (consultadoItemsArancel == null) return [];

    return consultadoItemsArancel!
        .where((item) => item.paisId == idpais)
        .toList();
  }

  ModelDefinicionDetail? definicionesData;

  // Servicio
  ConsuladoService? _consultadoService;

  @override
  void onInit() {
    super.onInit();
    // Inyectar el servicio
    try {
      _consultadoService = Get.find<ConsuladoService>();
      seccionArancel = SeccionArancel.obtenerSeccionesDefault();
    } catch (e) {
      print('⚠️ ConsuladoService no encontrado, creando nueva instancia');
      _consultadoService = ConsuladoService();
    }
  }

  /// Cargar datos del consulado
  Future<void> loadConsultadoForArancel() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('📡 Cargando datos del consulado para aranceles...');
      final data = await _consultadoService!.obtenerConsuladosForArancel();

      consultadoItemsArancel = data.lista;
      print('✅ Datos del consulado para aranceles cargados correctamente');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('❌ Error al cargar datos del consulado: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Cargar datos del consulado
  Future<void> loadConsultadoData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('📡 Cargando datos del consulado...');

      final data = await _consultadoService!.obtenerDatosConsulado();

      consultadoData = data.regiones;
      print('✅ Datos del consulado cargados correctamente');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('❌ Error al cargar datos del consulado: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Cargar datos del consulado
  Future<void> loadDefinicionesData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('📡 Cargando datos del consulado...');

      final data = await _consultadoService!.obtenerDefiniciones();

      definicionesData = data;
      servicios.assignAll(definicionesData!.servicios);
      print('✅ Datos del consulado cargados correctamente');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('❌ Error al cargar datos del consulado: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Cargar datos del consulado
  Future<void> loadArancelesData(String pContacto, String pSeccion) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('📡 Obteniendo datos de aranceles $pContacto / $pSeccion...');

      final data = await _consultadoService!
          .obtenerArancelContactoSeccion(pContacto, pSeccion);

      aranceles.value = data.lista ?? [];

      print('✅ Datos de aranceles cargados correctamente');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('❌ Error al cargar datos de aranceles: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Verificar si hay datos disponibles
  bool get hasData => consultadoData != null;

  /// Obtener definiciones
  List<Intro> get definiciones {
    return definicionesData?.intros ?? [];
  }

  /// Recargar datos
  Future<void> reloadData() async {
    await loadConsultadoData();
  }

  void goBack() {
    Constant.backToPrev(Get.context!);
  }

  /// Enviar servicio al TabHomeController y navegar
  void navigateToServicioDetail(Servicio servicio) {
    try {
      // Obtener o crear el TabHomeController
      TabHomeController tabHomeController;

      if (Get.isRegistered<TabHomeController>()) {
        tabHomeController = Get.find<TabHomeController>();
      } else {
        tabHomeController = Get.put(TabHomeController());
      }

      // Llamar al método goToServicio del TabHomeController
      tabHomeController.goToServicio(servicio);
    } catch (e) {
      print('❌ Error al navegar a detalle de servicio: $e');
    }
  }

  /// Obtener países
  List<Pais> getPaises(int idregion) {
    // ignore: unrelated_type_equality_checks
    return consultadoData
            // ignore: unrelated_type_equality_checks
            ?.firstWhere((region) => region.id == idregion)
            .paises ??
        [];
  }

  List<Servicio> getServicios() {
    servicios.assignAll(definicionesData!.servicios);
    return servicios;
  }

  /// Refrescar datos (alias para reloadData)
  Future<void> refreshData() async {
    await reloadData();
  }

  /// Limpiar datos
  void clearData() {
    consultadoData = null;
    servicios.clear();
    hasError.value = false;
    errorMessage.value = '';
    isLoading.value = false;
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}
