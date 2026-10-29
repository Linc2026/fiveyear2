import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_theme.dart';

class AppSubPageBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const AppSubPageBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 8.h),
      child: Row(
        children: [
          Material(
            color: AppPalette.surface(context),
            shape: CircleBorder(side: BorderSide(color: AppPalette.border(context))),
            child: InkWell(
              onTap: onBack ?? () => Get.back(),
              customBorder: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.pageTitle(
                    size: 20.sp,
                    color: AppPalette.textPrimary(context),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption(
                      size: 12.sp,
                      color: AppPalette.textSecondary(context),
                    ),
                  ),
              ],
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

class AppCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? bgColor;

  const AppCircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor ?? AppPalette.surface(context),
      shape: CircleBorder(side: BorderSide(color: AppPalette.border(context))),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Icon(icon, size: 20.sp, color: iconColor ?? AppColors.primary),
        ),
      ),
    );
  }
}
