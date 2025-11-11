import 'dart:io';
import 'dart:async';

/// Servicio simple para verificar conectividad
class ConnectivityService {
  /// Verifica si hay conexión a internet
  static Future<bool> hasInternetConnection() async {
    try {
      // Intentar conectar con el servidor de la aplicación primero
      final result =
          await InternetAddress.lookup('servicios.cancilleria.gob.bo')
              .timeout(const Duration(seconds: 10));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      print('Error al conectar con servidor principal: $e');
    }

    try {
      // Fallback a Google DNS como segunda opción
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      print('Error al conectar con servidor de respaldo: $e');
    }

    return false;
  }

  /// Verifica conectividad específica con el servidor de la app
  static Future<bool> canReachAppServer() async {
    try {
      final result =
          await InternetAddress.lookup('servicios.cancilleria.gob.bo')
              .timeout(const Duration(seconds: 15));

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      print('No se puede conectar con el servidor de la app: $e');
      return false;
    }
  }

  /// Realiza un test de conectividad más robusto
  static Future<ConnectivityResult> checkConnectivityStatus() async {
    try {
      // Primero verificar conectividad general
      final hasInternet = await hasInternetConnection();
      if (!hasInternet) {
        return ConnectivityResult.noConnection;
      }

      // Verificar conectividad específica con el servidor de la app
      final canReachServer = await canReachAppServer();
      if (!canReachServer) {
        return ConnectivityResult.internetButNoServer;
      }

      return ConnectivityResult.fullConnectivity;
    } catch (e) {
      print('Error en verificación de conectividad: $e');
      return ConnectivityResult.noConnection;
    }
  }
}

/// Enum para representar los diferentes estados de conectividad
enum ConnectivityResult {
  /// Sin conexión a internet
  noConnection,

  /// Hay internet pero no se puede conectar con el servidor de la app
  internetButNoServer,

  /// Conectividad completa
  fullConnectivity,
}

/// Extensión para obtener descripciones legibles
extension ConnectivityResultDescription on ConnectivityResult {
  String get description {
    switch (this) {
      case ConnectivityResult.noConnection:
        return 'Sin conexión a internet';
      case ConnectivityResult.internetButNoServer:
        return 'Internet disponible, servidor no accesible';
      case ConnectivityResult.fullConnectivity:
        return 'Conectividad completa';
    }
  }

  bool get hasInternet {
    return this != ConnectivityResult.noConnection;
  }

  bool get canUseOnlineServices {
    return this == ConnectivityResult.fullConnectivity;
  }
}
