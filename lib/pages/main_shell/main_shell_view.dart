import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import '../calendar/calendar_view.dart';
import '../diary/diary_view.dart';
import '../trail/trail_view.dart';
import '../memories/memories_view.dart';
import '../profile/profile_view.dart';
import 'main_shell_logic.dart';

class MainShellView extends GetView<MainShellLogic> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final index = controller.currentIndex.value;
        return Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              DiaryView(),
              CalendarView(),
              TrailView(),
              MemoriesView(),
              ProfileView(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg.withValues(alpha: 0.96),
              border: Border(top: BorderSide(color: AppColors.border)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(4.w, 12.h, 4.w, 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _SideNavItem(
                      icon: Icons.menu_book_rounded,
                      label: Lang.tabDiary,
                      selected: index == 0,
                      onTap: () => controller.changeTab(0),
                    ),
                    _SideNavItem(
                      icon: Icons.calendar_month_rounded,
                      label: Lang.tabCalendar,
                      selected: index == 1,
                      onTap: () => controller.changeTab(1),
                    ),
                    _CenterTrailNav(
                      selected: index == 2,
                      onTap: () => controller.changeTab(2),
                    ),
                    _SideNavItem(
                      icon: Icons.photo_library_rounded,
                      label: Lang.tabMemories,
                      selected: index == 3,
                      onTap: () => controller.changeTab(3),
                    ),
                    _SideNavItem(
                      icon: Icons.person_rounded,
                      label: Lang.tabProfile,
                      selected: index == 4,
                      onTap: () => controller.changeTab(4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SideNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SideNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(selected ? 6.w : 4.w),
                decoration: BoxDecoration(
                  color: selected ? AppColors.peach : Colors.transparent,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                style: AppTextStyles.caption(
                  size: 9.sp,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                ).copyWith(fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterTrailNav extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _CenterTrailNav({
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(0, -10.h),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: selected
                        ? [AppColors.cta, AppColors.primaryLight]
                        : [AppColors.primary, AppColors.primaryDark],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBg, width: 3.w),
                  boxShadow: [
                    BoxShadow(
                      color: (selected ? AppColors.cta : AppColors.primary)
                          .withValues(alpha: 0.32),
                      blurRadius: 12,
                      offset: Offset(0, 3.h),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
            Text(
              Lang.tabTrail,
              style: AppTextStyles.caption(
                size: 9.sp,
                color: selected ? AppColors.cta : AppColors.textSecondary,
              ).copyWith(fontWeight: selected ? FontWeight.w700 : FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
