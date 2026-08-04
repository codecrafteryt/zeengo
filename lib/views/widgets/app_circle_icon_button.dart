import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/values/app_palette.dart';
import 'app_card.dart';
import 'custom_text_widget.dart';

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
    this.backgroundColor,
    this.foregroundColor,
  }) : assert(svgAsset != null || icon != null || label != null);

  final String? svgAsset;
  final IconData? icon;
  final String? label;
  final VoidCallback? onTap;
  final double? size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final bg = backgroundColor ?? palette.card;
    final fg = foregroundColor ?? palette.icon;
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
            color: bg,
            shape: BoxShape.circle,
            boxShadow: AppShadows.soft(context),
          ),
          alignment: Alignment.center,
          child: _buildChild(iSize, fg),
        ),
      ),
    );
  }

  Widget _buildChild(double iSize, Color fg) {
    if (label != null) {
      return CustomTextWidget(
        label!,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: fg,
      );
    }
    if (svgAsset != null) {
      return SvgPicture.asset(
        svgAsset!,
        width: iSize,
        height: iSize,
        colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
      );
    }
    return Icon(icon, size: iSize, color: fg);
  }
}
