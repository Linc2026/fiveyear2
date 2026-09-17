import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/app_ui_kit.dart';
import '../../components/grid_paper_background.dart';
import '../../db_five_year_diary/db_five_year_diary_entity.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'memories_logic.dart';

class MemoriesView extends GetView<MemoriesLogic> {
  const MemoriesView({super.key});

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
    return GridPaperBackground(
      child: SafeArea(
        child: Obx(() {
          controller.loading.value;

          if (!controller.hasData) {
            return Column(
              children: [
                _buildTopBar(),
                Expanded(child: _buildEmptyState()),
              ],
            );
          }

          final entry = controller.randomEntry.value;
          final photos = controller.photoEntries;

          return RefreshIndicator(
            onRefresh: controller.loadData,
            color: AppColors.primary,
            child: ListView(
              padding: EdgeInsets.only(bottom: 24.h),
              children: [
                _buildTopBar(),
                _buildSummaryStrip(),
                if (entry != null) _buildRandomHero(entry),
                if (photos.isNotEmpty) ...[
                  _buildPhotoWallHeader(),
                  _buildPhotoWall(photos),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                    child: Center(
                      child: Text(
                        Lang.memoriesWallHint,
                        style: AppTextStyles.caption(size: 11.sp),
                      ),
                    ),
                  ),
                ],
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
          Text(Lang.memoriesTitle, style: AppTextStyles.pageTitle()),
          SizedBox(height: 2.h),
          Text(Lang.memoriesSubtitle, style: AppTextStyles.caption()),
        ],
      ),
    );
  }

  Widget _buildSummaryStrip() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Row(
        children: [
          _SummaryChip(
            icon: Icons.photo_library_rounded,
            label: '${controller.photoCount} ${Lang.memoriesPhotoCount}',
            color: AppColors.primary,
          ),
          SizedBox(width: 10.w),
          _SummaryChip(
            icon: Icons.auto_stories_rounded,
            label: Lang.memoriesRandom,
            color: AppColors.cta,
          ),
        ],
      ),
    );
  }

  Widget _buildRandomHero(DiaryEntry entry) {
    final years = controller.yearsFromNow(entry);
    final hasPhoto =
        entry.photoPath != null && entry.photoPath!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 12.w, 14.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.peach,
                          AppColors.peach.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(
                            Icons.shuffle_rounded,
                            size: 22.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Lang.memoriesRandom,
                                style: AppTextStyles.pageTitle(size: 18.sp),
                              ),
                              Text(
                                controller.formatDate(entry),
                                style: AppTextStyles.caption(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: AppColors.cardBg,
                          shape: CircleBorder(
                            side: BorderSide(color: AppColors.border),
                          ),
                          child: InkWell(
                            onTap: controller.refreshRandom,
                            customBorder: const CircleBorder(),
                            child: Padding(
                              padding: EdgeInsets.all(10.w),
                              child: Icon(
                                Icons.refresh_rounded,
                                size: 20.sp,
                                color: AppColors.cta,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _moodIcons[entry.mood.clamp(0, 5)],
                              size: 22.sp,
                              color: AppColors.secondary,
                            ),
                            SizedBox(width: 8.w),
                            if (years > 0)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.cta.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  '$years ${Lang.memoriesYearsAgo}',
                                  style: AppTextStyles.caption(
                                    color: AppColors.cta,
                                    size: 11.sp,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        if (hasPhoto) ...[
                          _PolaroidFrame(
                            path: entry.photoPath!,
                            onTap: () => controller.openPhoto(entry.photoPath!),
                          ),
                          SizedBox(height: 14.h),
                        ],
                        Text(
                          entry.content,
                          style: AppTextStyles.body(size: 15.sp),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (entry.weather.isNotEmpty ||
                            entry.location.isNotEmpty) ...[
                          SizedBox(height: 12.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 6.h,
                            children: [
                              if (entry.weather.isNotEmpty)
                                _MetaTag(Icons.wb_sunny_outlined, entry.weather),
                              if (entry.location.isNotEmpty)
                                _MetaTag(Icons.place_outlined, entry.location),
                            ],
                          ),
                        ],
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                color: AppColors.cta.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12.r),
                                child: InkWell(
                                  onTap: () => _showMemorySheet(entry),
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.menu_book_rounded,
                                            size: 18.sp, color: AppColors.cta),
                                        SizedBox(width: 6.w),
                                        Text(
                                          Lang.memoriesReadMore,
                                          style: AppTextStyles.body(
                                            color: AppColors.cta,
                                            size: 14.sp,
                                            weight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Material(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                child: InkWell(
                                  onTap: () => controller.openEntryInDiary(entry),
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.calendar_today_rounded,
                                            size: 18.sp, color: AppColors.primary),
                                        SizedBox(width: 6.w),
                                        Text(
                                          Lang.memoriesViewDiary,
                                          style: AppTextStyles.body(
                                            color: AppColors.primary,
                                            size: 14.sp,
                                            weight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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

  Widget _buildPhotoWallHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
      child: Row(
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
          Text(Lang.memoriesPhotos, style: AppTextStyles.pageTitle(size: 18.sp)),
          const Spacer(),
          Text(
            '${controller.photoCount}',
            style: AppTextStyles.displayTitle(size: 24.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoWall(List<DiaryEntry> photos) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.85,
        ),
        itemCount: photos.length,
        itemBuilder: (_, i) {
          final e = photos[i];
          final rotation = (i % 3 - 1) * 0.03;
          return Transform.rotate(
            angle: rotation,
            child: _PhotoWallItem(
              entry: e,
              dateLabel: controller.formatDate(e),
              onTap: () => controller.openPhoto(e.photoPath!),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: AppColors.peach,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_stories_outlined,
                size: 48.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              Lang.memoriesEmpty,
              style: AppTextStyles.body(
                color: AppColors.textSecondary,
                size: 15.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Material(
              elevation: 4,
              shadowColor: AppColors.cta.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(26.r),
              color: AppColors.cta,
              child: InkWell(
                onTap: controller.goWriteDiary,
                borderRadius: BorderRadius.circular(26.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_rounded, color: Colors.white, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        Lang.memoriesWrite,
                        style: AppTextStyles.body(
                          color: Colors.white,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMemorySheet(DiaryEntry entry) {
    Get.bottomSheet(
      AppSheetContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppUi.sheetHandle(),
            AppUi.sheetTitle(Lang.memoriesRandom),
            SizedBox(height: 8.h),
            Text(
              controller.formatDate(entry),
              style: AppTextStyles.caption(color: AppColors.primary),
            ),
            SizedBox(height: 12.h),
            Text(entry.content, style: AppTextStyles.body(size: 15.sp)),
            if (entry.photoPath != null && entry.photoPath!.isNotEmpty) ...[
              SizedBox(height: 16.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AppLocalImage(
                  path: entry.photoPath!,
                  width: double.infinity,
                  height: 180.h,
                ),
              ),
            ],
            SizedBox(height: 16.h),
            AppUi.primaryButton(
              label: Lang.diaryTitle,
              icon: Icons.menu_book_rounded,
              onPressed: () {
                Get.back();
                controller.openEntryInDiary(entry);
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 6.w),
          Text(label, style: AppTextStyles.caption(color: color)),
        ],
      ),
    );
  }
}

class _PolaroidFrame extends StatelessWidget {
  final String path;
  final VoidCallback onTap;

  const _PolaroidFrame({required this.path, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppLocalImage(
            path: path,
            width: double.infinity,
            height: 160.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}

class _PhotoWallItem extends StatelessWidget {
  final DiaryEntry entry;
  final String dateLabel;
  final VoidCallback onTap;

  const _PhotoWallItem({
    required this.entry,
    required this.dateLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 20.w),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AppLocalImage(
                  path: entry.photoPath!,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                dateLabel,
                style: AppTextStyles.caption(
                  color: AppColors.primary,
                  size: 11.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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
        color: AppColors.rowAlt,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: AppColors.secondary),
          SizedBox(width: 4.w),
          Text(
            text,
            style: AppTextStyles.caption(size: 11.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
