import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para manejar caché offline de datos críticos
class OfflineDataService {
  static const String _prefPrefix = "offline_cache_";

  // Claves para datos críticos
  static const String _consultadoDataKey = "${_prefPrefix}consulado_data";
  static const String _regionesDataKey = "${_prefPrefix}regiones_data";
  static const String _tramiteServiciosKey = "${_prefPrefix}tramite_servicios";
  static const String _isFirstLaunchKey = "${_prefPrefix}is_first_launch";
  static const String _lastUpdateKey = "${_prefPrefix}last_update";
  static const String _dataVersionKey = "${_prefPrefix}data_version";

  // Versión de datos para invalidar caché cuando sea necesario
  static const String _currentDataVersion = "1.0.0";

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  /// Verifica si es el primer lanzamiento de la app
  static Future<bool> isFirstLaunch() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_isFirstLaunchKey) ?? true;
  }

  /// Marca que la app ya no es el primer lanzamiento
  static Future<void> markAsLaunched() async {
    final prefs = await _getPrefs();
    await prefs.setBool(_isFirstLaunchKey, false);
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  /// Verifica si los datos críticos están disponibles offline
  static Future<bool> hasCriticalDataOffline() async {
    final prefs = await _getPrefs();

    // Verificar versión de datos
    final cachedVersion = prefs.getString(_dataVersionKey) ?? "";
    if (cachedVersion != _currentDataVersion) {
      return false;
    }

    // Verificar que todos los datos críticos estén presentes
    final consultadoData = prefs.getString(_consultadoDataKey);
    final regionesData = prefs.getString(_regionesDataKey);
    final tramiteServicios = prefs.getString(_tramiteServiciosKey);

    return consultadoData != null &&
        regionesData != null &&
        tramiteServicios != null &&
        consultadoData.isNotEmpty &&
        regionesData.isNotEmpty &&
        tramiteServicios.isNotEmpty;
  }

  /// Guarda datos del consulado en caché
  static Future<void> saveConsultadoData(Map<String, dynamic> data) async {
    final prefs = await _getPrefs();
    final jsonString = json.encode(data);
    await prefs.setString(_consultadoDataKey, jsonString);
    await prefs.setString(_dataVersionKey, _currentDataVersion);
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  /// Recupera datos del consulado desde caché
  static Future<Map<String, dynamic>?> getConsultadoData() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_consultadoDataKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        return json.decode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        print('Error al decodificar datos del consulado: $e');
        return null;
      }
    }
    return null;
  }

  /// Guarda datos de regiones en caché
  static Future<void> saveRegionesData(List<dynamic> data) async {
    final prefs = await _getPrefs();
    final jsonString = json.encode(data);
    await prefs.setString(_regionesDataKey, jsonString);
    await prefs.setString(_dataVersionKey, _currentDataVersion);
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  /// Recupera datos de regiones desde caché
  static Future<List<dynamic>?> getRegionesData() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_regionesDataKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        return json.decode(jsonString) as List<dynamic>;
      } catch (e) {
        print('Error al decodificar datos de regiones: $e');
        return null;
      }
    }
    return null;
  }

  /// Guarda datos de trámites y servicios en caché
  static Future<void> saveTramiteServiciosData(List<dynamic> data) async {
    final prefs = await _getPrefs();
    final jsonString = json.encode(data);
    await prefs.setString(_tramiteServiciosKey, jsonString);
    await prefs.setString(_dataVersionKey, _currentDataVersion);
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  /// Recupera datos de trámites y servicios desde caché
  static Future<List<dynamic>?> getTramiteServiciosData() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_tramiteServiciosKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        return json.decode(jsonString) as List<dynamic>;
      } catch (e) {
        print('Error al decodificar datos de trámites: $e');
        return null;
      }
    }
    return null;
  }

  /// Obtiene la fecha de la última actualización
  static Future<DateTime?> getLastUpdateDate() async {
    final prefs = await _getPrefs();
    final dateString = prefs.getString(_lastUpdateKey);
    if (dateString != null && dateString.isNotEmpty) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Limpia todos los datos en caché
  static Future<void> clearOfflineData() async {
    final prefs = await _getPrefs();
    await prefs.remove(_consultadoDataKey);
    await prefs.remove(_regionesDataKey);
    await prefs.remove(_tramiteServiciosKey);
    await prefs.remove(_dataVersionKey);
    await prefs.remove(_lastUpdateKey);
    // Nota: No limpiar _isFirstLaunchKey para mantener el estado
  }

  /// Verifica si los datos en caché son antiguos (más de 24 horas)
  static Future<bool> isCacheStale() async {
    final lastUpdate = await getLastUpdateDate();
    if (lastUpdate == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastUpdate);

    // Considerar datos antiguos después de 24 horas
    return difference.inHours > 24;
  }

  /// Obtiene estadísticas del caché para debugging
  static Future<Map<String, dynamic>> getCacheStats() async {
    final hasData = await hasCriticalDataOffline();
    final isFirst = await isFirstLaunch();
    final lastUpdate = await getLastUpdateDate();
    final isStale = await isCacheStale();

    return {
      'hasCriticalData': hasData,
      'isFirstLaunch': isFirst,
      'lastUpdate': lastUpdate?.toIso8601String(),
      'isCacheStale': isStale,
      'dataVersion': _currentDataVersion,
    };
  }
}
