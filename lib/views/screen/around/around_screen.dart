import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/around_controller.dart';
import '../../../data/models/around/around_static_data.dart';
import '../../../utils/values/my_color.dart';

class AroundScreen extends StatelessWidget {
  const AroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AroundController>();
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: _AroundHero(top: top, controller: controller),
          ),
          Obx(() {
            final using = controller.usingDeviceLocation.value;
            return SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                child: Text(
                  using
                      ? 'Sorted from your pin · private on device'
                      : 'Sorted from Red Square until you share location',
                  style: TextStyle(fontSize: 13.sp, color: MyColors.aloMuted),
                ),
              ),
            );
          }),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          SliverToBoxAdapter(
            child: _SectionHead(
              title: 'Browse nearby',
              subtitle: 'Opens the sharpest map experience in Russia',
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12.h)),
          SliverToBoxAdapter(child: _CategoryPills(controller: controller)),
          SliverToBoxAdapter(child: SizedBox(height: 28.h)),
          SliverToBoxAdapter(
            child: _SectionHead(
              title: 'Under 6 minutes',
              subtitle: 'Step outside — you are already there',
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12.h)),
          SliverToBoxAdapter(
            child: _PlaceList(
              places: controller.under6,
              controller: controller,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 28.h)),
          SliverToBoxAdapter(
            child: _SectionHead(
              title: 'A short walk',
              subtitle: 'Six to fourteen minutes of city air',
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12.h)),
          SliverToBoxAdapter(
            child: _PlaceList(
              places: controller.shortWalk,
              controller: controller,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 28.h)),
          SliverToBoxAdapter(
            child: _SectionHead(
              title: 'A short ride',
              subtitle: 'Metro or car — still close',
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12.h)),
          SliverToBoxAdapter(
            child: _PlaceList(
              places: controller.shortRide,
              controller: controller,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _AllPlacesCta(onTap: controller.openAllPlaces),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100.h + bottom)),
        ],
      ),
    );
  }
}

class _AroundHero extends StatelessWidget {
  const _AroundHero({required this.top, required this.controller});

  final double top;
  final AroundController controller;

  @override
  Widget build(BuildContext context) {
    final highlight = controller.under6.isNotEmpty
        ? controller.under6.first
        : AroundStaticData.places.first;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, top + 12.h, 20.w, 20.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B3A2F), Color(0xFF152E26)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Around me',
            style: TextStyle(
              fontSize: 34.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.8,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Distance-aware discovery. Nothing leaves your phone.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          SizedBox(height: 18.h),
          Obx(() {
            final busy =
                controller.locationState.value == AroundLocationState.requesting;
            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.r),
              child: InkWell(
                onTap: busy ? null : controller.useMyLocation,
                borderRadius: BorderRadius.circular(28.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (busy)
                        SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: MyColors.aloForest,
                          ),
                        )
                      else
                        Icon(Icons.my_location, color: MyColors.aloForest, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        busy ? 'Finding you…' : 'Use my location',
                        style: TextStyle(
                          color: MyColors.aloForest,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: SizedBox(
              height: 168.h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1513326738677-b964603b136d?w=900',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        Container(color: MyColors.aloMintSoft),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.45),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12.w,
                    bottom: 12.h,
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.r),
                      child: InkWell(
                        onTap: () => controller.openYandexMaps(highlight),
                        borderRadius: BorderRadius.circular(22.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 9.h,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.near_me_outlined,
                                  size: 16.sp, color: MyColors.aloForest),
                              SizedBox(width: 6.w),
                              Text(
                                'Open in Yandex Maps',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w800,
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
          ),
        ],
      ),
    );
  }
}

class _SectionHead extends StatelessWidget {
  const _SectionHead({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: MyColors.aloText,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13.sp, color: MyColors.aloMuted),
          ),
        ],
      ),
    );
  }
}

class _CategoryPills extends StatelessWidget {
  const _CategoryPills({required this.controller});

  final AroundController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: Obx(() {
        final selected = controller.selectedCategory.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: AroundStaticData.categories.length,
          separatorBuilder: (_, __) => SizedBox(width: 8.w),
          itemBuilder: (_, i) {
            final cat = AroundStaticData.categories[i];
            final on = selected == cat.id;
            return GestureDetector(
              onTap: () => controller.selectCategory(cat.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: on ? MyColors.aloForest : Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      cat.icon,
                      size: 16.sp,
                      color: on ? Colors.white : MyColors.aloForest,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      cat.label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: on ? Colors.white : MyColors.aloText,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class _PlaceList extends StatelessWidget {
  const _PlaceList({required this.places, required this.controller});

  final List<AroundPlace> places;
  final AroundController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: places.map((p) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: GestureDetector(
              onTap: () => controller.openPlaceDetail(p),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: CachedNetworkImage(
                        imageUrl: p.imageUrl,
                        width: 72.w,
                        height: 72.w,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          width: 72.w,
                          height: 72.w,
                          color: MyColors.aloMintSoft,
                          child: Icon(Icons.place_outlined,
                              color: MyColors.aloForest),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  p.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w800,
                                    color: MyColors.aloText,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.aloMintSoft,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  p.badge,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w800,
                                    color: MyColors.aloForest,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            p.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: MyColors.aloMuted,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${p.area} · ${p.distanceLabel}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: MyColors.aloMuted.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: MyColors.aloMuted),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AllPlacesCta extends StatelessWidget {
  const _AllPlacesCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.aloForest,
      borderRadius: BorderRadius.circular(28.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 18.w),
          child: Row(
            children: [
              Icon(Icons.explore_outlined, color: Colors.white, size: 18.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'All places in Moscow',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.white, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }
}
