import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../data/models/map/nearby_place.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

class MapDirectionsSheet extends StatelessWidget {
  const MapDirectionsSheet({
    super.key,
    required this.place,
    required this.etaLabel,
    required this.distanceLabel,
    required this.providerLabel,
    required this.onStart,
    required this.onOpenExternal,
    this.onClose,
  });

  final NearbyPlace place;
  final String etaLabel;
  final String distanceLabel;
  final String providerLabel;
  final VoidCallback onStart;
  final VoidCallback onOpenExternal;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 16.h),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: palette.border.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 28,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (onClose != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onClose,
                      customBorder: const CircleBorder(),
                      child: Ink(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: palette.cardMuted,
                          border: Border.all(
                            color: palette.border.withValues(alpha: 0.8),
                          ),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18.sp,
                          color: palette.icon,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              AppSvgIcon(
                asset: MyImages.mapNavigate,
                size: 20.sp,
                color: MyColors.darkPurple,
                bgColor: MyColors.darkPurple.withValues(alpha: 0.12),
                padding: 10,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      place.name,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: palette.textPrimary,
                    ),
                    SizedBox(height: 6.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: [
                        _MetaChip(label: distanceLabel),
                        _MetaChip(label: etaLabel),
                        _MetaChip(label: providerLabel),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.darkPurple,
                      foregroundColor: MyColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: CustomTextWidget(
                      Enus.startNavigation.tr,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                      color: MyColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: onOpenExternal,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MyColors.darkPurple,
                      side: const BorderSide(
                        color: MyColors.darkPurple,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: CustomTextWidget(
                      Enus.openInMaps.tr,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                      color: MyColors.darkPurple,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: palette.cardMuted,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: palette.border.withValues(alpha: 0.7)),
      ),
      child: CustomTextWidget(
        label,
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: palette.textSecondary,
      ),
    );
  }
}
