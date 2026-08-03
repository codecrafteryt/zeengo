import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';
import '../app_svg_icon.dart';

class ChatWhatsappBanner extends StatelessWidget {
  const ChatWhatsappBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: MyColors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: MyColors.green.withValues(alpha: 0.55)),
          ),
          child: Row(
            children: [
              AppSvgIcon(
                asset: MyImages.chatPhone,
                size: 20.sp,
                color: MyColors.green,
                bgColor: MyColors.green.withValues(alpha: 0.15),
                padding: 10,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: MyColors.green,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: MyColors.green.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: MyColors.green,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
