import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveActiveUnits(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("active_units", ids);
  }

  static Future<List<String>?> loadActiveUnits() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("active_units");
  }

  static Future<void> saveUnitPrice(String id, double price) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("unit_price_$id", price);
  }

  static Future<double?> loadUnitPrice(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("unit_price_$id");
  }
}
