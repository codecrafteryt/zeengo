import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Agar Get use karte ho:
// import 'package:get/get.dart';

enum HeaderAlignment { start, end }

class CustomHeaderBarWidget extends StatelessWidget {
  final String? title;
  final bool? radius;
  final double? fontSize;
  final FontWeight? titleFontWeight;
  final Color? titleColor;
  final TextAlign? titleAlign;

  final bool showClear;
  final String? clearText;
  final Color? clearTextColor;
  final double? clearFontSize;
  final FontWeight? clearFontWeight;
  final Function()? functionClear;

  final bool showDivider;
  final String backIconPath;
  final double backIconSize;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onLeadingTap;
  final HeaderAlignment alignment;

  static const EdgeInsets defaultPadding = EdgeInsets.only(
    right: 16, // spacing2
    top: 16,
  );

  const CustomHeaderBarWidget({
    Key? key,
    this.title,
    this.radius = false,
    this.fontSize,
    this.titleFontWeight,
    this.titleColor,
    this.titleAlign,
    this.showClear = true,
    this.clearText,
    this.clearTextColor,
    this.clearFontSize,
    this.clearFontWeight,
    this.functionClear,
    this.showDivider = true,
    this.backIconPath = "assets/icon/close_cancel.svg",
    this.backIconSize = 20.0,
    this.onLeadingTap,
    this.padding,
    this.alignment = HeaderAlignment.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? defaultPadding,
      child: Row(
        mainAxisAlignment: alignment == HeaderAlignment.end
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          _iconButton(context),
        ],
      ),
    );
  }

  Widget _iconButton(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onLeadingTap ?? () {
          // Get use karte ho to: Get.back();
          Navigator.of(context).maybePop();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
        ),
        child: SvgPicture.asset(
          backIconPath,
          height: backIconSize,
        ),
      ),
    );
  }
}
