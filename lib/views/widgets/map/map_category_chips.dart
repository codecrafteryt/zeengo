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

class MapCategoryChips extends StatelessWidget {
  const MapCategoryChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PlaceCategory selected;
  final ValueChanged<PlaceCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final items = <(PlaceCategory, String, String?)>[
      (PlaceCategory.all, Enus.catAll.tr, null),
      (PlaceCategory.mosques, Enus.catMosques.tr, MyImages.mapMosque),
      (PlaceCategory.halal, Enus.catHalal.tr, MyImages.mapHalal),
      (PlaceCategory.atm, Enus.catAtm.tr, MyImages.mapAtm),
      (PlaceCategory.malls, Enus.catMalls.tr, MyImages.mapMall),
    ];

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final (cat, label, icon) = items[i];
          final active = selected == cat;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              gradient: active
                  ? const LinearGradient(
                      colors: [Color(0xFF818CF8), MyColors.darkPurple],
                    )
                  : null,
              color: active ? null : palette.card,
              border: Border.all(
                color: active
                    ? Colors.transparent
                    : palette.border.withValues(alpha: 0.8),
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: MyColors.darkPurple.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onChanged(cat),
                borderRadius: BorderRadius.circular(22.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        AppSvgIcon(
                          asset: icon,
                          size: 15.sp,
                          color: active ? MyColors.white : palette.textPrimary,
                        ),
                        SizedBox(width: 6.w),
                      ],
                      CustomTextWidget(
                        label,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: active ? MyColors.white : palette.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
