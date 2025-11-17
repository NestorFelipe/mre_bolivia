import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mre_bolivia/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/consulado/splash_image_controller.dart';
import '../../services/offline_data_service.dart';
import '../../services/connectivity_service.dart';
import '../../controllers/consulado/consulado_controller.dart';

class SplashImageScreen extends StatefulWidget {
  const SplashImageScreen({super.key});

  @override
  State<SplashImageScreen> createState() => _SplashImageScreenState();
}

class _SplashImageScreenState extends State<SplashImageScreen>
    with TickerProviderStateMixin {
  late SplashImageController controller;
  late AnimationController _typewriterController;
  late AnimationController _explosionController;
  late Animation<int> _firstLineAnimation;
  late Animation<int> _secondLineAnimation;
  late Animation<double> _explosionAnimation;

  final String _firstLine = 'Ministerio de Relaciones';
  final String _secondLinePart1 = 'Exteriores de ';
  final String _secondLinePart2 = 'BOLIVIA';

  @override
  void initState() {
    super.initState();
    controller = Get.put(SplashImageController());

    // Configurar animación de máquina de escribir
    _typewriterController = AnimationController(
      duration: const Duration(milliseconds: 3000), // 3 segundos total
      vsync: this,
    );

    // Configurar animación de explosión
    _explosionController = AnimationController(
      duration: const Duration(milliseconds: 1800), // Más lenta: 1.8 segundos
      vsync: this,
    );

    // Primera línea: aparece del 0% al 50% de la animación
    _firstLineAnimation = IntTween(
      begin: 0,
      end: _firstLine.length,
    ).animate(CurvedAnimation(
      parent: _typewriterController,
      curve: const Interval(0.0, 0.5, curve: Curves.linear),
    ));

    // Segunda línea: aparece del 50% al 100% de la animación
    _secondLineAnimation = IntTween(
      begin: 0,
      end: _secondLinePart1.length + _secondLinePart2.length,
    ).animate(CurvedAnimation(
      parent: _typewriterController,
      curve: const Interval(0.5, 1.0, curve: Curves.linear),
    ));

    // Animación de brillo (de izquierda a derecha)
    _explosionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _explosionController,
      curve: Curves.easeOut, // Curva más suave para efecto solar
    ));

    // Inicializar el controlador del splash correctamente
    controller.initialize(this);

    // Iniciar animaciones inmediatamente para el splash
    _startSplashAnimations();
  }

  void _startSplashAnimations() {
    // Iniciar texto después de 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _typewriterController.forward();

        // Iniciar el efecto solar después de que termine la animación de texto
        Future.delayed(const Duration(milliseconds: 3000), () {
          // 3 segundos para que termine el texto
          if (mounted) {
            _explosionController.repeat(
                period: const Duration(milliseconds: 4000));
          }
        });

        // Iniciar carga de datos offline después de 2 segundos (mientras se muestran las animaciones)
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted) {
            _loadOfflineDataIfNeeded();
          }
        });
      }
    });
  }

  // Función simple para manejar datos offline sin controladores complicados
  void _loadOfflineDataIfNeeded() async {
    try {
      final isFirstLaunch = await OfflineDataService.isFirstLaunch();

      if (isFirstLaunch) {
        // Primera vez - necesita conexión
        final hasInternet = await ConnectivityService.hasInternetConnection();
        if (hasInternet) {
          // Cargar datos del servidor usando el controlador existente en segundo plano
          try {
            final consuladoController = Get.find<ConsuladoController>();
            await consuladoController.loadConsultadoData();
            await consuladoController.loadTramiteServiciosData();

            // IMPORTANTE: Guardar los datos en cache después de cargarlos
            await _saveDataToCache(consuladoController);
            await OfflineDataService.markAsLaunched();

            print('✅ Datos cargados del servidor y guardados en cache');
          } catch (e) {
            print('Error cargando datos: $e');
          }
        } else {
          print('❌ Sin internet en primer lanzamiento');
        }
      } else {
        // No es primer lanzamiento - verificar si hay datos en cache
        final hasCachedData = await OfflineDataService.hasCriticalDataOffline();
        if (!hasCachedData) {
          // No hay cache, intentar cargar desde servidor
          final hasInternet = await ConnectivityService.hasInternetConnection();
          if (hasInternet) {
            try {
              final consuladoController = Get.find<ConsuladoController>();
              await consuladoController.loadConsultadoData();
              await consuladoController.loadTramiteServiciosData();
              await _saveDataToCache(consuladoController);
              print('✅ Datos recargados desde servidor y guardados en cache');
            } catch (e) {
              print('Error recargando datos: $e');
            }
          } else {
            print('❌ Sin internet y sin cache disponible');
          }
        } else {
          print('✅ Datos disponibles en cache, cargando desde cache...');
          await _loadDataFromCache();
        }
      }

      // NO hacer nada más - dejar que el splash original maneje su propia navegación
    } catch (e) {
      print('Error en carga offline: $e');
      // No hacer nada - continuar con flujo normal
    }
  }

  // Guardar datos en cache
  Future<void> _saveDataToCache(ConsuladoController consuladoController) async {
    try {
      // Guardar datos del consulado (regiones)
      if (consuladoController.consultadoData != null) {
        final consultadoMap = {
          'regiones': consuladoController.consultadoData,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };
        await OfflineDataService.saveConsultadoData(consultadoMap);
      }

      // Guardar regiones por separado
      if (consuladoController.consultadoData != null) {
        await OfflineDataService.saveRegionesData(
            consuladoController.consultadoData!);
      }

      // Guardar servicios de tramites
      if (consuladoController.tramiteServicios.isNotEmpty) {
        final tramitesData = consuladoController.tramiteServicios
            .map((tramite) => {
                  'id': tramite.id,
                  'nombre': tramite.nombre,
                  'descripcion': tramite.descripcion,
                  'entidadNombre': tramite.entidadNombre,
                  'precio': tramite.precio,
                  'url': tramite.url,
                  // Agregar otros campos necesarios
                })
            .toList();
        await OfflineDataService.saveTramiteServiciosData(tramitesData);
      }

      print('✅ Todos los datos guardados en cache exitosamente');
    } catch (e) {
      print('❌ Error guardando datos en cache: $e');
    }
  }

  // Cargar datos desde cache
  Future<void> _loadDataFromCache() async {
    try {
      final consuladoController = Get.find<ConsuladoController>();

      // Cargar datos del consulado desde cache usando el controlador
      await consuladoController.loadConsultadoDataFromCache();

      // Cargar servicios de tramites desde cache usando el controlador
      await consuladoController.loadTramiteServiciosFromCache();

      print('✅ Todos los datos cargados desde cache al controlador');
    } catch (e) {
      print('❌ Error cargando datos desde cache: $e');
    }
  }

  @override
  void dispose() {
    _typewriterController.dispose();
    _explosionController.dispose();
    Get.delete<SplashImageController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      backgroundColor: fondoGris,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Logo centrado
            Transform.scale(
              scale: 0.75,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackLogo();
                },
              ),
            ),
            // Efecto de explosión detrás del escudo
            AnimatedBuilder(
              animation: _explosionAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(200,
                      200), // Área más pequeña: 200x200 en lugar de 300x300
                  painter: ExplosionPainter(
                    progress: _explosionAnimation.value,
                  ),
                );
              },
            ),
            // Escudo encima del efecto de explosión
            Transform.scale(
              scale: 0.75,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackLogo();
                },
              ),
            ),
            // Texto posicionado exactamente debajo del escudo
            Positioned(
              top: 250, // Posición desde arriba para que sea visible
              child: AnimatedBuilder(
                animation: _typewriterController,
                builder: (context, child) {
                  return Column(
                    children: [
                      // Primera línea con efecto de máquina de escribir
                      Text(
                        _firstLine.substring(0, _firstLineAnimation.value),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                          letterSpacing: 0.1,
                        ),
                      ),
                      // Segunda línea con efecto de máquina de escribir
                      _buildSecondLine(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondLine() {
    final currentLength = _secondLineAnimation.value;

    if (currentLength == 0) {
      return const SizedBox(height: 12); // Mantener espacio para la línea
    }

    String displayText1 = '';
    String displayText2 = '';

    if (currentLength <= _secondLinePart1.length) {
      // Mostrando solo la primera parte
      displayText1 = _secondLinePart1.substring(0, currentLength);
    } else {
      // Mostrando primera parte completa + parte de la segunda
      displayText1 = _secondLinePart1;
      displayText2 = _secondLinePart2.substring(
          0, currentLength - _secondLinePart1.length);
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: displayText1,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
          if (displayText2.isNotEmpty)
            TextSpan(
              text: displayText2,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackLogo() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.flag,
          size: 80,
          color: Colors.black54,
        ),
        SizedBox(height: 16),
        Text(
          'BOLIVIA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'MINISTERIO DE\nRELACIONES EXTERIORES',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}

// Clase para crear el efecto de sol brillante desde el centro hacia afuera
class ExplosionPainter extends CustomPainter {
  final double progress;

  ExplosionPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.2; // Más pequeño: 20% en lugar de 30%

    // Crear efecto de resplandor solar con círculos suaves
    for (int i = 0; i < 3; i++) {
      // Menos círculos para efecto más sutil
      final delay = i * 0.15; // Mayor delay entre círculos
      final adjustedProgress = (progress - delay).clamp(0.0, 1.0);

      if (adjustedProgress > 0) {
        final currentRadius = maxRadius * adjustedProgress;
        final opacity = (1.0 - adjustedProgress) *
            0.5; // Mucho más intenso: 0.5 en lugar de 0.25

        // Colores de sol mucho más brillantes e intensos
        Color sunColor;
        if (i == 0) {
          sunColor = Colors.amber.shade600; // Centro mucho más dorado e intenso
        } else if (i == 1) {
          sunColor = Colors.yellow.shade800; // Medio amarillo muy vibrante
        } else {
          sunColor = Colors.orange.shade600; // Exterior mucho más intenso
        }

        final paint = Paint()
          ..color = sunColor.withOpacity(opacity)
          ..style = PaintingStyle
              .fill // Fill en lugar de stroke para efecto más suave
          ..maskFilter =
              const MaskFilter.blur(BlurStyle.normal, 3.0); // Efecto blur suave

        canvas.drawCircle(center, currentRadius, paint);
      }
    }

    // Añadir rayos de fuego sutiles (menos partículas, más como rayos)
    final rayCount = 8; // Menos rayos para efecto más elegante
    for (int i = 0; i < rayCount; i++) {
      final angle = (i * 2 * pi) / rayCount;
      final rayLength = maxRadius * progress * 0.6;
      final opacity =
          (1.0 - progress) * 0.6; // Mucho más intenso: 0.6 en lugar de 0.35

      if (opacity > 0) {
        final startX = center.dx + cos(angle) * (maxRadius * 0.2);
        final startY = center.dy + sin(angle) * (maxRadius * 0.2);
        final endX = center.dx + cos(angle) * (maxRadius * 0.2 + rayLength);
        final endY = center.dy + sin(angle) * (maxRadius * 0.2 + rayLength);

        // Rayos de sol mucho más brillantes e intensos
        Color rayColor =
            i % 2 == 0 ? Colors.amber.shade700 : Colors.yellow.shade900;

        final paint = Paint()
          ..color = rayColor.withOpacity(opacity)
          ..strokeWidth = 3.0 // Más grueso: 3.0 en lugar de 2.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      }
    }

    // Añadir un resplandor central muy sutil de color fuego
    if (progress > 0) {
      final centralOpacity = (sin(progress * pi) * 0.35)
          .clamp(0.0, 0.35); // Mucho más intenso: 0.35 en lugar de 0.18
      final centralPaint = Paint()
        ..color = Colors.amber.shade400
            .withOpacity(centralOpacity) // Núcleo dorado mucho más brillante
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

      canvas.drawCircle(center, maxRadius * 0.3, centralPaint);
    }

    // Añadir destellos dorados de esperanza (muy pequeños)
    final sparkleCount = 16; // Número de destellos dorados
    for (int i = 0; i < sparkleCount; i++) {
      final angle =
          (i * 2 * pi) / sparkleCount + (progress * 0.5); // Rotación sutil
      final sparkleDistance =
          maxRadius * (0.7 + progress * 0.3); // Distancia variable
      final sparkleOpacity = (sin(progress * pi) * 0.7)
          .clamp(0.0, 0.7); // Mucho más brillante: 0.7

      if (sparkleOpacity > 0) {
        final sparkleX = center.dx + cos(angle) * sparkleDistance;
        final sparkleY = center.dy + sin(angle) * sparkleDistance;

        // Colores dorados mucho más intensos
        final sparkleColors = [
          Colors.amber.shade700, // Dorado muy intenso
          Colors.yellow.shade800, // Amarillo muy vibrante
          Colors.orange.shade600, // Naranja intenso
          Colors.amber.shade600 // Dorado intenso
        ];
        final sparkleColor = sparkleColors[i % sparkleColors.length];

        final sparklePaint = Paint()
          ..color = sparkleColor.withOpacity(sparkleOpacity)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);

        // Destellos de diferentes tamaños que irradían esperanza
        final sparkleSize = 1.0 + (sin(progress * pi * 3 + i) * 0.5).abs();
        canvas.drawCircle(
            Offset(sparkleX, sparkleY), sparkleSize, sparklePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
