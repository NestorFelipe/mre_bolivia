# Videos Assets

## Instrucciones para agregar el video de splash

1. **Coloca tu video aquí** con uno de estos nombres:
   - `splash_video.webm` (primera opción)
   - `splash_video.mp4` (opción de respaldo)

2. **Formatos soportados**: 
   - WebM (recomendado para Android)
   - MP4 (más compatible)

## ✅ Solución al error PlatformException

Si obtienes el error `androidx.media3.exoplayer.ExoPlaybackException: Source error`:

### **Paso 1: Verifica que el archivo existe**
- Asegúrate de que el archivo esté en `assets/videos/`
- El nombre debe ser exactamente `splash_video.webm` o `splash_video.mp4`

### **Paso 2: Convierte tu video al formato correcto**
Usa FFmpeg para convertir tu video:

```bash
# Para WebM (recomendado)
ffmpeg -i tu_video.mp4 -c:v libvpx-vp9 -crf 30 -b:v 1M -c:a libopus splash_video.webm

# Para MP4 (alternativa)
ffmpeg -i tu_video.mp4 -c:v libx264 -crf 23 -preset medium -c:a aac splash_video.mp4
```

### **Paso 3: Optimiza el video**
- **Duración**: Máximo 5 segundos
- **Resolución**: 720p o 1080p
- **Tamaño**: Menos de 3MB
- **Frame rate**: 30fps máximo

## 🎯 Características actuales:

- ✅ **Manejo de errores robusto**: Si falla WebM, intenta MP4
- ✅ **Fallback a imagen**: Si falla el video, muestra la imagen original  
- ✅ **Pantalla completa**: Video ajustado a toda la pantalla
- ✅ **Reproducción automática**: Inicia al cargar la pantalla
- ✅ **Bucle continuo**: Se repite automáticamente

## 🔧 Para testing sin video:

Si no tienes video aún, la app funcionará normalmente mostrando la imagen de respaldo (`splash_logo.png`).

## 📱 Compatibilidad:

- ✅ Android 5.0+ (API 21+)
- ✅ iOS 9.0+
- ✅ Dispositivos con hardware acceleration
