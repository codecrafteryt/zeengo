import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/values/app_palette.dart';
import '../../utils/values/my_images.dart';
import 'app_circle_icon_button.dart';

/// Top bar with a close/back action always pinned to the right.
class CustomHeaderBarWidget extends StatelessWidget {
  const CustomHeaderBarWidget({
    super.key,
    this.backIconPath = MyImages.closeCancelSvg,
    this.backIconSize,
    this.buttonSize,
    this.iconColor,
    this.buttonColor,
    this.onLeadingTap,
    this.padding,
  });

  final String backIconPath;
  final double? backIconSize;
  final double? buttonSize;
  final Color? iconColor;
  final Color? buttonColor;
  final VoidCallback? onLeadingTap;
  final EdgeInsetsGeometry? padding;

  static const EdgeInsets defaultPadding = EdgeInsets.only(top: 4);

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Padding(
      padding: padding ?? defaultPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppCircleIconButton(
            svgAsset: backIconPath,
            onTap: onLeadingTap ?? () => Navigator.of(context).maybePop(),
            size: buttonSize ?? 40.w,
            iconSize: backIconSize ?? 16.sp,
            backgroundColor: buttonColor ?? palette.cardMuted,
            foregroundColor: iconColor ?? palette.icon,
          ),
        ],
      ),
    );
  }
}
