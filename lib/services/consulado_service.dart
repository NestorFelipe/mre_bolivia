import 'package:mi_cancilleria/app/models/consulado/model_definicion_detail.dart';
import 'package:mi_cancilleria/app/models/consulado/model_regiones.dart';

import 'api_service.dart';

class ConsuladoService {
  /// Obtiene los datos completos del consulado
  Future<RegionesResponse> obtenerDatosConsulado() async {
    try {
      final response = await ApiService.get()
          .end('/Apostilla/paises-y-consulados')
          .runAsync<Map<String, dynamic>>();

      if (response.success && response.data != null) {
        return RegionesResponse.fromJson(response.data!['data']);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      throw Exception('Error al obtener datos del consulado: $e');
    }
  }

  /// Obtiene solo las definiciones del consulado
  Future<ModelDefinicionDetail> obtenerDefiniciones() async {
    try {
      final response = await ApiService.get()
          .end('/Apostilla/definicion')
          .runAsync<Map<String, dynamic>>();

      if (response.success && response.data != null) {
        return ModelDefinicionDetail.fromJson(response.data!['data']);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      throw Exception('Error al obtener definiciones: $e');
    }
  }
}

