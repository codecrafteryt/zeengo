import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
import '../app_card.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

class ExploreActionItem {
  const ExploreActionItem({
    required this.svgAsset,
    required this.title,
    required this.subtitle,
    required this.accent,
    this.onTap,
  });

  final String svgAsset;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback? onTap;
}

class ExploreActionsGrid extends StatelessWidget {
  const ExploreActionsGrid({super.key, required this.items});

  final List<ExploreActionItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (_, i) => _ActionCard(item: items[i]),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.item});

  final ExploreActionItem item;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      onTap: item.onTap,
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvgIcon(
            asset: item.svgAsset,
            size: 20.sp,
            color: item.accent,
            bgColor: item.accent.withValues(alpha: 0.12),
            padding: 10,
          ),
          const Spacer(),
          CustomTextWidget(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
          SizedBox(height: 2.h),
          CustomTextWidget(
            item.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: palette.textSecondary,
          ),
        ],
      ),
    );
  }
}
