import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

/// Compact glass location strip — premium without covering the map.
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
    final palette = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 10.w, 12.h),
      decoration: BoxDecoration(
        color: palette.card.withValues(alpha: isDark ? 0.92 : 0.96),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: palette.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          AppSvgIcon(
            asset: MyImages.mapPin,
            size: 18.sp,
            color: MyColors.darkPurple,
            bgColor: MyColors.darkPurple.withValues(alpha: 0.12),
            padding: 10,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomTextWidget(
                        city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                    if (isDriverActive) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: MyColors.green.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: const BoxDecoration(
                                color: MyColors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            CustomTextWidget(
                              Enus.driverActive.tr,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: MyColors.green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                CustomTextWidget(
                  coords,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: palette.textSecondary,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onOpenYandex,
              customBorder: const CircleBorder(),
              child: Ink(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF818CF8), MyColors.darkPurple],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.darkPurple.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: AppSvgIcon(
                    asset: MyImages.mapNavigate,
                    size: 18.sp,
                    color: MyColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
