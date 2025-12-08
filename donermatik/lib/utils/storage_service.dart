import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // ACTIVE UNITS
  static Future<void> saveActiveUnits(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("active_units", ids);
  }

  static Future<List<String>?> loadActiveUnits() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("active_units");
  }

  // UNIT PRICE
  static Future<void> saveUnitPrice(String id, double price) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("unit_price_$id", price);
  }

  static Future<double?> loadUnitPrice(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("unit_price_$id");
  }

  // CUSTOM UNITS SAVE
  static Future<void> saveCustomUnits(List<Map<String, dynamic>> units) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> encoded = units
        .map((m) => m.toString())
        .toList(); // encode map → string

    await prefs.setStringList("custom_units", encoded);
  }

  // CUSTOM UNITS LOAD
  static Future<List<Map<String, dynamic>>> loadCustomUnits() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? saved = prefs.getStringList("custom_units");

    if (saved == null) return [];

    return saved.map((str) {
      str = str.substring(1, str.length - 1); // remove {}

      final pairs = str.split(", ");
      Map<String, dynamic> out = {};

      for (var p in pairs) {
        var kv = p.split(": ");
        out[kv[0]] = kv[1];
      }
      return out;
    }).toList();
  }
}
