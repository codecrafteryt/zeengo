import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';
import '../app_card.dart';
import '../app_svg_icon.dart';

class ExploreWeatherCard extends StatelessWidget {
  const ExploreWeatherCard({
    super.key,
    required this.city,
    required this.dateLabel,
    required this.temperature,
    this.onForecast,
  });

  final String city;
  final String dateLabel;
  final String temperature;
  final VoidCallback? onForecast;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onForecast,
      child: Row(
        children: [
          AppSvgIcon(
            asset: MyImages.exploreWeather,
            size: 28.sp,
            color: MyColors.darkPurple,
            bgColor: MyColors.darkPurple.withValues(alpha: 0.12),
            padding: 12,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Enus.cityWeather.trParams({'city': city}),
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: MyColors.blackDark,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  dateLabel,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 12.sp,
                    color: MyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                temperature,
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: MyColors.blackDark,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                Enus.fullForecast.tr,
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: MyColors.darkPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
