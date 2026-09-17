import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/app_sub_page_bar.dart';
import '../../components/app_ui_kit.dart';
import '../../components/grid_paper_background.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'future_message_logic.dart';

class FutureMessageView extends GetView<FutureMessageLogic> {
  const FutureMessageView({super.key});

  bool get _isSubPage => Get.currentRoute == '/five_future_message';

  @override
  Widget build(BuildContext context) {
    return GridPaperBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Obx(() {
            controller.unlocked.value;
            controller.daysLeft.value;
            controller.saving.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isSubPage)
                  AppSubPageBar(
                    title: Lang.futureTitle,
                    subtitle: Lang.futureSubtitle,
                  )
                else
                  _buildTabHeader(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.loadData,
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusCard(),
                          SizedBox(height: 14.h),
                          AppFormCard(
                            child: TextField(
                              controller: controller.contentController,
                              maxLines: 12,
                              readOnly: controller.unlocked.value,
                              style: AppTextStyles.body(size: 15.sp),
                              decoration: AppUi.inputDecoration(
                                hint: Lang.futureEditHint,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          if (!controller.unlocked.value)
                            AppUi.primaryButton(
                              label: Lang.futureSave,
                              icon: Icons.save_outlined,
                              onPressed: controller.save,
                              loading: controller.saving.value,
                            ),
                        ],
                      ),
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

  Widget _buildTabHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Lang.futureTitle, style: AppTextStyles.pageTitle()),
          SizedBox(height: 2.h),
          Text(Lang.futureSubtitle, style: AppTextStyles.caption()),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.peach,
            AppColors.cardBg,
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              controller.unlocked.value
                  ? Icons.lock_open_rounded
                  : Icons.lock_clock_rounded,
              color: AppColors.primary,
              size: 26.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.unlocked.value
                      ? Lang.futureUnlocked
                      : Lang.futureLocked,
                  style: AppTextStyles.body(
                    weight: FontWeight.w700,
                  ),
                ),
                if (!controller.unlocked.value)
                  Text(
                    '${Lang.futureCountdown} ${controller.daysLeft.value} ${Lang.futureDays}',
                    style: AppTextStyles.caption(
                      color: AppColors.cta,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
