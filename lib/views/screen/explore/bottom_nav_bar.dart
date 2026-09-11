/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Bottom navigation — Explore, Map, Inbox, Pay, Profile
  Braelo-matching floating frosted capsule nav (collapse on Explore scroll).
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zeengo/views/payouts/payouts.dart';
import 'package:zeengo/views/screen/map/map_screen.dart';

import '../../../controller/map_controller.dart';
import '../../../data/enus.dart';
import '../../../utils/values/my_images.dart';
import '../account/account.dart';
import '../chat/chats_screen.dart';
import 'explore_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  static const _homeIndex = 0;
  static const _expandedH = 58.0;
  static const _collapsedH = 44.0;
  static const _collapsedWidthFactor = 0.78;
  static const _sizeAnim = Duration(milliseconds: 220);
  static const _slideAnim = Duration(milliseconds: 500);

  int _selectedIndex = 0;
  bool _collapsed = false;

  late final AnimationController _highlightCtrl;
  late Animation<double> _highlightT;
  int _fromIndex = 0;
  int _toIndex = 0;

  List<({String asset, String label})> get _items => [
        (asset: MyImages.navExploreSvg, label: Enus.explore.tr),
        (asset: MyImages.navMapSvg, label: Enus.map.tr),
        (asset: MyImages.navInboxSvg, label: Enus.inbox.tr),
        (asset: MyImages.navPaySvg, label: Enus.pay.tr),
        (asset: MyImages.navProfileSvg, label: Enus.profile.tr),
      ];

  @override
  void initState() {
    super.initState();
    _highlightCtrl = AnimationController(vsync: this, duration: _slideAnim);
    _highlightT = AlwaysStoppedAnimation(_selectedIndex.toDouble());
    _fromIndex = _selectedIndex;
    _toIndex = _selectedIndex;
  }

  @override
  void dispose() {
    _highlightCtrl.dispose();
    super.dispose();
  }

  double _bottomPad(double systemBottom) {
    if (systemBottom <= 0) return 6;
    return (systemBottom - 18).clamp(6.0, 40.0);
  }

  double _barH(bool collapsed) => collapsed ? _collapsedH : _expandedH;

  double _contentReserve(double systemBottom, bool collapsed, bool hideNav) {
    if (hideNav) return 0;
    return _barH(collapsed) + _bottomPad(systemBottom);
  }

  void _onItemTapped(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (index == _selectedIndex) {
      if (index == _homeIndex && _collapsed) {
        setState(() => _collapsed = false);
      }
      return;
    }
    _fromIndex = _selectedIndex;
    _toIndex = index;
    _highlightT = Tween<double>(
      begin: _fromIndex.toDouble(),
      end: _toIndex.toDouble(),
    ).animate(CurvedAnimation(
      parent: _highlightCtrl,
      curve: Curves.easeOutCubic,
    ));
    _highlightCtrl.forward(from: 0);
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
    return GetBuilder<MapController>(
      id: MapController.mapUiId,
      builder: (_) => _buildShell(context),
    );
  }

  Widget _buildShell(BuildContext context) {
    final mq = MediaQuery.of(context);
    final systemBottom = mq.padding.bottom;
    final keyboard = mq.viewInsets.bottom;
    final hideNav = Get.find<MapController>().isNavigating;
    final collapsed = _selectedIndex == _homeIndex && _collapsed;
    final reserve = _contentReserve(systemBottom, collapsed, hideNav);
    final bottomPad = _bottomPad(systemBottom);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = <Widget>[
      NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: const ExploreScreen(),
      ),
      MapTabHost(isActive: _selectedIndex == 1),
      const ChatsScreen(),
      const Payouts(),
      const Account(),
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
            if (!hideNav)
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomPad + keyboard,
                child: AnimatedAlign(
                  duration: _sizeAnim,
                  curve: Curves.easeInOut,
                  alignment: Alignment.bottomCenter,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final sw = constraints.maxWidth;
                      final expandedW = sw - 28;
                      final collapsedW = sw * _collapsedWidthFactor;
                      final barW = collapsed ? collapsedW : expandedW;
                      return AnimatedContainer(
                        duration: _sizeAnim,
                        curve: Curves.easeInOut,
                        width: barW,
                        child: AnimatedBuilder(
                          animation: _highlightCtrl,
                          builder: (context, _) {
                            final t = _highlightCtrl.isAnimating
                                ? _highlightT.value
                                : _selectedIndex.toDouble();
                            return _FloatingBar(
                              highlightT: t,
                              collapsed: collapsed,
                              isDark: isDark,
                              onHomeTab: _selectedIndex == _homeIndex,
                              items: _items,
                              selectedIndex: _selectedIndex,
                              onTap: _onItemTapped,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FloatingBar extends StatelessWidget {
  const _FloatingBar({
    required this.highlightT,
    required this.collapsed,
    required this.isDark,
    required this.onHomeTab,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  final double highlightT;
  final bool collapsed;
  final bool isDark;
  final bool onHomeTab;
  final List<({String asset, String label})> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const _radius = 32.0;
  static const _sizeAnim = Duration(milliseconds: 220);
  static const _lightIcon = Color(0xFF333333);
  static const _darkIcon = Color(0xFFE8E8E8);

  @override
  Widget build(BuildContext context) {
    final fillAlpha = onHomeTab ? 0.60 : 0.35;
    final borderAlpha = onHomeTab ? 0.55 : 0.40;
    final vPad = collapsed ? 1.0 : 2.0;
    final hInset = collapsed ? 6.0 : 8.0;
    final iconSize = collapsed ? 15.0 : 18.0;
    final rowH = collapsed ? 24.0 : 30.0;
    final pillPad = collapsed ? 10.0 : 12.0;
    final barH = collapsed ? 44.0 : 58.0;

    final shellFill = isDark
        ? Colors.black.withValues(alpha: fillAlpha)
        : Colors.white.withValues(alpha: fillAlpha);
    final shellBorder = Colors.white.withValues(alpha: borderAlpha);
    final iconColor = isDark ? _darkIcon : _lightIcon;
    final highlight = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : const Color(0xFF333333).withValues(alpha: 0.14);

    return AnimatedContainer(
      duration: _sizeAnim,
      curve: Curves.easeInOut,
      height: barH,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: AnimatedContainer(
            duration: _sizeAnim,
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(vertical: vPad),
            decoration: BoxDecoration(
              color: shellFill,
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(color: shellBorder, width: 1),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final innerW = constraints.maxWidth;
                final usable = (innerW - hInset * 2).clamp(0.0, innerW);
                final slotW = usable / items.length;
                final pillW = (iconSize + pillPad * 2).clamp(0.0, (slotW - 4).clamp(0.0, slotW));
                final pillLeft = hInset + slotW * highlightT + (slotW - pillW) / 2;
                final pillTop = ((constraints.maxHeight - rowH) / 2).clamp(0.0, constraints.maxHeight);

                return Stack(
                  children: [
                    Positioned(
                      left: pillLeft,
                      top: pillTop,
                      width: pillW,
                      height: rowH,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: highlight,
                          borderRadius: BorderRadius.circular(rowH / 2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hInset, vertical: 12),
                      child: Row(
                        children: [
                          for (var i = 0; i < items.length; i++)
                            Expanded(
                              child: _NavSlot(
                                asset: items[i].asset,
                                label: items[i].label,
                                selected: selectedIndex == i,
                                iconSize: iconSize,
                                rowHeight: rowH,
                                iconColor: iconColor,
                                onTap: () => onTap(i),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
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
    required this.rowHeight,
    required this.iconColor,
    required this.onTap,
  });

  final String asset;
  final String label;
  final bool selected;
  final double iconSize;
  final double rowHeight;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: rowHeight,
          child: Center(
            child: SvgPicture.asset(
              asset,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
