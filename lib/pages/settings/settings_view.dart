import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/app_sub_page_bar.dart';
import '../../components/app_ui_kit.dart';
import '../../components/grid_paper_background.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'settings_logic.dart';

class SettingsView extends GetView<SettingsLogic> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridPaperBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSubPageBar(title: Lang.settingsTitle),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppFormCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppUi.fieldLabel(Lang.settingsNickname),
                            TextField(
                              controller: controller.nicknameController,
                              style: AppTextStyles.body(
                                color: AppPalette.textPrimary(context),
                              ),
                              decoration: AppUi.inputDecoration(
                                context: context,
                                hint: Lang.settingsNicknameHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      AppFormCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppUi.fieldLabel(Lang.settingsStartYear),
                            Obx(
                                  () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppCircleIconButton(
                                    icon: Icons.remove_rounded,
                                    onTap: controller.decrementStartYear,
                                  ),
                                  SizedBox(width: 20.w),
                                  Text(
                                    '${controller.startYear.value}',
                                    style: AppTextStyles.displayTitle(size: 36.sp),
                                  ),
                                  SizedBox(width: 20.w),
                                  AppCircleIconButton(
                                    icon: Icons.add_rounded,
                                    onTap: controller.incrementStartYear,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      AppFormCard(
                        child: Obx(
                              () => Row(
                            children: [
                              Icon(Icons.dark_mode_outlined,
                                  size: 22.sp, color: AppColors.primary),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  Lang.settingsDarkMode,
                                  style: AppTextStyles.body(
                                    weight: FontWeight.w600,
                                    color: AppPalette.textPrimary(context),
                                  ),
                                ),
                              ),
                              Switch.adaptive(
                                value: controller.darkMode.value,
                                activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
                                thumbColor: WidgetStatePropertyAll(AppColors.primary),
                                onChanged: controller.setDarkMode,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Obx(
                            () => AppUi.primaryButton(
                          label: Lang.editDone,
                          icon: Icons.save_outlined,
                          onPressed: controller.save,
                          loading: controller.saving.value,
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
}
