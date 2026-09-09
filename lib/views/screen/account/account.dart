/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Account / Profile — Airbnb list tiles + Cupertino sheets
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/language_controller.dart';
import '../../../controller/theme_controller.dart';
import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../../widgets/ai/ai_assistant_sheet.dart';
import '../../widgets/cupertino_option_sheet.dart';
import '../../widgets/currency/currency_calculator_sheet.dart';
import '../../widgets/custom_text_widget.dart';
import '../../widgets/suggestions/suggestions_sheet.dart';
import '../notifications/notifications_screen.dart';

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
          SliverToBoxAdapter(child: _ProfileHeader(topPad: topPad)),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: _AccountCard(
                children: [
                  _AccountTile(
                    svgAsset: MyImages.notificationFlat,
                    label: Enus.notifications.tr,
                    onTap: () => Get.to(() => const NotificationsScreen()),
                  ),
                  _divider(context),
                  _AccountTile(
                    svgAsset: MyImages.profileRequestChanges,
                    label: Enus.requestChanges.tr,
                    onTap: () => _toast(Enus.requestChanges),
                  ),
                  _divider(context),
                  _AccountTile(
                    svgAsset: MyImages.profileCurrencyCalculator,
                    label: Enus.currencyCalculator.tr,
                    onTap: () => CurrencyCalculatorSheet.show(context),
                  ),
                  _divider(context),
                  _AccountTile(
                    svgAsset: MyImages.profileAiAssistant,
                    label: Enus.aiAssistant.tr,
                    onTap: () => AiAssistantSheet.show(context),
                  ),
                  _divider(context),
                  _AccountTile(
                    svgAsset: MyImages.profileSuggestions,
                    label: Enus.smartSuggestions.tr,
                    onTap: () => SuggestionsSheet.show(context),
                  ),
                  _divider(context),
                  _AccountTile(
                    svgAsset: MyImages.profileMyBooking,
                    label: Enus.myBookingInfo.tr,
                    onTap: () => _toast(Enus.myBookingInfo),
                  ),
                  _divider(context),
                  _AccountTile(
                    icon: Icons.mosque_outlined,
                    label: Enus.prayerTimes.tr,
                    onTap: () => _toast(Enus.prayerTimes),
                  ),
                  _divider(context),
                  _AccountTile(
                    svgAsset: MyImages.profileGuide,
                    label: Enus.russiaGuide.tr,
                    onTap: () => _toast(Enus.russiaGuide),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: _AccountCard(
                children: [
                  _AccountTile(
                    svgAsset: MyImages.translateFlatSvg,
                    label: Enus.language.tr,
                    onTap: () =>
                        Get.find<LanguageController>().showLanguagePicker(),
                  ),
                  _divider(context),
                  _AccountTile(
                    icon: Icons.dark_mode_outlined,
                    label: Enus.theme.tr,
                    onTap: () =>
                        Get.find<ThemeController>().showThemePicker(),
                  ),
                  _divider(context),
                  _AccountTile(
                    icon: Icons.info_outline_rounded,
                    label: Enus.about.tr,
                    onTap: () => _toast(Enus.about),
                  ),
                  _divider(context),
                  _AccountTile(
                    icon: Icons.menu_book_outlined,
                    label: Enus.privacyPolicy.tr,
                    onTap: () => _toast(Enus.privacyPolicy),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 12.h + bottomPad),
              child: InkWell(
                onTap: () => _showLogoutSheet(context),
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
            ),
          ),
        ],
      ),
    );
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

  static void _showLogoutSheet(BuildContext context) {
    CupertinoOptionSheet.show(
      context: context,
      title: Enus.logout.tr,
      cancelLabel: Enus.cancel.tr,
      options: [
        CupertinoSheetOption(
          label: Enus.logout.tr,
          isDestructive: true,
          onTap: () => Get.find<AuthController>().logout(),
        ),
      ],
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.topPad});

  final double topPad;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
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
              onPressed: () => Account._toast(Enus.profile),
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
