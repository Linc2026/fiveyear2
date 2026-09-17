import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/grid_paper_background.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'profile_logic.dart';

class ProfileView extends GetView<ProfileLogic> {
  const ProfileView({super.key});

  static const _tabColors = [
    AppColors.accentBlue,
    AppColors.accentPink,
    AppColors.accentYellow,
  ];

  static const _kpiIcons = [
    Icons.menu_book_rounded,
    Icons.text_fields_rounded,
    Icons.calendar_month_rounded,
    Icons.photo_camera_rounded,
  ];

  static const _quickColors = [
    AppColors.cta,
    AppColors.primary,
    AppColors.secondary,
    AppColors.primaryLight,
  ];

  @override
  Widget build(BuildContext context) {
    return GridPaperBackground(
      child: SafeArea(
        child: Obx(() {
          controller.loading.value;
          final name = controller.displayName.isEmpty
              ? Lang.profileDefaultName
              : controller.displayName;

          return RefreshIndicator(
            onRefresh: controller.loadData,
            color: AppColors.primary,
            child: ListView(
              padding: EdgeInsets.only(bottom: 28.h),
              children: [
                _buildTopBar(),
                _buildUserHero(name),
                _buildDataOverview(),
                _buildQuickActions(),
                _buildMenuNotebook(
                  Lang.profileGroupData,
                  [
                    _MenuData(
                      Icons.bar_chart_rounded,
                      Lang.profileStats,
                      AppColors.cta,
                      controller.goStats,
                    ),
                    _MenuData(
                      Icons.mail_outline_rounded,
                      Lang.profileFutureMessage,
                      AppColors.primary,
                      controller.goFuture,
                    ),
                  ],
                ),
                _buildMenuNotebook(
                  Lang.profileGroupMore,
                  [
                    _MenuData(
                      Icons.settings_outlined,
                      Lang.profileSettings,
                      AppColors.secondary,
                      controller.goSettings,
                    ),
                    _MenuData(
                      Icons.help_outline_rounded,
                      Lang.profileHelp,
                      AppColors.primaryLight,
                      controller.goHelp,
                    ),
                    _MenuData(
                      Icons.info_outline_rounded,
                      Lang.profileAbout,
                      AppColors.textSecondary,
                      controller.goAbout,
                    ),
                  ],
                ),
                _buildFooter(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Lang.profileTitle, style: AppTextStyles.pageTitle()),
          SizedBox(height: 2.h),
          Text(Lang.profileSubtitle, style: AppTextStyles.caption()),
        ],
      ),
    );
  }

  Widget _buildUserHero(String name) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -4.w,
            top: 28.h,
            child: Column(
              children: List.generate(3, (i) {
                return Container(
                  width: 14.w,
                  height: 28.h,
                  margin: EdgeInsets.only(bottom: 8.h),
                  decoration: BoxDecoration(
                    color: _tabColors[i],
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(4.r),
                    ),
                  ),
                );
              }),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.goSettings,
                borderRadius: BorderRadius.circular(22.r),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Row(
                    children: [
                      Container(
                        width: 64.w,
                        height: 64.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 36.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTextStyles.displayTitle(
                                size: 26.sp,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_fire_department_rounded,
                                        size: 14.sp,
                                        color: AppColors.accentYellow,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '${Lang.profileStreak} ${controller.streak.value} ${Lang.profileDays}',
                                        style: AppTextStyles.caption(
                                          color: Colors.white,
                                          size: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 28.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataOverview() {
    final items = [
      (Lang.profileTotalEntries, '${controller.totalEntries.value}'),
      (Lang.profileTotalWords, '${controller.totalWords.value}'),
      (Lang.profileMonthEntries, '${controller.monthEntries.value}'),
      (Lang.profilePhotos, '${controller.photoCount.value}'),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                Lang.profileDataOverview,
                style: AppTextStyles.pageTitle(size: 18.sp),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Text(
              Lang.profileTapStats,
              style: AppTextStyles.caption(size: 11.sp),
            ),
          ),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 1.65,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              return _KpiTile(
                icon: _kpiIcons[i],
                label: items[i].$1,
                value: items[i].$2,
                onTap: controller.goStats,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      (Icons.edit_rounded, Lang.profileQuickWrite, controller.quickWrite),
      (Icons.mail_outline_rounded, Lang.profileQuickFuture, controller.goFuture),
      (Icons.file_download_outlined, Lang.profileQuickExport, controller.goExport),
      (Icons.shuffle_rounded, Lang.profileQuickMemory, controller.quickMemory),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Lang.profileQuickActions,
            style: AppTextStyles.pageTitle(size: 18.sp),
          ),
          SizedBox(height: 12.h),
          Row(
            children: List.generate(actions.length, (i) {
              final a = actions[i];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 3 ? 8.w : 0),
                  child: Material(
                    color: _quickColors[i].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16.r),
                    child: InkWell(
                      onTap: a.$3,
                      borderRadius: BorderRadius.circular(16.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: Column(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: _quickColors[i].withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(a.$1, color: _quickColors[i], size: 22.sp),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              a.$2,
                              style: AppTextStyles.caption(size: 10.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuNotebook(String title, List<_MenuData> items) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
            child: Text(
              title,
              style: AppTextStyles.caption().copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Column(
                children: items.asMap().entries.map((e) {
                  final item = e.value;
                  final isLast = e.key == items.length - 1;
                  return Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: item.onTap,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    color: item.color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    item.icon,
                                    color: item.color,
                                    size: 22.sp,
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: AppTextStyles.body(size: 15.sp),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.textSecondary,
                                  size: 22.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Divider(
                          height: 1,
                          indent: 70.w,
                          color: AppColors.border,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
      child: Center(
        child: Text(
          Lang.appName,
          style: AppTextStyles.caption(size: 11.sp),
        ),
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _KpiTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: AppColors.peach,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, size: 20.sp, color: AppColors.primary),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: AppTextStyles.caption(size: 11.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        value,
                        style: AppTextStyles.pageTitle(
                          size: 20.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuData {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuData(this.icon, this.title, this.color, this.onTap);
}
