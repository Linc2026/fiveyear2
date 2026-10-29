import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/app_sub_page_bar.dart';
import '../../components/app_ui_kit.dart';
import '../../components/grid_paper_background.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'stats_logic.dart';

class StatsView extends GetView<StatsLogic> {
  const StatsView({super.key});

  static const _moodIcons = [
    Icons.sentiment_very_satisfied_rounded,
    Icons.sentiment_satisfied_rounded,
    Icons.sentiment_neutral_rounded,
    Icons.bedtime_rounded,
    Icons.sentiment_dissatisfied_rounded,
    Icons.sentiment_very_dissatisfied_rounded,
  ];

  static const _kpiIcons = [
    Icons.text_fields_rounded,
    Icons.photo_camera_rounded,
    Icons.date_range_rounded,
    Icons.emoji_emotions_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return GridPaperBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Obx(() {
            controller.loading.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSubPageBar(
                  title: Lang.statsTitle,
                  subtitle: Lang.statsSubtitle,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.loadData,
                    color: AppPalette.primary(context),
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                      children: [
                        _buildPeriodFilter(context),
                        SizedBox(height: 14.h),
                        _buildHeroCard(context),
                        SizedBox(height: 14.h),
                        _buildKpiGrid(context),
                        SizedBox(height: 8.h),
                        _buildSection(
                          context: context,
                          icon: Icons.show_chart_rounded,
                          title: Lang.statsTrend,
                          child: _buildTrend(context),
                        ),
                        _buildSection(
                          context: context,
                          icon: Icons.emoji_emotions_outlined,
                          title: Lang.statsMood,
                          child: _buildMood(context),
                        ),
                        _buildSection(
                          context: context,
                          icon: Icons.place_outlined,
                          title: Lang.statsLocation,
                          child: _buildLocations(context),
                        ),
                        _buildSection(
                          context: context,
                          icon: Icons.monitor_weight_outlined,
                          title: Lang.statsWeight,
                          child: _buildWeight(context),
                        ),
                        _buildSection(
                          context: context,
                          icon: Icons.insights_outlined,
                          title: Lang.statsActivity,
                          child: _buildActivity(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPeriodFilter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppPalette.surfaceElevated(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppPalette.border(context)),
      ),
      child: Row(
        children: [
          _PeriodTab(
            label: Lang.statsPeriodMonth,
            selected: controller.period.value == 'month',
            onTap: () => controller.setPeriod('month'),
          ),
          _PeriodTab(
            label: Lang.statsPeriodYear,
            selected: controller.period.value == 'year',
            onTap: () => controller.setPeriod('year'),
          ),
          _PeriodTab(
            label: Lang.statsPeriodAll,
            selected: controller.period.value == 'all',
            onTap: () => controller.setPeriod('all'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppPalette.peach(context),
            AppPalette.surfaceElevated(context),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppPalette.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppPalette.cardShadow(context),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Lang.statsHeroEntries,
                  style: AppTextStyles.caption(context: context),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${controller.totalEntries.value}',
                  style: AppTextStyles.displayTitle(size: 48.sp, context: context),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _HeroBadge(
                icon: Icons.local_fire_department_rounded,
                label: '${Lang.statsHeroStreak} ${controller.streak.value}',
                color: AppColors.secondary,
              ),
              SizedBox(height: 8.h),
              _HeroBadge(
                icon: Icons.timeline_rounded,
                label:
                '${Lang.statsHeroDaily} ${controller.dailyAvg.value.toStringAsFixed(2)}',
                color: AppColors.cta,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(BuildContext context) {
    final kpis = [
      (Lang.statsKpiWords, '${controller.totalWords.value}'),
      (Lang.statsKpiPhotos, '${controller.photoCount.value}'),
      (Lang.statsKpiYears, '${controller.coveredYears.value}'),
      (Lang.statsKpiMood, '${controller.moodCount.value}'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1.7,
      ),
      itemCount: kpis.length,
      itemBuilder: (_, i) {
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppPalette.surfaceElevated(context),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppPalette.border(context)),
          ),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppPalette.peach(context),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  _kpiIcons[i],
                  size: 20.sp,
                  color: AppPalette.primary(context),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kpis[i].$1,
                      style: AppTextStyles.caption(size: 11.sp, context: context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      kpis[i].$2,
                      style: AppTextStyles.pageTitle(
                        size: 20.sp,
                        context: context,
                        color: AppPalette.primary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppPalette.surfaceElevated(context),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppPalette.border(context)),
          boxShadow: [
            BoxShadow(
              color: AppPalette.cardShadow(context),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
                color: AppPalette.sectionHeaderBg(context),
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: AppPalette.primaryTint(context),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        icon,
                        size: 18.sp,
                        color: AppPalette.primary(context),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      title,
                      style: AppTextStyles.pageTitle(size: 16.sp, context: context),
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

  Widget _buildTrend(BuildContext context) {
    if (controller.trendValues.isEmpty) {
      return _emptyHint(context, Lang.emptyNoData);
    }
    return SimpleBarChart(
      values: controller.trendValues,
      labels: controller.trendLabels,
      barColor: AppColors.cta,
    );
  }

  Widget _buildMood(BuildContext context) {
    if (controller.moodStats.isEmpty) {
      return _emptyHint(context, Lang.emptyNoData);
    }
    final max = controller.moodStats
        .map((e) => e.count)
        .reduce((a, b) => a > b ? a : b);
    return Column(
      children: controller.moodStats.map((m) {
        final idx = m.mood.clamp(0, 5);
        return Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h, right: 8.w),
                child: Icon(_moodIcons[idx], size: 20.sp, color: AppColors.secondary),
              ),
              Expanded(
                child: ProgressBarItem(
                  label: Lang.moodLabels[idx],
                  progress: max == 0 ? 0 : m.count / max,
                  trailing: '${m.count}',
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocations(BuildContext context) {
    if (controller.locations.isEmpty) {
      return _emptyHint(context, Lang.emptyNoLocation);
    }
    final max = controller.locations.first.count;
    return Column(
      children: controller.locations.asMap().entries.map((e) {
        final loc = e.value;
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              _RankBadge(rank: e.key + 1),
              SizedBox(width: 10.w),
              Expanded(
                child: ProgressBarItem(
                  label: loc.location,
                  progress: loc.count / max,
                  trailing: '${loc.count}',
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeight(BuildContext context) {
    if (controller.weights.isEmpty) {
      return _emptyHint(context, Lang.emptyNoWeight);
    }
    return Column(
      children: controller.weights.map((w) {
        final date = DateTime.fromMillisecondsSinceEpoch(w.timestamp);
        final dateStr =
            '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppPalette.rowAlt(context),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppPalette.border(context)),
          ),
          child: Row(
            children: [
              Icon(Icons.circle, size: 8.sp, color: AppColors.cta),
              SizedBox(width: 10.w),
              Text(
                dateStr,
                style: AppTextStyles.caption(context: context),
              ),
              const Spacer(),
              Text(
                '${w.weight.toStringAsFixed(1)} kg',
                style: AppTextStyles.body(
                  size: 14.sp,
                  weight: FontWeight.w700,
                  context: context,
                  color: AppPalette.primary(context),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivity(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActivityChip(
            icon: Icons.wb_sunny_outlined,
            label: Lang.statsWeatherTags,
            count: controller.weatherTags.value,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _ActivityChip(
            icon: Icons.local_cafe_outlined,
            label: Lang.statsSceneTags,
            count: controller.sceneTags.value,
            color: AppColors.cta,
          ),
        ),
      ],
    );
  }

  Widget _emptyHint(BuildContext context, String text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(text, style: AppTextStyles.caption(context: context)),
      ),
    );
  }
}

class _PeriodTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? AppPalette.primary(context) : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(
                size: 13.sp,
                weight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? Colors.white
                    : AppPalette.textSecondary(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _HeroBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.caption(color: color, size: 11.sp),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;

  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    final colors = [AppColors.primary, AppColors.cta, AppColors.secondary];
    final color = colors[(rank - 1).clamp(0, 2)];
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: AppTextStyles.body(
            size: 12.sp,
            weight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _ActivityChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _ActivityChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24.sp, color: color),
          SizedBox(height: 8.h),
          Text(
            '$count',
            style: AppTextStyles.pageTitle(size: 22.sp, color: color),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppTextStyles.caption(size: 11.sp),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
