import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../data/models/map/nearby_place.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../custom_text_widget.dart';

class MapProviderSwitch extends StatelessWidget {
  const MapProviderSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final MapProviderType value;
  final ValueChanged<MapProviderType> onChanged;

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
          Expanded(
            child: _Tab(
              label: Enus.googleMaps.tr,
              icon: Icons.map_rounded,
              selected: value == MapProviderType.google,
              onTap: () => onChanged(MapProviderType.google),
            ),
          ),
          Expanded(
            child: _Tab(
              label: Enus.yandexMaps.tr,
              icon: Icons.layers_rounded,
              selected: value == MapProviderType.yandex,
              onTap: () => onChanged(MapProviderType.yandex),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
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
            padding: EdgeInsets.symmetric(vertical: 11.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15.sp,
                  color: selected ? MyColors.white : palette.textSecondary,
                ),
                SizedBox(width: 6.w),
                CustomTextWidget(
                  label,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: selected ? MyColors.white : palette.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
