import 'package:mre_bolivia/app/view/consulado/consulados_screen.dart';
import 'package:mre_bolivia/app/view/home/category_screen.dart';

import 'package:mre_bolivia/app/view/home/region_screen.dart';
import 'package:mre_bolivia/app/view/home/home_screen.dart';
import 'package:mre_bolivia/app/view/home/detail_screen.dart';

import 'package:mre_bolivia/app/view/home/tab/tab_aranceles.dart';
import 'package:mre_bolivia/app/view/home/tab/tab_seguimiento_tramite.dart';
import 'package:mre_bolivia/app/view/vivencias/forgot_password.dart';
import 'package:mre_bolivia/app/view/vivencias/vivencia_screen.dart';
import 'package:mre_bolivia/bindings/category_binding.dart';
import 'package:mre_bolivia/bindings/vivencia_binding.dart';

import 'package:mre_bolivia/bindings/aranceles_binding.dart';
import 'package:mre_bolivia/bindings/region_binding.dart';
import 'package:get/get.dart';
import 'package:mre_bolivia/bindings/seguimiento_tramite_binding.dart';
import '../view/splash_screen.dart';
import '../ui/pages/consulado_page.dart';
import '../view/consulado/definicion_detail_screen.dart';
import 'app_routes.dart';
import '../../bindings/splash_binding.dart';
import '../../bindings/home_binding.dart';
import '../../bindings/consulado_binding.dart';

class AppPages {
  static const initialRoute = Routes.homeRoute;
  static List<GetPage> pages = [
    GetPage(
        name: Routes.consuladosRoute,
        page: () => ConsuladosScreen(),
        binding: ConsultadoBinding()),
    GetPage(
      name: Routes.homeRoute,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.forgotRoute,
      page: () => const ForgotPassword(),
    ),
    GetPage(
      name: Routes.resetRoute,
      page: () => const VivenciaScreen(),
      binding: VivenciaBinding(),
    ),
    GetPage(
      name: Routes.homeScreenRoute,
      page: () => HomeScreen(0),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.regionRoute,
      page: () => const RegionScreen(),
      binding: RegionBinding(),
    ),
    GetPage(
      name: Routes.detailRoute,
      page: () => const DetailScreen(),
    ),
    GetPage(
      name: Routes.consultadoRoute,
      page: () => const ConsultadoPage(),
      binding: ConsultadoBinding(),
    ),
    GetPage(
      name: Routes.definicionDetailRoute,
      page: () => const DefinicionDetailScreen(),
    ),
    GetPage(
        name: Routes.seguimientoTramiteRoute,
        page: () => const SeguimientoTramite(),
        binding: SeguimientoTramiteBinding()),
    GetPage(
        name: Routes.arancelesRoute,
        page: () => const Aranceles(),
        binding: ArancelesBinding()),
    GetPage(
      name: Routes.categoryRoute,
      page: () => const CategoryScreen(),
      binding: CategoryBinding(),
    ),
  ];
}
