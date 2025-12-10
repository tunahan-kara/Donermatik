class SettingsModel {
  final bool darkMode;
  final String currency;
  final String defaultUnit; // doner, cay, sigara, custom
  final String? customUnitName;
  final String userName;
  final String avatar;

  SettingsModel({
    required this.darkMode,
    required this.currency,
    required this.defaultUnit,
    required this.userName,
    required this.avatar,
    this.customUnitName,
  });

  SettingsModel copyWith({
    bool? darkMode,
    String? currency,
    String? defaultUnit,
    String? customUnitName,
    String? userName,
    String? avatar,
  }) {
    return SettingsModel(
      darkMode: darkMode ?? this.darkMode,
      currency: currency ?? this.currency,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      customUnitName: customUnitName ?? this.customUnitName,
      userName: userName ?? this.userName,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "darkMode": darkMode,
      "currency": currency,
      "defaultUnit": defaultUnit,
      "customUnitName": customUnitName,
      "userName": userName,
      "avatar": avatar,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      darkMode: map["darkMode"] ?? true,
      currency: map["currency"] ?? "TRY",
      defaultUnit: map["defaultUnit"] ?? "doner",
      customUnitName: map["customUnitName"],
      userName: map["userName"] ?? "Kullanıcı",
      avatar: map["avatar"] ?? "😎",
    );
  }
}
