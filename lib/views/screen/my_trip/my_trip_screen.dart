import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/my_trip_controller.dart';
import '../../../data/models/my_trip/my_trip_static_data.dart';
import '../../../utils/values/my_color.dart';

class MyTripScreen extends StatelessWidget {
  const MyTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyTripController>();
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: EdgeInsets.only(bottom: bottom + 100.h),
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20.w, top + 14.h, 20.w, 24.h),
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
                  'Your ${controller.tripDayCount} days',
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  MyTripStaticData.subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.72),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 18.h),
                Obx(() {
                  final sel = controller.selectedDayIndex.value;
                  return Row(
                    children: List.generate(controller.days.length, (i) {
                      final on = sel == i;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: i == controller.days.length - 1 ? 0 : 8.w,
                          ),
                          child: GestureDetector(
                            onTap: () => controller.selectDay(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: on
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'DAY ${i + 1}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: on
                                          ? MyColors.aloForest
                                          : Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '${controller.days[i].stopCount} stops',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: on
                                          ? MyColors.aloText
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 0),
            child: Text(
              'THE JOURNEY',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: MyColors.aloMuted,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Obx(() {
            final sel = controller.selectedDayIndex.value;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  for (var i = 0; i < controller.days.length; i++)
                    _JourneyRow(
                      day: controller.days[i],
                      isLast: i == controller.days.length - 1,
                      selected: sel == i,
                      onTap: () => controller.selectDay(i),
                    ),
                ],
              ),
            );
          }),
          SizedBox(height: 8.h),
          ...controller.days.map(
            (day) => Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 14.h),
              child: _DayCard(day: day, controller: controller),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyRow extends StatelessWidget {
  const _JourneyRow({
    required this.day,
    required this.isLast,
    required this.selected,
    required this.onTap,
  });

  final TripDay day;
  final bool isLast;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 22.w,
              child: Column(
                children: [
                  Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? MyColors.aloForest : Colors.white,
                      border: Border.all(color: MyColors.aloForest, width: 2.2),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        color: MyColors.borderSubtle,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 8.h : 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAY ${day.dayNumber}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: MyColors.aloForest,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      day.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: MyColors.aloText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: [
                        _Pill(
                          icon: Icons.place_outlined,
                          label: '${day.stopCount} STOPS',
                        ),
                        _Pill(
                          icon: Icons.mosque,
                          label: day.mosqueLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: MyColors.aloMintSoft,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: MyColors.aloForest),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              color: MyColors.aloForest,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.day, required this.controller});

  final TripDay day;
  final MyTripController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: MyColors.aloForest,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${day.dayNumber}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day ${day.dayNumber}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: MyColors.aloText,
                      ),
                    ),
                    Text(
                      day.title,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: MyColors.aloMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: MyColors.aloMintSoft,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.mosque, size: 13.sp, color: MyColors.aloForest),
                    SizedBox(width: 4.w),
                    Text(
                      day.mosqueShortLabel,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: MyColors.aloForest,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          ...List.generate(day.stops.length, (i) {
            final stop = day.stops[i];
            final last = i == day.stops.length - 1;
            return InkWell(
              onTap: () => controller.openStop(stop),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 28.w,
                      child: Column(
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: MyColors.borderSubtle,
                                width: 1.4,
                              ),
                            ),
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: MyColors.aloMuted,
                              ),
                            ),
                          ),
                          if (!last)
                            Expanded(
                              child: Container(
                                width: 1.5,
                                margin: EdgeInsets.symmetric(vertical: 2.h),
                                color: MyColors.borderSubtle,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: last ? 4.h : 14.h,
                          top: 2.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stop.title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: MyColors.aloText,
                              ),
                            ),
                            if (stop.subtitle != null)
                              Text(
                                stop.subtitle!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: MyColors.aloMuted,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: MyColors.aloMuted, size: 20.sp),
                  ],
                ),
              ),
            );
          }),
          TextButton.icon(
            onPressed: () => controller.openDayOnYandexMaps(day),
            icon: Icon(Icons.near_me_outlined, size: 16.sp, color: MyColors.aloText),
            label: Text(
              'Open day ${day.dayNumber} on Yandex Maps',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: MyColors.aloText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
