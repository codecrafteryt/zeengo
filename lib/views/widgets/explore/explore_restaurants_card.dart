import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppSvgIcon(
              asset: MyImages.exploreRestaurant,
              size: 16.sp,
              color: MyColors.green,
              bgColor: MyColors.green.withValues(alpha: 0.12),
              padding: 8,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomTextWidget(
                Enus.nearbyHalalRestaurants.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 148.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, i) => _RestaurantCard(
              item: items[i],
              isDark: isDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.item, required this.isDark});

  final ExploreRestaurant item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final stars = item.rating.round().clamp(0, 5);

    return Container(
      width: 190.w,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: palette.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppSvgIcon(
                asset: MyImages.exploreRestaurant,
                size: 16.sp,
                color: MyColors.green,
                bgColor: MyColors.green.withValues(alpha: 0.12),
                padding: 9,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: MyColors.darkPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustomTextWidget(
                  item.distance,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: MyColors.darkPurple,
                ),
              ),
            ],
          ),
          const Spacer(),
          CustomTextWidget(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
          SizedBox(height: 3.h),
          CustomTextWidget(
            item.cuisine,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: 12.sp,
            color: palette.textSecondary,
          ),
          SizedBox(height: 8.h),
          Row(
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
    );
  }
}
