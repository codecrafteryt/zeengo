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

class MapPlaceTile extends StatelessWidget {
  const MapPlaceTile({
    super.key,
    required this.place,
    required this.onDirections,
  });

  final NearbyPlace place;
  final VoidCallback onDirections;

  String get _icon {
    return switch (place.category) {
      PlaceCategory.mosques => MyImages.mapMosque,
      PlaceCategory.halal => MyImages.mapHalal,
      PlaceCategory.atm => MyImages.mapAtm,
      PlaceCategory.malls => MyImages.mapMall,
      PlaceCategory.all => MyImages.mapPin,
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          AppSvgIcon(
            asset: _icon,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
                SizedBox(height: 3.h),
                CustomTextWidget(
                  place.categoryLabelKey.tr,
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
                '${place.distanceKm.toStringAsFixed(1)} km',
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: MyColors.darkPurple,
              ),
              SizedBox(height: 6.h),
              InkWell(
                onTap: onDirections,
                child: CustomTextWidget(
                  Enus.directions.tr,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
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
