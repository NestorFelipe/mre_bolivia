import 'package:fix_store/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with TickerProviderStateMixin {
  
  late SplashController controller;

  @override
  void initState() {
    super.initState();
    
    controller = Get.put(SplashController());
    controller.initialize(this);
    
    // Mantener el tema consistente
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFE0E0E0),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFE0E0E0),
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    Get.delete<SplashController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoGris,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: fondoGris,
        child: Center(
          child: Obx(() => _buildContent()),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Si la app no está lista, mostrar placeholder inmediatamente
    if (!controller.isAppReady.value) {
      return _buildPlaceholder();
    }
    
    if (controller.showVideo.value && controller.videoController != null && controller.videoController!.value.isInitialized) {
      // Mostrar video con fade in
      return FadeTransition(
        opacity: controller.fadeAnimation!,
        child: _buildVideoPlayer(),
      );
    } else {
      // Mostrar imagen estática con fade in
      return FadeTransition(
        opacity: controller.fadeAnimation!,
        child: _buildStaticLogo(),
      );
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 240.h,
      height: 240.h,
      color: fondoGris,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 240.h,
          height: 240.h,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Si hay error cargando la imagen, mostrar un placeholder simple
            return Container(
              width: 240.h,
              height: 240.h,
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
      padding: const EdgeInsets.only(top:  20, left: 5),
      child: SizedBox(
        
        width: 240.h,
        height: 240.h,
        child: AspectRatio(
          aspectRatio: controller.videoController!.value.aspectRatio,
          child: VideoPlayer(controller.videoController!),
        ),
      ),
    );
  }

  Widget _buildStaticLogo() {
    return Container(
      width: 240.h,
      height: 240.h,
      color: fondoGris,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 240.h,
          height: 240.h,
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
