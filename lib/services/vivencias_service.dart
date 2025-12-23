import 'package:mre_bolivia/app/models/consulado/model_genericresponse.dart';
import 'package:mre_bolivia/app/models/consulado/model_lista_vivencia.dart';
import 'package:mre_bolivia/app/models/consulado/model_periodos_vigente.dart';
import 'package:mre_bolivia/app/models/consulado/model_response_auth.dart';
import 'package:mre_bolivia/services/api_service.dart';

class VivenciasService {
  static const Duration _timeout = Duration(seconds: 30);

  Future<ModelResponseAuth> authVivencia(String ci, String password) async {
    try {
      final response = await ApiService.post()
          .end('/Apostilla/vivencia/auth')
          .body({
            'ci': ci,
            'password': password,
          })
          .runAsync<Map<String, dynamic>>()
          .timeout(_timeout, onTimeout: () {
            throw Exception(
                'Timeout: La solicitud de autenticación tardó demasiado');
          });

      if (response.data != null) {
        final jsonData = response.data!;
        return ModelResponseAuth.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print('Error en authVivencia: $e');
      throw Exception('Error de autenticación: $e');
    }
  }

  Future<ModelGenericResponse> authUnlock(String email, String ci) async {
    try {
      final response = await ApiService.post()
          .end('/Apostilla/vivencia/auth/unlock')
          .body({
            'mail': email,
            'user': ci,
          })
          .runAsync<Map<String, dynamic>>()
          .timeout(_timeout, onTimeout: () {
            throw Exception(
                'Timeout: La solicitud de autenticación tardó demasiado');
          });

      if (response.data != null) {
        final jsonData = response.data!;
        return ModelGenericResponse.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print('Error en authVivencia: $e');
      throw Exception('Error de autenticación: $e');
    }
  }

  Future<ModelGenericResponse> authRecovery(String email, String ci) async {
    try {
      final response = await ApiService.post()
          .end('/Apostilla/vivencia/auth/recovery')
          .body({
            'mail': email,
            'user': ci,
          })
          .runAsync<Map<String, dynamic>>()
          .timeout(_timeout, onTimeout: () {
            throw Exception(
                'Timeout: La solicitud de autenticación tardó demasiado');
          });

      if (response.data != null) {
        final jsonData = response.data!;
        return ModelGenericResponse.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print('Error en authVivencia: $e');
      throw Exception('Error de autenticación: $e');
    }
  }

  Future<ListaVivenciaResponse> getInfoUser(
      String token, String idpsersona) async {
    try {
      if (token.isEmpty) {
        throw Exception('Token vacío');
      }

      final response = await ApiService.get()
          .header("Authorization", "Bearer $token")
          .end('/Apostilla/vivencia/user/$idpsersona')
          .runAsync<Map<String, dynamic>>()
          .timeout(_timeout, onTimeout: () {
        throw Exception('Timeout: La solicitud de usuario tardó demasiado');
      });

      if (response.data != null) {
        final jsonData = response.data!;
        return ListaVivenciaResponse.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print('Error en getInfoUser: $e');
      // No relanzar error aquí, solo retornar null en el controlador
      rethrow;
    }
  }

  Future<ModelPeriodosVigente> getPeriodoVigente(
      String token, String idpsersona) async {
    try {
      if (token.isEmpty) {
        throw Exception('Token vacío');
      }

      final response = await ApiService.get()
          .header("Authorization", "Bearer $token")
          .end('/Apostilla/vivencia/periodo/vigente/$idpsersona')
          .runAsync<Map<String, dynamic>>()
          .timeout(_timeout, onTimeout: () {
        throw Exception('Timeout: La solicitud de periodos tardó demasiado');
      });

      if (response.data != null) {
        final jsonData = response.data!;
        return ModelPeriodosVigente.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print('Error en getPeriodoVigente: $e');
      rethrow;
    }
  }

  Future<ListaVivenciaResponse> getLitaVivencia(
      int reg, String token, String idpsersona) async {
    try {
      if (token.isEmpty) {
        throw Exception('Token vacío');
      }

      final response = await ApiService.get()
          .header("Authorization", "Bearer $token")
          .end('/Apostilla/vivencia/lista/$reg/$idpsersona')
          .runAsync<Map<String, dynamic>>()
          .timeout(_timeout, onTimeout: () {
        throw Exception('Timeout: La solicitud de vivencias tardó demasiado');
      });

      if (response.data != null) {
        final jsonData = response.data!;
        return ListaVivenciaResponse.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print('Error en getLitaVivencia: $e');
      rethrow;
    }
  }

  Future<ModelResponseAuth> validaImagen(String ci, String password) async {
    try {
      final response = await ApiService.post()
          .end('/Apostilla/vivencia/auth')
          .body({
            'ci': ci,
            'password': password,
          })
          .runAsync<Map<String, dynamic>>()
          .timeout(_timeout, onTimeout: () {
            throw Exception('Timeout: La validación tardó demasiado');
          });

      if (response.data != null) {
        final jsonData = response.data!;
        return ModelResponseAuth.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print('Error en validaImagen: $e');
      throw Exception('Error en validación: $e');
    }
  }
}
