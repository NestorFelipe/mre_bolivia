import UIKit
import Flutter

extension FlutterViewController {
    
    /// Configuración optimizada para la transición del splash screen
    /// Mantiene la consistencia visual con Android
    func configureSplashTransition() {
        // Configurar el color de fondo para mantener consistencia
        view.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0) // #E0E0E0
        
        // Configurar la barra de estado
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    /// Optimiza la inicialización de Flutter para reducir el tiempo de carga
    func optimizeFlutterEngine() {
        // Flutter engine ya está optimizado por defecto en iOS
        // Esta función existe para mantener paridad con Android
        // y posibles optimizaciones futuras
    }
}

// Extensión para coordinar las transiciones suaves
extension UIView {
    
    /// Animación de fade que coincide con la configuración de Android
    func fadeTransition(duration: TimeInterval = 0.6, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.alpha = self.alpha == 0 ? 1 : 0
            },
            completion: { _ in
                completion?()
            }
        )
    }
}