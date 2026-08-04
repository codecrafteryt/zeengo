import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

class AiEmptyState extends StatelessWidget {
  const AiEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 112.w,
          height: 112.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                MyColors.purple.withValues(alpha: 0.22),
                MyColors.darkPurple.withValues(alpha: 0.06),
                Colors.transparent,
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 78.w,
            height: 78.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.cardMuted,
              border: Border.all(
                color: MyColors.darkPurple.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: MyColors.darkPurple.withValues(alpha: 0.18),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: AppSvgIcon(
              asset: MyImages.exploreAi,
              size: 34.sp,
              color: MyColors.darkPurple,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        CustomTextWidget(
          title,
          textAlign: TextAlign.center,
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: palette.textPrimary,
        ),
        SizedBox(height: 6.h),
        CustomTextWidget(
          subtitle,
          textAlign: TextAlign.center,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: palette.textSecondary,
        ),
      ],
    );
  }
}
