import 'package:flutter/material.dart';
import 'splash_image_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // Usar el splash original con funcionalidad offline integrada
    return const SplashImageScreen();
  }
}

// Mantener el VideoSplashScreen original para compatibilidad
class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // Usar también el splash original para compatibilidad
    return const SplashImageScreen();
  }
}
