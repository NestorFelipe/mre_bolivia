import 'package:get/get.dart';
import 'dart:io';
import 'dart:convert';
import '../app/models/model_consulado.dart';

class ConsultadoService extends GetConnect {
  static const String _baseUrlHttps = 'https://miconsulado.rree.gob.bo/components/com_cancilleria/json.php';
  static const String _baseUrlHttp = 'http://miconsulado.rree.gob.bo/components/com_cancilleria/json.php';

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = '';
    httpClient.timeout = const Duration(seconds: 30);
    
    // Configurar headers para aceptar JSON
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<void>((request) {
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['User-Agent'] = 'Flutter App';
      return request;
    });
  }

  /// Obtiene los datos del consulado desde la API con fallback HTTP
  Future<Response<ModelConsulado?>> getConsultadoData() async {
    // Primero intentar con HTTPS
    final httpsResult = await _makeRequest(_baseUrlHttps, 'HTTPS');
    if (httpsResult.statusCode == 200 && httpsResult.body != null) {
      return httpsResult;
    }

    print('🔄 HTTPS falló, intentando con HTTP...');
    
    // Si HTTPS falla, intentar con HTTP
    return await _makeRequest(_baseUrlHttp, 'HTTP');
  }

  /// Realiza la petición HTTP/HTTPS usando HttpClient nativo
  Future<Response<ModelConsulado?>> _makeRequest(String url, String protocol) async {
    try {
      print('📡 Iniciando llamada $protocol a: $url');
      
      // Crear HttpClient con configuración SSL personalizada
      final httpClient = HttpClient();
      
      if (protocol == 'HTTPS') {
        httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
          print('⚠️ Certificado SSL no válido para $host:$port - Permitiendo conexión');
          return true; // Permitir conexiones con certificados no válidos
        };
      }

      final uri = Uri.parse(url);
      final request = await httpClient.getUrl(uri);
      
      // Configurar headers
      request.headers.set('Accept', 'application/json');
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('User-Agent', 'Flutter App');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      httpClient.close();

      print('📊 Status Code ($protocol): ${response.statusCode}');
      print('📋 Status: ${response.reasonPhrase}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✅ Datos recibidos via $protocol, procesando JSON...');
        
        try {
          final jsonData = json.decode(responseBody);
          final consultadoData = ModelConsulado.fromJson(jsonData);
          print('✅ JSON procesado exitosamente');
          print('📈 Definiciones encontradas: ${consultadoData.definiciones.length}');
          
          return Response(
            statusCode: response.statusCode,
            statusText: 'OK',
            body: consultadoData,
          );
        } catch (e) {
          print('❌ Error al procesar JSON: $e');
          return Response(
            statusCode: 500,
            statusText: 'Error al procesar datos: $e',
            body: null,
          );
        }
      } else {
        print('❌ Error en la respuesta $protocol: ${response.statusCode} - ${response.reasonPhrase}');
        return Response(
          statusCode: response.statusCode,
          statusText: 'Error del servidor ($protocol): ${response.reasonPhrase}',
          body: null,
        );
      }
    } on HandshakeException catch (e) {
      print('🔒 Error de certificado SSL ($protocol): $e');
      return Response(
        statusCode: 500,
        statusText: 'Error de certificado SSL ($protocol): ${e.message}',
        body: null,
      );
    } on SocketException catch (e) {
      print('🌐 Error de conexión ($protocol): $e');
      return Response(
        statusCode: 500,
        statusText: 'Error de conexión ($protocol): Sin conexión a internet',
        body: null,
      );
    } catch (e) {
      print('💥 Error inesperado ($protocol): $e');
      return Response(
        statusCode: 500,
        statusText: 'Error inesperado ($protocol): $e',
        body: null,
      );
    }
  }
}