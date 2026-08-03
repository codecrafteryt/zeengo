import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Colored SVG icon with optional circular background.
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon({
    super.key,
    required this.asset,
    this.size = 24,
    this.color,
    this.bgColor,
    this.padding = 10,
  });

  final String asset;
  final double size;
  final Color? color;
  final Color? bgColor;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );

    if (bgColor == null) return icon;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: icon,
    );
  }
}
