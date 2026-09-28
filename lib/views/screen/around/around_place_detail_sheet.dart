import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/around_controller.dart';
import '../../../data/models/around/around_static_data.dart';
import '../../../utils/values/my_color.dart';

class AroundPlaceDetailSheet extends StatelessWidget {
  const AroundPlaceDetailSheet({super.key, required this.place});

  final AroundPlace place;

  static Future<void> show(AroundPlace place) {
    return Get.bottomSheet(
      AroundPlaceDetailSheet(place: place),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      ignoreSafeArea: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AroundController>();
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.92,
      decoration: BoxDecoration(
        color: MyColors.aloScaffold,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: MyColors.borderSubtle,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h + bottom),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.title,
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w800,
                              color: MyColors.aloText,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            '${place.category} · ${place.distanceLabel.replaceAll(' away', '')} · ${place.walkLabel} · Metro ${place.area}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: MyColors.aloMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: MyColors.borderSubtle),
                      ),
                      icon: Icon(Icons.close, color: MyColors.aloText),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: MyColors.aloForest,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: MyColors.aloLime,
                              width: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          place.title,
                          style: TextStyle(
                            color: MyColors.aloLime,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10.sp, color: MyColors.green),
                    SizedBox(width: 6.w),
                    Text(
                      place.openLabel,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: MyColors.aloText,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${place.distanceLabel.replaceAll(' away', '')} · ${place.priceLabel}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: MyColors.aloMuted,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  place.description,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: MyColors.aloText,
                    height: 1.4,
                  ),
                ),
                if (place.arabicDescription != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    place.arabicDescription!,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: MyColors.aloText,
                      height: 1.4,
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: place.imageUrl,
                        height: 160.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          height: 160.h,
                          color: MyColors.aloMintSoft,
                          child: Icon(
                            Icons.map_outlined,
                            color: MyColors.aloForest,
                            size: 40.sp,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12.w,
                        bottom: 12.h,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          child: InkWell(
                            onTap: () => controller.openYandexMaps(place),
                            borderRadius: BorderRadius.circular(20.r),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.near_me_outlined,
                                    size: 16.sp,
                                    color: MyColors.aloForest,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'Open in Yandex Maps',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: MyColors.aloText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                Material(
                  color: MyColors.aloForest,
                  borderRadius: BorderRadius.circular(28.r),
                  child: InkWell(
                    onTap: () => controller.openYandexMaps(place),
                    borderRadius: BorderRadius.circular(28.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_outlined, color: Colors.white, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Directions on Yandex Maps',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => controller.snack('Saved ${place.title}'),
                        icon: Icon(Icons.favorite_border, color: MyColors.aloForest),
                        label: Text(
                          'Save',
                          style: TextStyle(
                            color: MyColors.aloText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(0, 50.h),
                          side: BorderSide(color: MyColors.borderSubtle),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => controller.snack('Share ${place.title}'),
                        icon: Icon(Icons.ios_share, color: MyColors.aloForest),
                        label: Text(
                          'Share',
                          style: TextStyle(
                            color: MyColors.aloText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(0, 50.h),
                          side: BorderSide(color: MyColors.borderSubtle),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
