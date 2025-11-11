import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../app/routes/app_routes.dart';
import 'consulado_controller.dart';

class SplashLogoController extends GetxController with WidgetsBindingObserver {
  // Observables para estado reactivo
  RxBool hasNavigated = false.obs;
  RxBool isAppReady = false.obs;
  RxBool isDisposed = false.obs;
  RxBool showAnimation = false.obs;

  // Observables para APIs
  RxBool isLoadingConsulado = false.obs;
  RxBool consultadoLoaded = false.obs;
  RxBool isLoadingRegiones = false.obs;
  RxBool regionesLoaded = false.obs;
  RxBool isLoadingTramiteServicios = false.obs;
  RxBool tramiteServiciosLoaded = false.obs;

  RxBool allApisLoaded = false.obs;
  RxBool consuladoArancelLoaded = false.obs;

  // Controladores de animación
  Timer? navigationTimer;
  ConsuladoController? consultadoController;

  // Controladores de animación específicos para el brillo
  AnimationController? fadeController;
  AnimationController? glowController;

  Animation<double>? fadeAnimation;
  Animation<double>? glowAnimation;

  // Variable para controlar la rotación del brillo
  RxDouble glowPosition = 0.0.obs;
  Timer? glowTimer;

  // Inicializar con TickerProvider
  void initialize(TickerProvider vsync) {
    WidgetsBinding.instance.addObserver(this);

    // Animación de fade in inicial
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: fadeController!, curve: Curves.easeInOut),
    );

    // Animación del doble brillo que se encuentra en el centro derecho
    glowController = AnimationController(
      duration: const Duration(seconds: 5), // 5 segundos para el ciclo completo
      vsync: vsync,
    );

    glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: glowController!, curve: Curves.easeInOut),
    );

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('🎬 Iniciando splash con logo y brillo...');

      await WidgetsBinding.instance.endOfFrame;
      await Future.delayed(const Duration(milliseconds: 200));

      if (!isDisposed.value) {
        // Inyectar controladores de datos
        _injectDataControllers();

        // Marcar app como lista
        isAppReady.value = true;

        // Iniciar animaciones
        await _startAnimations();

        // Cargar APIs en segundo plano
        _loadApisInBackground();

        // Setup del timer de navegación
        _setupNavigationTimer();
      }
    } catch (e) {
      print('❌ Error durante la inicialización: $e');
      if (!isDisposed.value) {
        isAppReady.value = true;
        _startAnimations();
        _setupNavigationTimer();
      }
    }
  }

  Future<void> _startAnimations() async {
    if (isDisposed.value) return;

    showAnimation.value = true;

    // Iniciar fade in
    fadeController!.forward();

    // Esperar un poco y luego iniciar la animación del brillo
    await Future.delayed(const Duration(milliseconds: 600));

    if (!isDisposed.value) {
      // Iniciar el brillo rotativo infinito
      glowController!.repeat();
      print('✨ Brillo circular iniciado');
    }
  }

  void _setupNavigationTimer() {
    // Timer para navegación (8 segundos igual que el video)
    navigationTimer = Timer(const Duration(seconds: 8), () {
      if (!hasNavigated.value) {
        print('⏰ Timer de navegación activado');
        _navigateToNext();
      }
    });
  }

  /// Cargar APIs en segundo plano
  void _loadApisInBackground() {
    Future(() async {
      final futures = [
        _loadRegionesData(),
        _loadConsultadoData(),
        _loadConsuladoForArancel(),
        _loadTramiteServicios()
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

  void _injectDataControllers() {
    try {
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

  Future<void> _loadConsultadoData() async {
    try {
      if (consultadoController == null) return;
      print('📡 Cargando datos del consulado...');
      await consultadoController!.loadDefinicionesData();
      if (!isDisposed.value) {
        consultadoLoaded.value = true;
        print('✅ Datos del consulado cargados');
      }
    } catch (e) {
      print('❌ Error al cargar datos del consulado: $e');
    }
  }

  Future<void> _loadTramiteServicios() async {
    try {
      if (consultadoController == null) return;
      print('📡 Cargando datos de tramite servicios...');
      await consultadoController!.loadTramiteServiciosData();
      if (!isDisposed.value) {
        tramiteServiciosLoaded.value = true;
      }
    } catch (e) {
      print('❌ Error al cargar datos de tramite servicios: $e');
    }
  }

  Future<void> _loadRegionesData() async {
    try {
      if (consultadoController == null) return;
      print('🌎 Cargando datos de regiones...');
      await consultadoController!.loadConsultadoData();
      if (!isDisposed.value) {
        regionesLoaded.value = true;
        print('✅ Datos de regiones cargados');
      }
    } catch (e) {
      print('❌ Error al cargar datos de regiones: $e');
    }
  }

  Future<void> _loadConsuladoForArancel() async {
    try {
      if (consultadoController == null) return;
      print('🌎 Cargando datos de consulados para aranceles...');
      await consultadoController!.loadConsultadoForArancel();
      if (!isDisposed.value) {
        consuladoArancelLoaded.value = true;
        print('✅ Datos de consulados para aranceles cargados');
      }
    } catch (e) {
      print('❌ Error al cargar datos de consulados para aranceles: $e');
    }
  }

  void _checkAllApisLoaded() {
    if (consultadoLoaded.value &&
        regionesLoaded.value &&
        tramiteServiciosLoaded.value &&
        consuladoArancelLoaded.value) {
      allApisLoaded.value = true;
      print('🎉 Todas las APIs han cargado correctamente');
    }
  }

  void _navigateToNext() {
    if (hasNavigated.value || isDisposed.value) return;

    hasNavigated.value = true;

    print('📊 Resumen de carga de datos:');
    print('  - Consulado cargado: ${consultadoLoaded.value}');
    print('  - Regiones cargadas: ${regionesLoaded.value}');
    print('  - Todas las APIs: ${allApisLoaded.value}');

    print('🏠 Navegando al home...');

    _stopAnimations();
    navigationTimer?.cancel();

    try {
      Get.offAllNamed(Routes.homeScreenRoute);
    } catch (e) {
      print('❌ Error durante navegación: $e');
    }
  }

  void _stopAnimations() {
    try {
      glowTimer?.cancel();
      glowController?.stop();
      fadeController?.stop();
    } catch (e) {
      print('Error al detener animaciones: $e');
    }
  }

  // Métodos públicos para acceder al estado de los datos
  bool get isConsultadoDataLoaded => consultadoLoaded.value;
  bool get isRegionesDataLoaded => regionesLoaded.value;
  bool get isConsuladoForArancelLoaded => consuladoArancelLoaded.value;
  bool get isTramiteServiciosDataLoaded => tramiteServiciosLoaded.value;
  bool get areAllApisLoaded => allApisLoaded.value;

  double get loadingProgress {
    int loadedApis = 0;
    int totalApis = 4;
    if (consultadoLoaded.value) loadedApis++;
    if (regionesLoaded.value) loadedApis++;
    if (tramiteServiciosLoaded.value) loadedApis++;
    if (consuladoArancelLoaded.value) loadedApis++;
    return loadedApis / totalApis;
  }

  @override
  void onClose() {
    print('🔚 Cerrando SplashLogoController...');
    isDisposed.value = true;

    WidgetsBinding.instance.removeObserver(this);
    navigationTimer?.cancel();

    try {
      _stopAnimations();
      fadeController?.dispose();
      glowController?.dispose();
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
        glowController?.stop();
        break;
      case AppLifecycleState.resumed:
        if (!isDisposed.value && !hasNavigated.value && showAnimation.value) {
          glowController?.repeat();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }
}
