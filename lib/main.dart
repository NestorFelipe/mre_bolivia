import 'package:fix_store/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  // Asegurar que Flutter esté completamente inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Forzar tema light a nivel del sistema
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFFE0E0E0), // Mismo color que fondoGris
    statusBarIconBrightness: Brightness.dark, // Iconos oscuros para fondo claro
    systemNavigationBarColor: Color(0xFFE0E0E0), // Mismo color consistente
    systemNavigationBarIconBrightness: Brightness.dark, // Iconos oscuros
  ));
  
  // Configurar orientación de pantalla
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896), // Tamaños de diseño basados en FetchPixels
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.initialRoute,
        getPages: AppPages.pages,
        theme: ThemeData(
          // Configurar el color de fondo por defecto para toda la app
          scaffoldBackgroundColor: const Color(0xFFE0E0E0),
          // Forzar tema claro siempre
          brightness: Brightness.light,
          // Configurar colores de la barra de estado
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xFFE0E0E0),
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Color(0xFFE0E0E0),
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
          ),
        ),
        // IMPORTANTE: Eliminar darkTheme completamente para forzar solo tema light
        themeMode: ThemeMode.light, // Forzar siempre tema claro
      ),
    );
  }
}
