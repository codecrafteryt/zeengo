/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Bottom navigation — Explore, Map, Inbox, Pay, Profile
*/
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zeengo/views/payouts/payouts.dart';
import 'package:zeengo/views/screen/map/map_screen.dart';
import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../account/account.dart';
import '../chat/chats_screen.dart';
import 'explore_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _children = [
    ExploreScreen(),
    MapScreen(),
    ChatsScreen(),
    Payouts(),
    Account(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _navIcon(String asset, {required bool selected}) {
    final palette = AppPalette.of(context);
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        asset,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(
          selected ? MyColors.darkPurple : palette.icon,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _children,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: palette.navBar,
          border: Border(
            top: BorderSide(color: palette.border, width: 0.5),
          ),
        ),
        padding: EdgeInsets.only(bottom: bottomPad > 0 ? bottomPad : 8),
        child: BottomNavigationBar(
          backgroundColor: palette.navBar,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          selectedItemColor: MyColors.darkPurple,
          unselectedItemColor: palette.icon,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          items: [
            BottomNavigationBarItem(
              icon: _navIcon(MyImages.navExploreSvg, selected: false),
              activeIcon: _navIcon(MyImages.navExploreSvg, selected: true),
              label: Enus.explore.tr,
            ),
            BottomNavigationBarItem(
              icon: _navIcon(MyImages.navMapSvg, selected: false),
              activeIcon: _navIcon(MyImages.navMapSvg, selected: true),
              label: Enus.map.tr,
            ),
            BottomNavigationBarItem(
              icon: _navIcon(MyImages.navInboxSvg, selected: false),
              activeIcon: _navIcon(MyImages.navInboxSvg, selected: true),
              label: Enus.inbox.tr,
            ),
            BottomNavigationBarItem(
              icon: _navIcon(MyImages.navPaySvg, selected: false),
              activeIcon: _navIcon(MyImages.navPaySvg, selected: true),
              label: Enus.pay.tr,
            ),
            BottomNavigationBarItem(
              icon: _navIcon(MyImages.navProfileSvg, selected: false),
              activeIcon: _navIcon(MyImages.navProfileSvg, selected: true),
              label: Enus.profile.tr,
            ),
          ],
        ),
      ),
    );
  }
}
