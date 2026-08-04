import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/values/my_fonts.dart';

/// App-wide text (Roboto by default).
/// `CustomTextWidget('Hello', fontSize: 16.sp, fontWeight: FontWeight.w600)`
class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.letterSpacing,
    this.decoration,
    this.decorationColor,
    this.softWrap,
  });

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final double? letterSpacing;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final fallback = Theme.of(context).colorScheme.onSurface;

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: TextStyle(
        fontFamily: MyFonts.roboto,
        fontSize: fontSize ?? 14.sp,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? fallback,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
        decorationColor: decorationColor ?? color ?? fallback,
      ),
    );
  }
}
