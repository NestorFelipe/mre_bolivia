import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Modelo de respuesta estándar para el API service
class ApiResponse<T> {
  final T? data;
  final int estado;
  final String mensaje;
  final bool success;

  ApiResponse({
    this.data,
    required this.estado,
    required this.mensaje,
    required this.success,
  });

  factory ApiResponse.success({
    T? data,
    String mensaje = 'Operación exitosa',
  }) {
    return ApiResponse<T>(
      data: data,
      estado: 200,
      mensaje: mensaje,
      success: true,
    );
  }

  factory ApiResponse.error({
    required int estado,
    required String mensaje,
  }) {
    return ApiResponse<T>(
      data: null,
      estado: estado,
      mensaje: mensaje,
      success: false,
    );
  }
}

/// Clase principal del API service con patrón builder
class ApiService {
  // static const String _baseUrl = 'http://localhost:7050/api';

  static const String _baseUrl =
      'https://servicios.cancilleria.gob.bo/app-movil/api';

  static final Map<String, String> _globalHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'User-Agent': 'Mobile-App-MiCancilleria-Bolivia'
  };

  // Cliente HTTP personalizado para manejar certificados
  static http.Client? _httpClient;

  /// Inicializar cliente HTTP con configuración SSL personalizada
  static void _initializeHttpClient() {
    if (_httpClient == null) {
      final client = HttpClient();

      // Configurar timeouts para mejor rendimiento en móviles
      client.connectionTimeout = const Duration(seconds: 15);
      client.idleTimeout = const Duration(seconds: 30);

      // Configurar para ignorar errores de certificado (solo para desarrollo/testing)
      // En producción, considerar validar certificados específicos del dominio
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        // Validar solo para el dominio específico de la aplicación
        if (host == 'servicios.cancilleria.gob.bo' ||
            host == 'servicios.rree.gob.bo') {
          return true;
        }
        return false;
      };

      // Configurar User-Agent específico para móviles
      client.userAgent = 'MiCancilleria-Flutter-App/1.0';

      _httpClient = IOClient(client);
    }
  }

  /// Método para obtener el cliente HTTP configurado
  static http.Client _getHttpClient() {
    _initializeHttpClient();
    return _httpClient!;
  }

  /// Método para cerrar el cliente HTTP
  static void dispose() {
    _httpClient?.close();
    _httpClient = null;
  }

  /// Método estático para inicializar el builder
  static ApiRequestBuilder get() {
    return ApiRequestBuilder._();
  }

  /// Método para configurar headers globales
  static void setGlobalHeader(String key, String value) {
    _globalHeaders[key] = value;
  }

  /// Método para remover un header global
  static void removeGlobalHeader(String key) {
    _globalHeaders.remove(key);
  }

  /// Método para obtener todos los headers globales
  static Map<String, String> getGlobalHeaders() {
    return Map.from(_globalHeaders);
  }
}

/// Builder para construir requests
class ApiRequestBuilder {
  String? _endpoint;
  String? _customBaseUrl;
  final Map<String, String> _headers = {};
  final Map<String, dynamic> _queryParams = {};

  ApiRequestBuilder._();

  /// Define el endpoint para la request
  ApiRequestBuilder end(String endpoint) {
    _endpoint = endpoint;
    return this;
  }

  /// Define una URL base personalizada (opcional)
  ApiRequestBuilder baseUrl(String url) {
    _customBaseUrl = url;
    return this;
  }

  /// Agrega headers específicos para esta request
  ApiRequestBuilder headers(Map<String, String> headers) {
    _headers.addAll(headers);
    return this;
  }

  /// Agrega un header específico
  ApiRequestBuilder header(String key, String value) {
    _headers[key] = value;
    return this;
  }

  /// Agrega parámetros de consulta
  ApiRequestBuilder queryParams(Map<String, dynamic> params) {
    _queryParams.addAll(params);
    return this;
  }

  /// Agrega un parámetro de consulta específico
  ApiRequestBuilder queryParam(String key, dynamic value) {
    _queryParams[key] = value;
    return this;
  }

  /// Ejecuta la request GET de manera asíncrona
  Future<ApiResponse<T>> runAsync<T>({
    T Function(dynamic)? parser,
  }) async {
    return _executeRequest<T>('GET', parser: parser);
  }

  /// Ejecuta la request POST de manera asíncrona
  Future<ApiResponse<T>> postAsync<T>(
    Map<String, dynamic> body, {
    T Function(dynamic)? parser,
  }) async {
    return _executeRequest<T>('POST', body: body, parser: parser);
  }

  /// Ejecuta la request PUT de manera asíncrona
  Future<ApiResponse<T>> putAsync<T>(
    Map<String, dynamic> body, {
    T Function(dynamic)? parser,
  }) async {
    return _executeRequest<T>('PUT', body: body, parser: parser);
  }

  /// Ejecuta la request DELETE de manera asíncrona
  Future<ApiResponse<T>> deleteAsync<T>({
    T Function(dynamic)? parser,
  }) async {
    return _executeRequest<T>('DELETE', parser: parser);
  }

  /// Método privado para ejecutar requests HTTP
  Future<ApiResponse<T>> _executeRequest<T>(
    String method, {
    Map<String, dynamic>? body,
    T Function(dynamic)? parser,
  }) async {
    if (_endpoint == null) {
      return ApiResponse<T>.error(
        estado: 400,
        mensaje: 'Endpoint no definido',
      );
    }

    try {
      // Construir URL
      final baseUrl = _customBaseUrl ?? ApiService._baseUrl;
      final uri = Uri.parse('$baseUrl$_endpoint');

      // Agregar query parameters si existen
      final finalUri = _queryParams.isNotEmpty
          ? uri.replace(
              queryParameters:
                  _queryParams.map((k, v) => MapEntry(k, v.toString())))
          : uri;

      // Combinar headers globales con headers específicos
      final combinedHeaders = <String, String>{}
        ..addAll(ApiService._globalHeaders)
        ..addAll(_headers);

      // Usar el cliente HTTP personalizado
      final client = ApiService._getHttpClient();

      // Ejecutar request según el método
      http.Response response;
      switch (method) {
        case 'POST':
          response = await client.post(
            finalUri,
            headers: combinedHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await client.put(
            finalUri,
            headers: combinedHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await client.delete(
            finalUri,
            headers: combinedHeaders,
          );
          break;
        case 'GET':
        default:
          response = await client.get(
            finalUri,
            headers: combinedHeaders,
          );
          break;
      }

      // Procesar respuesta
      return _processResponse<T>(response, parser);
    } on SocketException {
      return ApiResponse<T>.error(
        estado: 500,
        mensaje: 'Sin conexión a internet. Verifica tu conexión de red.',
      );
    } on HandshakeException {
      return ApiResponse<T>.error(
        estado: 500,
        mensaje: 'Error de certificado SSL. Contacta al administrador.',
      );
    } on HttpException catch (e) {
      return ApiResponse<T>.error(
        estado: 500,
        mensaje: 'Error HTTP: ${e.message}',
      );
    } catch (e) {
      return ApiResponse<T>.error(
        estado: 500,
        mensaje: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Procesa la respuesta HTTP
  ApiResponse<T> _processResponse<T>(
    http.Response response,
    T Function(dynamic)? parser,
  ) {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Respuesta exitosa
        final dynamic jsonData = json.decode(response.body);

        T? parsedData;
        if (parser != null) {
          parsedData = parser(jsonData);
        } else if (T == String) {
          parsedData = response.body as T;
        } else {
          parsedData = jsonData as T?;
        }

        return ApiResponse<T>.success(
          data: parsedData,
          mensaje: 'Operación exitosa',
        );
      } else {
        // Error del servidor
        String mensaje = 'Error del servidor';

        try {
          final errorData = json.decode(response.body);
          if (errorData is Map && errorData.containsKey('mensaje')) {
            mensaje = errorData['mensaje'].toString();
          } else if (errorData is Map && errorData.containsKey('message')) {
            mensaje = errorData['message'].toString();
          }
        } catch (e) {
          // Si no se puede parsear el error, usar el mensaje por defecto
          mensaje = 'Error ${response.statusCode}: ${response.reasonPhrase}';
        }

        return ApiResponse<T>.error(
          estado: response.statusCode,
          mensaje: mensaje,
        );
      }
    } catch (e) {
      return ApiResponse<T>.error(
        estado: 500,
        mensaje: 'Error al procesar la respuesta: ${e.toString()}',
      );
    }
  }
}
