/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Splash screen
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/extensions/extentions.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_images.dart';
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
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Get.off(() => const HomePages());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Image.asset(
                MyImages.appIcon,
                width: 140.w,
                height: 140.w,
                fit: BoxFit.contain,
              ),
            ),
            20.sbh,
            LoadingAnimationWidget.waveDots(
              color: MyColors.darkPurple,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
