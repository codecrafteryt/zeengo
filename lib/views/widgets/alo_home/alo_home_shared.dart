import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/my_color.dart';

class AloSectionHeader extends StatelessWidget {
  const AloSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTrailingTap,
  });

  final String title;
  final String subtitle;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: MyColors.aloText,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: MyColors.aloMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Text(
                trailing!,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: MyColors.aloForest,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AloPlaceImageCard extends StatelessWidget {
  const AloPlaceImageCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.badge,
    this.width,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final String? badge;
  final double? width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final w = width ?? 148.w;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: w,
                    height: 148.w,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: w,
                      height: 148.w,
                      color: MyColors.aloMintSoft,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: w,
                      height: 148.w,
                      color: MyColors.aloMintSoft,
                      child: Icon(
                        Icons.image_outlined,
                        color: MyColors.aloForest.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.aloMint,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: MyColors.aloForest,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: MyColors.aloText,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                color: MyColors.aloMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AloHorizontalPlaces extends StatelessWidget {
  const AloHorizontalPlaces({
    super.key,
    required this.items,
    required this.onTap,
  });

  final List<({String title, String subtitle, String imageUrl, String? badge})>
      items;
  final void Function(String title) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, i) {
          final item = items[i];
          return AloPlaceImageCard(
            title: item.title,
            subtitle: item.subtitle,
            imageUrl: item.imageUrl,
            badge: item.badge,
            onTap: () => onTap(item.title),
          );
        },
      ),
    );
  }
}
