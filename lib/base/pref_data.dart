import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static String prefName = "com.screensizer.screen_sizer";

  static String introAvailable = "${prefName}isIntroAvailable";
  static String isLoggedIn = "${prefName}isLoggedIn";
  static String getTheme = "${prefName}isSelectedTheme";

  static Future<SharedPreferences> getPrefInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }


  static setLogIn(bool avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setBool(isLoggedIn, avail);
  }


  static Future<bool> isLogIn() async {
    SharedPreferences preferences = await getPrefInstance();
    bool isIntroAvailable = preferences.getBool(isLoggedIn) ?? false;
    return isIntroAvailable;
  }

}

