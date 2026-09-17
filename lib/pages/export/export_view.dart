import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/app_sub_page_bar.dart';
import '../../components/app_ui_kit.dart';
import '../../components/grid_paper_background.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'export_logic.dart';

class ExportView extends GetView<ExportLogic> {
  const ExportView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridPaperBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSubPageBar(
                title: Lang.exportTitle,
                subtitle: Lang.exportSubtitle,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: AppFormCard(
                    child: Column(
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: AppColors.peach,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(
                            Icons.table_chart_outlined,
                            size: 40.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          Lang.exportSubtitle,
                          style: AppTextStyles.caption(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        Obx(
                          () => AppUi.primaryButton(
                            label: Lang.exportButton,
                            icon: Icons.file_download_outlined,
                            onPressed: controller.exportCsv,
                            loading: controller.exporting.value,
                          ),
                        ),
                        Obx(() {
                          if (controller.exportPath.value == null) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: AppUi.outlineButton(
                              label: Lang.exportShare,
                              icon: Icons.share_outlined,
                              onPressed: controller.shareFile,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
