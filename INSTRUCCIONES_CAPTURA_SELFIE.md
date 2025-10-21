# Instrucciones para Implementar Captura de Selfie

## 📋 Resumen de la Implementación

El formulario `NuevoCertificado` ahora incluye un flujo completo de validación y captura de selfie que sigue estos pasos:

1. ✅ **Validación exhaustiva de todos los campos**
2. ✅ **Captura de selfie con la cámara del dispositivo**
3. ✅ **Preparación de datos para enviar a servicios REST**

## 🔧 Dependencia Requerida

Para habilitar la captura de selfie con la cámara, necesitas agregar la dependencia `image_picker` al proyecto.

### Paso 1: Agregar al pubspec.yaml

Abre el archivo `pubspec.yaml` y agrega la siguiente dependencia:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # ... otras dependencias existentes ...
  image_picker: ^1.0.4 # O la última versión disponible
```

### Paso 2: Instalar la dependencia

Ejecuta en la terminal:

```bash
flutter pub get
```

### Paso 3: Configurar permisos

#### Android (android/app/src/main/AndroidManifest.xml)

Agrega dentro de `<manifest>`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

<application>
    <!-- ... configuración existente ... -->
    <activity
        android:name=".MainActivity">
        <!-- ... configuración existente ... -->
    </activity>
</application>
```

#### iOS (ios/Info.plist)

Agrega dentro de `<dict>`:

```xml
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a la cámara para capturar su selfie y completar el registro del certificado de vivencia</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Necesitamos acceso a la galería para seleccionar imágenes</string>
```

### Paso 4: Descomentar código en nuevo_certificado.dart

Una vez instalada la dependencia, ve al archivo:
`lib/app/view/vivencias/nuevo_certificado.dart`

**Descomentar las siguientes líneas:**

#### En la parte superior del archivo (líneas 14-15):

```dart
// TODO: Descomentar cuando se agregue la dependencia image_picker al pubspec.yaml
import 'dart:io';
import 'package:image_picker/image_picker.dart';
```

#### En la clase \_NuevoCertificadoState (línea 40):

```dart
// TODO: Descomentar cuando se agregue image_picker
final ImagePicker _picker = ImagePicker();
```

#### En el método \_capturarSelfie() (líneas ~750-780):

```dart
// TODO: Implementar captura real con image_picker cuando esté disponible
// Descomentar el siguiente código cuando se agregue la dependencia:

final XFile? photo = await _picker.pickImage(
  source: ImageSource.camera,
  preferredCameraDevice: CameraDevice.front,
  imageQuality: 85,
  maxWidth: 1024,
  maxHeight: 1024,
);

Get.back(); // Cerrar diálogo de carga

if (photo != null) {
  setState(() {
    capturedImagePath = photo.path;
  });

  // Mostrar preview de la imagen capturada con opción de confirmar o reintentar
  final bool? confirmar = await _mostrarPreviewImagen(photo.path);

  if (confirmar == true) {
    return photo.path;
  } else {
    // Usuario quiere reintentar
    return await _capturarSelfie();
  }
}
```

#### Método adicional \_mostrarPreviewImagen (al final del archivo):

```dart
// TODO: Implementar método para mostrar preview de imagen y confirmar
Future<bool?> _mostrarPreviewImagen(String imagePath) async {
  return await Get.dialog<bool>(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Verificar Selfie',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF14357D),
              ),
            ),
            SizedBox(height: 16.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.file(
                File(imagePath),
                height: 300.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '¿La imagen es correcta?',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(result: false),
                    child: Text('Reintentar'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14357D),
                    ),
                    child: Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
```

## 🎯 Flujo Completo Implementado

### 1. Validación de Datos

Al hacer clic en "Guardar Certificado", se validan:

- ✅ Tipo de residencia seleccionado
- ✅ Nombre del apoderado (mínimo 3 caracteres)
- ✅ NI del apoderado (mínimo 5 caracteres)
- ✅ Departamento seleccionado
- ✅ Ciudad seleccionada
- ✅ Dirección (mínimo 10 caracteres)

### 2. Captura de Selfie

Si las validaciones pasan:

1. Se muestra un diálogo con instrucciones para el usuario
2. El usuario confirma que está listo
3. Se abre la cámara frontal del dispositivo
4. El usuario captura la selfie
5. Se muestra un preview para confirmar o reintentar
6. La imagen se guarda temporalmente

### 3. Procesamiento

Una vez capturada la selfie:

1. Se muestran indicadores de "Procesando..."
2. Los datos se preparan en el formato correcto
3. La ruta de la imagen está disponible en `capturedImagePath`

### 4. Envío a Servicios (TODO)

Están preparados dos puntos para implementar:

```dart
// TODO: PASO 4 - Enviar imagen al primer servicio
// final responseImagen = await enviarImagenAlServicio(imagenCapturada);

// TODO: PASO 5 - Si la imagen es OK, enviar datos al segundo servicio
// if (responseImagen.success) {
//   final responseDatos = await enviarDatosAlServicio(datosParaGuardar);
// }
```

## 📦 Datos Preparados para Servicios

El objeto `datosParaGuardar` contiene:

```dart
{
  'idperiodo': int,                // ID del periodo seleccionado
  'idresidencia': int,             // ID del tipo de residencia
  'apoderado': String,             // Nombre del apoderado
  'niapoderado': String,           // NI del apoderado
  'dptoapoderado': String,         // Nombre del departamento
  'direccionapoderado': String,    // Dirección completa
  'iddepartamental': int,          // ID de la ciudad
}
```

La imagen capturada está en: `capturedImagePath` (String con la ruta del archivo)

## 🎨 UI/UX Implementado

### Diálogo de Instrucciones

- ✅ Icono de cámara
- ✅ Instrucciones claras para el usuario
- ✅ Recomendaciones visuales con viñetas
- ✅ Botones "Cancelar" y "Abrir Cámara"

### Indicadores de Estado

- ✅ Loading spinner al abrir cámara
- ✅ Snackbar de confirmación al capturar
- ✅ Botón "Procesando..." con spinner
- ✅ Botones deshabilitados durante proceso

### Validaciones Visuales

- ✅ Snackbars con iconos para cada error
- ✅ Mensajes específicos para cada campo
- ✅ Colores diferenciados (rojo=error, verde=éxito)

## 🚀 Próximos Pasos

1. **Instalar dependencia**: `flutter pub get` después de agregar `image_picker`
2. **Configurar permisos**: Android e iOS
3. **Descomentar código**: En `nuevo_certificado.dart`
4. **Implementar servicios**:
   - Servicio para enviar imagen
   - Servicio para enviar datos del certificado
5. **Probar en dispositivo real**: La cámara no funciona en emuladores

## 📱 Pruebas

Para probar completamente:

1. Usar un dispositivo físico (la cámara no funciona en emuladores)
2. Verificar que los permisos se soliciten correctamente
3. Capturar selfie y verificar que se guarde
4. Confirmar que los datos se preparen correctamente
5. Implementar los servicios REST finales

## 🔍 Notas Importantes

- El código actual tiene una **SIMULACIÓN** que funciona sin `image_picker`
- Una vez agregada la dependencia, la simulación debe ser reemplazada
- La imagen debe ser enviada como `multipart/form-data` o `base64`
- Considerar comprimir la imagen antes de enviar (ya configurado: `imageQuality: 85`)
- El tamaño máximo está limitado a 1024x1024 para optimizar el envío

---

**Estado Actual**: ✅ Listo para agregar dependencia y descomentar código
**Versión**: 1.0.0
**Fecha**: Octubre 2025
