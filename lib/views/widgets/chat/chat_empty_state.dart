import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';
import '../app_svg_icon.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvgIcon(
              asset: MyImages.chatEmpty,
              size: 36.sp,
              color: MyColors.darkPurple,
              bgColor: MyColors.darkPurple.withValues(alpha: 0.1),
              padding: 18,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: MyFonts.plusJakartaSans,
                fontSize: 14.sp,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: MyColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
