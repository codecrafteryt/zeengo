import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';
import '../app_card.dart';
import '../app_svg_icon.dart';

class MapLocationHeader extends StatelessWidget {
  const MapLocationHeader({
    super.key,
    required this.city,
    required this.coords,
    required this.isDriverActive,
    required this.onOpenYandex,
  });

  final String city;
  final String coords;
  final bool isDriverActive;
  final VoidCallback onOpenYandex;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              if (isDriverActive)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: MyColors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    Enus.driverActive.tr,
                    style: TextStyle(
                      fontFamily: MyFonts.plusJakartaSans,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: MyColors.green,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          AppSvgIcon(
            asset: MyImages.mapPin,
            size: 28.sp,
            color: MyColors.darkPurple,
            bgColor: MyColors.darkPurple.withValues(alpha: 0.12),
            padding: 14,
          ),
          SizedBox(height: 12.h),
          Text(
            city,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: MyColors.blackDark,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            coords,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 12.sp,
              color: MyColors.textSecondary,
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onOpenYandex,
              icon: AppSvgIcon(
                asset: MyImages.mapNavigate,
                size: 16.sp,
                color: MyColors.white,
              ),
              label: Text(
                Enus.openYandexMaps.tr,
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.darkPurple,
                foregroundColor: MyColors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
