/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: custom bullets
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/values/app_palette.dart';
import 'custom_text_widget.dart';

class CustomBullet extends StatelessWidget {
  final String text;
  const CustomBullet({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            '• ',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: palette.textPrimary,
          ),
          Expanded(
            child: CustomTextWidget(
              text,
              fontSize: 13.sp,
              fontWeight: FontWeight.w300,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
