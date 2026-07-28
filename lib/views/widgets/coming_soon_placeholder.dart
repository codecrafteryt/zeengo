/*
  Polished “Coming soon” empty state for tab placeholders.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/values/my_color.dart';
import '../../utils/values/my_fonts.dart';

class ComingSoonPlaceholder extends StatelessWidget {
  const ComingSoonPlaceholder({
    super.key,
    required this.title,
    required this.icon,
    this.message,
  });

  final String title;
  final IconData icon;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    return ColoredBox(
      color: MyColors.scaffoldMuted,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(28.w, 24.h, 28.w, 24.h + bottomPad),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.brandPrimary.withValues(alpha: 0.12),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        color: MyColors.brandPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 36.sp,
                        color: MyColors.brandPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: MyColors.blackDark,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: MyColors.brandPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Coming soon',
                    style: TextStyle(
                      fontFamily: MyFonts.plusJakartaSans,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: MyColors.brandPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  message ??
                      'We\'re building something great here. Check back soon for updates.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 15.sp,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: MyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
