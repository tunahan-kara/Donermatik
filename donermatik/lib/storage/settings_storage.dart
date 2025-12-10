import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';

class SettingsStorage {
  static Future<void> save(SettingsModel model) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("darkMode", model.darkMode);
    prefs.setString("currency", model.currency);
    prefs.setString("defaultUnit", model.defaultUnit);
    prefs.setString("customUnitName", model.customUnitName ?? "");
    prefs.setString("userName", model.userName);
    prefs.setString("avatar", model.avatar);
  }

  static Future<SettingsModel> load() async {
    final prefs = await SharedPreferences.getInstance();

    return SettingsModel(
      darkMode: prefs.getBool("darkMode") ?? true,
      currency: prefs.getString("currency") ?? "TRY",
      defaultUnit: prefs.getString("defaultUnit") ?? "doner",
      customUnitName: prefs.getString("customUnitName"),
      userName: prefs.getString("userName") ?? "Kullanıcı",
      avatar: prefs.getString("avatar") ?? "😎",
    );
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
