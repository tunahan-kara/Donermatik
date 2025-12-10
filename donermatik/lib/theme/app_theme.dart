import 'package:flutter/material.dart';

class AppColors {
  static const backgroundDark = Color(0xFF0F0F11);
  static const cardDark = Color(0xFF1A1A1E);

  static const backgroundLight = Color(0xFFF5F5F7);
  static const cardLight = Color(0xFFFFFFFF);

  static const accent = Color(0xFFF4D23C);

  static const accentDark = Color(0xFFE0BE2E);

  static const textPrimary = Colors.white;
  static const textSecondary = Colors.white70;

  static const textPrimaryLight = Colors.black87;
  static const textSecondaryLight = Colors.black54;
}

class AppTheme {
  // -------------------------------------------------------
  // DARK THEME
  // -------------------------------------------------------
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardColor: AppColors.cardDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.accent,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textSecondary),
    ),
  );

  // -------------------------------------------------------
  // LIGHT THEME (SENDE EKSİK OLAN BU!)
  // -------------------------------------------------------
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardColor: AppColors.cardLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      secondary: AppColors.accent,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimaryLight),
      bodyMedium: TextStyle(color: AppColors.textSecondaryLight),
    ),
  );

  // -------------------------------------------------------
  // YARDIMCI KART DEKORASYONU (Dashboard için)
  // -------------------------------------------------------
  static BoxDecoration cardDecoration({bool soft = false}) {
    return BoxDecoration(
      color: soft ? AppColors.cardDark.withOpacity(0.8) : AppColors.cardDark,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white10, width: 1),
    );
  }
}
