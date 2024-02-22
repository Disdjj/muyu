import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> setInt(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(key, value);
  }

  static Future<int?> getInt(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }

  static Future<void> incrementCounter(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int currentCount = sp.getInt(key) ?? 0;
    sp.setInt(key, currentCount + 1);
  }
}
