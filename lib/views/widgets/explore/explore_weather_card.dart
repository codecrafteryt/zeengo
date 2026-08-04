import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onForecast,
        borderRadius: BorderRadius.circular(22.r),
        child: Ink(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E1B4B),
                      palette.card,
                    ]
                  : [
                      const Color(0xFFEEF2FF),
                      palette.card,
                    ],
            ),
            border: Border.all(color: palette.border.withValues(alpha: 0.65)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              AppSvgIcon(
                asset: MyImages.exploreWeather,
                size: 26.sp,
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
                    SizedBox(height: 3.h),
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
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                  SizedBox(height: 3.h),
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
        ),
      ),
    );
  }
}
