import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../data/models/map/nearby_place.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../app_card.dart';

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
    return AppCard(
      padding: EdgeInsets.all(4.w),
      radius: 14.r,
      child: Row(
        children: [
          Expanded(
            child: _Tab(
              label: Enus.googleMaps.tr,
              selected: value == MapProviderType.google,
              onTap: () => onChanged(MapProviderType.google),
            ),
          ),
          Expanded(
            child: _Tab(
              label: Enus.yandexMaps.tr,
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
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? MyColors.darkPurple : Colors.transparent,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: selected ? MyColors.white : MyColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
