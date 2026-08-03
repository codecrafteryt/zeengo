/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Splash screen
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/extensions/extentions.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_images.dart';
import '../../data/enus.dart';
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
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Image.asset(
                    MyImages.braelo_logo,
                    width: 220.w,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.sports_soccer_rounded,
                      size: 120.w,
                      color: MyColors.brandPrimary,
                    ),
                  ),
                ),
                20.sbh,
                const CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.teal,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: _SplashVersionText(),
          ),
        ],
      ),
    );
  }
}

class _SplashVersionText extends StatelessWidget {
  const _SplashVersionText();

  @override
  Widget build(BuildContext context) {
    return Text(
      Enus.version.trParams({'version': '1.0.2'}),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: MyColors.black,
      ),
    );
  }
}
