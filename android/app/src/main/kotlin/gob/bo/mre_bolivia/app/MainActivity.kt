package gob.bo.mre_bolivia.app

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.os.Build
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.view.View
import android.view.ViewTreeObserver

class MainActivity: FlutterActivity() {
    private var keepSplashOnScreen = true
    
    override fun onCreate(savedInstanceState: Bundle?) {
        
        // Instalar el splash screen de Android 12+ si está disponible
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val splashScreen = installSplashScreen()
            
            // Controlar cuándo mantener el splash screen visible
            splashScreen.setKeepOnScreenCondition { keepSplashOnScreen }
            
            // Configurar animación de salida personalizada
            splashScreen.setOnExitAnimationListener { splashScreenViewProvider ->
                val splashScreenView = splashScreenViewProvider.view
                
                // Crear fade out suave de 600ms
                splashScreenView.animate()
                    .alpha(0f)
                    .setDuration(600)
                    .setListener(object : AnimatorListenerAdapter() {
                        override fun onAnimationEnd(animation: Animator) {
                            splashScreenViewProvider.remove()
                        }
                    })
                    .start()
            }
        }
        
        super.onCreate(savedInstanceState)
        
        // Permitir que Flutter tome control después de 1.5 segundos
        // Esto da tiempo para que se muestre el splash nativo y luego haga fade out
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            window.decorView.viewTreeObserver.addOnPreDrawListener(
                object : ViewTreeObserver.OnPreDrawListener {
                    override fun onPreDraw(): Boolean {
                        return if (flutterEngine?.dartExecutor?.isExecutingDart == true) {
                            // Flutter está listo, permitir que el splash haga fade out
                            keepSplashOnScreen = false
                            window.decorView.viewTreeObserver.removeOnPreDrawListener(this)
                            true
                        } else {
                            false
                        }
                    }
                }
            )
        }
    }
}
