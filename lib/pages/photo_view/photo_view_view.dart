import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../lang/lang.dart';
import '../../utils/app_text_styles.dart';
import 'photo_view_logic.dart';

class PhotoViewView extends GetView<PhotoViewLogic> {
  const PhotoViewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.45),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: Material(
            color: Colors.white.withValues(alpha: 0.15),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => Get.back(),
              customBorder: const CircleBorder(),
              child: Icon(Icons.close_rounded, color: Colors.white, size: 22.sp),
            ),
          ),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4,
          child: Hero(
            tag: controller.path,
            child: Image.file(
              File(controller.path),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stack) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image_outlined,
                      color: Colors.white54, size: 64.sp),
                  SizedBox(height: 12.h),
                  Text(
                    Lang.photoUnavailable,
                    style: AppTextStyles.caption(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
