import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/grid_paper_background.dart';
import '../../db_five_year_diary/db_five_year_diary_entity.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'trail_logic.dart';

class TrailView extends GetView<TrailLogic> {
  const TrailView({super.key});

  static const _moodColors = [
    Color(0xFF059669),
    Color(0xFF0D9488),
    Color(0xFF64748B),
    Color(0xFF6366F1),
    Color(0xFFF59E0B),
    Color(0xFFE84855),
  ];

  static const _heatmapColors = [
    AppColors.rowAlt,
    Color(0xFF99F6E4),
    Color(0xFF2DD4BF),
    Color(0xFF0F9488),
  ];

  static IconData _badgeIcon(String id) {
    switch (id) {
      case 'first':
        return Icons.flag_rounded;
      case 'streak7':
      case 'streak30':
        return Icons.local_fire_department_rounded;
      case 'entries10':
        return Icons.menu_book_rounded;
      case 'photo5':
        return Icons.photo_camera_rounded;
      case 'mood10':
        return Icons.emoji_emotions_rounded;
      case 'words1k':
        return Icons.text_fields_rounded;
      case 'years2':
        return Icons.date_range_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridPaperBackground(
      child: SafeArea(
        child: Obx(() {
          controller.loading.value;
          return RefreshIndicator(
            onRefresh: controller.loadData,
            color: AppColors.primary,
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 28.h),
              children: [
                _buildHeader(),
                SizedBox(height: 14.h),
                _buildHeroCard(),
                _buildSection(
                  icon: Icons.grid_view_rounded,
                  title: Lang.trailHeatmap,
                  subtitle: Lang.trailHeatmapPeriod,
                  child: _buildHeatmap(),
                ),
                _buildSection(
                  icon: Icons.palette_rounded,
                  title: Lang.trailMoodMosaic,
                  subtitle: Lang.trailMoodMosaicHint,
                  tint: AppColors.peach.withValues(alpha: 0.35),
                  child: _buildMoodMosaic(),
                ),
                _buildSection(
                  icon: Icons.bar_chart_rounded,
                  title: Lang.trailRhythm,
                  child: _buildRhythm(),
                ),
                _buildSection(
                  icon: Icons.military_tech_rounded,
                  title: Lang.trailMilestones,
                  child: _buildMilestones(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Lang.trailTitle, style: AppTextStyles.pageTitle()),
          SizedBox(height: 4.h),
          Text(Lang.trailSubtitle, style: AppTextStyles.caption()),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.92),
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${controller.activeDays.value}',
                style: AppTextStyles.displayTitle(
                  size: 52.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  Lang.trailActiveDays,
                  style: AppTextStyles.caption(
                    color: Colors.white.withValues(alpha: 0.85),
                    size: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  icon: Icons.local_fire_department_rounded,
                  label: Lang.trailHeroStreak,
                  value: '${controller.streak.value} ${Lang.profileDays}',
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _HeroStat(
                  icon: Icons.emoji_events_rounded,
                  label: Lang.trailHeroBadges,
                  value:
                      '${controller.unlockedBadges.value}/${controller.badges.length}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
    String? subtitle,
    Color? tint,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
                color: tint ?? AppColors.rowAlt,
                child: Row(
                  children: [
                    Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(icon, size: 18.sp, color: AppColors.primary),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.pageTitle(size: 16.sp),
                          ),
                          if (subtitle != null) ...[
                            SizedBox(height: 2.h),
                            Text(
                              subtitle,
                              style: AppTextStyles.caption(size: 11.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeatmap() {
    if (controller.heatmap.isEmpty) {
      return Text(Lang.emptyNoData, style: AppTextStyles.caption());
    }

    final weekdays = Lang.calendarWeekdays;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: List.generate(7, (i) {
            return Expanded(
              child: Center(
                child: Text(
                  weekdays[i].substring(0, 1),
                  style: AppTextStyles.caption(
                    size: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8.h),
        _buildHeatmapGrid(controller.heatmap),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(Lang.trailLess, style: AppTextStyles.caption(size: 9.sp)),
            SizedBox(width: 6.w),
            ...List.generate(4, (i) {
              return Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    color: _heatmapColors[i],
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(width: 6.w),
            Text(Lang.trailMore, style: AppTextStyles.caption(size: 9.sp)),
          ],
        ),
      ],
    );
  }

  Widget _buildHeatmapGrid(List<HeatmapCell> cells) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 5.w,
        mainAxisSpacing: 5.h,
        childAspectRatio: 1,
      ),
      itemCount: cells.length,
      itemBuilder: (_, i) {
        final cell = cells[i];
        final level = cell.level.clamp(0, 3);
        final active = level > 0;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: _heatmapColors[level],
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: active
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : AppColors.border.withValues(alpha: 0.7),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.primaryLight.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }

  Widget _buildMoodMosaic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 6.w,
            mainAxisSpacing: 6.h,
            childAspectRatio: 1,
          ),
          itemCount: controller.moodCells.length,
          itemBuilder: (_, i) {
            final mood = controller.moodCells[i];
            final filled = mood >= 0;
            return Container(
              decoration: BoxDecoration(
                color: filled ? _moodColors[mood.clamp(0, 5)] : AppColors.rowAlt,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: filled
                      ? Colors.white.withValues(alpha: 0.35)
                      : AppColors.border,
                ),
                boxShadow: filled
                    ? [
                        BoxShadow(
                          color: _moodColors[mood.clamp(0, 5)].withValues(alpha: 0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          children: List.generate(6, (i) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: _moodColors[i],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  Lang.moodLabels[i],
                  style: AppTextStyles.caption(size: 9.sp),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRhythm() {
    final weekdays = Lang.calendarWeekdays;
    final maxWd = controller.weekdayCounts.isEmpty
        ? 1
        : controller.weekdayCounts.reduce((a, b) => a > b ? a : b).clamp(1, 999);
    final maxBarH = 56.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 78.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final count = i < controller.weekdayCounts.length
                  ? controller.weekdayCounts[i]
                  : 0;
              final ratio = maxWd == 0 ? 0.0 : count / maxWd;
              final h = (ratio * maxBarH).clamp(6.h, maxBarH);
              final isTop = weekdays[i] == controller.topWeekday;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (count > 0)
                        Text(
                          '$count',
                          style: AppTextStyles.caption(
                            size: 9.sp,
                            color: isTop ? AppColors.cta : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (count > 0) SizedBox(height: 4.h),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        height: h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: isTop
                                ? [AppColors.cta, AppColors.cta.withValues(alpha: 0.55)]
                                : [
                                    AppColors.primaryLight,
                                    AppColors.primaryLight.withValues(alpha: 0.45),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: List.generate(7, (i) {
            final isTop = weekdays[i] == controller.topWeekday;
            return Expanded(
              child: Text(
                weekdays[i].substring(0, 2),
                style: AppTextStyles.caption(
                  size: 9.sp,
                  color: isTop ? AppColors.primary : AppColors.textSecondary,
                ).copyWith(fontWeight: isTop ? FontWeight.w700 : FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            );
          }),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _RhythmInsight(
                icon: Icons.calendar_today_rounded,
                label: Lang.trailTopDay,
                value: controller.topWeekday,
                accent: AppColors.primary,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _RhythmInsight(
                icon: Icons.schedule_rounded,
                label: Lang.trailTopTime,
                value: controller.topTimeBucket,
                accent: AppColors.cta,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMilestones() {
    final unlocked = controller.unlockedBadges.value;
    final total = controller.badges.length;
    final progress = total == 0 ? 0.0 : unlocked / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8.h,
                  backgroundColor: AppColors.rowAlt,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              '$unlocked/$total',
              style: AppTextStyles.body(
                weight: FontWeight.w700,
                size: 13.sp,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 1.28,
          ),
          itemCount: controller.badges.length,
          itemBuilder: (_, i) {
            final badge = controller.badges[i];
            return _BadgeCard(
              badge: badge,
              icon: _badgeIcon(badge.id),
            );
          },
        ),
      ],
    );
  }
}

class _HeroStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HeroStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: Colors.white.withValues(alpha: 0.95)),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption(
                    size: 10.sp,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: AppTextStyles.body(
                    weight: FontWeight.w700,
                    size: 13.sp,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RhythmInsight extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _RhythmInsight({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 16.sp, color: accent),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption(size: 10.sp)),
                Text(
                  value,
                  style: AppTextStyles.body(weight: FontWeight.w700, size: 13.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final TrailBadge badge;
  final IconData icon;

  const _BadgeCard({required this.badge, required this.icon});

  @override
  Widget build(BuildContext context) {
    final unlocked = badge.unlocked;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: unlocked
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.cardBg,
                  AppColors.peach.withValues(alpha: 0.5),
                ],
              )
            : null,
        color: unlocked ? null : AppColors.rowAlt,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: unlocked
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.border,
          width: unlocked ? 1.5 : 1,
        ),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              gradient: unlocked
                  ? LinearGradient(
                      colors: [AppColors.primaryLight, AppColors.primary],
                    )
                  : null,
              color: unlocked ? null : AppColors.divider,
              shape: BoxShape.circle,
            ),
            child: Icon(
              unlocked ? icon : Icons.lock_outline_rounded,
              size: 18.sp,
              color: unlocked ? Colors.white : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            badge.title,
            style: AppTextStyles.body(
              weight: FontWeight.w700,
              size: 13.sp,
              color: unlocked ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: Text(
              badge.description,
              style: AppTextStyles.caption(size: 10.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
