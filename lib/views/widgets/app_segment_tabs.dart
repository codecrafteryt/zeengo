import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/values/app_palette.dart';
import '../../utils/values/my_color.dart';
import 'custom_text_widget.dart';

class AppSegmentTab {
  const AppSegmentTab({
    required this.label,
    required this.svgAsset,
  });

  final String label;
  final String svgAsset;
}

/// Pill segment control — same visual language as [MapProviderSwitch].
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
    final palette = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: palette.card.withValues(alpha: isDark ? 0.92 : 0.96),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: palette.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: _SegmentItem(
                tab: tabs[i],
                selected: i == index,
                onTap: () => onChanged(i),
              ),
            ),
        ],
      ),
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
    final palette = AppPalette.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: selected
            ? const LinearGradient(
                colors: [Color(0xFF818CF8), MyColors.darkPurple],
              )
            : null,
        boxShadow: selected
            ? [
                BoxShadow(
                  color: MyColors.darkPurple.withValues(alpha: 0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  tab.svgAsset,
                  width: 15.sp,
                  height: 15.sp,
                  colorFilter: ColorFilter.mode(
                    selected ? MyColors.white : palette.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 5.w),
                Flexible(
                  child: CustomTextWidget(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: selected ? MyColors.white : palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
