import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/grid_paper_background.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import 'entry_logic.dart';

class EntryView extends GetView<EntryLogic> {
  const EntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridPaperBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 108.w,
                height: 108.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.peach, AppColors.cardBg],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28.r),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 52.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                Lang.appName,
                style: AppTextStyles.displayTitle(size: 32.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                '${Lang.diaryQuoteOpen}${Lang.diaryQuotePrefix}${Lang.diaryQuoteHighlight}${Lang.diaryQuoteClose}',
                style: AppTextStyles.quote(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
