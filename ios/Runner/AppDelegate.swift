import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // CRÍTICO: Configurar AVAudioSession para compatibilidad con audio de otras apps
    do {
      let audioSession = AVAudioSession.sharedInstance()
      // Configurar categoría que permite mezclar con otras apps (como Spotify)
      try audioSession.setCategory(.playback, options: [.mixWithOthers])
      try audioSession.setActive(true, options: [])
      print("✅ iOS: Sesión de audio configurada para mixWithOthers")
    } catch {
      print("⚠️ iOS: Error configurando sesión de audio: \(error)")
    }
    
    // Configurar el tema de la barra de estado para mantener consistencia con Android
    if #available(iOS 13.0, *) {
      // Configurar apariencia global para mantener consistencia
      let statusBarStyle = UIStatusBarStyle.darkContent
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        windowScene.statusBarManager?.statusBarStyle = statusBarStyle
      }
    }
    
    // Configurar la ventana principal con el mismo color de fondo que Flutter
    if let window = self.window {
      window.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0) // #E0E0E0
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Configurar el FlutterViewController para transición optimizada
    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      flutterViewController.configureSplashTransition()
      flutterViewController.optimizeFlutterEngine()
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent // Para mantener consistencia con Android
  }
}
