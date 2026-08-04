import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../data/models/map/nearby_place.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

class MapPlaceTile extends StatelessWidget {
  const MapPlaceTile({
    super.key,
    required this.place,
    required this.onDirections,
    this.index = 0,
  });

  final NearbyPlace place;
  final VoidCallback onDirections;
  final int index;

  String get _icon {
    return switch (place.category) {
      PlaceCategory.mosques => MyImages.mapMosque,
      PlaceCategory.halal => MyImages.mapHalal,
      PlaceCategory.atm => MyImages.mapAtm,
      PlaceCategory.malls => MyImages.mapMall,
      PlaceCategory.all => MyImages.mapPin,
    };
  }

  Color get _accent {
    return switch (place.category) {
      PlaceCategory.mosques => MyColors.darkPurple,
      PlaceCategory.halal => MyColors.green,
      PlaceCategory.atm => const Color(0xFFD97706),
      PlaceCategory.malls => MyColors.purple,
      PlaceCategory.all => MyColors.darkPurple,
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _accent;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 10),
          child: child,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: palette.border.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            AppSvgIcon(
              asset: _icon,
              size: 18.sp,
              color: accent,
              bgColor: accent.withValues(alpha: 0.12),
              padding: 11,
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
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      CustomTextWidget(
                        place.categoryLabelKey.tr,
                        fontSize: 12.sp,
                        color: palette.textSecondary,
                      ),
                      CustomTextWidget(
                        '  ·  ',
                        fontSize: 12.sp,
                        color: palette.textSecondary,
                      ),
                      CustomTextWidget(
                        '${place.distanceKm.toStringAsFixed(1)} km',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onDirections,
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: MyColors.darkPurple.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.directions_rounded,
                        size: 14.sp,
                        color: MyColors.darkPurple,
                      ),
                      SizedBox(width: 4.w),
                      CustomTextWidget(
                        Enus.directions.tr,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: MyColors.darkPurple,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
