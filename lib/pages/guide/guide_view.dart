import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/app_ui_kit.dart';
import '../../components/grid_paper_background.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'guide_logic.dart';

class GuideView extends GetView<GuideLogic> {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      _GuidePageData(
        icon: Icons.edit_note_rounded,
        color: AppColors.accentBlue,
        title: Lang.guideTitle1,
        subtitle: Lang.guideSubtitle1,
      ),
      _GuidePageData(
        icon: Icons.mail_outline_rounded,
        color: AppColors.accentPink,
        title: Lang.guideTitle2,
        subtitle: Lang.guideSubtitle2,
      ),
      _GuidePageData(
        icon: Icons.auto_stories_rounded,
        color: AppColors.accentYellow,
        title: Lang.guideTitle3,
        subtitle: Lang.guideSubtitle3,
      ),
    ];

    return GridPaperBackground(
      child: SafeArea(
        child: Obx(() {
          final page = pages[controller.currentPage.value];
          final isLast = controller.currentPage.value == pages.length - 1;
          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.finishGuide,
                  child: Text(
                    Lang.guideSkip,
                    style: AppTextStyles.caption(color: AppColors.textSecondary),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 128.w,
                        height: 128.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [page.color, page.color.withValues(alpha: 0.55)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: page.color.withValues(alpha: 0.45),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(page.icon, size: 56.sp, color: AppColors.primary),
                      ),
                      SizedBox(height: 36.h),
                      Text(
                        page.title,
                        style: AppTextStyles.pageTitle(size: 24.sp),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        page.subtitle,
                        style: AppTextStyles.body(
                          color: AppColors.textSecondary,
                          size: 15.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: controller.currentPage.value == i ? 28.w : 8.w,
                    height: 8.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == i
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: AppUi.primaryButton(
                  label: isLast ? Lang.guideStart : Lang.guideNext,
                  icon: isLast ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                  onPressed: controller.nextPage,
                ),
              ),
              SizedBox(height: 28.h),
            ],
          );
        }),
      ),
    );
  }
}

class _GuidePageData {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _GuidePageData({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });
}
