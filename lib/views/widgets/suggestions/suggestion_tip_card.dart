import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/suggestion_tip.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../custom_text_widget.dart';

/// Airbnb-style suggestion tip card — reusable for static + API data.
class SuggestionTipCard extends StatelessWidget {
  const SuggestionTipCard({
    super.key,
    required this.tip,
    this.onAction,
  });

  final SuggestionTip tip;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final accent = MyColors.darkPurple;
    final iconTint = tip.iconColor ?? accent;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.35
                  : 0.06,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: iconTint.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14.r),
            ),
            alignment: Alignment.center,
            child: Icon(tip.icon, size: 26.sp, color: iconTint),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  tip.title,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
                SizedBox(height: 6.h),
                CustomTextWidget(
                  tip.description,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: palette.textSecondary,
                ),
                SizedBox(height: 12.h),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onAction,
                    borderRadius: BorderRadius.circular(22.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.75),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(tip.actionIcon, size: 15.sp, color: accent),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: CustomTextWidget(
                              tip.actionLabel,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: accent,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
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
