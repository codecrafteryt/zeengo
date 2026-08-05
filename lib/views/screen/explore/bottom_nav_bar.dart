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

  void _onItemTapped(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
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

  /// Fixed height of the custom bottom bar (Material bar + safe inset pad).
  double _navBarHeight(double bottomSafe) {
    return kBottomNavigationBarHeight + (bottomSafe > 0 ? bottomSafe : 8);
  }

  Widget _buildBottomNav(AppPalette palette, double bottomPad) {
    return Material(
      color: palette.navBar,
      child: Container(
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

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final mq = MediaQuery.of(context);
    final bottomSafe = mq.padding.bottom;
    final keyboard = mq.viewInsets.bottom;
    final navHeight = _navBarHeight(bottomSafe);

    final children = <Widget>[
      const ExploreScreen(),
      MapTabHost(isActive: _selectedIndex == 1),
      const ChatsScreen(),
      const Payouts(),
      const Account(),
    ];

    // ── ROOT CAUSE (why the bar was "moving up") ───────────────────────────
    // Scaffold.bottomNavigationBar is laid out inside the *same* Flutter view
    // box as the body. When the IME opens:
    //   • Android adjustResize shrinks the view, OR
    //   • Scaffold inset math keeps everything above MediaQuery.viewInsets
    // so body + bottomNavigationBar both sit on top of the keyboard (nav bar
    // looks “pushed up”). resizeToAvoidBottomInset:false alone cannot pin a
    // bar below a smaller host view.
    //
    // FIX: leave bottomNavigationBar empty; pin the bar with Positioned(bottom:0)
    // on a full-height Stack, and shrink *only* the tab content by
    // (navHeight + keyboard). Requires Android adjustNothing so the view
    // height stays full screen (see AndroidManifest).
    // ───────────────────────────────────────────────────────────────────────
    return MediaQuery(
      // Shell ignores IME insets so Scaffold never rebases its layout box.
      data: mq.copyWith(viewInsets: EdgeInsets.zero),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Content only — height reduced by keyboard, not the nav slot.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: navHeight + keyboard,
              child: MediaQuery(
                // Tabs should not re-apply viewInsets (would double-pad).
                data: mq.copyWith(viewInsets: EdgeInsets.zero),
                child: IndexedStack(
                  index: _selectedIndex,
                  children: children,
                ),
              ),
            ),
            // Always fixed to the physical bottom of the screen.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: navHeight,
              child: _buildBottomNav(palette, bottomSafe),
            ),
          ],
        ),
      ),
    );
  }
}
