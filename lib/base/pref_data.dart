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

  static setToken(String token) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString("token", token);
  }

  static setCi(String ci) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString("ci", ci);
  }

  static setReg(int reg) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setInt("reg", reg);
  }

  static setUsuario(String usuario) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString("usuario", usuario);
  }

  static setIdPersona(String idPersona) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString("idPersona", idPersona);
  }

  static setExpire(DateTime expiration) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString("expire", expiration.toIso8601String());
  }

  static Future<bool> isLogIn() async {
    SharedPreferences preferences = await getPrefInstance();
    bool isIntroAvailable = preferences.getBool(isLoggedIn) ?? false;
    return isIntroAvailable;
  }

  static Future<String> getToken() async {
    SharedPreferences preferences = await getPrefInstance();
    String token = preferences.getString("token") ?? "";
    return token;
  }

  static Future<String> getIdPersona() async {
    SharedPreferences preferences = await getPrefInstance();
    String idPersona = preferences.getString("idPersona") ?? "";
    return idPersona;
  }

  static Future<String> getCi() async {
    SharedPreferences preferences = await getPrefInstance();
    String ci = preferences.getString("ci") ?? "";
    return ci;
  }

  static Future<DateTime?> getExpire() async {
    SharedPreferences preferences = await getPrefInstance();
    String? expireString = preferences.getString("expire");
    if (expireString != null && expireString.isNotEmpty) {
      return DateTime.parse(expireString);
    }
    return null;
  }

  static Future<int> getReg() async {
    SharedPreferences preferences = await getPrefInstance();
    int reg = preferences.getInt("reg") ?? 0;
    return reg;
  }

  static Future<String> getUsuario() async {
    SharedPreferences preferences = await getPrefInstance();
    String usuario = preferences.getString("usuario") ?? "";
    return usuario;
  }

  static clearPref() async {
    SharedPreferences preferences = await getPrefInstance();
    await preferences.clear();
  }
}
