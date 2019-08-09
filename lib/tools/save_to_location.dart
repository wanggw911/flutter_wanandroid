
import 'package:shared_preferences/shared_preferences.dart';

class DataHander {
  static SharedPreferences sharedInstance;

  static Future setup() async {
    sharedInstance = await SharedPreferences.getInstance();
  }

  static saveStringWith(key, value) {
    sharedInstance.setString(key, value);
  }

  static String readStringWith(key) {
    return sharedInstance.getString(key);
  }

  static saveBoolWith(key, value) {
    sharedInstance.setBool(key, value);
  }

  static Future<bool> readBoolWith(key) async {
    if (sharedInstance == null) {
      sharedInstance = await SharedPreferences.getInstance();
    }
    bool value = sharedInstance.getBool(key);
    return value == null ? false : value;
  }
}