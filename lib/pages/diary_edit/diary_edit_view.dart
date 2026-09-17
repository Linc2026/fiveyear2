import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/app_sub_page_bar.dart';
import '../../components/app_ui_kit.dart';
import '../../components/grid_paper_background.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'diary_edit_logic.dart';

class DiaryEditView extends GetView<DiaryEditLogic> {
  const DiaryEditView({super.key});

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 0),
                child: Row(
                  children: [
                    AppCircleIconButton(
                      icon: Icons.close_rounded,
                      onTap: () => Get.back(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            Lang.editTitle,
                            style: AppTextStyles.pageTitle(size: 18.sp),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today_rounded,
                                  size: 13.sp, color: AppColors.primary),
                              SizedBox(width: 4.w),
                              Text(
                                controller.dateTitle,
                                style: AppTextStyles.caption(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (controller.existing != null)
                      AppCircleIconButton(
                        icon: Icons.delete_outline_rounded,
                        iconColor: AppColors.destructive,
                        onTap: controller.deleteEntry,
                      )
                    else
                      SizedBox(width: 44.w),
                    SizedBox(width: 8.w),
                    Material(
                      color: AppColors.cta,
                      borderRadius: BorderRadius.circular(14.r),
                      child: InkWell(
                        onTap: controller.save,
                        borderRadius: BorderRadius.circular(14.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          child: Text(
                            Lang.editDone,
                            style: AppTextStyles.body(
                              color: Colors.white,
                              weight: FontWeight.w700,
                              size: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppFormCard(child: _buildMoodSection()),
                      SizedBox(height: 12.h),
                      AppFormCard(
                        child: TextField(
                          controller: controller.contentController,
                          maxLines: 8,
                          style: AppTextStyles.body(size: 15.sp),
                          decoration: AppUi.inputDecoration(
                            hint: Lang.editContentHint,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      AppFormCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppUi.fieldLabel(Lang.editPhotoAdd),
                            _buildPhotoSection(),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      AppFormCard(
                        child: Column(
                          children: [
                            _buildMetaField(Icons.wb_sunny_outlined, Lang.editWeather,
                                controller.weatherController),
                            SizedBox(height: 12.h),
                            _buildMetaField(Icons.local_cafe_outlined, Lang.editScene,
                                controller.sceneController),
                            SizedBox(height: 12.h),
                            _buildMetaField(Icons.place_outlined, Lang.editLocation,
                                controller.locationController),
                            SizedBox(height: 12.h),
                            _buildMetaField(Icons.monitor_weight_outlined, Lang.editWeight,
                                controller.weightController,
                                keyboard: TextInputType.number),
                          ],
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

  Widget _buildMoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.emoji_emotions_outlined,
                size: 18.sp, color: AppColors.primary),
            SizedBox(width: 6.w),
            Text(Lang.editMood, style: AppTextStyles.body(weight: FontWeight.w700)),
          ],
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              final selected = controller.mood.value == i;
              return Material(
                color: selected ? AppColors.accentYellow : AppColors.rowAlt,
                shape: CircleBorder(
                  side: BorderSide(
                    color: selected ? AppColors.primary : AppColors.border,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: () => controller.mood.value = i,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Icon(
                      _moodIcons[i],
                      size: 22.sp,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Obx(() {
      final path = controller.photoPath.value;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.pickPhoto,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            width: 110.w,
            height: 110.w,
            decoration: BoxDecoration(
              color: AppColors.peach,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
                style: path == null ? BorderStyle.solid : BorderStyle.none,
              ),
            ),
            child: path != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      AppLocalImage(
                        path: path,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: controller.removePhoto,
                          child: Container(
                            padding: EdgeInsets.all(5.w),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close, size: 14.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined,
                          size: 30.sp, color: AppColors.primary),
                      SizedBox(height: 6.h),
                      Text(
                        Lang.editPhotoAdd,
                        style: AppTextStyles.caption(color: AppColors.primary),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }

  Widget _buildMetaField(
    IconData icon,
    String label,
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 14.h),
          child: Icon(icon, size: 20.sp, color: AppColors.secondary),
        ),
        SizedBox(width: 10.w),
        SizedBox(
          width: 52.w,
          child: Padding(
            padding: EdgeInsets.only(top: 14.h),
            child: Text(label, style: AppTextStyles.caption()),
          ),
        ),
        Expanded(
          child: TextField(
            controller: ctrl,
            keyboardType: keyboard,
            style: AppTextStyles.body(size: 14.sp),
            decoration: AppUi.inputDecoration(hint: Lang.editCustom),
          ),
        ),
      ],
    );
  }
}
