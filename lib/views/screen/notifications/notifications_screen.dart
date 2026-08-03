import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: MyColors.scaffoldMuted,
      appBar: AppBar(
        backgroundColor: MyColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: MyColors.blackDark),
        ),
        title: Text(
          Enus.notifications.tr,
          style: TextStyle(
            fontFamily: MyFonts.plusJakartaSans,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: MyColors.blackDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h + bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                MyImages.noNotifications,
                width: 180.w,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.notifications_none_rounded,
                  size: 96.sp,
                  color: MyColors.gray100,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                Enus.noNotifications.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: MyColors.blackDark,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                Enus.noNotificationsMessage.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 13.sp,
                  height: 1.4,
                  color: MyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
