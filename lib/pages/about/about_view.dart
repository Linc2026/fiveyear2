import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/app_sub_page_bar.dart';
import '../../components/app_ui_kit.dart';
import '../../components/grid_paper_background.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'about_logic.dart';

class AboutView extends GetView<AboutLogic> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      Lang.aboutFeature1,
      Lang.aboutFeature2,
      Lang.aboutFeature3,
      Lang.aboutFeature4,
    ];

    return GridPaperBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              AppSubPageBar(title: Lang.aboutTitle, subtitle: Lang.appName),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  children: [
                    Container(
                      padding: EdgeInsets.all(28.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 72.w,
                            height: 72.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              size: 40.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            Lang.appName,
                            style: AppTextStyles.displayTitle(
                              size: 30.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            Lang.aboutVersion,
                            style: AppTextStyles.caption(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    AppFormCard(
                      child: Text(
                        Lang.aboutDesc,
                        style: AppTextStyles.body(size: 14.sp),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    ...features.map(
                      (f) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  size: 20.sp, color: AppColors.cta),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(f, style: AppTextStyles.body(size: 14.sp)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
