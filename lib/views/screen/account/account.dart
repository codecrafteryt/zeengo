/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Account / More — Guest profile + Trip, Payments, Travel, Support, Settings
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controller/language_controller.dart';
import '../../../controller/theme_controller.dart';
import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../../widgets/custom_text_widget.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final topPad = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: palette.scaffold,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24.w, topPad + 16.h, 24.w, 28.h),
              decoration: BoxDecoration(
                color: palette.card,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    Enus.profile.tr,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                    letterSpacing: -0.5,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 72.w,
                        height: 72.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: palette.cardMuted,
                          border: Border.all(color: palette.border, width: 1),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 40.sp,
                          color: MyColors.grayscale40,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              Enus.guest.tr,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary,
                            ),
                            SizedBox(height: 4.h),
                            CustomTextWidget(
                              Enus.showProfile.tr,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: palette.textSecondary,
                              decoration: TextDecoration.underline,
                              decorationColor: palette.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => _toast(Enus.profile),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: palette.textPrimary,
                        side: BorderSide(color: palette.textPrimary, width: 1.2),
                        shape: const StadiumBorder(),
                      ),
                      child: CustomTextWidget(
                        Enus.showProfile.tr,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),

          ..._buildSection(
            context,
            titleKey: Enus.trip,
            tiles: const [
              (Icons.assignment_outlined, null, Enus.bookingDetails),
              (Icons.calendar_today_outlined, null, Enus.dailyProgram),
              (Icons.edit_outlined, null, Enus.requestChanges),
              (Icons.notifications_outlined, null, Enus.notifications),
            ],
          ),

          ..._buildSection(
            context,
            titleKey: Enus.payments,
            tiles: const [
              (Icons.account_balance_wallet_outlined, null, Enus.outstandingBalance),
              (Icons.receipt_long_outlined, null, Enus.paymentHistory),
              (Icons.currency_exchange_outlined, null, Enus.currencyCalculator),
            ],
          ),

          ..._buildSection(
            context,
            titleKey: Enus.travel,
            tiles: const [
              (Icons.mosque_outlined, null, Enus.prayerTimes),
              (Icons.menu_book_outlined, null, Enus.russiaGuide),
              (Icons.map_outlined, null, Enus.maps),
              (Icons.place_outlined, null, Enus.nearbyPlaces),
            ],
          ),

          ..._buildSection(
            context,
            titleKey: Enus.support,
            tiles: const [
              (Icons.chat_bubble_outline_rounded, null, Enus.chat),
              (Icons.emergency_outlined, null, Enus.emergencyContacts),
            ],
          ),

          ..._buildSection(
            context,
            titleKey: Enus.settings,
            tiles: const [
              (null, MyImages.translateFlatSvg, Enus.language),
              (Icons.dark_mode_outlined, null, Enus.theme),
              (Icons.info_outline_rounded, null, Enus.about),
              (Icons.menu_book_outlined, null, Enus.privacyPolicy),
            ],
            onTileTap: (key) {
              if (key == Enus.language) {
                Get.find<LanguageController>().showLanguagePicker();
                return;
              }
              if (key == Enus.theme) {
                Get.find<ThemeController>().showThemePicker();
                return;
              }
              _toast(key);
            },
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h + bottomPad),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            MyImages.logout,
                            width: 23.w,
                            height: 23.h,
                            colorFilter: ColorFilter.mode(
                              palette.icon,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          CustomTextWidget(
                            Enus.logout.tr,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: palette.textPrimary,
                            decoration: TextDecoration.underline,
                            decorationColor: palette.textPrimary,
                          ),
                        ],
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

  static List<Widget> _buildSection(
    BuildContext context, {
    required String titleKey,
    required List<(IconData?, String?, String)> tiles,
    void Function(String key)? onTileTap,
  }) {
    final palette = AppPalette.of(context);
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: CustomTextWidget(
            titleKey.tr,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 12.h)),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: _AccountCard(
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i > 0) _divider(context),
                _AccountTile(
                  icon: tiles[i].$1,
                  svgAsset: tiles[i].$2,
                  label: tiles[i].$3.tr,
                  onTap: () =>
                      (onTileTap ?? (key) => _toast(key))(tiles[i].$3),
                ),
              ],
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 28.h)),
    ];
  }

  static void _toast(String key) {
    Get.snackbar(
      key.tr,
      Enus.sectionComingSoon.tr,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  static Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppPalette.of(context).border,
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    this.icon,
    this.svgAsset,
    required this.label,
    required this.onTap,
  }) : assert(icon != null || svgAsset != null);

  final IconData? icon;
  final String? svgAsset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              if (svgAsset != null)
                SvgPicture.asset(
                  svgAsset!,
                  width: 24.sp,
                  height: 24.sp,
                  colorFilter: ColorFilter.mode(palette.icon, BlendMode.srcIn),
                )
              else
                Icon(icon, size: 24.sp, color: palette.icon),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomTextWidget(
                  label,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: palette.textPrimary,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 24.sp,
                color: MyColors.grayscale30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
