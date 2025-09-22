import 'package:get/get.dart';
import '../app/models/model_consulado.dart';
import '../services/consulado_service.dart';

class ConsultadoController extends GetxController {
  final ConsultadoService _consultadoService = Get.find<ConsultadoService>();

  // Estado de la aplicación
  final _isLoading = false.obs;
  final _hasError = false.obs;
  final _errorMessage = ''.obs;

  // Datos del consulado
  final Rx<ModelConsulado?> _consultadoData = Rx<ModelConsulado?>(null);

  // Getters
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  ModelConsulado? get consultadoData => _consultadoData.value;

  @override
  void onInit() {
    super.onInit();
    loadConsultadoData();
  }

  /// Cargar datos del consulado
  Future<void> loadConsultadoData() async {
    try {
      print('🔄 Iniciando carga de datos del consulado...');
      _setLoading(true);
      _clearError();

      final response = await _consultadoService.getConsultadoData();

      print('📡 Respuesta recibida - Status: ${response.statusCode}');

      if (response.hasError) {
        final errorMsg = 'Error ${response.statusCode}: ${response.statusText}';
        print('❌ $errorMsg');
        _setError(errorMsg);
        return;
      }

      if (response.body != null) {
        _consultadoData.value = response.body;
        print('✅ Datos cargados exitosamente');
        print('📊 Definiciones: ${response.body!.definiciones.length}');
        print('🌍 Países: ${response.body!.pais.length}');
        print('🏢 Entidades: ${response.body!.entidad.length}');
      } else {
        const errorMsg = 'No se encontraron datos del consulado';
        print('⚠️ $errorMsg');
        _setError(errorMsg);
      }
    } catch (e) {
      final errorMsg = 'Error inesperado: ${e.toString()}';
      print('💥 $errorMsg');
      _setError(errorMsg);
    } finally {
      _setLoading(false);
      print('🏁 Proceso de carga finalizado');
    }
  }

  /// Recargar datos
  Future<void> refreshData() async {
    await loadConsultadoData();
  }

  /// Establecer estado de carga
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  /// Establecer error
  void _setError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
  }

  /// Limpiar error
  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  /// Obtener definiciones por tipo
  List<ModelDefinicion> getDefinicionesByTipo(String tipo) {
    if (_consultadoData.value?.definiciones == null) return [];
    
    return _consultadoData.value!.definiciones
        .where((def) => def.tipo == tipo)
        .toList();
  }

  /// Obtener países disponibles
  List<ModelPais> getPaises() {
    return _consultadoData.value?.pais ?? [];
  }

  /// Obtener tipos de trámite
  List<ModelTramiteTipo> getTiposTramite() {
    return _consultadoData.value?.tramitesTipos ?? [];
  }

  /// Obtener entidades
  List<ModelEntidad> getEntidades() {
    return _consultadoData.value?.entidad ?? [];
  }
}