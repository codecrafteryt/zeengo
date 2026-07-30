/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Bottom navigation — Home, Map, Support, Pay, More
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/map_controller.dart';
import '../../../utils/values/air_bnb_style.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../widgets/coming_soon_placeholder.dart';
import '../account/account.dart';
import '../chat/chats.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  static const Color _activeColor = Color(0xFFE8C547);
  static const Color _inactiveColor = Color(0xFF7BA3C4);

  int _selectedIndex = 0;

  late final List<Widget> _children = [
    const Scaffold(
      body: ComingSoonPlaceholder(
        title: 'Home',
        icon: Icons.home_outlined,
        message:
            'Your home feed and nearby venues will show up here soon.',
      ),
    ),
    const _MapTab(),
    const Chats(),
    const Scaffold(
      body: ComingSoonPlaceholder(
        title: 'Pay',
        icon: Icons.credit_card_outlined,
        message: 'Payments and wallet features are coming soon.',
      ),
    ),
    const Account(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
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
          selectedItemColor: _activeColor,
          unselectedItemColor: _inactiveColor,
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              activeIcon: Icon(Icons.home_outlined, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined, size: 24),
              activeIcon: Icon(Icons.map_outlined, size: 24),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 22),
              activeIcon: Icon(Icons.chat_bubble_outline, size: 22),
              label: 'Support',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card_outlined, size: 24),
              activeIcon: Icon(Icons.credit_card_outlined, size: 24),
              label: 'Pay',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz, size: 24),
              activeIcon: Icon(Icons.more_horiz, size: 24),
              label: 'More',
            ),
          ],
        ),
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
