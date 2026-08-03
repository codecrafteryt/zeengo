/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Bottom navigation — Explore, Map, Inbox, Pay, Profile
*/
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/map_controller.dart';
import '../../../data/enus.dart';
import '../../../utils/values/air_bnb_style.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';
import '../../widgets/coming_soon_placeholder.dart';
import '../account/account.dart';
import '../chat/chats.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _children = [
    _ExploreTab(),
    _MapTab(),
    Chats(),
    _PayTab(),
    Account(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _navIcon(String asset, {required bool selected}) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        asset,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(
          selected ? MyColors.darkPurple : MyColors.black,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _children,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: MyColors.scaffoldMuted,
          border: Border(
            top: BorderSide(color: MyColors.gray100, width: 0.1),
          ),
        ),
        padding: EdgeInsets.only(bottom: bottomPad > 0 ? bottomPad : 8),
        child: BottomNavigationBar(
          backgroundColor: MyColors.scaffoldMuted,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          selectedItemColor: MyColors.darkPurple,
          unselectedItemColor: MyColors.black,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(
            fontFamily: MyFonts.plusJakartaSans,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: MyFonts.plusJakartaSans,
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

class _ExploreTab extends StatelessWidget {
  const _ExploreTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ComingSoonPlaceholder(
        title: Enus.explore.tr,
        icon: Icons.search_outlined,
        message: Enus.exploreMessage.tr,
      ),
    );
  }
}

class _PayTab extends StatelessWidget {
  const _PayTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ComingSoonPlaceholder(
        title: Enus.pay.tr,
        icon: Icons.credit_card_outlined,
        message: Enus.payMessage.tr,
      ),
    );
  }
}

class _MapTab extends StatelessWidget {
  const _MapTab();

  MapController _resolveController() {
    if (Get.isRegistered<MapController>()) {
      return Get.find<MapController>();
    }
    return Get.put(
      MapController(sharedPreferences: Get.find<SharedPreferences>()),
      permanent: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapController = _resolveController();

    return Scaffold(
      body: GetBuilder<MapController>(
        init: mapController,
        builder: (c) {
          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: MapController.pakistanRoughCenter,
              zoom: MapController.zoomSheetExpanded,
            ),
            padding: c.mapPadding,
            style: kAirbnbLikeMapStyle,
            markers: c.markers,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            onMapCreated: mapController.onMapCreated,
          );
        },
      ),
    );
  }
}
