/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: March 31, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: map screen.dart
*/

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../controller/map_controller.dart';
import '../../../utils/values/air_bnb_style.dart';

class ExploreMapView extends StatelessWidget {
  const ExploreMapView({
    super.key,
    required this.mapController,
    required this.onMapTap,
  });

  final MapController mapController;
  final VoidCallback onMapTap;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: MapController.pakistanRoughCenter,
        zoom: MapController.zoomSheetExpanded,
      ),
      padding: mapController.mapPadding,
      style: kAirbnbLikeMapStyle,
      markers: mapController.markers,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      liteModeEnabled: false,
      onMapCreated: mapController.onMapCreated,
      onTap: (_) => onMapTap(),
    );
  }
}
