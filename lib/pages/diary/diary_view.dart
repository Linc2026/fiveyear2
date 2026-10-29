import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../components/app_ui_kit.dart';
import '../../components/grid_paper_background.dart';
import '../../db_five_year_diary/db_five_year_diary_entity.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'diary_logic.dart';

class DiaryView extends GetView<DiaryLogic> {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridPaperBackground(
      child: SafeArea(
        child: Obx(() {
          controller.loading.value;
          return Stack(
            children: [
              Column(
                children: [
                  _buildTopBar(context),
                  _buildQuoteBanner(context),
                  _buildDateHero(context),
                  _buildProgressStrip(context),
                  Expanded(child: _buildNotebook(context)),
                ],
              ),
              if (controller.isSelectedToday)
                Positioned(
                  right: 20.w,
                  bottom: 20.h,
                  child: _buildWriteFab(),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 12.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Lang.diaryTitle,
                  style: AppTextStyles.pageTitle(context: context),
                ),
                SizedBox(height: 2.h),
                Text(
                  Lang.diarySubtitle,
                  style: AppTextStyles.caption(context: context),
                ),
              ],
            ),
          ),
          Material(
            color: AppPalette.surface(context),
            shape: CircleBorder(
              side: BorderSide(color: AppPalette.border(context)),
            ),
            child: InkWell(
              onTap: controller.openSettings,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Icon(
                  Icons.tune_rounded,
                  size: 20.sp,
                  color: AppPalette.primary(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteBanner(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppPalette.surfaceMuted(context),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppPalette.border(context)),
        ),
        child: Row(
          children: [
            Text(
              Lang.diaryQuoteOpen,
              style: AppTextStyles.quote(
                context: context,
                color: AppPalette.quoteTint(context),
              ),
            ),
            Expanded(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.quote(context: context),
                  children: [
                    const TextSpan(text: Lang.diaryQuotePrefix),
                    TextSpan(
                      text: Lang.diaryQuoteHighlight,
                      style: AppTextStyles.quote(
                        context: context,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              Lang.diaryQuoteClose,
              style: AppTextStyles.quote(
                context: context,
                color: AppPalette.quoteTint(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHero(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
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
          children: [
            _DateNavButton(
              icon: Icons.chevron_left_rounded,
              onTap: controller.prevDay,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    controller.dateLabel,
                    style: AppTextStyles.displayTitle(size: 36.sp, context: context),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 13.sp,
                        color: AppPalette.textSecondary(context),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        controller.weekdayLabel,
                        style: AppTextStyles.caption(context: context),
                      ),
                      if (controller.isSelectedToday) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppPalette.accentSoft(context),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            Lang.diaryToday,
                            style: AppTextStyles.caption(
                              color: AppColors.cta,
                              size: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!controller.isSelectedToday) ...[
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: controller.goToToday,
                      child: Text(
                        Lang.diaryGoToday,
                        style: AppTextStyles.caption(color: AppColors.cta),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _DateNavButton(
              icon: Icons.chevron_right_rounded,
              onTap: controller.nextDay,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStrip(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: Row(
        children: [
          Text(
            '${Lang.diaryFilled} ${controller.filledCount}/5 ${Lang.diaryYears}',
            style: AppTextStyles.caption(
              context: context,
              color: AppPalette.primary(context),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Row(
              children: List.generate(5, (i) {
                final filled = i < controller.filledCount;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 6.h,
                    margin: EdgeInsets.only(right: i < 4 ? 6.w : 0),
                    decoration: BoxDecoration(
                      color: filled
                          ? AppPalette.primary(context)
                          : AppPalette.rowAlt(context),
                      borderRadius: BorderRadius.circular(3.r),
                      border: Border.all(
                        color: filled
                            ? AppPalette.primary(context)
                            : AppPalette.border(context),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotebook(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppPalette.surfaceElevated(context),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppPalette.border(context)),
          boxShadow: [
            BoxShadow(
              color: AppPalette.cardShadow(context),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBindingStrip(context),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.loadData,
                  color: AppPalette.primary(context),
                  edgeOffset: 8,
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(12.w, 16.h, 16.w, 16.h),
                    itemCount: controller.yearRange.length,
                    separatorBuilder: (_, __) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        children: List.generate(
                          24,
                              (i) => Expanded(
                            child: Container(
                              height: 1,
                              margin: EdgeInsets.symmetric(horizontal: 1.w),
                              color: i.isEven
                                  ? AppPalette.border(context)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    itemBuilder: (_, i) {
                      final year = controller.yearRange[i];
                      return _YearTimelineEntry(
                        year: year,
                        month: controller.selectedMonth.value,
                        day: controller.selectedDay.value,
                        entry: controller.entryForYear(year),
                        isCurrentYear: year == controller.currentYear,
                        onTap: () => controller.openEdit(year),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBindingStrip(BuildContext context) {
    return Container(
      width: 28.w,
      color: AppPalette.rowAlt(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          8,
              (_) => Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.bindingHole(context),
              border: Border.all(
                color: AppPalette.border(context),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWriteFab() {
    return Material(
      elevation: 6,
      shadowColor: AppColors.cta.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(28.r),
      color: AppColors.cta,
      child: InkWell(
        onTap: controller.writeToday,
        borderRadius: BorderRadius.circular(28.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_rounded, color: Colors.white, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                Lang.diaryWriteToday,
                style: AppTextStyles.body(
                  color: Colors.white,
                  size: 14.sp,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DateNavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.surface(context),
      shape: CircleBorder(side: BorderSide(color: AppPalette.border(context))),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Icon(icon, size: 26.sp, color: AppPalette.primary(context)),
        ),
      ),
    );
  }
}

class _YearTimelineEntry extends StatelessWidget {
  final int year;
  final int month;
  final int day;
  final DiaryEntry? entry;
  final bool isCurrentYear;
  final VoidCallback onTap;

  const _YearTimelineEntry({
    required this.year,
    required this.month,
    required this.day,
    required this.entry,
    required this.isCurrentYear,
    required this.onTap,
  });

  static const _moodIcons = [
    Icons.sentiment_very_satisfied_rounded,
    Icons.sentiment_satisfied_rounded,
    Icons.sentiment_neutral_rounded,
    Icons.bedtime_rounded,
    Icons.sentiment_dissatisfied_rounded,
    Icons.sentiment_very_dissatisfied_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final hasContent = entry?.hasContent ?? false;
    final now = DateTime.now();
    final isFuture = DateTime(year, month, day).isAfter(now);
    final weekday = DateFormat('EEE', 'en_US').format(DateTime(year, month, day));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isFuture ? null : onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: hasContent
                ? AppPalette.highlightFill(context)
                : (isCurrentYear && !isFuture
                ? AppPalette.rowAlt(context)
                : Colors.transparent),
            borderRadius: BorderRadius.circular(14.r),
            border: isCurrentYear && !isFuture
                ? Border.all(color: AppColors.cta.withValues(alpha: 0.45))
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasContent
                          ? AppPalette.primary(context)
                          : AppPalette.border(context),
                      border: Border.all(
                        color: hasContent
                            ? AppPalette.primary(context)
                            : AppPalette.textSecondary(context),
                        width: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppPalette.yearChipBg(
                              context,
                              hasContent: hasContent,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            '$year',
                            style: AppTextStyles.pageTitle(
                              size: 18.sp,
                              context: context,
                              color: AppPalette.primary(context),
                            ),
                          ),
                        ),
                        if (hasContent) ...[
                          SizedBox(width: 8.w),
                          Icon(
                            _moodIcons[entry!.mood.clamp(0, 5)],
                            size: 20.sp,
                            color: AppColors.secondary,
                          ),
                        ],
                        if (isCurrentYear) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppPalette.accentSoft(context),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              Lang.diaryToday,
                              style: AppTextStyles.caption(
                                color: AppColors.cta,
                                size: 10.sp,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (hasContent)
                          Text(
                            weekday,
                            style: AppTextStyles.caption(
                              size: 11.sp,
                              context: context,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    if (hasContent) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              entry!.content,
                              style: AppTextStyles.body(
                                size: 14.sp,
                                context: context,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (entry!.photoPath != null &&
                              entry!.photoPath!.isNotEmpty) ...[
                            SizedBox(width: 10.w),
                            _PolaroidThumb(path: entry!.photoPath!),
                          ],
                        ],
                      ),
                      if (entry!.weather.isNotEmpty ||
                          entry!.location.isNotEmpty ||
                          entry!.weight != null) ...[
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 6.h,
                          children: [
                            if (entry!.weather.isNotEmpty)
                              _MetaTag(
                                Icons.wb_sunny_outlined,
                                entry!.weather,
                              ),
                            if (entry!.weight != null)
                              _MetaTag(
                                Icons.monitor_weight_outlined,
                                '${entry!.weight!.toStringAsFixed(1)}kg',
                              ),
                            if (entry!.location.isNotEmpty)
                              _MetaTag(Icons.place_outlined, entry!.location),
                          ],
                        ),
                      ],
                    ] else
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              isFuture
                                  ? Lang.diaryFutureHint
                                  : Lang.diaryEmptyHint,
                              style: AppTextStyles.caption(
                                context: context,
                              ).copyWith(fontStyle: FontStyle.italic),
                            ),
                          ),
                          if (!isFuture)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppPalette.accentSurface(context),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_rounded,
                                      size: 16.sp, color: AppColors.cta),
                                  SizedBox(width: 4.w),
                                  Text(
                                    Lang.diaryAdd,
                                    style: AppTextStyles.caption(
                                      color: AppColors.cta,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _PolaroidThumb extends StatelessWidget {
  final String path;

  const _PolaroidThumb({required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppPalette.polaroidBg(context),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppPalette.border(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: AppLocalImage(
          path: path,
          width: 52.w,
          height: 52.w,
        ),
      ),
    );
  }
}

class _MetaTag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaTag(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppPalette.surface(context),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppPalette.border(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: AppColors.secondary),
          SizedBox(width: 4.w),
          Text(
            text,
            style: AppTextStyles.caption(size: 11.sp, context: context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
