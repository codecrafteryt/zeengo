import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';
import '../app_card.dart';
import '../app_svg_icon.dart';

class ExploreScheduleCard extends StatelessWidget {
  const ExploreScheduleCard({
    super.key,
    required this.dateLabel,
    this.emptyMessage,
  });

  final String dateLabel;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppSvgIcon(
                asset: MyImages.exploreCalendar,
                size: 18.sp,
                color: MyColors.darkPurple,
                bgColor: MyColors.darkPurple.withValues(alpha: 0.12),
                padding: 8,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  Enus.todaysSchedule.tr,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: MyColors.blackDark,
                  ),
                ),
              ),
              Text(
                dateLabel,
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: MyColors.darkPurple,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Center(
            child: Text(
              emptyMessage ?? Enus.noEventsToday.tr,
              style: TextStyle(
                fontFamily: MyFonts.plusJakartaSans,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: MyColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
