import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../app_card.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

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
    final palette = AppPalette.of(context);
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
                CustomTextWidget(
                  Enus.cityWeather.trParams({'city': city}),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
                SizedBox(height: 2.h),
                CustomTextWidget(
                  dateLabel,
                  fontSize: 12.sp,
                  color: palette.textSecondary,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomTextWidget(
                temperature,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
              SizedBox(height: 2.h),
              CustomTextWidget(
                Enus.fullForecast.tr,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: MyColors.darkPurple,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
