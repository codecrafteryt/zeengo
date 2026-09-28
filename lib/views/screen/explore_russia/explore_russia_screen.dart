import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/explore_russia_controller.dart';
import '../../../data/models/explore_russia/explore_russia_static_data.dart';
import '../../../utils/values/my_color.dart';

class ExploreRussiaScreen extends StatelessWidget {
  const ExploreRussiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExploreRussiaController>();
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
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, top + 14.h, 20.w, 22.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B3A2F), Color(0xFF0F241C)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore\nRussia',
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.05,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Pick a mood — aLo re-sorts the whole country around it.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.72),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _ChipHeaderDelegate(controller: controller),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
              child: Obx(() {
                final has = controller.selectedFilterId.value != null;
                if (!has) {
                  return Text(
                    '${controller.matchCount} ideas ready',
                    style: TextStyle(fontSize: 13.sp, color: MyColors.aloMuted),
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.statusTitle,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: MyColors.aloText,
                            ),
                          ),
                          Text(
                            '${controller.matchCount} ideas match this filter',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: MyColors.aloMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: controller.clearFilter,
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: MyColors.aloForest,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          Obx(() {
            final places = controller.filteredPlaces;
            return SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, bottom + 100.h),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 18.h,
                  childAspectRatio: 0.70,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final place = places[index];
                    return _IdeaTile(
                      place: place,
                      onTap: () => controller.openPlace(place),
                    );
                  },
                  childCount: places.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ChipHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ChipHeaderDelegate({required this.controller});

  final ExploreRussiaController controller;

  @override
  double get minExtent => 64;

  @override
  double get maxExtent => 64;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: const Color(0xFFF7F7F5),
      alignment: Alignment.center,
      child: SizedBox(
        height: 40,
        child: Obx(() {
          final selected = controller.selectedFilterId.value;
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = controller.filters[index];
              final on = selected == filter.id;
              return GestureDetector(
                onTap: () => controller.selectFilter(filter.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: on ? MyColors.aloForest : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: on ? MyColors.aloForest : MyColors.borderSubtle,
                    ),
                    boxShadow: on
                        ? [
                            BoxShadow(
                              color: MyColors.aloForest.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    filter.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: on ? Colors.white : MyColors.aloText,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ChipHeaderDelegate oldDelegate) => true;
}

class _IdeaTile extends StatelessWidget {
  const _IdeaTile({required this.place, required this.onTap});

  final ExploreRussiaPlace place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: place.usePlaceholder || place.imageUrl == null
                  ? Container(
                      color: const Color(0xFFEDE8DC),
                      child: Center(
                        child: Container(
                          width: 72.w,
                          height: 72.w,
                          decoration: BoxDecoration(
                            color: MyColors.aloForest,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: MyColors.aloLime,
                            size: 28.sp,
                          ),
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: place.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Container(color: MyColors.aloMintSoft),
                    ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            place.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: MyColors.aloText,
              height: 1.2,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            place.tagsLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, color: MyColors.aloMuted),
          ),
        ],
      ),
    );
  }
}
