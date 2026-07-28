// lib/widgets/custom_leading_icon.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/values/my_color.dart';

class CustomLeadingIcon extends StatelessWidget {

  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double containerSize;
  final EdgeInsets padding;
  final VoidCallback? onPressed;
  final BoxShape shape;

  CustomLeadingIcon({
    this.backgroundColor = MyColors.darkWhite,
    this.icon = Icons.arrow_back_outlined,
    this.iconColor = Colors.black,
    this.iconSize = 24.0,
    this.containerSize = 40.0,
    this.padding = const EdgeInsets.all(5.0),
    this.onPressed,
    this.shape = BoxShape.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        width: containerSize.w,
        height: containerSize.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: shape,
        ),
        child: IconButton(
          icon: Icon(
            icon,
            color: iconColor,
            size: iconSize.h,
          ),
          onPressed: onPressed ?? () => Get.back(), // Use Get.back() if onPressed is null
        ),
      ),
    );
  }
}
