import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:audioplayers/audioplayers.dart';

// Modelo de resultado para el plugin
class LivenessResult {
  final Uint8List? frontImage;
  final bool success;
  final String? errorMessage;
  final Map<String, dynamic> validationData;

  LivenessResult({
    this.frontImage,
    required this.success,
    this.errorMessage,
    required this.validationData,
  });

  Map<String, dynamic> toJson() => {
        'success': success,
        'errorMessage': errorMessage,
        'validationData': validationData,
      };
}

// Configuración del plugin
class LivenessConfig {
  final int requiredBlinks;
  final int maxStepDurationSeconds;
  final int maxFailedAttempts;
  final double blinkThreshold;
  final double openEyeThreshold;
  final Function(LivenessResult)? onComplete;
  final Function(String)? onError;

  const LivenessConfig({
    this.requiredBlinks = 2,
    this.maxStepDurationSeconds = 25,
    this.maxFailedAttempts = 3,
    this.blinkThreshold = 0.2,
    this.openEyeThreshold = 0.8,
    this.onComplete,
    this.onError,
  });
}

class LivenessDetectionScreen extends StatefulWidget {
  final LivenessConfig config;

  const LivenessDetectionScreen({
    super.key,
    this.config = const LivenessConfig(),
  });

  @override
  // ignore: library_private_types_in_public_api
  _LivenessDetectionScreenState createState() =>
      _LivenessDetectionScreenState();
}

class _LivenessDetectionScreenState extends State<LivenessDetectionScreen> {
  CameraController? _cameraController;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableTracking: true,
      enableLandmarks: true,
      minFaceSize: 0.15,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  bool _isProcessing = false;
  String _instruction = "Preparando cámara...";
  int _step = 0;

  // Estados de validación mejorados
  bool _blinkDetected = false;
  bool _frontFaceDetected = false;
  bool _leftProfileDetected = false;
  bool _rightProfileDetected = false;

  // Sistema de parpadeo mejorado
  int _blinkCount = 0;
  late int _requiredBlinks;
  bool _eyesWereOpen = true;
  bool _eyesWereClosed = false;

  // Análisis de movimiento
  final List<double> _headYAngles = [];
  final List<double> _headXAngles = [];
  DateTime? _lastMovementCheck;

  // Timeouts y límites
  DateTime? _stepStartTime;
  int _failedAttempts = 0;
  late int _maxStepDuration;
  late int _maxFailedAttempts;

  // Debug y validación
  final Map<String, dynamic> _validationData = {
    'blinkCount': 0,
    'requiredBlinks': 0,
    'movementPattern': 'smooth',
    'attemptCount': 0,
    'timestamp': DateTime.now().toIso8601String(),
  };

  Uint8List? _capturedFrontImage;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Inicializar configuración
    _requiredBlinks = widget.config.requiredBlinks;
    _maxStepDuration = widget.config.maxStepDurationSeconds;
    _maxFailedAttempts = widget.config.maxFailedAttempts;
    _validationData['requiredBlinks'] = _requiredBlinks;
    // Activar wakelock para mantener pantalla activa
    WakelockPlus.enable();
    _initializeCamera();
  }

  Future<void> _playSuccessSound() async {
    try {
      // Reproducir archivo de audio beep.mp3
      await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
      // Vibración adicional
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Error reproduciendo sonido: $e');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => throw Exception('No se encontró cámara frontal'),
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: defaultTargetPlatform == TargetPlatform.android
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _instruction = "Parpadea $_requiredBlinks veces para comenzar";
          _stepStartTime = DateTime.now();
        });
        // Dar tiempo a que la cámara se estabilice
        await Future.delayed(const Duration(milliseconds: 800));
        _startDetection();
      }
    } catch (e) {
      _handleError('Error inicializando cámara: $e');
    }
  }

  void _handleError(String error) {
    debugPrint(error);
    widget.config.onError?.call(error);
    if (mounted) {
      setState(() {
        _instruction = "Error: $error";
      });
    }
  }

  void _startDetection() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      _handleError('Cámara no inicializada');
      return;
    }

    try {
      _cameraController!.startImageStream((CameraImage image) async {
        if (_isProcessing) return;
        _isProcessing = true;

        try {
          await _processImage(image);
        } catch (e) {
          debugPrint('Error procesando imagen: $e');
          // No detener el stream por un error de procesamiento
        }

        _isProcessing = false;
      });
    } catch (e) {
      _handleError('Error iniciando detección: $e');
    }
  }

  Future<void> _processImage(CameraImage image) async {
    final inputImage = _convertCameraImage(image);
    if (inputImage == null) {
      debugPrint('⚠️ No se pudo convertir imagen');
      return;
    }

    try {
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        if (mounted) {
          setState(() {
            _instruction = "No se detecta rostro. Acércate más a la cámara";
          });
        }
        return;
      }

      final face = faces.first;
      debugPrint('✅ Rostro detectado - Paso: $_step');

      // Solo verificar timeout DESPUÉS de detectar cara
      _checkTimeout();

      // Analizar patrón de movimiento
      _analyzeMovementPattern(face);

      // Paso 0: Detectar parpadeo múltiple
      if (_step == 0) {
        await _detectBlink(face);
      }
      // Paso 1: Detectar rostro de frente
      else if (_step == 1) {
        await _detectFrontFace(face);
      }
      // Paso 2: Detectar perfil derecho
      else if (_step == 2) {
        await _detectRightProfile(face);
      }
      // Paso 3: Detectar perfil izquierdo
      else if (_step == 3) {
        await _detectLeftProfile(face);
      }
      // Paso 4: Capturar foto final
      else if (_step == 4) {
        await _captureFinalPhoto(face);
      }
    } catch (e) {
      debugPrint('Error en detección de rostro: $e');
    }
  }

  void _checkTimeout() {
    if (_stepStartTime != null) {
      final elapsed = DateTime.now().difference(_stepStartTime!).inSeconds;
      // Aumentar tiempo de timeout para dar más margen
      if (elapsed > _maxStepDuration) {
        _failedAttempts++;
        _validationData['attemptCount'] = _failedAttempts;

        if (_failedAttempts >= _maxFailedAttempts) {
          _showFailureAndExit('Tiempo agotado. Demasiados intentos fallidos.');
        } else {
          _resetCurrentStep();
        }
      }
    }
  }

  void _analyzeMovementPattern(Face face) {
    final yAngle = face.headEulerAngleY ?? 0;
    final xAngle = face.headEulerAngleX ?? 0;

    _headYAngles.add(yAngle);
    _headXAngles.add(xAngle);

    // Mantener solo los últimos 15 frames
    if (_headYAngles.length > 15) {
      _headYAngles.removeAt(0);
      _headXAngles.removeAt(0);
    }

    // Verificar cada segundo
    final now = DateTime.now();
    if (_lastMovementCheck == null ||
        now.difference(_lastMovementCheck!).inSeconds >= 1) {
      _lastMovementCheck = now;

      if (_headYAngles.length >= 10) {
        // Detectar saltos bruscos (posible video/foto)
        double maxJump = 0;
        for (int i = 1; i < _headYAngles.length; i++) {
          final jump = (_headYAngles[i] - _headYAngles[i - 1]).abs();
          if (jump > maxJump) maxJump = jump;
        }

        // Si hay saltos muy bruscos (>30°), es sospechoso
        if (maxJump > 30) {
          _validationData['movementPattern'] = 'suspicious';
          debugPrint(
              '⚠️ Movimiento sospechoso detectado: salto de ${maxJump.toStringAsFixed(1)}°');
        } else {
          _validationData['movementPattern'] = 'smooth';
        }
      }
    }
  }

  void _resetCurrentStep() {
    if (mounted) {
      setState(() {
        _instruction = "Tiempo agotado. Intenta de nuevo...";
        _stepStartTime = DateTime.now();
      });
    }
  }

  void _showFailureAndExit(String reason) async {
    final result = LivenessResult(
      success: false,
      errorMessage: reason,
      validationData: _validationData,
    );

    widget.config.onComplete?.call(result);

    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  Future<void> _detectBlink(Face face) async {
    final leftEyeOpen = face.leftEyeOpenProbability;
    final rightEyeOpen = face.rightEyeOpenProbability;

    // Verificar que tengamos datos de probabilidad de ojos
    if (leftEyeOpen == null || rightEyeOpen == null) {
      debugPrint('⚠️ No hay datos de probabilidad de ojos');
      if (mounted) {
        setState(() {
          _instruction =
              "Ajustando detección... Asegúrate de estar bien iluminado";
        });
      }
      return;
    }

    final eyesClosed = leftEyeOpen < widget.config.blinkThreshold &&
        rightEyeOpen < widget.config.blinkThreshold;
    final eyesOpen = leftEyeOpen > widget.config.openEyeThreshold &&
        rightEyeOpen > widget.config.openEyeThreshold;

    debugPrint(
        '👁️ Ojos: L=${leftEyeOpen.toStringAsFixed(2)}, R=${rightEyeOpen.toStringAsFixed(2)}');

    // Detectar ciclo completo: abierto -> cerrado -> abierto
    if (_eyesWereOpen && eyesClosed && !_eyesWereClosed) {
      _eyesWereClosed = true;
      _eyesWereOpen = false;
      debugPrint('👁️ Ojos cerrados detectados');
    } else if (_eyesWereClosed && eyesOpen) {
      _blinkCount++;
      _eyesWereOpen = true;
      _eyesWereClosed = false;
      _validationData['blinkCount'] = _blinkCount;
      debugPrint('✅ Parpadeo #$_blinkCount detectado');

      // Sonido y vibración en cada parpadeo individual
      _audioPlayer.play(AssetSource('sounds/beep.mp3'));
      HapticFeedback.lightImpact();

      if (mounted) {
        setState(() {
          if (_blinkCount >= _requiredBlinks) {
            _blinkDetected = true;
            _instruction =
                "¡$_blinkCount parpadeos detectados! ✓\nAhora mantén tu rostro de frente";
            _step = 1;
            _stepStartTime = DateTime.now();
            _playSuccessSound();
          } else {
            _instruction =
                "Parpadeo $_blinkCount/$_requiredBlinks ✓\nParpadea ${_requiredBlinks - _blinkCount} vez más";
          }
        });
      }

      if (_blinkCount >= _requiredBlinks) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } else if (eyesOpen && !_eyesWereOpen && !_eyesWereClosed) {
      _eyesWereOpen = true;
    }

    if (!_blinkDetected && _blinkCount == 0 && mounted) {
      setState(() {
        _instruction =
            "Parpadea $_requiredBlinks veces para verificar que eres real";
      });
    }
  }

  Future<void> _detectFrontFace(Face face) async {
    final yAngle = face.headEulerAngleY ?? 0;
    final xAngle = face.headEulerAngleX ?? 0;

    // Rostro de frente: ángulos cerca de 0
    if (yAngle.abs() < 10 && xAngle.abs() < 10) {
      if (!_frontFaceDetected && mounted) {
        setState(() {
          _frontFaceDetected = true;
          _instruction =
              "¡Frente detectado! ✓\nAhora gira tu cabeza a la IZQUIERDA";
          _step = 2;
          _stepStartTime = DateTime.now();
        });
        _playSuccessSound();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } else if (mounted) {
      setState(() {
        _instruction = "Mantén tu rostro de frente mirando la cámara";
      });
    }
  }

  Future<void> _detectRightProfile(Face face) async {
    final yAngle = face.headEulerAngleY ?? 0;

    // Perfil derecho: ángulo Y positivo (>20°)
    if (yAngle > 20 && yAngle < 45) {
      if (!_rightProfileDetected && mounted) {
        setState(() {
          _rightProfileDetected = true;
          _instruction =
              "¡Perfil derecho detectado! ✓\nAhora gira tu cabeza a la DERECHA";
          _step = 3;
          _stepStartTime = DateTime.now();
        });
        _playSuccessSound();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } else if (mounted) {
      setState(() {
        _instruction = "Gira tu cabeza hacia la IZQUIERDA ←";
      });
    }
  }

  Future<void> _detectLeftProfile(Face face) async {
    final yAngle = face.headEulerAngleY ?? 0;

    // Perfil izquierdo: ángulo Y negativo (<-20°)
    if (yAngle < -20 && yAngle > -45) {
      if (!_leftProfileDetected && mounted) {
        setState(() {
          _leftProfileDetected = true;
          _instruction =
              "¡Perfil izquierdo detectado! ✓\nAhora regresa al frente para la foto final";
          _step = 4;
          _stepStartTime = DateTime.now();
        });
        _playSuccessSound();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } else if (mounted) {
      setState(() {
        _instruction = "Gira tu cabeza hacia la DERECHA →";
      });
    }
  }

  Future<void> _captureFinalPhoto(Face face) async {
    final yAngle = face.headEulerAngleY ?? 0;
    final xAngle = face.headEulerAngleX ?? 0;

    // Verificar que está de frente nuevamente
    if (yAngle.abs() < 10 && xAngle.abs() < 10) {
      if (mounted) {
        setState(() {
          _instruction = "¡Perfecto! Capturando foto...";
        });
      }

      try {
        // Detener el stream
        await _cameraController!.stopImageStream();

        // Tomar la foto final
        final XFile photo = await _cameraController!.takePicture();
        final bytes = await photo.readAsBytes();

        if (mounted) {
          setState(() {
            _capturedFrontImage = bytes;
            _instruction = "¡Verificación completada! ✓";
            _step = 5;
          });
        }

        // Completar validación
        _validationData['completedAt'] = DateTime.now().toIso8601String();
        final result = LivenessResult(
          frontImage: bytes,
          success: true,
          validationData: _validationData,
        );

        widget.config.onComplete?.call(result);

        // Cerrar pantalla automáticamente
        if (mounted) {
          Navigator.pop(context, result);
        }
      } catch (e) {
        _handleError('Error capturando foto: $e');
      }
    } else if (mounted) {
      setState(() {
        _instruction = "Regresa tu rostro al frente para la foto final";
      });
    }
  }

  InputImage? _convertCameraImage(CameraImage image) {
    try {
      final camera = _cameraController!.description;

      // Determinar la rotación correcta según la orientación del sensor
      final sensorOrientation = camera.sensorOrientation;
      final imageRotation =
          InputImageRotationValue.fromRawValue(sensorOrientation) ??
              InputImageRotation.rotation0deg;

      // Determinar el formato de imagen
      final inputImageFormat =
          InputImageFormatValue.fromRawValue(image.format.raw);

      if (inputImageFormat == null) {
        debugPrint('⚠️ Formato de imagen no soportado: ${image.format.raw}');
        return null;
      }

      // Concatenar los bytes de todos los planos
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final imageSize = Size(image.width.toDouble(), image.height.toDouble());

      final inputImageData = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.isNotEmpty
            ? image.planes.first.bytesPerRow
            : image.width,
      );

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: inputImageData,
      );

      return inputImage;
    } catch (e) {
      debugPrint('❌ Error convirtiendo imagen: $e');
      return null;
    }
  }

  @override
  void dispose() {
    try {
      _cameraController?.stopImageStream().catchError((e) {
        debugPrint('Error deteniendo stream: $e');
      });
      _cameraController?.dispose();
      _faceDetector.close();
      _audioPlayer.dispose();
      // Desactivar wakelock
      WakelockPlus.disable();
    } catch (e) {
      debugPrint('Error en dispose: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Inicializando cámara...',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  if (mounted) Navigator.pop(context);
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // Detener la cámara antes de salir
        try {
          await _cameraController?.stopImageStream().catchError((_) {});
        } catch (e) {
          debugPrint('Error deteniendo stream: $e');
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Vista de la cámara con aspect ratio correcto
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _cameraController!.value.previewSize!.height,
                  height: _cameraController!.value.previewSize!.width,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ),

            // Overlay con guía facial
            CustomPaint(
              painter: FaceGuidePainter(),
              child: Container(),
            ),

            // Instrucciones
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Text(
                  _instruction,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ),
            ),

            // Indicadores de progreso mejorados
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStepIndicator(
                        "Parpadeo", _blinkDetected, Icons.remove_red_eye),
                    _buildStepIndicator(
                        "Frente", _frontFaceDetected, Icons.face),
                    _buildStepIndicator(
                        "Derecha", _rightProfileDetected, Icons.arrow_forward),
                    _buildStepIndicator(
                        "Izquierda", _leftProfileDetected, Icons.arrow_back),
                  ],
                ),
              ),
            ),

            // Botón cancelar
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () {
                  final result = LivenessResult(
                    success: false,
                    errorMessage: 'Cancelado por el usuario',
                    validationData: _validationData,
                  );
                  Navigator.pop(context, result);
                },
              ),
            ),

            // Mostrar imagen capturada
            if (_capturedFrontImage != null)
              Positioned.fill(
                child: Container(
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          _capturedFrontImage!,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "¡Verificación completada!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Parpadeos: $_blinkCount | Movimiento: ${_validationData['movementPattern']}",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          final result = LivenessResult(
                            frontImage: _capturedFrontImage,
                            success: true,
                            validationData: _validationData,
                          );
                          Navigator.pop(context, result);
                        },
                        child: const Text(
                          "Continuar",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(String label, bool completed, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: completed ? Colors.green : Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Icon(
            completed ? Icons.check : icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: completed ? Colors.green : Colors.white70,
            fontSize: 11,
            fontWeight: completed ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// Painter para dibujar guía facial
class FaceGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Dibujar óvalo guía en el centro
    final center = Offset(size.width / 2, size.height / 2);
    final ovalRect = Rect.fromCenter(
      center: center,
      width: size.width * 0.6,
      height: size.height * 0.5,
    );

    canvas.drawOval(ovalRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
