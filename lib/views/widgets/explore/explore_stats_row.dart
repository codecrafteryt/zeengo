import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
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
          Expanded(child: _StatCard(item: items[i], index: i)),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item, required this.index});

  final ExploreStatItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 12),
          child: child,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: palette.border.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            AppSvgIcon(
              asset: item.svgAsset,
              size: 20.sp,
              color: item.iconColor,
              bgColor: item.bgColor,
              padding: 10,
            ),
            SizedBox(height: 12.h),
            CustomTextWidget(
              item.value,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
            SizedBox(height: 3.h),
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
      ),
    );
  }
}
