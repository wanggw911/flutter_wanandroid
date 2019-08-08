
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
}