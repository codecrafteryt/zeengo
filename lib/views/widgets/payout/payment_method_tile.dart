import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../app_badge.dart';
import '../app_card.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.svgAsset,
    required this.title,
    required this.subtitle,
    required this.accent,
    this.badge,
    this.expanded = false,
    this.onTap,
  });

  final String svgAsset;
  final String title;
  final String subtitle;
  final Color accent;
  final String? badge;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      onTap: onTap,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          AppSvgIcon(
            asset: svgAsset,
            size: 20.sp,
            color: accent,
            bgColor: accent.withValues(alpha: 0.12),
            padding: 10,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomTextWidget(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                    if (badge != null) ...[
                      SizedBox(width: 8.w),
                      AppBadge(label: badge!),
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                CustomTextWidget(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 12.sp,
                  color: palette.textSecondary,
                ),
              ],
            ),
          ),
          Icon(
            expanded
                ? Icons.keyboard_arrow_down_rounded
                : Icons.chevron_right_rounded,
            color: expanded ? accent : MyColors.grayscale30,
            size: 24.sp,
          ),
        ],
      ),
    );
  }
}
