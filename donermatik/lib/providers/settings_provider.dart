import 'package:flutter/material.dart';
import '../models/settings_model.dart';
import '../storage/settings_storage.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsModel _settings = SettingsModel(
    darkMode: true,
    currency: "TRY",
    defaultUnit: "doner",
    userName: "Kullanıcı",
    avatar: "😎",
  );

  SettingsModel get settings => _settings;

  Future<void> loadSettings() async {
    _settings = await SettingsStorage.load();
    notifyListeners();
  }

  void toggleTheme() {
    _settings = _settings.copyWith(darkMode: !_settings.darkMode);
    SettingsStorage.save(_settings);
    notifyListeners();
  }

  void setCurrency(String newCurrency) {
    _settings = _settings.copyWith(currency: newCurrency);
    SettingsStorage.save(_settings);
    notifyListeners();
  }

  void setDefaultUnit(String unit, {String? customName}) {
    _settings = _settings.copyWith(
      defaultUnit: unit,
      customUnitName: customName,
    );
    SettingsStorage.save(_settings);
    notifyListeners();
  }

  void setUserName(String name) {
    _settings = _settings.copyWith(userName: name);
    SettingsStorage.save(_settings);
    notifyListeners();
  }

  void setAvatar(String avatar) {
    _settings = _settings.copyWith(avatar: avatar);
    SettingsStorage.save(_settings);
    notifyListeners();
  }

  Future<void> resetAllData() async {
    await SettingsStorage.reset();
    _settings = SettingsModel(
      darkMode: true,
      currency: "TRY",
      defaultUnit: "doner",
      userName: "Kullanıcı",
      avatar: "😎",
    );
    notifyListeners();
  }
}
