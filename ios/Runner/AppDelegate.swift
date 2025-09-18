import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
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
