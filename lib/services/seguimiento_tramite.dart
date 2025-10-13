import '../app/models/consulado/model_tipo_tramite.dart';
import '../app/models/consulado/model_tramite_asistenciaconsular.dart';
import '../app/models/consulado/model_tramite_passaportes.dart';
import '../app/models/consulado/model_tramite_poderes.dart';
import '../app/models/consulado/model_tramite_visas.dart';
import '../app/models/consulado/model_tramite_vivencias.dart';
import 'api_service.dart';

class SeguimientoTramiteService {
  /// Obtiene la información de seguimiento de un trámite basado en el tipo y ID
  Future<dynamic> obtenerSeguimientoTramite(
      String tipoTramite, String idTramite) async {
    try {
      final response = await ApiService.get()
          .end('/apostilla/seguimiento/tramite/$tipoTramite/$idTramite')
          .runAsync<Map<String, dynamic>>();

      if (response.success && response.data != null) {
        final jsonData = response.data!;

        // Parsear basado en el tipo de trámite
        switch (tipoTramite) {
          case '1': // Visas
            return TramiteVisasResponse.fromJson(jsonData);
          case '2': // Poderes
            return TramitePoderesResponse.fromJson(jsonData);
          case '3': // Pasaporte
            return TramitePassaportesResponse.fromJson(jsonData);
          case '4': // Vivencias
            return TramiteVivenciasResponse.fromJson(jsonData);
          case '5': // AsistenciaConsular
            return TramiteAsistenciaConsularResponse.fromJson(jsonData);
          default:
            throw Exception('Tipo de trámite no reconocido: $tipoTramite');
        }
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      throw Exception('Error al obtener seguimiento del trámite: $e');
    }
  }

  /// Obtiene los tipos de trámites
  Future<TipoTramiteResponse> obtenerTiposTramite() async {
    try {
      final response = await ApiService.get()
          .end('/apostilla/seguimiento/tipostramite')
          .runAsync<Map<String, dynamic>>();

      if (response.success && response.data != null) {
        final jsonData = response.data!;
        return TipoTramiteResponse.fromJson(jsonData);
      } else {
        throw Exception('${response.mensaje} (Estado: ${response.estado})');
      }
    } catch (e) {
      print(e);
      throw Exception('Error al obtener tipos de trámite: $e');
    }
  }
}
