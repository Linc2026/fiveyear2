import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayTitle({Color? color, double? size, BuildContext? context}) {
    return GoogleFonts.caveat(
      fontSize: size ?? 28.sp,
      fontWeight: FontWeight.w700,
      color: color ??
          (context != null
              ? AppPalette.displayAccent(context)
              : AppColors.primary),
      height: 1.2,
    );
  }

  static TextStyle pageTitle({Color? color, double? size, BuildContext? context}) {
    return GoogleFonts.quicksand(
      fontSize: size ?? 22.sp,
      fontWeight: FontWeight.w700,
      color: color ??
          (context != null
              ? AppPalette.textPrimary(context)
              : AppColors.textPrimary),
      height: 1.3,
    );
  }

  static TextStyle body({
    Color? color,
    double? size,
    FontWeight? weight,
    BuildContext? context,
  }) {
    return GoogleFonts.quicksand(
      fontSize: size ?? 14.sp,
      fontWeight: weight ?? FontWeight.w500,
      color: color ??
          (context != null
              ? AppPalette.textPrimary(context)
              : AppColors.textPrimary),
      height: 1.55,
    );
  }

  static TextStyle caption({Color? color, double? size, BuildContext? context}) {
    return GoogleFonts.quicksand(
      fontSize: size ?? 12.sp,
      fontWeight: FontWeight.w500,
      color: color ??
          (context != null
              ? AppPalette.textSecondary(context)
              : AppColors.textSecondary),
      height: 1.4,
    );
  }

  static TextStyle quote({Color? color, BuildContext? context}) {
    return GoogleFonts.caveat(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: color ??
          (context != null
              ? AppPalette.displayAccent(context)
              : AppColors.primary),
      height: 1.4,
    );
  }
}
