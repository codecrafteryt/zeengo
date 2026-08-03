import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../app_card.dart';

/// Expandable detail shell: title, close, body, primary CTA.
class PayoutDetailShell extends StatelessWidget {
  const PayoutDetailShell({
    super.key,
    required this.title,
    required this.child,
    required this.buttonLabel,
    required this.onClose,
    required this.onAction,
    this.buttonColor = MyColors.darkPurple,
    this.leadingSvg,
  });

  final String title;
  final Widget child;
  final String buttonLabel;
  final VoidCallback onClose;
  final VoidCallback onAction;
  final Color buttonColor;
  final String? leadingSvg;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: MyColors.blackDark,
                  ),
                ),
              ),
              InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(20.r),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(Icons.close_rounded, size: 20.sp, color: MyColors.textSecondary),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          child,
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: MyColors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingSvg != null) ...[
                    SvgPicture.asset(
                      leadingSvg!,
                      width: 18.sp,
                      height: 18.sp,
                      colorFilter: const ColorFilter.mode(
                        MyColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Flexible(
                    child: Text(
                      buttonLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
