import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

class ChatThreadHeader extends StatelessWidget {
  const ChatThreadHeader({
    super.key,
    required this.title,
    required this.svgAsset,
    required this.statusLabel,
    required this.accent,
    this.isOnline = true,
  });

  final String title;
  final String svgAsset;
  final String statusLabel;
  final Color accent;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Row(
      children: [
        AppSvgIcon(
          asset: svgAsset,
          size: 22.sp,
          color: accent,
          bgColor: accent.withValues(alpha: 0.12),
          padding: 12,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: isOnline ? MyColors.green : MyColors.gray100,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  CustomTextWidget(
                    statusLabel,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: accent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
