import 'package:mre_bolivia/app/models/consulado/model_arancel_consulado.dart';
import 'package:mre_bolivia/app/models/consulado/model_arancel_contacto_seccion.dart';
import 'package:mre_bolivia/app/models/consulado/model_definicion_detail.dart';
import 'package:mre_bolivia/app/models/consulado/model_intro.dart';
import 'package:mre_bolivia/app/models/consulado/model_paises.dart';
import 'package:mre_bolivia/app/models/consulado/model_regiones.dart';
import 'package:mre_bolivia/app/models/consulado/model_seccion.dart';
import 'package:mre_bolivia/app/models/consulado/model_servicio.dart';
import 'package:mre_bolivia/app/models/consulado/model_servicios_tramites.dart';
import 'package:mre_bolivia/base/constant.dart';
import 'package:get/get.dart';

import '../../services/consulado_service.dart';
import '../../services/offline_data_service.dart';
import 'tab_home_controller.dart';

class ConsuladoController extends GetxController {
  // Observables para el estado
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxList<Servicio> servicios = <Servicio>[].obs;
  RxList<Arancel> aranceles = <Arancel>[].obs;

  RxList<ServicioTramite> tramiteServicios = <ServicioTramite>[].obs;
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

      // Guardar en cache para uso offline
      try {
        await _saveConsultadoDataToCache();
      } catch (cacheError) {
        print('⚠️ Error guardando en cache: $cacheError');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('❌ Error al cargar datos del consulado: $e');

      // Intentar cargar desde cache si falla la conexión
      try {
        print('🔄 Intentando cargar desde cache...');
        await loadConsultadoDataFromCache();
        if (consultadoData != null && consultadoData!.isNotEmpty) {
          hasError.value = false;
          errorMessage.value = '';
          print('✅ Datos del consulado cargados desde cache');
        }
      } catch (cacheError) {
        print('❌ Error cargando desde cache: $cacheError');
      }
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
      if (definicionesData?.servicios != null) {
        servicios.assignAll(definicionesData!.servicios);
      }
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

  /// Cargar datos tramite servicios
  Future<void> loadTramiteServiciosData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('📡 Cargando datos tramite servicios.');

      final data = await _consultadoService!.obtenerTramiteServicios();
      tramiteServicios.value = data.data;

      print('✅ Datos de tramite servicios cargados correctamente');

      // Guardar en cache para uso offline
      try {
        await _saveTramiteServiciosToCache();
      } catch (cacheError) {
        print('⚠️ Error guardando trámites en cache: $cacheError');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('❌ Error al cargar datos tramite servicios: $e');

      // Intentar cargar desde cache si falla la conexión
      try {
        print('🔄 Intentando cargar trámites desde cache...');
        await loadTramiteServiciosFromCache();
        if (tramiteServicios.isNotEmpty) {
          hasError.value = false;
          errorMessage.value = '';
          print('✅ Datos de trámites cargados desde cache');
        }
      } catch (cacheError) {
        print('❌ Error cargando trámites desde cache: $cacheError');
      }
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
    if (definicionesData?.servicios != null) {
      servicios.assignAll(definicionesData!.servicios);
    }
    return servicios;
  }

  // Métodos para cache offline
  Future<void> _saveConsultadoDataToCache() async {
    if (consultadoData != null) {
      final consultadoMap = {
        'regiones': consultadoData!.map((region) => region.toJson()).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await OfflineDataService.saveConsultadoData(consultadoMap);
      await OfflineDataService.saveRegionesData(
          consultadoData!.map((region) => region.toJson()).toList());
    }
  }

  Future<void> loadConsultadoDataFromCache() async {
    final consultadoCache = await OfflineDataService.getConsultadoData();
    if (consultadoCache != null && consultadoCache['regiones'] != null) {
      final regionesList = consultadoCache['regiones'] as List;
      consultadoData = regionesList
          .map((regionJson) =>
              Region.fromJson(regionJson as Map<String, dynamic>))
          .toList();
      print(
          '✅ Datos de consulado restaurados desde cache (${consultadoData!.length} regiones)');
    }
  }

  Future<void> _saveTramiteServiciosToCache() async {
    if (tramiteServicios.isNotEmpty) {
      final tramitesData = tramiteServicios
          .map((tramite) => {
                'id': tramite.id,
                'nombre': tramite.nombre,
                'descripcion': tramite.descripcion,
                'entidadNombre': tramite.entidadNombre,
                'entidadSigla': tramite.entidadSigla,
                'entidadCodigoPortal': tramite.entidadCodigoPortal,
                'precio': tramite.precio,
                'codigoPortal': tramite.codigoPortal,
                'monto': tramite.monto
                    .map((m) => {
                          'monto': m.monto,
                          'cuenta': m.cuenta,
                        })
                    .toList(),
                'otros': tramite.otros,
                'url': tramite.url,
              })
          .toList();
      await OfflineDataService.saveTramiteServiciosData(tramitesData);
    }
  }

  Future<void> loadTramiteServiciosFromCache() async {
    final tramitesData = await OfflineDataService.getTramiteServiciosData();
    if (tramitesData != null && tramitesData.isNotEmpty) {
      // Restaurar los datos de tramites desde cache
      final List<ServicioTramite> tramitesFromCache = tramitesData.map((data) {
        return ServicioTramite.fromJson(data as Map<String, dynamic>);
      }).toList();

      tramiteServicios.assignAll(tramitesFromCache);
      print(
          '✅ Servicios de tramites restaurados desde cache (${tramiteServicios.length} items)');
    }
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
