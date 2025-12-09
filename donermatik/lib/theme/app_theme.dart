import 'package:flutter/material.dart';

class AppColors {
  // BACKGROUND
  static const Color background = Color(0xFF101012); // soft dark
  static const Color scaffold = Color(0xFF111216);

  // CARDS
  static const Color card = Color(0xFF1E1F24); // hafif mavi-gri koyu
  static const Color cardSoft = Color(0xFF24262E); // biraz daha açık kart

  // ACCENT (pastel sarı)
  static const Color accent = Color(0xFFF4D23C);
  static const Color accentDark = Color(0xFFE0BD32);

  // TEXT
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9FA1A9);

  // DIVIDER
  static const Color divider = Color(0xFF2A2C32);

  static Color get shadow => Colors.black.withOpacity(0.35);
}

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark();

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.scaffold,
      primaryColor: AppColors.accent,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.accent,
        secondary: AppColors.accent,
        brightness: Brightness.dark,
      ),

      // APP BAR
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // TEXT
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),

      // INPUTS
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      // BUTTONLAR
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // iOS vari
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // SWITCH
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.accent;
          }
          return Colors.grey.shade400;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.accent.withOpacity(0.35);
          }
          return Colors.grey.shade700;
        }),
      ),

      // BOTTOM NAV
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF111216),
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  // Kartlar için ortak dekorasyon
  static BoxDecoration cardDecoration({bool soft = false}) {
    return BoxDecoration(
      color: soft ? AppColors.cardSoft : AppColors.card,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
