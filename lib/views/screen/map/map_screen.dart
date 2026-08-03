/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: March 31, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: map screen.dart
*/

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/map_controller.dart';
import '../../../utils/values/air_bnb_style.dart';

class MapScreen extends StatelessWidget {
  const MapScreen();

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

