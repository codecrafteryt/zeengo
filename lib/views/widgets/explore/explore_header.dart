import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controller/language_controller.dart';
import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../../screen/notifications/notifications_screen.dart';
import '../custom_text_widget.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({
    super.key,
    required this.userName,
    required this.packageLabel,
    required this.bookingId,
  });

  final String userName;
  final String packageLabel;
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final lang = Get.find<LanguageController>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            MyColors.darkPurple,
            Color(0xFF7C3AED),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 0.55, 1],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
        boxShadow: [
          BoxShadow(
            color: MyColors.darkPurple.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
        child: Stack(
          children: [
            Positioned(
              right: -48.w,
              top: -36.h,
              child: _GlowOrb(size: 160.w, opacity: 0.16),
            ),
            Positioned(
              left: -40.w,
              bottom: -20.h,
              child: _GlowOrb(size: 120.w, opacity: 0.12),
            ),
            Positioned(
              right: 48.w,
              bottom: 24.h,
              child: _GlowOrb(size: 64.w, opacity: 0.1),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, top + 14.h, 18.w, 34.h),
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: MyColors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: MyColors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: CustomTextWidget(
                      'ZEENGO · $bookingId',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: MyColors.white.withValues(alpha: 0.92),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Obx(
                        () => _GlassIconButton(
                          label: lang.isArabic ? 'EN' : 'ع',
                          onTap: lang.showLanguagePicker,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            CustomTextWidget(
                              Enus.welcomeUser.trParams({'name': userName}),
                              textAlign: TextAlign.center,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: MyColors.white,
                              height: 1.15,
                            ),
                            SizedBox(height: 6.h),
                            CustomTextWidget(
                              packageLabel,
                              textAlign: TextAlign.center,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: MyColors.white.withValues(alpha: 0.88),
                            ),
                          ],
                        ),
                      ),
                      _GlassIconButton(
                        svgAsset: MyImages.notificationFlat,
                        onTap: () =>
                            Get.to(() => const NotificationsScreen()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MyColors.white.withValues(alpha: opacity),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    this.label,
    this.svgAsset,
    required this.onTap,
  }) : assert(label != null || svgAsset != null);

  final String? label;
  final String? svgAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MyColors.white.withValues(alpha: 0.16),
            border: Border.all(
              color: MyColors.white.withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: label != null
                ? CustomTextWidget(
                    label!,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: MyColors.white,
                  )
                : SvgPicture.asset(
                    svgAsset!,
                    width: 18.sp,
                    height: 18.sp,
                    colorFilter: const ColorFilter.mode(
                      MyColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
