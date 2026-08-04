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

class ExploreRestaurant {
  const ExploreRestaurant({
    required this.name,
    required this.cuisine,
    required this.distance,
    required this.rating,
  });

  final String name;
  final String cuisine;
  final String distance;
  final double rating;
}

class ExploreRestaurantsCard extends StatelessWidget {
  const ExploreRestaurantsCard({super.key, required this.items});

  final List<ExploreRestaurant> items;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppSvgIcon(
                asset: MyImages.exploreRestaurant,
                size: 18.sp,
                color: MyColors.green,
                bgColor: MyColors.green.withValues(alpha: 0.12),
                padding: 8,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomTextWidget(
                  Enus.nearbyHalalRestaurants.tr,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Divider(height: 1, color: palette.border),
            _RestaurantTile(item: items[i]),
          ],
        ],
      ),
    );
  }
}

class _RestaurantTile extends StatelessWidget {
  const _RestaurantTile({required this.item});

  final ExploreRestaurant item;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final stars = item.rating.round().clamp(0, 5);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          AppSvgIcon(
            asset: MyImages.exploreRestaurant,
            size: 18.sp,
            color: MyColors.green,
            bgColor: MyColors.green.withValues(alpha: 0.1),
            padding: 10,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  item.name,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
                SizedBox(height: 2.h),
                CustomTextWidget(
                  item.cuisine,
                  fontSize: 12.sp,
                  color: MyColors.darkPurple,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomTextWidget(
                item.distance,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: MyColors.darkPurple,
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 14.sp,
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
