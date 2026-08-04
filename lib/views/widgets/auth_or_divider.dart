/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Horizontal "or" separator for auth forms.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/enus.dart';
import '../../utils/values/app_palette.dart';
import '../widgets/custom_text_widget.dart';

class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final line = Expanded(
      child: Divider(
        height: 1,
        thickness: 1,
        color: palette.border,
      ),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomTextWidget(
            Enus.or.tr,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: palette.textSecondary,
          ),
        ),
        line,
      ],
    );
  }
}
