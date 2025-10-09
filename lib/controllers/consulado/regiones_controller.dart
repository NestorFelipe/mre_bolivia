import 'package:get/get.dart';
import '../../app/models/consulado/model_regiones.dart';
import '../../services/regiones_service.dart';

class RegionesController extends GetxController {
  // Observables para el estado
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  // Datos de las regiones
  RxList<Region> regiones = <Region>[].obs;

  // Servicio
  RegionesService? _regionesService;

  @override
  void onInit() {
    super.onInit();
    // Inyectar el servicio
    try {
      _regionesService = Get.find<RegionesService>();
    } catch (e) {
      print('⚠️ RegionesService no encontrado, creando nueva instancia');
      _regionesService = RegionesService();
    }
  }

  /// Cargar regiones
  Future<void> loadRegiones() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('📡 Cargando regiones...');

      final data = await _regionesService!.obtenerRegiones();

      regiones.assignAll(data);
      print('✅ Regiones cargadas correctamente: ${regiones.length} regiones');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('❌ Error al cargar regiones: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Obtener región por ID
  Region? getRegionById(String regionId) {
    try {
      return regiones.firstWhere((region) => region.id == regionId);
    } catch (e) {
      return null;
    }
  }

  /// Buscar regiones por nombre
  List<Region> searchRegionesByName(String query) {
    if (query.isEmpty) return regiones;

    return regiones
        .where((region) =>
            region.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Verificar si hay datos disponibles
  bool get hasData => regiones.isNotEmpty;

  /// Obtener total de regiones
  int get totalRegiones => regiones.length;

  /// Obtener total de países en todas las regiones
  int get totalPaises {
    int total = 0;
    for (final region in regiones) {
      total += region.paises.length;
    }
    return total;
  }

  /// Recargar datos
  Future<void> reloadData() async {
    await loadRegiones();
  }

  /// Limpiar datos
  void clearData() {
    regiones.clear();
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

