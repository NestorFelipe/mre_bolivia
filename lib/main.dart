import 'package:fix_store/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  // Asegurar que Flutter esté completamente inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // // Mantener el splash nativo hasta que Flutter esté listo
  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  
  // // Configurar orientación de pantalla
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  
  // // Configurar colores de la barra de estado para coincidir con el splash
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Color(0xFFE0E0E0), // Mismo color del splash
  //   statusBarIconBrightness: Brightness.dark,
  //   systemNavigationBarColor: Color(0xFFE0E0E0),
  //   systemNavigationBarIconBrightness: Brightness.dark,
  // ));
  
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
    
    // Estrategia seamless: delay más largo para permitir coordinación perfecta
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   if (mounted) {
    //     // Transición gradual del splash nativo
    //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //   }
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: AppPages.routes,
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
      // Deshabilitar tema oscuro completamente
      darkTheme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE0E0E0),
        brightness: Brightness.light, // Forzar tema claro incluso en darkTheme
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFFE0E0E0),
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xFFE0E0E0),
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      themeMode: ThemeMode.light, // Forzar siempre tema claro
    );
  }
}
