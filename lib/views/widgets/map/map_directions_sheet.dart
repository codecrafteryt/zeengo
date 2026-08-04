import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../data/models/map/nearby_place.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../app_card.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

class MapDirectionsSheet extends StatelessWidget {
  const MapDirectionsSheet({
    super.key,
    required this.place,
    required this.etaLabel,
    required this.distanceLabel,
    required this.providerLabel,
    required this.onStart,
    required this.onOpenExternal,
  });

  final NearbyPlace place;
  final String etaLabel;
  final String distanceLabel;
  final String providerLabel;
  final VoidCallback onStart;
  final VoidCallback onOpenExternal;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      margin: EdgeInsets.zero,
      radius: 24.r,
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 18.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: palette.border,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              AppSvgIcon(
                asset: MyImages.mapNavigate,
                size: 20.sp,
                color: MyColors.darkPurple,
                bgColor: MyColors.darkPurple.withValues(alpha: 0.12),
                padding: 10,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      place.name,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: palette.textPrimary,
                    ),
                    SizedBox(height: 2.h),
                    CustomTextWidget(
                      '$distanceLabel · $etaLabel · $providerLabel',
                      fontSize: 12.sp,
                      color: palette.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.darkPurple,
                    foregroundColor: MyColors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: CustomTextWidget(
                    Enus.startNavigation.tr,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: MyColors.white,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: onOpenExternal,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: MyColors.darkPurple,
                    side: const BorderSide(color: MyColors.darkPurple),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: CustomTextWidget(
                    Enus.openInMaps.tr,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                    color: MyColors.darkPurple,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
