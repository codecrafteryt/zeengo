import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../data/models/alo_home/alo_home_static_data.dart';
import '../../../utils/values/my_color.dart';
import '../../widgets/alo_home/alo_search_sheet.dart';

class ExploreScreen extends GetView<HomeController> {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // Immersive hero
          SliverToBoxAdapter(
            child: _HeroBlock(top: top, controller: controller),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 8.h)),
          SliverToBoxAdapter(child: _CategoryStrip(controller: controller)),
          SliverToBoxAdapter(child: SizedBox(height: 28.h)),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Inspired for today',
              subtitle: 'Curated for where you are right now',
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 14.h)),
          SliverToBoxAdapter(
            child: Obx(
              () => _FeaturedCarousel(
                items: controller.moscowNow.toList(),
                onTap: controller.snack,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'What suits you?',
              subtitle: 'One tap and aLo reshapes the city',
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 14.h)),
          SliverToBoxAdapter(child: _MoodGrid(controller: controller)),
          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Close to the centre',
              subtitle: 'Walkable icons & views',
              action: 'See all',
              onAction: () => controller.snack('See all · centre'),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 14.h)),
          SliverToBoxAdapter(
            child: Obx(
              () => _PlaceRail(
                items: controller.closeToCentre.toList(),
                onTap: controller.snack,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'First time in Moscow',
              subtitle: 'The essentials, sequenced beautifully',
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 14.h)),
          SliverToBoxAdapter(
            child: Obx(
              () => _PlaceRail(
                items: controller.firstTime.toList(),
                wide: true,
                onTap: controller.snack,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Where to eat',
              subtitle: 'Halal-friendly kitchens locals love',
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 14.h)),
          SliverToBoxAdapter(child: _FoodList(controller: controller)),
          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'With kids',
              subtitle: 'Easy days the whole family enjoys',
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 14.h)),
          SliverToBoxAdapter(
            child: Obx(
              () => _PlaceRail(
                items: controller.withKids.toList(),
                onTap: controller.snack,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          SliverToBoxAdapter(child: _ServicesGrid(controller: controller)),
          SliverToBoxAdapter(child: SizedBox(height: 28.h)),
          SliverToBoxAdapter(child: _TrustFooter()),
          SliverToBoxAdapter(child: SizedBox(height: 100.h + bottom)),
        ],
      ),
    );
  }
}

// ─── Hero ────────────────────────────────────────────────────────────────────

class _HeroBlock extends StatelessWidget {
  const _HeroBlock({required this.top, required this.controller});

  final double top;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MyColors.aloForest,
            MyColors.aloForestDeep,
            const Color(0xFF0F241C),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40.w,
            top: 40.h,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            left: -60.w,
            bottom: 20.h,
            child: Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.aloLime.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, top + 12.h, 20.w, 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'aLo',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.8,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Russia',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w300,
                        color: MyColors.aloLime,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    _GlassChip(
                      icon: Icons.place_outlined,
                      label: 'Moscow',
                      onTap: () => AloSearchSheet.showFrom(),
                    ),
                  ],
                ),
                SizedBox(height: 28.h),
                Text(
                  'Where to\ntoday?',
                  style: TextStyle(
                    fontSize: 42.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.05,
                    letterSpacing: -1.2,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Stays, rides, food and moments — planned like Airbnb, built for Russia.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.72),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 22.h),
                Obx(() {
                  final summary = controller.searchSummary;
                  return GestureDetector(
                    onTap: () => AloSearchSheet.show(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 28,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: MyColors.aloMintSoft,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.search,
                              color: MyColors.aloForest,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.searchTo.value.isEmpty
                                      ? 'Start your search'
                                      : controller.searchTo.value,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w800,
                                    color: MyColors.aloText,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  summary,
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
                          Icon(
                            Icons.tune_rounded,
                            color: MyColors.aloForest,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 34.h,
                  child: Obx(
                    () => ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.quickChips.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      itemBuilder: (_, i) {
                        final chip = controller.quickChips[i];
                        return GestureDetector(
                          onTap: () {
                            controller.setSearchTo(chip);
                            AloSearchSheet.showTo();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.18),
                              ),
                            ),
                            child: Text(
                              chip,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  const _GlassChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14.sp, color: Colors.white),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Categories ──────────────────────────────────────────────────────────────

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -18.h),
      child: SizedBox(
        height: 96.h,
        child: Obx(
          () => ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: controller.categories.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, i) {
              final c = controller.categories[i];
              return GestureDetector(
                onTap: () {
                  controller.snack(c.label);
                  AloSearchSheet.show();
                },
                child: Container(
                  width: 84.w,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(c.icon, color: MyColors.aloForest, size: 26.sp),
                    SizedBox(height: 8.h),
                    Text(
                      c.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: MyColors.aloText,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        ),
      ),
    );
  }
}

// ─── Shared section chrome ───────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
    this.action,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: MyColors.aloText,
                    letterSpacing: -0.5,
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
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: MyColors.aloForest,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Featured / rails ────────────────────────────────────────────────────────

class _FeaturedCarousel extends StatelessWidget {
  const _FeaturedCarousel({required this.items, required this.onTap});

  final List<AloPlaceCard> items;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.88),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final p = items[i];
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () => onTap(p.title),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: p.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Container(color: MyColors.aloMintSoft),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                    if (p.badge != null)
                      Positioned(
                        top: 16.h,
                        left: 16.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            p.badge!,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12.sp,
                              color: MyColors.aloForest,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      left: 18.w,
                      right: 18.w,
                      bottom: 18.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.title,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            p.subtitle,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PlaceRail extends StatelessWidget {
  const _PlaceRail({
    required this.items,
    required this.onTap,
    this.wide = false,
  });

  final List<AloPlaceCard> items;
  final ValueChanged<String> onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final w = wide ? 220.w : 168.w;
    final h = wide ? 200.h : 168.h;
    return SizedBox(
      height: h + 58.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 14.w),
        itemBuilder: (_, i) {
          final p = items[i];
          return GestureDetector(
            onTap: () => onTap(p.title),
            child: SizedBox(
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22.r),
                    child: CachedNetworkImage(
                      imageUrl: p.imageUrl,
                      width: w,
                      height: h,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: w,
                        height: h,
                        color: MyColors.aloMintSoft,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: MyColors.aloText,
                    ),
                  ),
                  Text(
                    p.subtitle,
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
        },
      ),
    );
  }
}

class _MoodGrid extends StatelessWidget {
  const _MoodGrid({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedSuit.value;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.suitYou.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (_, i) {
            final m = controller.suitYou[i];
            final on = selected == m.title;
            return GestureDetector(
              onTap: () => controller.setSuit(m.title),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: on ? MyColors.aloForest : Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: on ? 0.12 : 0.05),
                      blurRadius: on ? 20 : 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      m.icon,
                      color: on ? MyColors.aloLime : MyColors.aloForest,
                      size: 22.sp,
                    ),
                    const Spacer(),
                    Text(
                      m.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: on ? Colors.white : MyColors.aloText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      m.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: on
                            ? Colors.white.withValues(alpha: 0.75)
                            : MyColors.aloMuted,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _FoodList extends StatelessWidget {
  const _FoodList({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: controller.food.map((f) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: GestureDetector(
                onTap: () => controller.snack(f.title),
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          color: MyColors.aloMintSoft,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      child: Icon(
                        Icons.restaurant_outlined,
                        color: MyColors.aloForest,
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
                                  f.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15.sp,
                                    color: MyColors.aloText,
                                  ),
                                ),
                              ),
                              if (f.halalFriendly) ...[
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
                                    'Halal',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: MyColors.aloForest,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            f.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: MyColors.aloMuted,
                            ),
                          ),
                          Text(
                            f.location,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: MyColors.aloMuted.withValues(alpha: 0.8),
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
      ),
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  const _ServicesGrid({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Everything in one place',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: MyColors.aloText,
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 14.h),
            ...controller.services.map((s) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: GestureDetector(
                  onTap: () => controller.snack(s.title),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: MyColors.aloMintSoft,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(s.icon, color: MyColors.aloForest),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.sp,
                                  color: MyColors.aloText,
                                ),
                              ),
                              Text(
                                s.subtitle,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: MyColors.aloMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14.sp,
                          color: MyColors.aloMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TrustFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MyColors.aloForest, MyColors.aloForestDeep],
          ),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Designed for guests\nwho expect more.',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Arabic support · Team inside Russia · Live city intelligence',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
