import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../lang/lang.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_theme.dart';

class AppUi {
  AppUi._();

  static BoxDecoration cardDecoration({Color? color, BuildContext? context}) {
    final surface = context != null ? AppPalette.surface(context) : AppColors.cardBg;
    final border = context != null ? AppPalette.border(context) : AppColors.border;
    return BoxDecoration(
      color: color ?? surface,
      borderRadius: BorderRadius.circular(18.r),
      border: Border.all(color: border),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static InputDecoration inputDecoration({
    String? label,
    String? hint,
    BuildContext? context,
  }) {
    final secondary =
    context != null ? AppPalette.textSecondary(context) : AppColors.textSecondary;
    final rowAlt = context != null ? AppPalette.rowAlt(context) : AppColors.rowAlt;
    final border = context != null ? AppPalette.border(context) : AppColors.border;
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.caption(color: secondary),
      hintText: hint,
      hintStyle: AppTextStyles.caption(color: secondary),
      filled: true,
      fillColor: rowAlt,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    );
  }

  static Widget sheetHandle() {
    return Center(
      child: Container(
        width: 44.w,
        height: 5.h,
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(3.r),
        ),
      ),
    );
  }

  static Widget sheetTitle(String title) {
    return Text(title, style: AppTextStyles.pageTitle(size: 18.sp));
  }

  static Widget sheetSubtitle(String text) {
    return Text(text, style: AppTextStyles.caption());
  }

  static Widget primaryButton({
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool loading = false,
    Color? color,
  }) {
    return Material(
      color: color ?? AppColors.cta,
      borderRadius: BorderRadius.circular(14.r),
      elevation: 0,
      shadowColor: (color ?? AppColors.cta).withValues(alpha: 0.35),
      child: InkWell(
        onTap: loading ? null : onPressed,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: double.infinity,
          height: 50.h,
          alignment: Alignment.center,
          child: loading
              ? SizedBox(
            width: 22.w,
            height: 22.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20.sp, color: Colors.white),
                SizedBox(width: 8.w),
              ],
              Text(
                label,
                style: AppTextStyles.body(
                  color: Colors.white,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget outlineButton({
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return Material(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: double.infinity,
          height: 50.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20.sp, color: AppColors.textPrimary),
                SizedBox(width: 8.w),
              ],
              Text(label, style: AppTextStyles.body(weight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? AppColors.primary : AppColors.cardBg,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption(
              color: selected ? Colors.white : AppColors.textSecondary,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  static Widget fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 2.w),
      child: Text(
        text,
        style: AppTextStyles.body(size: 14.sp, weight: FontWeight.w700),
      ),
    );
  }

  static Widget sectionTitle(String title, {Color accent = AppColors.primary}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 0, 0, 10.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          Text(title, style: AppTextStyles.pageTitle(size: 16.sp)),
        ],
      ),
    );
  }

  static Future<bool?> confirm({
    required String title,
    String? message,
  }) {
    return Get.dialog<bool>(
      Dialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.destructive.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 28.sp,
                  color: AppColors.destructive,
                ),
              ),
              SizedBox(height: 16.h),
              Text(title, style: AppTextStyles.pageTitle(size: 18.sp)),
              if (message != null) ...[
                SizedBox(height: 10.h),
                Text(
                  message,
                  style: AppTextStyles.body(
                    color: AppColors.textSecondary,
                    size: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: outlineButton(
                      label: Lang.cancel,
                      onPressed: () => Get.back(result: false),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: primaryButton(
                      label: Lang.confirm,
                      color: AppColors.destructive,
                      onPressed: () => Get.back(result: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showMessageSheet({
    required String title,
    required String message,
    IconData icon = Icons.check_circle_outline_rounded,
    Color iconColor = AppColors.primary,
  }) {
    Get.bottomSheet(
      AppSheetContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            sheetHandle(),
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 32.sp),
            ),
            SizedBox(height: 16.h),
            sheetTitle(title),
            SizedBox(height: 8.h),
            Text(
              message,
              style: AppTextStyles.caption(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            primaryButton(label: Lang.confirm, onPressed: () => Get.back()),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static Future<T?> showFormSheet<T>({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Get.bottomSheet<T>(
      AppSheetContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sheetHandle(),
            sheetTitle(title),
            if (subtitle != null) ...[
              SizedBox(height: 6.h),
              sheetSubtitle(subtitle),
            ],
            SizedBox(height: 16.h),
            child,
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class AppSheetContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppSheetContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40.h),
      decoration: BoxDecoration(
        color: AppPalette.surfaceElevated(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: padding ??
            EdgeInsets.fromLTRB(
              20.w,
              12.h,
              20.w,
              MediaQuery.of(context).viewInsets.bottom + 28.h,
            ),
        child: child,
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  final String text;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.text,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                color: AppColors.peach,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, size: 40.sp, color: AppColors.primary),
            ),
            SizedBox(height: 20.h),
            Text(
              text,
              style: AppTextStyles.body(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 24.h),
              AppUi.primaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<int> values;
  final List<String> labels;
  final Color barColor;

  const SimpleBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.barColor = AppColors.cta,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 130.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final h = maxVal == 0 ? 4.h : (values[i] / maxVal) * 88.h;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${values[i]}', style: AppTextStyles.caption(size: 10.sp)),
                SizedBox(height: 4.h),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 22.w,
                  height: h.clamp(4.h, 88.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [barColor, barColor.withValues(alpha: 0.7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  labels[i],
                  style: AppTextStyles.caption(size: 9.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class ProgressBarItem extends StatelessWidget {
  final String label;
  final double progress;
  final String trailing;

  const ProgressBarItem({
    super.key,
    required this.label,
    required this.progress,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body(size: 13.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(trailing, style: AppTextStyles.caption(size: 12.sp)),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8.h,
              backgroundColor: AppColors.rowAlt,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class AppFormCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppFormCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: AppUi.cardDecoration(context: context),
      child: child,
    );
  }
}

class AppLocalImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? placeholderColor;
  final Color? iconColor;

  const AppLocalImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget placeholder() {
      final iconSize = width != null && height != null
          ? (width! < height! ? width! : height!) * 0.38
          : 24.sp;
      return Container(
        width: width,
        height: height,
        color: placeholderColor ?? AppColors.rowAlt,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: iconSize,
          color: iconColor ?? AppColors.textSecondary,
        ),
      );
    }

    if (path.isEmpty || !File(path).existsSync()) {
      return _wrap(placeholder());
    }

    return _wrap(
      Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => placeholder(),
      ),
    );
  }

  Widget _wrap(Widget child) {
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }
}
