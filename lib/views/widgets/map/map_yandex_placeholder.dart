import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../app_card.dart';

class MapYandexPlaceholder extends StatelessWidget {
  const MapYandexPlaceholder({super.key, required this.onUseGoogle});

  final VoidCallback onUseGoogle;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: MyColors.scaffoldMuted,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map_outlined, size: 48.sp, color: MyColors.darkPurple),
                SizedBox(height: 12.h),
                Text(
                  Enus.yandexComingSoon.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: MyColors.blackDark,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  Enus.yandexKeyMissing.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 13.sp,
                    height: 1.4,
                    color: MyColors.textSecondary,
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onUseGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.darkPurple,
                      foregroundColor: MyColors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      Enus.useGoogleMaps.tr,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
