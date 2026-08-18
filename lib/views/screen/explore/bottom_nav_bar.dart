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
import '../../../controller/map_controller.dart';
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

  static const double _barContentHeight = 56;

  void _onItemTapped(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _selectedIndex = index);
  }

  Widget _navIcon(String asset, {required bool selected}) {
    final palette = AppPalette.of(context);
    return SvgPicture.asset(
      asset,
      width: 22,
      height: 22,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(
        selected ? MyColors.darkPurple : palette.icon,
        BlendMode.srcIn,
      ),
    );
  }

  /// Content row (56) + home indicator / fallback pad. Never double-count
  /// MediaQuery padding inside the bar itself (that caused iOS overflow).
  double _navBarHeight(double bottomSafe) {
    return _barContentHeight + (bottomSafe > 0 ? bottomSafe : 8);
  }

  Widget _buildBottomNav(AppPalette palette, double bottomPad) {
    final items = <({String asset, String label})>[
      (asset: MyImages.navExploreSvg, label: Enus.explore.tr),
      (asset: MyImages.navMapSvg, label: Enus.map.tr),
      (asset: MyImages.navInboxSvg, label: Enus.inbox.tr),
      (asset: MyImages.navPaySvg, label: Enus.pay.tr),
      (asset: MyImages.navProfileSvg, label: Enus.profile.tr),
    ];

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
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.textScalerOf(context).clamp(
              minScaleFactor: 1,
              maxScaleFactor: 1.1,
            ),
          ),
          child: SizedBox(
            height: _barContentHeight,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavBarItem(
                      label: items[i].label,
                      selected: _selectedIndex == i,
                      icon: _navIcon(
                        items[i].asset,
                        selected: _selectedIndex == i,
                      ),
                      selectedColor: MyColors.darkPurple,
                      unselectedColor: palette.icon,
                      onTap: () => _onItemTapped(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
      id: MapController.mapUiId,
      builder: (_) => _buildShell(context),
    );
  }

  Widget _buildShell(BuildContext context) {
    final palette = AppPalette.of(context);
    final mq = MediaQuery.of(context);
    final bottomSafe = mq.viewPadding.bottom;
    final keyboard = mq.viewInsets.bottom;
    final hideNav = Get.find<MapController>().isNavigating;
    final navHeight = hideNav ? 0.0 : _navBarHeight(bottomSafe);

    final children = <Widget>[
      const ExploreScreen(),
      MapTabHost(isActive: _selectedIndex == 1),
      const ChatsScreen(),
      const Payouts(),
      const Account(),
    ];

    // Pin the bar to the physical bottom. Shrink only tab content by
    // (navHeight + keyboard) so IME never lifts the nav bar.
    return MediaQuery(
      data: mq.copyWith(viewInsets: EdgeInsets.zero),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: navHeight + keyboard,
              child: MediaQuery(
                data: mq.copyWith(viewInsets: EdgeInsets.zero),
                child: IndexedStack(
                  index: _selectedIndex,
                  children: children,
                ),
              ),
            ),
            if (!hideNav)
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

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.label,
    required this.selected,
    required this.icon,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Widget icon;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? selectedColor : unselectedColor;
    return InkWell(
      onTap: onTap,
      splashColor: selectedColor.withValues(alpha: 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              height: 1.1,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
