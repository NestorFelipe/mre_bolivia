import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/routes/app_routes.dart';
import '../base/constant.dart';
import '../base/device_util.dart';

class CategoryController extends GetxController {
  // Observable para la lista de categorías
  // RxList<ModelCategory> categoryList = <ModelCategory>[].obs;

  // Observable para el número de columnas del grid
  RxInt numberOfColumns = 3.obs;

  // SharedPreferences para guardar índice seleccionado
  SharedPreferences? sharedPreferences;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _initializeSharedPreferences();
  }

  // Inicializar datos
  void _initializeData() {
    // Cargar datos de categorías
    // categoryList.assignAll(DataFile.categoryList);

    // Configurar número de columnas según dispositivo
    numberOfColumns.value = DeviceUtil.isTablet ? 6 : 3;
  }

  // Inicializar SharedPreferences
  void _initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // Navegar al detalle de categoría
  void goToCategoryDetail(int index) {
    // Guardar índice seleccionado en SharedPreferences
    sharedPreferences?.setInt("category_index", index);

    // Navegar a la pantalla de detalle
    Constant.sendToNext(Get.context!, Routes.detailRoute);
  }

  // Navegar hacia atrás
  void goBack() {
    Constant.backToPrev(Get.context!);
  }

  // Método para filtrar categorías (funcionalidad adicional)
  // void searchCategories(String query) {
  //   if (query.isEmpty) {
  //     categoryList.assignAll(DataFile.categoryList);
  //   } else {
  //     categoryList.assignAll(
  //       DataFile.categoryList.where((category) =>
  //         category.name?.toLowerCase().contains(query.toLowerCase()) == true
  //       ).toList()
  //     );
  //   }
  // }

  // Método para refrescar datos
  void refreshData() {
    _initializeData();
  }
}
