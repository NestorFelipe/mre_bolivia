import 'dart:async';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import '../../../app/routes/app_routes.dart';
import 'consulado_controller.dart';

class SplashController extends GetxController with WidgetsBindingObserver {
  // Observables para estado reactivo
  RxBool hasNavigated = false.obs;
  RxBool isAppReady = false.obs;
  RxBool isDisposed = false.obs;
  RxBool showVideo = false.obs;

  // Observables para APIs
  RxBool isLoadingConsulado = false.obs;
  RxBool consultadoLoaded = false.obs;
  RxBool isLoadingRegiones = false.obs;
  RxBool regionesLoaded = false.obs;
  RxBool allApisLoaded = false.obs;
  RxBool consuladoArancelLoaded = false.obs;

  // Controladores
  VideoPlayerController? videoController;
  Timer? navigationTimer;

  // Controladores de datos
  ConsuladoController? consultadoController;

  // Controladores de animación (se pasan desde el widget)
  AnimationController? fadeController;
  Animation<double>? fadeAnimation;

  // Servicio de consulado

  // Inicializar con TickerProvider
  void initialize(TickerProvider vsync) {
    WidgetsBinding.instance.addObserver(this);

    fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: fadeController!, curve: Curves.easeInOut),
    );

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('🚀 Iniciando aplicación...');

      await WidgetsBinding.instance.endOfFrame;
      await Future.delayed(const Duration(milliseconds: 100));

      if (!isDisposed.value) {
        // Inyectar controladores de datos
        _injectDataControllers();

        // Marcar app como lista inicialmente
        isAppReady.value = true;

        // Primero inicializar y reproducir el video
        await _initializeVideo();

        // Iniciar animación inmediatamente después del video
        _startFadeAnimation();

        // Cargar APIs en segundo plano sin bloquear el video
        _loadApisInBackground();

        // Setup del timer de navegación (aumentado para dar tiempo al video)
        _setupNavigationTimer();
      }
    } catch (e) {
      print('❌ Error durante la inicialización: $e');
      // Continuar con la navegación aunque haya errores
      if (!isDisposed.value) {
        isAppReady.value = true;
        _startFadeAnimation();
        _setupNavigationTimer();
      }
    }
  }

  void _startFadeAnimation() {
    if (fadeController != null && !isDisposed.value) {
      fadeController!.forward();
    }
  }

  void _setupNavigationTimer() {
    // Aumentar el tiempo para permitir que el video se reproduzca completamente
    navigationTimer = Timer(const Duration(seconds: 8), () {
      if (!hasNavigated.value) {
        print('⏰ Timer de navegación activado');
        _navigateToNext();
      }
    });
  }

  /// Cargar APIs en segundo plano sin interferir con el video
  void _loadApisInBackground() {
    // Cargar APIs sin esperar y sin bloquear la UI
    Future(() async {
      final futures = [
        _loadRegionesData(),
        _loadConsultadoData(),
        _loadConsuladoForArancel(),
      ];

      try {
        await Future.wait(futures).timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            print('⏰ Timeout en carga de APIs, continuando...');
            return [];
          },
        );
        _checkAllApisLoaded();
      } catch (e) {
        print('❌ Error cargando APIs en segundo plano: $e');
      }
    });
  }

  /// Inyectar controladores de datos
  void _injectDataControllers() {
    try {
      // Intentar obtener ConsultadoController existente o crear uno nuevo
      if (Get.isRegistered<ConsuladoController>()) {
        consultadoController = Get.find<ConsuladoController>();
      } else {
        consultadoController = Get.put(ConsuladoController(), permanent: true);
      }

      print('✅ Controladores de datos inyectados correctamente');
    } catch (e) {
      print('❌ Error al inyectar controladores: $e');
    }
  }

  /// Inicializar reproductor de video
  Future<void> _initializeVideo() async {
    try {
      print('🎬 Inicializando video...');

      // Ruta del video de splash (ajustar según tu archivo de video)
      const videoPath = 'assets/videos/video_splash.webm';

      videoController = VideoPlayerController.asset(videoPath);

      await videoController!.initialize();

      if (!isDisposed.value) {
        showVideo.value = true;
        videoController!.addListener(_onVideoStateChanged);
        videoController!.play();
        print('✅ Video inicializado y reproduciendo');
      }
    } catch (e) {
      print('❌ Error al inicializar video: $e');
      // Continuar sin video si hay error
      showVideo.value = false;
    }
  }

  /// Cargar datos del consulado (modificado para no interferir con UI)
  Future<void> _loadConsultadoData() async {
    try {
      if (consultadoController == null) return;

      print('📡 Cargando datos del consulado en segundo plano...');

      await consultadoController!.loadDefinicionesData();

      if (!isDisposed.value) {
        consultadoLoaded.value = true;
        print('✅ Datos del consulado cargados');
      }
    } catch (e) {
      print('❌ Error al cargar datos del consulado: $e');
    }
  }

  /// Cargar datos de regiones (modificado para no interferir con UI)
  Future<void> _loadRegionesData() async {
    try {
      if (consultadoController == null) return;

      print('🌎 Cargando datos de regiones en segundo plano...');
      await consultadoController!.loadConsultadoData();

      if (!isDisposed.value) {
        regionesLoaded.value = true;
        print('✅ Datos de regiones cargados');
      }
    } catch (e) {
      print('❌ Error al cargar datos de regiones: $e');
    }
  }

  /// Cargar datos de regiones (modificado para no interferir con UI)
  Future<void> _loadConsuladoForArancel() async {
    try {
      if (consultadoController == null) return;

      print(
          '🌎 Cargando datos de consulados para aranceles en segundo plano...');
      await consultadoController!.loadConsultadoForArancel();

      if (!isDisposed.value) {
        consuladoArancelLoaded.value = true;
        print('✅ Datos de consulados para aranceles cargados');
      }
    } catch (e) {
      print('❌ Error al cargar datos de consulados para aranceles: $e');
    }
  }

  /// Verificar si todas las APIs han cargado
  void _checkAllApisLoaded() {
    if (consultadoLoaded.value && regionesLoaded.value) {
      allApisLoaded.value = true;
      print('🎉 Todas las APIs han cargado correctamente');
    } else {
      print('⏳ Esperando que terminen de cargar las APIs...');
      print('  - Consulado: ${consultadoLoaded.value}');
      print('  - Regiones: ${regionesLoaded.value}');
    }
  }

  void _onVideoStateChanged() {
    if (videoController == null || isDisposed.value) return;

    final value = videoController!.value;
    if (value.isInitialized &&
        !value.isPlaying &&
        value.position >= value.duration &&
        value.duration.inMilliseconds > 0) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!isDisposed.value) {
          _navigateToNext();
        }
      });
    }
  }

  void _navigateToNext() {
    if (hasNavigated.value || isDisposed.value) return;

    // Solo verificar si el video ha terminado, no las APIs
    final videoFinished = _isVideoFinished();

    // Si el video terminó o el timer se activó, navegar
    if (videoFinished || true) {
      // true porque el timer ya garantiza el tiempo mínimo
      hasNavigated.value = true;

      // Mostrar resumen de carga de datos
      print('📊 Resumen de carga de datos:');
      print('  - Consulado cargado: ${consultadoLoaded.value}');
      print('  - Regiones cargadas: ${regionesLoaded.value}');
      print('  - Todas las APIs: ${allApisLoaded.value}');

      print('🏠 Navegando al home...');

      _stopAndDisposeVideo();
      navigationTimer?.cancel();

      try {
        Get.offAllNamed(Routes.homeScreenRoute);
      } catch (e) {
        print('❌ Error durante navegación: $e');
      }
    }
  }

  /// Verificar si el video ha terminado
  bool _isVideoFinished() {
    if (videoController == null) return true;

    final value = videoController!.value;
    return value.isInitialized &&
        !value.isPlaying &&
        value.position >= value.duration &&
        value.duration.inMilliseconds > 0;
  }

  void _stopAndDisposeVideo() {
    try {
      if (videoController != null) {
        videoController!.removeListener(_onVideoStateChanged);
        videoController!.pause();
        videoController!.dispose();
        videoController = null;
      }
    } catch (e) {
      print('Error al limpiar video: $e');
    }
  }

  // Métodos públicos para acceder al estado de los datos

  /// Verificar si los datos del consulado están cargados
  bool get isConsultadoDataLoaded => consultadoLoaded.value;

  /// Verificar si los datos de regiones están cargados
  bool get isRegionesDataLoaded => regionesLoaded.value;

  /// Verificar si todas las APIs están cargadas
  bool get areAllApisLoaded => allApisLoaded.value;

  /// Obtener progreso de carga (0.0 - 1.0)
  double get loadingProgress {
    int loadedApis = 0;
    int totalApis = 2; // consulado + regiones

    if (consultadoLoaded.value) loadedApis++;
    if (regionesLoaded.value) loadedApis++;

    return loadedApis / totalApis;
  }

  /// Obtener mensaje de estado actual
  String get currentStatusMessage {
    if (isLoadingConsulado.value && isLoadingRegiones.value) {
      return 'Cargando datos del consulado y regiones...';
    } else if (isLoadingConsulado.value) {
      return 'Cargando datos del consulado...';
    } else if (isLoadingRegiones.value) {
      return 'Cargando regiones...';
    } else if (allApisLoaded.value) {
      return 'Todos los datos cargados correctamente';
    } else {
      return 'Inicializando aplicación...';
    }
  }

  @override
  void onClose() {
    print('🔚 Cerrando SplashController...');
    isDisposed.value = true;

    WidgetsBinding.instance.removeObserver(this);
    navigationTimer?.cancel();

    try {
      _stopAndDisposeVideo();
      fadeController?.dispose();
    } catch (e) {
      print('⚠️ Error disposing controllers: $e');
    }

    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (videoController != null && !isDisposed.value) {
          videoController!.pause();
        }
        break;
      case AppLifecycleState.resumed:
        if (videoController != null &&
            !isDisposed.value &&
            !hasNavigated.value) {
          videoController!.play();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        if (videoController != null && !isDisposed.value) {
          videoController!.pause();
        }
        break;
    }
  }
}
