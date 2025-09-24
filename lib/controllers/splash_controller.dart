import 'dart:async';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import '../../app/routes/app_routes.dart';

class SplashController extends GetxController with WidgetsBindingObserver {
  // Observables para estado reactivo
  RxBool hasNavigated = false.obs;
  RxBool isAppReady = false.obs;
  RxBool isDisposed = false.obs;
  RxBool showVideo = false.obs;

  // Controladores
  VideoPlayerController? videoController;
  Timer? navigationTimer;

  // Controladores de animación (se pasan desde el widget)
  AnimationController? fadeController;
  Animation<double>? fadeAnimation;

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

    _initializeFlutterImmediately();
  }

  void _initializeFlutterImmediately() async {
    await WidgetsBinding.instance.endOfFrame;
    await Future.delayed(const Duration(milliseconds: 100));

    if (!isDisposed.value) {
      isAppReady.value = true;
      _initializeVideo();
      _setupNavigationTimer();
    }
  }

  void _initializeVideo() async {
    if (!isAppReady.value || isDisposed.value) return;

    try {
      videoController = VideoPlayerController.asset(
        'assets/videos/video_splash.webm',
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      videoController!.setVolume(0.0);
      await videoController!.initialize();

      if (isAppReady.value && !isDisposed.value) {
        showVideo.value = true;
        fadeController?.forward();

        videoController!.setLooping(false);
        videoController!.setVolume(0.0);
        videoController!.play();
        videoController!.addListener(_onVideoStateChanged);
      }
    } catch (e) {
      print('Video no disponible: $e');
      if (!isDisposed.value) {
        showVideo.value = false;
        fadeController?.forward();
      }
    }
  }

  void _setupNavigationTimer() {
    navigationTimer = Timer(const Duration(seconds: 6), () {
      if (!hasNavigated.value) {
        _navigateToNext();
      }
    });
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

    hasNavigated.value = true;
    isDisposed.value = true;

    _stopAndDisposeVideo();
    navigationTimer?.cancel();

    Get.toNamed(Routes.homeScreenRoute);
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

  @override
  void onClose() {
    isDisposed.value = true;
    WidgetsBinding.instance.removeObserver(this);
    _stopAndDisposeVideo();
    navigationTimer?.cancel();
    navigationTimer = null;
    fadeController?.dispose();
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
