import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/language_controller.dart';
import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';
import '../app_circle_icon_button.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({
    super.key,
    required this.userName,
    required this.packageLabel,
    required this.bookingId,
    this.onNotifications,
    this.onLogout,
  });

  final String userName;
  final String packageLabel;
  final String bookingId;
  final VoidCallback? onNotifications;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final lang = Get.find<LanguageController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, top + 12.h, 16.w, 28.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.darkPurple,
            MyColors.darkPurple.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
      ),
      child: Column(
        children: [
          Text(
            'ZEENGO - $bookingId',
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: MyColors.white.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Obx(
                () => AppCircleIconButton(
                  label: lang.isArabic ? 'EN' : 'ع',
                  foregroundColor: MyColors.darkPurple,
                  onTap: lang.showLanguagePicker,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      Enus.welcomeUser.trParams({'name': userName}),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: MyColors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      packageLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: MyFonts.plusJakartaSans,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: MyColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              AppCircleIconButton(
                svgAsset: MyImages.exploreBell,
                foregroundColor: MyColors.darkPurple,
                onTap: onNotifications,
              ),
              SizedBox(width: 8.w),
              AppCircleIconButton(
                svgAsset: MyImages.exploreLogout,
                foregroundColor: MyColors.darkPurple,
                onTap: onLogout,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
