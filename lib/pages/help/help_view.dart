import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/app_sub_page_bar.dart';
import '../../components/app_ui_kit.dart';
import '../../components/grid_paper_background.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'help_logic.dart';

class HelpView extends GetView<HelpLogic> {
  const HelpView({super.key});

  static const _sectionIcons = [
    Icons.edit_note_rounded,
    Icons.calendar_month_rounded,
    Icons.mail_outline_rounded,
    Icons.file_download_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final sections = [
      (Lang.helpWriteTitle, Lang.helpWriteBody),
      (Lang.helpCalendarTitle, Lang.helpCalendarBody),
      (Lang.helpFutureTitle, Lang.helpFutureBody),
      (Lang.helpExportTitle, Lang.helpExportBody),
    ];

    return GridPaperBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              AppSubPageBar(
                title: Lang.helpTitle,
                subtitle: Lang.appName,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  children: [
                    Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.peach, AppColors.cardBg],
                        ),
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        Lang.helpIntro,
                        style: AppTextStyles.body(size: 14.sp),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    ...sections.asMap().entries.map((e) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: AppFormCard(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  _sectionIcons[e.key],
                                  size: 22.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.value.$1,
                                      style: AppTextStyles.pageTitle(size: 16.sp),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      e.value.$2,
                                      style: AppTextStyles.body(
                                        color: AppColors.textSecondary,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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
