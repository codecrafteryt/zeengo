import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../app_card.dart';
import '../custom_text_widget.dart';

class ExplorePaymentCard extends StatelessWidget {
  const ExplorePaymentCard({
    super.key,
    required this.progress,
    required this.paidLabel,
    required this.totalLabel,
  });

  final double progress;
  final String paidLabel;
  final String totalLabel;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final pct = (progress.clamp(0.0, 1.0) * 100).round();

    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextWidget(
                  Enus.paymentProgress.tr,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
              CustomTextWidget(
                '$pct%',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: MyColors.darkPurple,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10.h,
              backgroundColor: palette.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(MyColors.darkPurple),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              CustomTextWidget(
                paidLabel,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: MyColors.green,
              ),
              const Spacer(),
              CustomTextWidget(
                totalLabel,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
