/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Account / More — Guest profile + Trip, Payments, Travel, Support, Settings
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: MyColors.scaffoldMuted,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24.w, topPad + 16.h, 24.w, 28.h),
              decoration: const BoxDecoration(
                color: MyColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontFamily: MyFonts.plusJakartaSans,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: MyColors.blackDark,
                      letterSpacing: -0.5,
                    ),
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
                          color: MyColors.darkWhite,
                          border: Border.all(color: MyColors.borderSubtle, width: 1),
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
                            Text(
                              'Guest',
                              style: TextStyle(
                                fontFamily: MyFonts.plusJakartaSans,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: MyColors.blackDark,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Show profile',
                              style: TextStyle(
                                fontFamily: MyFonts.plusJakartaSans,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: MyColors.textSecondary,
                                decoration: TextDecoration.underline,
                                decorationColor: MyColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _toast('Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MyColors.blackDark,
                        side: const BorderSide(color: MyColors.blackDark, width: 1.2),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Show profile',
                        style: TextStyle(
                          fontFamily: MyFonts.plusJakartaSans,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),

          ..._buildSection(
            title: 'Trip',
            tiles: const [
              (Icons.assignment_outlined, 'Booking Details'),
              (Icons.calendar_today_outlined, 'Daily Program'),
              (Icons.edit_outlined, 'Request Changes'),
              (Icons.notifications_outlined, 'Notifications'),
            ],
          ),

          ..._buildSection(
            title: 'Payments',
            tiles: const [
              (Icons.account_balance_wallet_outlined, 'Outstanding Balance'),
              (Icons.receipt_long_outlined, 'Payment History'),
              (Icons.currency_exchange_outlined, 'Currency Calculator'),
            ],
          ),

          ..._buildSection(
            title: 'Travel',
            tiles: const [
              (Icons.mosque_outlined, 'Prayer Times'),
              (Icons.menu_book_outlined, 'Russia Guide'),
              (Icons.map_outlined, 'Maps'),
              (Icons.place_outlined, 'Nearby Places'),
            ],
          ),

          ..._buildSection(
            title: 'Support',
            tiles: const [
              (Icons.chat_bubble_outline_rounded, 'Chat'),
              (Icons.emergency_outlined, 'Emergency Contacts'),
            ],
          ),

          ..._buildSection(
            title: 'Settings',
            tiles: const [
              (Icons.translate_rounded, 'Language'),
              (Icons.info_outline_rounded, 'About'),
              (Icons.logout_rounded, 'Logout'),
            ],
          ),

          SliverToBoxAdapter(child: SizedBox(height: 12.h + bottomPad)),
        ],
      ),
    );
  }

  static List<Widget> _buildSection({
    required String title,
    required List<(IconData, String)> tiles,
  }) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: MyColors.blackDark,
            ),
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
                if (i > 0) _divider(),
                _AccountTile(
                  icon: tiles[i].$1,
                  label: tiles[i].$2,
                  onTap: () => _toast(tiles[i].$2),
                ),
              ],
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 28.h)),
    ];
  }

  static void _toast(String label) {
    Get.snackbar(
      label,
      'This section is coming soon.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  static Widget _divider() {
    return Divider(height: 1, thickness: 1, color: MyColors.borderSubtle);
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: MyColors.borderSubtle),
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
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(icon, size: 24.sp, color: MyColors.blackDark),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: MyColors.blackDark,
                  ),
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
