import '../app/models/consulado/model_regiones.dart';
import 'api_service.dart';

class RegionesService {
  /// Obtiene la lista de regiones con países y consulados
  Future<List<Region>> obtenerRegiones() async {
    try {
      final response = await ApiService.get()
          .end('/Apostilla/paises-y-consulados')
          .runAsync<Map<String, dynamic>>();

      if (response.success && response.data != null) {
        final jsonData = response.data!;

        if (jsonData.containsKey('regiones')) {
          final List<dynamic> regionesList = jsonData['regiones'];
          return regionesList.map((json) => Region.fromJson(json)).toList();
        } else {
          throw Exception(
              'Formato de respuesta inválido: no se encontró "regiones"');
        }
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      throw Exception('Error al obtener regiones: $e');
    }
  }
}

