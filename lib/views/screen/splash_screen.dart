/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Splash screen
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../controller/auth_controller.dart';
import '../../data/constants.dart';
import '../../utils/extensions/extentions.dart';
import '../../utils/values/app_palette.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_images.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    statusCheck();
  }

  /// Routes to login or restores session after splash delay.
  void statusCheck() {
    Timer(const Duration(seconds: 2), () async {
      if (!mounted) return;

      final auth = Get.find<AuthController>();
      final refreshToken =
          auth.sharedPreferences.getString(Constants.refreshToken);

      debugPrint('====> SPLASH refreshToken=$refreshToken');

      if (refreshToken == null || refreshToken.isEmpty) {
        Get.offAll(() => const LoginScreen());
      } else {
        await auth.checkSession1();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: palette.scaffold,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Image.asset(
                  MyImages.appIconFor(context),
                  width: 250.w,
                  height: 250.h,
                  fit: BoxFit.contain,
                ),
              ),
              20.sbh,
              LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).brightness == Brightness.dark
                    ? MyColors.white
                    : MyColors.black,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
