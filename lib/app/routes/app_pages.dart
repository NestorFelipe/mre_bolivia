import 'package:fix_store/app/view/address/edit_address_screen.dart';
import 'package:fix_store/app/view/address/my_address_screen.dart';
import 'package:fix_store/app/view/bookings/booking_detail.dart';
import 'package:fix_store/app/view/card/card_screen.dart';
import 'package:fix_store/app/view/home/address_screen.dart';
import 'package:fix_store/app/view/home/cart_screen.dart';
import 'package:fix_store/app/view/home/category_screen.dart';
import 'package:fix_store/app/view/home/date_time_screen.dart';
import 'package:fix_store/app/view/home/home_screen.dart';
import 'package:fix_store/app/view/home/detail_screen.dart';
import 'package:fix_store/app/view/home/payment_screen.dart';
import 'package:fix_store/app/view/home/order_detail.dart';
import 'package:fix_store/app/view/intro/intro_screen.dart';
import 'package:fix_store/app/view/login/forgot_password.dart';
import 'package:fix_store/app/view/login/login_screen.dart';
import 'package:fix_store/app/view/login/reset_password.dart';
import 'package:fix_store/app/view/notification_screen.dart';
import 'package:fix_store/app/view/profile/edit_profile_screen.dart';
import 'package:fix_store/app/view/profile/profile_screen.dart';
import 'package:fix_store/app/view/search/search_screen.dart';
import 'package:fix_store/app/view/setting/help_screen.dart';
import 'package:fix_store/app/view/setting/privacy_screen.dart';
import 'package:fix_store/app/view/setting/security_screen.dart';
import 'package:fix_store/app/view/setting/setting_screen.dart';
import 'package:fix_store/app/view/setting/term_of_service_screen.dart';
import 'package:fix_store/app/view/signup/select_country.dart';
import 'package:fix_store/app/view/signup/signup_screen.dart';
import 'package:fix_store/app/view/signup/verify_screen.dart';

import 'package:get/get.dart';

import '../view/splash_screen.dart';
import '../ui/pages/consulado_page.dart';
import '../view/consulado/definicion_detail_screen.dart';
import 'app_routes.dart';
import '../../bindings/splash_binding.dart';
import '../../bindings/intro_binding.dart';
import '../../bindings/login_binding.dart';
import '../../bindings/signup_binding.dart';
import '../../bindings/home_binding.dart';
import '../../bindings/category_binding.dart';
import '../../bindings/consulado_binding.dart';

class AppPages {
  static const initialRoute = Routes.homeRoute;
  static List<GetPage> pages = [
    GetPage(
      name: Routes.homeRoute,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.introRoute,
      page: () => const IntroScreen(),
      binding: IntroBinding(),
    ),
    GetPage(
      name: Routes.loginRoute,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.forgotRoute,
      page: () => const ForgotPassword(),
    ),
    GetPage(
      name: Routes.resetRoute,
      page: () => const ResetPassword(),
    ),
    GetPage(
      name: Routes.signupRoute,
      page: () => const SignUpScreen(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: Routes.selectCountryRoute,
      page: () => const SelectCountry(),
    ),
    GetPage(
      name: Routes.verifyRoute,
      page: () => const VerifyScreen(),
    ),
    GetPage(
      name: Routes.homeScreenRoute,
      page: () => HomeScreen(0),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.categoryRoute,
      page: () => const CategoryScreen(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: Routes.detailRoute,
      page: () => const DetailScreen(),
    ),
    GetPage(
      name: Routes.cartRoute,
      page: () => const CartScreen(),
    ),
    GetPage(
      name: Routes.addressRoute,
      page: () => const AddressScreen(),
    ),
    GetPage(
      name: Routes.dateTimeRoute,
      page: () => const DateTimeScreen(),
    ),
    GetPage(
      name: Routes.paymentRoute,
      page: () => const PaymentScreen(),
    ),
    GetPage(
      name: Routes.orderDetailRoute,
      page: () => const OrderDetail(),
    ),
    GetPage(
      name: Routes.profileRoute,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: Routes.editProfileRoute,
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: Routes.myAddressRoute,
      page: () => const MyAddressScreen(),
    ),
    GetPage(
      name: Routes.editAddressRoute,
      page: () => const EditAddressScreen(),
    ),
    GetPage(
      name: Routes.cardRoute,
      page: () => const CardScreen(),
    ),
    GetPage(
      name: Routes.settingRoute,
      page: () => const SettingScreen(),
    ),
    GetPage(
      name: Routes.notificationRoutes,
      page: () => const NotificationScreen(),
    ),
    GetPage(
      name: Routes.searchRoute,
      page: () => const SearchScreen(),
    ),
    GetPage(
      name: Routes.bookingRoute,
      page: () => const BookingDetail(),
    ),
    GetPage(
      name: Routes.helpRoute,
      page: () => const HelpScreen(),
    ),
    GetPage(
      name: Routes.privacyRoute,
      page: () => const PrivacyScreen(),
    ),
    GetPage(
      name: Routes.securityRoute,
      page: () => const SecurityScreen(),
    ),
    GetPage(
      name: Routes.termOfServiceRoute,
      page: () => const TermOfServiceScreen(),
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
  ];
}
