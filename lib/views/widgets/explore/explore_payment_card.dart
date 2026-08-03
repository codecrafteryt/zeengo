import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../app_card.dart';

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
    final pct = (progress.clamp(0.0, 1.0) * 100).round();

    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  Enus.paymentProgress.tr,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: MyColors.blackDark,
                  ),
                ),
              ),
              Text(
                '$pct%',
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: MyColors.darkPurple,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10.h,
              backgroundColor: MyColors.borderSubtle,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(MyColors.darkPurple),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                paidLabel,
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: MyColors.green,
                ),
              ),
              const Spacer(),
              Text(
                totalLabel,
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: MyColors.blackDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
