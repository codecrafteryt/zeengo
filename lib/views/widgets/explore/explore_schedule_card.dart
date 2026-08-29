import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../data/models/home_model/home_model.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../app_card.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

class ExploreScheduleCard extends StatelessWidget {
  const ExploreScheduleCard({
    super.key,
    required this.dateLabel,
    this.items = const [],
    this.emptyMessage,
  });

  final String dateLabel;
  final List<TodayProgramItem> items;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      radius: 22.r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppSvgIcon(
                asset: MyImages.exploreCalendar,
                size: 18.sp,
                color: MyColors.darkPurple,
                bgColor: MyColors.darkPurple.withValues(alpha: 0.12),
                padding: 8,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomTextWidget(
                  Enus.todaysSchedule.tr,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: MyColors.darkPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomTextWidget(
                  dateLabel,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: MyColors.darkPurple,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          if (items.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: palette.cardMuted,
                borderRadius: BorderRadius.circular(16.r),
                border:
                    Border.all(color: palette.border.withValues(alpha: 0.65)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 28.sp,
                    color: MyColors.darkPurple.withValues(alpha: 0.75),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextWidget(
                    emptyMessage ?? Enus.noEventsToday.tr,
                    textAlign: TextAlign.center,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: palette.textSecondary,
                  ),
                ],
              ),
            )
          else
            ...items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _ProgramRow(item: item),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgramRow extends StatelessWidget {
  const _ProgramRow({required this.item});

  final TodayProgramItem item;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final time = item.displayTime;
    final title = item.title?.trim().isNotEmpty == true
        ? item.title!.trim()
        : 'Activity';
    final location = item.locationName?.trim() ?? '';
    final status = item.status?.trim() ?? '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: palette.cardMuted,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: palette.border.withValues(alpha: 0.65)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (time.isNotEmpty) ...[
            SizedBox(
              width: 48.w,
              child: CustomTextWidget(
                time,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: MyColors.darkPurple,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  title,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
                if (location.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  CustomTextWidget(
                    location,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: palette.textSecondary,
                  ),
                ],
                if (status.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  CustomTextWidget(
                    status,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: MyColors.darkPurple.withValues(alpha: 0.85),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
