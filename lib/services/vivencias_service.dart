import 'package:mre_bolivia/app/models/consulado/model_lista_vivencia.dart';
import 'package:mre_bolivia/app/models/consulado/model_periodos_vigente.dart';
import 'package:mre_bolivia/app/models/consulado/model_response_auth.dart';
import 'package:mre_bolivia/services/api_service.dart';
import 'package:http/http.dart' as http;

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

  Future<ModelResponseAuth> validaImagen(String ci, String password) async {
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

  Future<void> testService() async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjYxMDQ5MjMiLCJOSSI6IjYxMDQ5MjMiLCJBY2VwdG9UZXJtaW5vcyI6IlRydWUiLCJJZFBlcnNvbmEiOiIxMDc5ODEwIiwianRpIjoiNWVkMDg5ZDItMWFkYy00NWE0LTk3OWItMjgxMDFlOWI0MTUyIiwiZXhwIjoxNzkyNjg3NDgzLCJpc3MiOiJ3d3cucnJlZS5nb2IuYm8iLCJhdWQiOiIqIn0.Aw1uxoEXXmi7CprqBTw27LIfMtT55q2vH7_P9bscE0o'
    };
    var url = Uri.parse(
        'https://servicios.cancilleria.gob.bo/app-movil/api/Apostilla/vivencia/user/1079810');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }
}
