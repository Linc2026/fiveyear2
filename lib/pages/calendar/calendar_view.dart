import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/grid_paper_background.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'calendar_logic.dart';

class CalendarView extends GetView<CalendarLogic> {
  const CalendarView({super.key});

  static final _weekdays = Lang.calendarWeekdays;

  @override
  Widget build(BuildContext context) {
    return GridPaperBackground(
      child: SafeArea(
        child: Obx(() {
          controller.loading.value;
          return Column(
            children: [
              _buildTopBar(context),
              _buildMonthHero(context),
              _buildSummaryStrip(context),
              Expanded(child: _buildNotebookCalendar(context)),
              _buildLegend(context),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Lang.calendarTitle,
            style: AppTextStyles.pageTitle(context: context),
          ),
          SizedBox(height: 2.h),
          Text(
            Lang.calendarSubtitle,
            style: AppTextStyles.caption(context: context),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHero(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
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
            _NavButton(
              icon: Icons.chevron_left_rounded,
              onTap: controller.prevMonth,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    controller.monthDisplay,
                    style: AppTextStyles.displayTitle(size: 32.sp, context: context),
                    textAlign: TextAlign.center,
                  ),
                  if (!controller.isCurrentMonth) ...[
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: controller.goToCurrentMonth,
                      child: Text(
                        Lang.calendarGoThisMonth,
                        style: AppTextStyles.caption(color: AppColors.cta),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _NavButton(
              icon: Icons.chevron_right_rounded,
              onTap: controller.nextMonth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStrip(BuildContext context) {
    final now = DateTime.now();
    final todayMarked = controller.isCurrentMonth &&
        controller.markedDays.contains(now.day);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppPalette.primaryTint(context),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppPalette.border(context)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit_note_rounded,
                  size: 16.sp,
                  color: AppPalette.primary(context),
                ),
                SizedBox(width: 6.w),
                Text(
                  '${Lang.calendarMonthRecorded} ${controller.markedCount} ${Lang.calendarDays}',
                  style: AppTextStyles.caption(
                    context: context,
                    color: AppPalette.primary(context),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (controller.isCurrentMonth && todayMarked)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppPalette.accentSurface(context),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline_rounded,
                      size: 14.sp, color: AppColors.cta),
                  SizedBox(width: 4.w),
                  Text(
                    Lang.diaryToday,
                    style: AppTextStyles.caption(color: AppColors.cta, size: 11.sp),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotebookCalendar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
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
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(10.w, 14.h, 14.w, 14.h),
                    children: [
                      _buildWeekHeader(context),
                      SizedBox(height: 8.h),
                      _buildGrid(context),
                      SizedBox(height: 12.h),
                      Center(
                        child: Text(
                          Lang.calendarTapHint,
                          style: AppTextStyles.caption(size: 11.sp, context: context),
                        ),
                      ),
                    ],
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
      width: 24.w,
      color: AppPalette.rowAlt(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          6,
              (_) => Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.bindingHole(context),
              border: Border.all(color: AppPalette.border(context), width: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeekHeader(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        final isWeekend = i >= 5;
        return Expanded(
          child: Center(
            child: Text(
              _weekdays[i],
              style: AppTextStyles.caption(
                size: 12.sp,
                context: context,
                color: isWeekend
                    ? AppColors.secondary
                    : AppPalette.textSecondary(context),
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGrid(BuildContext context) {
    final total = controller.daysInMonth;
    final offset = controller.firstWeekday - 1;
    final cells = offset + total;
    final rows = (cells / 7).ceil();
    final now = DateTime.now();

    return Column(
      children: List.generate(rows, (row) {
        return Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Row(
            children: List.generate(7, (col) {
              final index = row * 7 + col;
              final day = index - offset + 1;
              if (day < 1 || day > total) {
                return Expanded(child: SizedBox(height: 52.h));
              }

              final marked = controller.markedDays.contains(day);
              final isToday = now.year == controller.displayYear.value &&
                  now.month == controller.displayMonth.value &&
                  now.day == day;
              final isWeekend = col >= 5;

              return Expanded(
                child: _DayCell(
                  day: day,
                  marked: marked,
                  isToday: isToday,
                  isWeekend: isWeekend,
                  onTap: () => controller.selectDay(day),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem(
            color: AppPalette.primary(context),
            hollow: false,
            label: Lang.calendarLegendRecorded,
          ),
          SizedBox(width: 20.w),
          _LegendItem(
            color: AppColors.cta,
            hollow: true,
            label: Lang.calendarLegendToday,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

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

class _DayCell extends StatelessWidget {
  final int day;
  final bool marked;
  final bool isToday;
  final bool isWeekend;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.marked,
    required this.isToday,
    required this.isWeekend,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.transparent;
    Border? border;
    Color textColor = AppPalette.textPrimary(context);

    if (isToday) {
      bg = AppPalette.accentSoft(context);
      border = Border.all(color: AppColors.cta, width: 1.5);
      textColor = AppColors.cta;
    } else if (marked) {
      bg = AppPalette.calendarDayMarked(context);
      border = Border.all(
        color: AppPalette.primary(context).withValues(alpha: 0.35),
      );
    } else if (isWeekend) {
      textColor = AppColors.secondary;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52.h,
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12.r),
            border: border,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$day',
                style: AppTextStyles.body(
                  size: 15.sp,
                  weight: isToday || marked ? FontWeight.w700 : FontWeight.w500,
                  color: textColor,
                ),
              ),
              SizedBox(height: 4.h),
              if (marked)
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.cta : AppPalette.primary(context),
                    shape: BoxShape.circle,
                  ),
                )
              else
                SizedBox(height: 6.w),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final bool hollow;
  final String label;

  const _LegendItem({
    required this.color,
    required this.hollow,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: hollow ? Colors.transparent : color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: hollow ? 1.5 : 0),
          ),
          child: hollow
              ? null
              : Center(
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTextStyles.caption(size: 11.sp, context: context),
        ),
      ],
    );
  }
}
