import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../base/constant.dart';
import '../../app/routes/app_routes.dart';
import '../controllers/shared_controller.dart';
import '../controllers/consulado_controller.dart';
import '../app/models/model_consulado.dart';

class TabHomeController extends GetxController {
  // Observable para la página seleccionada en PageView
  RxInt selectedPage = 0.obs;

  // Controlador de PageView
  final PageController pageController = PageController(initialPage: 0);

  // SharedPreferences
  SharedPreferences? sharedPreferences;

  // Controlador de búsqueda
  TextEditingController searchController = TextEditingController();

  // Estado de carga para SharedPreferences
  RxBool isPrefsReady = false.obs;

  // Inyectar SharedController
  late SharedController sharedController;

  // Inyectar ConsultadoController
  ConsultadoController? consultadoController;

  @override
  void onInit() {
    super.onInit();
    // Asegurar que SharedController esté disponible
    if (!Get.isRegistered<SharedController>()) {
      Get.put(SharedController(), permanent: true);
    }
    sharedController = Get.find<SharedController>();
    
    // Intentar obtener ConsultadoController si está disponible
    try {
      consultadoController = Get.find<ConsultadoController>();
    } catch (e) {
      // ConsultadoController no está disponible, se mantendrá como null
    }
    
    initializeSharedPreferences();
    update(); // Reconstruir inicialmente
  }

  // Inicializar SharedPreferences
  void initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isPrefsReady.value = true;
    update(); // Para notificar cambios si es necesario
  }

  // Cambiar página en PageView
  void changePage(int page) {
    selectedPage.value = page;
    update(); // Notificar cambios para GetBuilder
  }

  // Navegar a notificaciones
  void goToNotifications() {
    Constant.sendToNext(Get.context!, Routes.notificationRoutes);
  }

  // Navegar a búsqueda
  void goToSearch() {
    Constant.sendToNext(Get.context!, Routes.searchRoute);
  }

  // Navegar a categorías
  void goToCategories() {
    Constant.sendToNext(Get.context!, Routes.categoryRoute);
  }

  // Navegar a detalle de servicio
  void goToDetail(int index) {
    sharedPreferences?.setInt("index", index);
    Constant.sendToNext(Get.context!, Routes.detailRoute);
  }

  // Navegar a detalle de categoría
  void goToCategoryDetail() {
    sharedPreferences?.setInt("index", 1);
    Constant.sendToNext(Get.context!, Routes.detailRoute);
  }

  // Obtener definiciones del consulado para el slider
  List<ModelDefinicion> getSliderDefiniciones() {
    if (consultadoController?.consultadoData == null) {
      // Retorna lista vacía si no hay datos del consulado
      return [];
    }

    final definiciones = consultadoController!.consultadoData!.definiciones;
    
    // Tomar las primeras 3 definiciones disponibles
    if (definiciones.length >= 3) {
      return definiciones.take(3).toList();
    } else {
      // Retornar todas las definiciones disponibles
      return definiciones;
    }
  }

  // Verificar si hay datos del consulado disponibles
  bool get hasConsultadoData => consultadoController?.consultadoData != null;

  // Verificar si está cargando los datos del consulado
  bool get isLoadingConsultado => consultadoController?.isLoading ?? false;

  // Verificar si hay error en los datos del consulado
  bool get hasConsultadoError => consultadoController?.hasError ?? false;

  // Obtener mensaje de error del consulado
  String get consultadoErrorMessage => consultadoController?.errorMessage ?? '';

  // Navegar a la página de consulado
  void goToConsulado() {
    Constant.sendToNext(Get.context!, Routes.consultadoRoute);
  }

  // Navegar a la página de detalle de definición
  void goToDefinicionDetail(ModelDefinicion definicion, int index) {
    Get.toNamed(Routes.definicionDetailRoute, arguments: {
      'definicion': definicion,
      'index': index,
    });
  }
}