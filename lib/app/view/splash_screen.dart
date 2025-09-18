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

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _hasVideoError = false;
  bool _hasNavigated = false;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    
    // Configurar UI fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    
    _initializeVideo();
    _setupNavigationTimer();
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset('assets/videos/video_splash.webm');
      await _videoController!.initialize();
      
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
          _hasVideoError = false;
        });
        
        _videoController!.setLooping(false);
        _videoController!.setVolume(0.0);
        _videoController!.play();
        
        // Escuchar cuando termine el video
        _videoController!.addListener(_onVideoStateChanged);
      }
    } catch (e) {
      print('Error cargando video: $e');
      if (mounted) {
        setState(() {
          _hasVideoError = true;
          _isVideoInitialized = false;
        });
      }
    }
  }

  void _onVideoStateChanged() {
    if (_videoController == null || !mounted) return;
    
    final value = _videoController!.value;
    
    // Verificar si el video terminó
    if (value.isInitialized && 
        !value.isPlaying && 
        value.position >= value.duration &&
        value.duration.inMilliseconds > 0) {
      _navigateToNext();
    }
  }

  void _setupNavigationTimer() {
    // Timer de seguridad: navegar después de 5 segundos máximo
    _navigationTimer = Timer(const Duration(seconds: 5), () {
      if (!_hasNavigated) {
        _navigateToNext();
      }
    });
  }

  void _navigateToNext() {
    if (_hasNavigated) return;
    
    _hasNavigated = true;
    _navigationTimer?.cancel();
    _videoController?.pause();
    
    // Restaurar UI normal
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
    
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
    _navigationTimer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    final screenSize = MediaQuery.of(context).size;
    
    return WillPopScope(
      child: Scaffold(
        backgroundColor: fondoGris,
        body: Container(
          width: screenSize.width,
          height: screenSize.height,
          color: fondoGris,
          child: Stack(
            children: [
              // Imagen de fondo siempre visible
              // Center(
              //   child: getAssetImage(
              //     "logo.png",
              //     FetchPixels.getPixelHeight(350),
              //     FetchPixels.getPixelHeight(350),
              //   ),
              // ),
              
              // Video superpuesto si está disponible
              if (_isVideoInitialized && !_hasVideoError)
                Center(
                  child: SizedBox(
                    width: FetchPixels.getPixelHeight(240),
                    height: FetchPixels.getPixelHeight(240),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoController!.value.size.width,
                          height: _videoController!.value.size.height,
                          child: VideoPlayer(_videoController!),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
