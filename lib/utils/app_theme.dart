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
        onSurface: const Color(0xFFE8F5F3),
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

class AppPalette {
  AppPalette._();

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color background(BuildContext context) =>
      isDark(context) ? AppColors.darkBackground : AppColors.background;

  static Color surface(BuildContext context) =>
      isDark(context) ? AppColors.darkSurface : AppColors.cardBg;

  static Color border(BuildContext context) =>
      isDark(context) ? AppColors.darkBorder : AppColors.border;

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? const Color(0xFFE8F5F3) : AppColors.textPrimary;

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? const Color(0xFF94A8A5) : AppColors.textSecondary;

  static Color rowAlt(BuildContext context) =>
      isDark(context) ? const Color(0xFF1A3533) : AppColors.rowAlt;

  static Color gridLine(BuildContext context) =>
      isDark(context) ? AppColors.darkBorder : AppColors.gridLine;

  static Color surfaceElevated(BuildContext context) =>
      isDark(context) ? const Color(0xFF1E3D3A) : AppColors.cardBg;

  static Color surfaceMuted(BuildContext context) =>
      isDark(context)
          ? const Color(0xFF162E2C).withValues(alpha: 0.92)
          : AppColors.cardBg.withValues(alpha: 0.85);

  static Color peach(BuildContext context) =>
      isDark(context) ? const Color(0xFF1F3D38) : AppColors.peach;

  static Color primary(BuildContext context) =>
      isDark(context) ? AppColors.primaryLight : AppColors.primary;

  static Color accentSoft(BuildContext context) =>
      isDark(context)
          ? AppColors.cta.withValues(alpha: 0.22)
          : AppColors.cta.withValues(alpha: 0.15);

  static Color accentSurface(BuildContext context) =>
      isDark(context)
          ? AppColors.cta.withValues(alpha: 0.18)
          : AppColors.cta.withValues(alpha: 0.12);

  static Color highlightFill(BuildContext context) =>
      isDark(context)
          ? const Color(0xFF234842)
          : AppColors.peach.withValues(alpha: 0.35);

  static Color yearChipBg(BuildContext context, {required bool hasContent}) =>
      hasContent
          ? primary(context).withValues(alpha: isDark(context) ? 0.22 : 0.12)
          : rowAlt(context);

  static Color bindingHole(BuildContext context) =>
      isDark(context) ? AppColors.darkBackground : AppColors.background;

  static Color displayAccent(BuildContext context) =>
      isDark(context) ? const Color(0xFF5EEAD4) : AppColors.primary;

  static Color quoteTint(BuildContext context) =>
      isDark(context) ? AppColors.secondary : AppColors.primaryLight;

  static Color navSelectedBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF234842) : AppColors.peach;

  static Color cardShadow(BuildContext context) =>
      isDark(context)
          ? Colors.black.withValues(alpha: 0.4)
          : AppColors.primary.withValues(alpha: 0.08);

  static Color polaroidBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF243836) : Colors.white;

  static Color primaryTint(BuildContext context) => isDark(context)
      ? AppColors.primaryLight.withValues(alpha: 0.2)
      : AppColors.primary.withValues(alpha: 0.1);

  static Color calendarDayMarked(BuildContext context) => isDark(context)
      ? const Color(0xFF234842)
      : AppColors.peach.withValues(alpha: 0.5);

  static List<Color> heatmapScale(BuildContext context) => isDark(context)
      ? [
    const Color(0xFF1A3533),
    const Color(0xFF5EEAD4),
    const Color(0xFF2DD4BF),
    const Color(0xFF0F9488),
  ]
      : [
    AppColors.rowAlt,
    const Color(0xFF99F6E4),
    const Color(0xFF2DD4BF),
    const Color(0xFF0F9488),
  ];

  static List<Color> profileSideTabs(BuildContext context) => isDark(context)
      ? [
    const Color(0xFF2A5568),
    const Color(0xFF4A3038),
    const Color(0xFF3A4A2A),
  ]
      : [
    AppColors.accentBlue,
    AppColors.accentPink,
    AppColors.accentYellow,
  ];

  static Color sectionHeaderBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF1A3533) : AppColors.rowAlt;
}
