import 'dart:async';
import 'package:fix_store/base/color_data.dart';
import 'package:fix_store/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../base/constant.dart';
import '../../base/pref_data.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with TickerProviderStateMixin, WidgetsBindingObserver {
  
  VideoPlayerController? _videoController;
  bool _hasNavigated = false;
  Timer? _navigationTimer;
  bool _isAppReady = false;
  
  // Controladores de animación para transición coordinada
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _showVideo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Mantener el tema consistente
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFE0E0E0),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFE0E0E0),
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    // CLAVE: Inicialización inmediata de Flutter sin esperar splash nativo
    _initializeFlutterImmediately();
  }

  void _initializeFlutterImmediately() async {
    // Esperar que el motor de Flutter esté completamente inicializado
    await WidgetsBinding.instance.endOfFrame;
    
    // Inicialización inmediata - NO esperar al splash nativo
    // Flutter toma control inmediatamente después de que esté listo
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (mounted) {
      setState(() {
        _isAppReady = true; // Solo necesitamos esta variable ahora
      });
      
      // Inicializar el video de inmediato
      _initializeVideo();
      _setupNavigationTimer();
    }
  }

  void _initializeVideo() async {
    if (!mounted || !_isAppReady) return;
    
    try {
      _videoController = VideoPlayerController.asset('assets/videos/video_splash.webm');
      await _videoController!.initialize();
      
      if (mounted && _isAppReady) {
        setState(() {
          _showVideo = true;
        });
        
        // Fade in suave del video
        _fadeController.forward();
        
        // Configurar y reproducir video
        _videoController!.setLooping(false);
        _videoController!.setVolume(0.0);
        _videoController!.play();
        
        // Escuchar cuando termine
        _videoController!.addListener(_onVideoStateChanged);
      }
    } catch (e) {
      print('Video no disponible: $e');
      // Si no hay video, continuar con imagen estática
      if (mounted) {
        setState(() {
          _showVideo = false;
        });
        _fadeController.forward();
      }
    }
  }

  void _setupNavigationTimer() {
    // Timer de seguridad: navegar después de máximo 5 segundos
    _navigationTimer = Timer(const Duration(seconds: 5), () {
      if (!_hasNavigated) {
        _navigateToNext();
      }
    });
  }

  void _onVideoStateChanged() {
    if (_videoController == null || !mounted) return;
    
    final value = _videoController!.value;
    
    // Verificar si el video terminó
    if (value.isInitialized && 
        !value.isPlaying && 
        value.position >= value.duration &&
        value.duration.inMilliseconds > 0) {
      
      // Pequeño delay antes de navegar para suavizar transición
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateToNext();
      });
    }
  }

  void _navigateToNext() {
    if (_hasNavigated || !mounted) return;
    
    _hasNavigated = true;
    _navigationTimer?.cancel();
    _videoController?.pause();
    
    // Navegar basado en estado de login
    PrefData.isLogIn().then((isLoggedIn) {
      if (mounted) {
        if (isLoggedIn) {
          Constant.sendToNext(context, Routes.homeScreenRoute);
        } else {
          Constant.sendToNext(context, Routes.introRoute);
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _navigationTimer?.cancel();
    _videoController?.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    
    return Scaffold(
      backgroundColor: fondoGris,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: fondoGris,
        child: Center(
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Si la app no está lista, mostrar placeholder inmediatamente
    if (!_isAppReady) {
      return _buildPlaceholder();
    }
    
    if (_showVideo && _videoController != null && _videoController!.value.isInitialized) {
      // Mostrar video con fade in
      return FadeTransition(
        opacity: _fadeAnimation,
        child: _buildVideoPlayer(),
      );
    } else {
      // Mostrar imagen estática con fade in
      return FadeTransition(
        opacity: _fadeAnimation,
        child: _buildStaticLogo(),
      );
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: FetchPixels.getPixelHeight(240),
      height: FetchPixels.getPixelHeight(240),
      color: fondoGris,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: FetchPixels.getPixelHeight(240),
          height: FetchPixels.getPixelHeight(240),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Si hay error cargando la imagen, mostrar un placeholder simple
            return Container(
              width: FetchPixels.getPixelHeight(240),
              height: FetchPixels.getPixelHeight(240),
              color: fondoGris,
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 80,
                  color: Colors.black26,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Padding(
      padding: const EdgeInsets.only(top:  10, left: 10),
      child: SizedBox(
        
        width: FetchPixels.getPixelHeight(300),
        height: FetchPixels.getPixelHeight(300),
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
      ),
    );
  }

  Widget _buildStaticLogo() {
    return Container(
      width: FetchPixels.getPixelHeight(240),
      height: FetchPixels.getPixelHeight(240),
      color: fondoGris,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: FetchPixels.getPixelHeight(240),
          height: FetchPixels.getPixelHeight(240),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Si hay error cargando la imagen, mostrar el fallback anterior
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_circle_outline,
                  size: 80,
                  color: Colors.black26,
                ),
                const SizedBox(height: 16),
                const Text(
                  'BOLIVIA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const Text(
                  'MINISTERIO DE\nRELACIONES EXTERIORES',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black45,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
