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
    final value = progress.clamp(0.0, 1.0);

    return AppCard(
      radius: 22.r,
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MyColors.darkPurple,
                      MyColors.darkPurple.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomTextWidget(
                  '$pct%',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: MyColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 12.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: palette.border.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    height: 12.h,
                    width: constraints.maxWidth * value,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF818CF8), MyColors.darkPurple],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.darkPurple.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 14.h),
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
