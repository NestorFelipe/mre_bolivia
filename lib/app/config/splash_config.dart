/// Configuración para el tipo de splash screen a utilizar
class SplashConfig {
  /// Tipo de splash screen
  /// - video: Usa video MP4 con el escudo de Bolivia y efecto de brillo
  /// - image: Usa animaciones con imágenes (más eficiente)
  /// - particles: Usa animaciones con partículas (efecto profesional)
  /// - logo: Usa el logo.png con brillo giratorio (RECOMENDADO - replica el video)
  static const SplashType splashType = SplashType.logo;

  /// Duración del splash en segundos
  static const int splashDuration = 5;

  /// Habilitar efectos de sonido (solo para video)
  static const bool enableSound = false;

  /// Habilitar debug logs
  static const bool enableDebug = true;
}

enum SplashType {
  video,
  image,
  particles,
  logo, // Nuevo tipo para logo con brillo
}
