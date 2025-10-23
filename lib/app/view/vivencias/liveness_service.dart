import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'liveness_detection_screen.dart';

/// Helper para integrar la detección de vivacidad con servicios externos
/// como Kairos, AWS Rekognition, Azure Face API, etc.

class LivenessService {
  /// Convierte la imagen a Base64 para envío a APIs
  static String imageToBase64(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }

  /// Prepara los datos para envío a Kairos Face Recognition
  static Map<String, dynamic> prepareKairosPayload({
    required LivenessResult result,
    required String subjectId,
    required String galleryName,
  }) {
    if (result.frontImage == null) {
      throw Exception('No hay imagen disponible');
    }

    return {
      'image': imageToBase64(result.frontImage!),
      'subject_id': subjectId,
      'gallery_name': galleryName,
      'validation_metadata': result.validationData,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Prepara los datos para envío a AWS Rekognition
  static Map<String, dynamic> prepareAWSPayload({
    required LivenessResult result,
    String? collectionId,
  }) {
    if (result.frontImage == null) {
      throw Exception('No hay imagen disponible');
    }

    return {
      'Image': {
        'Bytes': result.frontImage,
      },
      if (collectionId != null) 'CollectionId': collectionId,
      'Attributes': ['ALL'],
      'ValidationData': result.validationData,
    };
  }

  /// Prepara los datos para envío a Azure Face API
  static Map<String, dynamic> prepareAzurePayload({
    required LivenessResult result,
    List<String> returnFaceAttributes = const [
      'age',
      'gender',
      'headPose',
      'smile',
      'facialHair',
      'glasses',
      'emotion'
    ],
  }) {
    if (result.frontImage == null) {
      throw Exception('No hay imagen disponible');
    }

    return {
      'url': null, // Se envía como binary en el body
      'imageBytes': result.frontImage,
      'returnFaceAttributes': returnFaceAttributes.join(','),
      'validationData': result.validationData,
    };
  }

  /// Valida que el resultado sea exitoso y tenga todos los datos necesarios
  static bool validateResult(LivenessResult result) {
    if (!result.success) {
      debugPrint('❌ Validación fallida: ${result.errorMessage}');
      return false;
    }

    if (result.frontImage == null) {
      debugPrint('❌ No hay imagen capturada');
      return false;
    }

    final validationData = result.validationData;

    // Verificar que tenga todos los datos esperados
    final requiredKeys = [
      'blinkCount',
      'requiredBlinks',
      'movementPattern',
      'timestamp',
      'completedAt'
    ];

    for (var key in requiredKeys) {
      if (!validationData.containsKey(key)) {
        debugPrint('⚠️ Falta dato de validación: $key');
        return false;
      }
    }

    // Verificar que los parpadeos sean suficientes
    final blinkCount = validationData['blinkCount'] as int;
    final requiredBlinks = validationData['requiredBlinks'] as int;

    if (blinkCount < requiredBlinks) {
      debugPrint('⚠️ Parpadeos insuficientes: $blinkCount < $requiredBlinks');
      return false;
    }

    // Verificar que el patrón de movimiento sea normal
    if (validationData['movementPattern'] == 'suspicious') {
      debugPrint('⚠️ Patrón de movimiento sospechoso detectado');
      // Podrías retornar false aquí para ser más estricto
      // return false;
    }

    debugPrint('✅ Resultado validado exitosamente');
    return true;
  }

  /// Genera un ID único para el usuario
  static String generateSubjectId({String? prefix}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return '${prefix ?? 'user'}_${timestamp}_$random';
  }

  /// Calcula un score de confianza basado en los datos de validación
  static double calculateConfidenceScore(LivenessResult result) {
    if (!result.success) return 0.0;

    double score = 0.0;

    // Base score si completó todas las validaciones
    score += 40.0;

    // Score por parpadeos (máximo 30 puntos)
    final blinkCount = result.validationData['blinkCount'] as int? ?? 0;
    final requiredBlinks = result.validationData['requiredBlinks'] as int? ?? 2;

    if (blinkCount >= requiredBlinks) {
      score += 20.0;
      // Bonus si parpadeó más de lo requerido
      if (blinkCount > requiredBlinks) {
        score += 10.0;
      }
    } else {
      score += (blinkCount / requiredBlinks) * 20.0;
    }

    // Score por patrón de movimiento (máximo 30 puntos)
    final movementPattern =
        result.validationData['movementPattern'] as String? ?? 'suspicious';
    if (movementPattern == 'smooth') {
      score += 30.0;
    } else {
      score += 10.0; // Penalización por movimiento sospechoso
    }

    return score.clamp(0.0, 100.0);
  }

  /// Genera un reporte detallado de la validación
  static Map<String, dynamic> generateValidationReport(LivenessResult result) {
    return {
      'success': result.success,
      'errorMessage': result.errorMessage,
      'confidenceScore': calculateConfidenceScore(result),
      'validationData': result.validationData,
      'hasImage': result.frontImage != null,
      'imageSize': result.frontImage?.length ?? 0,
      'generatedAt': DateTime.now().toIso8601String(),
      'recommendations': _generateRecommendations(result),
    };
  }

  /// Genera recomendaciones basadas en el resultado
  static List<String> _generateRecommendations(LivenessResult result) {
    final recommendations = <String>[];

    if (!result.success) {
      recommendations.add('La verificación falló. Intenta nuevamente.');
      if (result.errorMessage != null) {
        recommendations.add('Razón: ${result.errorMessage}');
      }
      return recommendations;
    }

    final score = calculateConfidenceScore(result);

    if (score >= 90) {
      recommendations.add('✅ Excelente verificación. Alta confianza.');
    } else if (score >= 70) {
      recommendations.add('✅ Buena verificación. Confianza media-alta.');
    } else if (score >= 50) {
      recommendations
          .add('⚠️ Verificación aceptable. Considera verificación adicional.');
    } else {
      recommendations.add('❌ Baja confianza. Requiere reverificación.');
    }

    final movementPattern =
        result.validationData['movementPattern'] as String? ?? '';
    if (movementPattern == 'suspicious') {
      recommendations.add('⚠️ Se detectó patrón de movimiento sospechoso.');
      recommendations.add('Considera solicitar verificación adicional.');
    }

    final attemptCount = result.validationData['attemptCount'] as int? ?? 0;
    if (attemptCount > 1) {
      recommendations
          .add('⚠️ Usuario requirió múltiples intentos ($attemptCount).');
    }

    return recommendations;
  }

  /// Crea un objeto metadata completo para almacenar en base de datos
  static Map<String, dynamic> createMetadata({
    required LivenessResult result,
    String? userId,
    String? sessionId,
    Map<String, dynamic>? additionalData,
  }) {
    return {
      'userId': userId,
      'sessionId': sessionId ?? generateSubjectId(prefix: 'session'),
      'success': result.success,
      'errorMessage': result.errorMessage,
      'confidenceScore': calculateConfidenceScore(result),
      'validationData': result.validationData,
      'imageSize': result.frontImage?.length ?? 0,
      'createdAt': DateTime.now().toIso8601String(),
      'device': {
        'platform': defaultTargetPlatform.toString(),
      },
      if (additionalData != null) ...additionalData,
    };
  }
}

/// Ejemplo de uso:
/// 
/// ```dart
/// // Después de obtener el resultado
/// final result = await Navigator.push<LivenessResult>(...);
/// 
/// // Validar el resultado
/// if (LivenessService.validateResult(result!)) {
///   // Generar reporte
///   final report = LivenessService.generateValidationReport(result);
///   print('Confidence Score: ${report['confidenceScore']}');
///   
///   // Preparar para Kairos
///   final payload = LivenessService.prepareKairosPayload(
///     result: result,
///     subjectId: LivenessService.generateSubjectId(prefix: 'user'),
///     galleryName: 'my_gallery',
///   );
///   
///   // Enviar a API
///   await sendToAPI(payload);
/// }
/// ```
