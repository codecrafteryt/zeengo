import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/values/my_color.dart';
import 'app_card.dart';

/// Circular tappable icon button (header actions, etc.).
class AppCircleIconButton extends StatelessWidget {
  const AppCircleIconButton({
    super.key,
    this.svgAsset,
    this.icon,
    this.label,
    this.onTap,
    this.size,
    this.iconSize,
    this.backgroundColor = MyColors.white,
    this.foregroundColor = MyColors.blackDark,
  }) : assert(svgAsset != null || icon != null || label != null);

  final String? svgAsset;
  final IconData? icon;
  final String? label;
  final VoidCallback? onTap;
  final double? size;
  final double? iconSize;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final dim = size ?? 40.w;
    final iSize = iconSize ?? 20.sp;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: dim,
          height: dim,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            boxShadow: AppShadows.soft,
          ),
          alignment: Alignment.center,
          child: _buildChild(iSize),
        ),
      ),
    );
  }

  Widget _buildChild(double iSize) {
    if (label != null) {
      return Text(
        label!,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: foregroundColor,
        ),
      );
    }
    if (svgAsset != null) {
      return SvgPicture.asset(
        svgAsset!,
        width: iSize,
        height: iSize,
        colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
      );
    }
    return Icon(icon, size: iSize, color: foregroundColor);
  }
}
