/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Description: Horizontal "or" separator for auth forms.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_fonts.dart';

class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Divider(
        height: 1,
        thickness: 1,
        color: MyColors.borderSubtle,
      ),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'or',
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: MyColors.textSecondary,
            ),
          ),
        ),
        line,
      ],
    );
  }
}
