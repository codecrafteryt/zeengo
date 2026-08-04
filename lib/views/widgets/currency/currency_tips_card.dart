import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../custom_text_widget.dart';

class CurrencyTipsCard extends StatelessWidget {
  const CurrencyTipsCard({super.key, required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final tips = [
      Enus.moneyTip1.tr,
      Enus.moneyTip2.tr,
      Enus.moneyTip3.tr,
      Enus.moneyTip4.tr,
      Enus.moneyTip5.tr,
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.35
                  : 0.06,
            ),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 18.sp, color: accent),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomTextWidget(
                  Enus.moneyTipsTitle.tr,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...tips.map(
            (tip) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    '✓',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: accent.withValues(alpha: 0.85),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomTextWidget(
                      tip,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
