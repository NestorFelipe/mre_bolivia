import 'package:mre_bolivia/app/models/consulado/model_intro.dart';
import 'package:mre_bolivia/app/models/consulado/model_paises.dart';
import 'package:mre_bolivia/app/models/consulado/model_regiones.dart';
import 'package:mre_bolivia/app/models/consulado/model_servicio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../base/constant.dart';
import '../../../app/routes/app_routes.dart';
import '../shared_controller.dart';
import 'consulado_controller.dart';

class TabHomeController extends GetxController {
  // Observable para la página seleccionada en PageView
  RxInt selectedPage = 0.obs;

  Rx<Region?> selectedRegion = Rx<Region?>(null);
  Rx<Pais?> selectedPais = Rx<Pais?>(null);

  Rx<Servicio?> selectedServicio = Rx<Servicio?>(null);

  // Controlador de PageView
  final PageController pageController = PageController(initialPage: 0);

  // SharedPreferences
  SharedPreferences? sharedPreferences;

  // Controlador de búsqueda
  TextEditingController searchController = TextEditingController();

  // Estado de carga para SharedPreferences
  RxBool isPrefsReady = false.obs;

  final RxList<Region> regions = <Region>[].obs;
  final RxList<Servicio> servicios = <Servicio>[].obs;

  // Para manejar la expansión de cards en ConsuladosScreen
  final RxSet<int> expandedCards = <int>{}.obs;

  // Método para toggle de expansión de cards
  void toggleCardExpansion(int index) {
    if (expandedCards.contains(index)) {
      expandedCards.remove(index);
    } else {
      expandedCards.add(index);
    }
  }

  // Inyectar SharedController
  late SharedController sharedController;

  // Inyectar ConsultadoController
  ConsuladoController? consultadoController;

  void goBack() {
    Constant.backToPrev(Get.context!);
  }

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
      consultadoController = Get.find<ConsuladoController>();
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

  void goToConsulado(Pais pais) {
    selectedPais.value = pais;
    Constant.sendToNext(Get.context!, Routes.consuladosRoute);
  }

  // Navegar a categorías
  void goToCategories() {
    Constant.sendToNext(Get.context!, Routes.categoryRoute);
  }

  void goToRegion(Region region) {
    selectedRegion.value = region;
    Constant.sendToNext(Get.context!, Routes.regionRoute);
  }

  // Navegar a detalle de servicio
  void goToServicio(Servicio servicio) {
    selectedServicio.value = servicio;
    Constant.sendToNext(Get.context!, Routes.detailRoute);
  }

  // Navegar a detalle de categoría
  void goToCategoryDetail() {
    Constant.sendToNext(Get.context!, Routes.detailRoute);
  }

  // Obtener definiciones del consulado para el slider
  List<Intro> getSliderDefiniciones() {
    if (consultadoController?.consultadoData == null) {
      // Retorna lista vacía si no hay datos del consulado
      return [];
    }

    final definiciones = consultadoController!.definicionesData?.intros;

    return definiciones!;
  }

  List<Region> getPaisregion() {
    regions.value = consultadoController!.consultadoData!;
    // ignore: invalid_use_of_protected_member
    return regions.value;
  }

  List<Servicio> getServicios() {
    servicios.value = consultadoController!.definicionesData!.servicios;
    // ignore: invalid_use_of_protected_member
    return servicios.value;
  }

  // Verificar si hay datos del consulado disponibles
  bool get hasConsultadoData => consultadoController?.consultadoData != null;

  // Verificar si está cargando los datos del consulado
  bool get isLoadingConsultado =>
      consultadoController?.isLoading.value ?? false;

  // Verificar si hay error en los datos del consulado
  bool get hasConsultadoError => consultadoController?.hasError.value ?? false;

  // Obtener mensaje de error del consulado
  String get consultadoErrorMessage =>
      consultadoController?.errorMessage.value ?? '';

  // Navegar a la página de detalle de definición
  void goToDefinicionDetail(Intro definicion, int index) {
    Get.toNamed(Routes.definicionDetailRoute, arguments: {
      'definicion': definicion,
      'index': index,
    });
  }
}
