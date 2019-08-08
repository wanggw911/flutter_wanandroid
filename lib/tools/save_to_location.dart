
import 'package:shared_preferences/shared_preferences.dart';

class DataHander {
  static SharedPreferences sharedInstance;

  static setup() async {
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

  static bool readBoolWith(key) {
    return sharedInstance.getBool(key);
  }
}