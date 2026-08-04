import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../../widgets/custom_text_widget.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: palette.scaffold,
      appBar: AppBar(
        backgroundColor: palette.card,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: palette.icon),
        ),
        title: CustomTextWidget(
          Enus.notifications.tr,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
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
              CustomTextWidget(
                Enus.noNotifications.tr,
                textAlign: TextAlign.center,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
              SizedBox(height: 8.h),
              CustomTextWidget(
                Enus.noNotificationsMessage.tr,
                textAlign: TextAlign.center,
                fontSize: 13.sp,
                height: 1.4,
                color: palette.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
