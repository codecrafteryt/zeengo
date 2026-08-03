import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../app_card.dart';

class PayoutBalanceCard extends StatelessWidget {
  const PayoutBalanceCard({
    super.key,
    required this.dueAmount,
    required this.paidAmount,
    required this.totalAmount,
  });

  final String dueAmount;
  final String paidAmount;
  final String totalAmount;

  @override
  Widget build(BuildContext context) {
    final paid = double.tryParse(paidAmount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    final total = double.tryParse(totalAmount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 1;
    final progress = (paid / total).clamp(0.0, 1.0);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Enus.outstandingBalance.tr,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: MyColors.darkPurple,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            dueAmount,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              color: MyColors.blackDark,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            Enus.paidOfTotal.trParams({
              'paid': paidAmount,
              'total': totalAmount,
            }),
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: MyColors.textSecondary,
            ),
          ),
          SizedBox(height: 14.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: MyColors.borderSubtle,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(MyColors.darkPurple),
            ),
          ),
        ],
      ),
    );
  }
}
