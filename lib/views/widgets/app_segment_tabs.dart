import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/values/my_color.dart';
import '../../utils/values/my_fonts.dart';
import 'app_card.dart';

class AppSegmentTab {
  const AppSegmentTab({
    required this.label,
    required this.svgAsset,
  });

  final String label;
  final String svgAsset;
}

/// Reusable equal-width segment tabs with Airbnb elevation.
class AppSegmentTabs extends StatelessWidget {
  const AppSegmentTabs({
    super.key,
    required this.tabs,
    required this.index,
    required this.onChanged,
  });

  final List<AppSegmentTab> tabs;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          if (i > 0) SizedBox(width: 8.w),
          Expanded(
            child: _SegmentItem(
              tab: tabs[i],
              selected: i == index,
              onTap: () => onChanged(i),
            ),
          ),
        ],
      ],
    );
  }
}

class _SegmentItem extends StatelessWidget {
  const _SegmentItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final AppSegmentTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? MyColors.darkPurple : MyColors.textSecondary;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      radius: 16.r,
      color: selected
          ? MyColors.darkPurple.withValues(alpha: 0.08)
          : MyColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            tab.svgAsset,
            width: 22.sp,
            height: 22.sp,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          SizedBox(height: 6.h),
          Text(
            tab.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 12.sp,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
