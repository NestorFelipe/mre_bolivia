import 'package:mi_cancilleria/app/models/consulado/model_lista_vivencia.dart';
import 'package:mi_cancilleria/app/models/consulado/model_periodos_vigente.dart';
import 'package:mi_cancilleria/app/models/consulado/model_response_auth.dart';
import 'package:mi_cancilleria/services/api_service.dart';

class VivenciasService {
  Future<ModelResponseAuth> authVivencia(String ci, String password) async {
    try {
      final response =
          await ApiService.post().end('/Apostilla/vivencia/auth').body({
        'ci': ci,
        'password': password,
      }).runAsync<Map<String, dynamic>>();

      if (response.data != null) {
        final jsonData = response.data!;
        return ModelResponseAuth.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print(e);
      throw Exception('Error al obtener tipos de trámite: $e');
    }
  }

  Future<ListaVivenciaResponse> getInfoUser(
      String token, String idpsersona) async {
    try {
      final response = await ApiService.get()
          .header("Authorization", "Bearer $token")
          .end('/Apostilla/vivencia/user/$idpsersona')
          .runAsync<Map<String, dynamic>>();

      if (response.data != null) {
        final jsonData = response.data!;
        return ListaVivenciaResponse.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print(e);
      throw Exception('Error al obtener tipos de trámite: $e');
    }
  }

  Future<ModelPeriodosVigente> getPeriodoVigente(
      String token, String idpsersona) async {
    try {
      final response = await ApiService.get()
          .header("Authorization", "Bearer $token")
          .end('/Apostilla/vivencia/periodo/vigente/$idpsersona')
          .runAsync<Map<String, dynamic>>();

      if (response.data != null) {
        final jsonData = response.data!;
        return ModelPeriodosVigente.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print(e);
      throw Exception('Error al obtener tipos de trámite: $e');
    }
  }

  Future<ListaVivenciaResponse> getLitaVivencia(
      int reg, String token, String idpsersona) async {
    try {
      final response = await ApiService.get()
          .header("Authorization", "Bearer $token")
          .end('/Apostilla/vivencia/lista/$reg/$idpsersona')
          .runAsync<Map<String, dynamic>>();

      if (response.data != null) {
        final jsonData = response.data!;
        return ListaVivenciaResponse.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print(e);
      throw Exception('Error al obtener tipos de trámite: $e');
    }
  }
}
