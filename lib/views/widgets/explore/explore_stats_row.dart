import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
import '../app_card.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

class ExploreStatItem {
  const ExploreStatItem({
    required this.svgAsset,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.bgColor,
  });

  final String svgAsset;
  final String value;
  final String label;
  final Color iconColor;
  final Color bgColor;
}

class ExploreStatsRow extends StatelessWidget {
  const ExploreStatsRow({super.key, required this.items});

  final List<ExploreStatItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: 10.w),
          Expanded(child: _StatCard(item: items[i])),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item});

  final ExploreStatItem item;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      child: Column(
        children: [
          AppSvgIcon(
            asset: item.svgAsset,
            size: 22.sp,
            color: item.iconColor,
            bgColor: item.bgColor,
            padding: 10,
          ),
          SizedBox(height: 10.h),
          CustomTextWidget(
            item.value,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
          SizedBox(height: 2.h),
          CustomTextWidget(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: palette.textSecondary,
          ),
        ],
      ),
    );
  }
}
