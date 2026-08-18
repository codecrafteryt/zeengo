/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Splash screen
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/extensions/extentions.dart';
import '../../utils/values/app_palette.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_images.dart';
import '../auth/login_screen.dart';
import 'explore/home_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 5100), () {
      if (!mounted) return;
      Get.off(() => const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
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
                color: Theme.of(context).brightness == Brightness.dark ? MyColors.white : MyColors.black,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
