/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Bottom navigation — solid white bar (Home, Around, Russia, Trip)
*/
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zeengo/views/screen/around/around_screen.dart';
import 'package:zeengo/views/screen/explore_russia/explore_russia_screen.dart';
import 'package:zeengo/views/screen/my_trip/my_trip_screen.dart';

import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import 'explore_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  static const _homeIndex = 0;
  static const _barH = 58.0;
  static const _sizeAnim = Duration(milliseconds: 220);

  int _selectedIndex = 0;
  bool _collapsed = false;

  List<({String asset, String label})> get _items => [
        (asset: MyImages.navHomeSvg, label: Enus.explore.tr),
        (asset: MyImages.navMapSvg, label: Enus.around.tr),
        (asset: MyImages.navSparkleSvg, label: Enus.exploreRussia.tr),
        (asset: MyImages.navTripSvg, label: Enus.myTrip.tr),
      ];

  double _bottomPad(double systemBottom) {
    if (systemBottom <= 0) return 8;
    return (systemBottom - 12).clamp(8.0, 40.0);
  }

  double _contentReserve(double systemBottom, bool collapsed) {
    final h = collapsed ? 44.0 : _barH;
    return h + _bottomPad(systemBottom);
  }

  void _onItemTapped(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (index == _selectedIndex) {
      if (index == _homeIndex && _collapsed) {
        setState(() => _collapsed = false);
      }
      return;
    }
    setState(() {
      _selectedIndex = index;
      _collapsed = false;
    });
  }

  bool _onScroll(ScrollNotification n) {
    if (_selectedIndex != _homeIndex) return false;
    if (n is! UserScrollNotification) return false;
    if (n.metrics.axis != Axis.vertical) return false;
    switch (n.direction) {
      case ScrollDirection.reverse:
        if (!_collapsed) setState(() => _collapsed = true);
        break;
      case ScrollDirection.forward:
        if (_collapsed) setState(() => _collapsed = false);
        break;
      case ScrollDirection.idle:
        break;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final systemBottom = mq.padding.bottom;
    final keyboard = mq.viewInsets.bottom;
    final collapsed = _selectedIndex == _homeIndex && _collapsed;
    final reserve = _contentReserve(systemBottom, collapsed);
    final bottomPad = _bottomPad(systemBottom);
    final barH = collapsed ? 44.0 : _barH;

    final pages = <Widget>[
      NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: const ExploreScreen(),
      ),
      const AroundScreen(),
      const ExploreRussiaScreen(),
      const MyTripScreen(),
    ];

    return MediaQuery(
      data: mq.copyWith(viewInsets: EdgeInsets.zero),
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: MediaQuery(
                data: mq.copyWith(
                  viewInsets: EdgeInsets.zero,
                  padding: mq.padding.copyWith(bottom: reserve + keyboard),
                  viewPadding:
                      mq.viewPadding.copyWith(bottom: reserve + keyboard),
                ),
                child: pages[_selectedIndex],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomPad + keyboard,
              child: Center(
                child: AnimatedContainer(
                  duration: _sizeAnim,
                  curve: Curves.easeInOut,
                  height: barH,
                  margin: EdgeInsets.symmetric(horizontal: collapsed ? 36 : 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: MyColors.borderSubtle, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      for (var i = 0; i < _items.length; i++)
                        Expanded(
                          child: _NavSlot(
                            asset: _items[i].asset,
                            label: _items[i].label,
                            selected: _selectedIndex == i,
                            iconSize: collapsed ? 18.0 : 22.0,
                            onTap: () => _onItemTapped(i),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavSlot extends StatelessWidget {
  const _NavSlot({
    required this.asset,
    required this.label,
    required this.selected,
    required this.iconSize,
    required this.onTap,
  });

  final String asset;
  final String label;
  final bool selected;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? MyColors.aloForest : const Color(0xFF6B6B6B);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              horizontal: selected ? 12 : 8,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? MyColors.aloMintSoft
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SvgPicture.asset(
              asset,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
