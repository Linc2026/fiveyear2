import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF155E59);
  static const Color primaryLight = Color(0xFF0F9488);
  static const Color secondary = Color(0xFF2DD4BF);
  static const Color primaryDark = Color(0xFF134E4A);
  static const Color cta = Color(0xFFE84855);
  static const Color background = Color(0xFFF3FAF9);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF1A3330);
  static const Color textSecondary = Color(0xFF5B7A76);
  static const Color divider = Color(0xFFCCE5E2);
  static const Color rowAlt = Color(0xFFE8F5F3);
  static const Color border = Color(0xFFCCE5E2);
  static const Color accentBlue = Color(0xFFBAE6FD);
  static const Color accentPink = Color(0xFFFECDD3);
  static const Color accentYellow = Color(0xFFE9FAC8);
  static const Color gridLine = Color(0xFFB8D9D5);
  static const Color peach = Color(0xFFD5F5F0);
  static const Color destructive = Color(0xFFDC2626);

  static const Color darkBackground = Color(0xFF0C1F1E);
  static const Color darkSurface = Color(0xFF162E2C);
  static const Color darkBorder = Color(0xFF2A4A47);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.cta,
        surface: AppColors.cardBg,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.cta,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryLight,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.cta,
        surface: AppColors.darkSurface,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.cta,
        foregroundColor: Colors.white,
      ),
    );
  }
}
