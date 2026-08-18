import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/map/nearby_place.dart';
import '../utils/values/env.dart';
import '../utils/values/my_color.dart';
import '../views/screen/map/nearby_places_data.dart';

class MapController extends GetxController {
  MapController({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String _providerKey = 'map_provider';
  /// Rebuilds only the native [GoogleMap] (markers / polylines).
  static const String mapLayerId = 'mapLayer';
  /// Rebuilds map chrome (chips, sheets, provider switch).
  static const String mapUiId = 'mapUi';
  static const LatLng moscowCenter = LatLng(55.7558, 37.6173);

  Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  MapProviderType provider = MapProviderType.google;
  PlaceCategory selectedCategory = PlaceCategory.mosques;
  NearbyPlace? activePlace;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  bool isNavigating = false;
  EdgeInsets mapPadding = EdgeInsets.zero;

  void refreshMap() => update([mapLayerId]);
  void refreshUi() => update([mapUiId]);
  void refreshAll() => update([mapLayerId, mapUiId]);

  List<NearbyPlace> get filteredPlaces {
    if (selectedCategory == PlaceCategory.all) {
      return NearbyPlacesData.moscow;
    }
    return NearbyPlacesData.moscow
        .where((p) => p.category == selectedCategory)
        .toList();
  }

  bool get isYandexReady => Env.yandexMapsApiKey.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    final saved = sharedPreferences.getString(_providerKey);
    if (saved == 'yandex') provider = MapProviderType.yandex;
    _rebuildMarkers();
  }

  void onMapCreated(GoogleMapController controller) {
    // Map is unmounted when leaving the tab; remount needs a fresh Completer.
    if (googleMapController.isCompleted) {
      googleMapController = Completer<GoogleMapController>();
    }
    googleMapController.complete(controller);
  }

  void onMapDisposed() {
    googleMapController = Completer<GoogleMapController>();
  }

  Future<void> setProvider(MapProviderType type) async {
    provider = type;
    await sharedPreferences.setString(
      _providerKey,
      type == MapProviderType.yandex ? 'yandex' : 'google',
    );
    if (type == MapProviderType.google) {
      _rebuildMarkers();
      await _focusMoscow();
      refreshMap();
    }
    refreshUi();
  }

  void setCategory(PlaceCategory category) {
    selectedCategory = category;
    activePlace = null;
    isNavigating = false;
    polylines = {};
    _rebuildMarkers();
    refreshAll();
  }

  void _rebuildMarkers() {
    markers = filteredPlaces
        .map(
          (p) => Marker(
            markerId: MarkerId(p.id),
            position: LatLng(p.lat, p.lng),
            infoWindow: InfoWindow(title: p.name),
            onTap: () => startDirections(p),
          ),
        )
        .toSet();
  }

  Future<void> _focusMoscow() async {
    try {
      final c = await googleMapController.future;
      await c.animateCamera(
        CameraUpdate.newLatLngZoom(moscowCenter, 12.2),
      );
    } catch (_) {}
  }

  Future<void> startDirections(NearbyPlace place) async {
    activePlace = place;
    isNavigating = false;
    final dest = LatLng(place.lat, place.lng);
    polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        color: MyColors.darkPurple,
        width: 5,
        points: _buildRoutePoints(moscowCenter, dest),
      ),
    };
    markers = {
      Marker(
        markerId: const MarkerId('origin'),
        position: moscowCenter,
        infoWindow: const InfoWindow(title: 'You'),
      ),
      Marker(
        markerId: MarkerId(place.id),
        position: dest,
        infoWindow: InfoWindow(title: place.name),
      ),
    };
    refreshAll();
    await _fitRoute(moscowCenter, dest);
  }

  List<LatLng> _buildRoutePoints(LatLng a, LatLng b) {
    // Smooth in-app preview path (Uber-like) until Directions API is wired.
    const steps = 24;
    final mid = LatLng(
      (a.latitude + b.latitude) / 2 + 0.008,
      (a.longitude + b.longitude) / 2 - 0.004,
    );
    return [
      for (var i = 0; i <= steps; i++)
        _quad(a, mid, b, i / steps),
    ];
  }

  LatLng _quad(LatLng p0, LatLng p1, LatLng p2, double t) {
    final u = 1 - t;
    return LatLng(
      u * u * p0.latitude + 2 * u * t * p1.latitude + t * t * p2.latitude,
      u * u * p0.longitude + 2 * u * t * p1.longitude + t * t * p2.longitude,
    );
  }

  Future<void> _fitRoute(LatLng a, LatLng b) async {
    try {
      final c = await googleMapController.future;
      final bounds = LatLngBounds(
        southwest: LatLng(
          math.min(a.latitude, b.latitude),
          math.min(a.longitude, b.longitude),
        ),
        northeast: LatLng(
          math.max(a.latitude, b.latitude),
          math.max(a.longitude, b.longitude),
        ),
      );
      await c.animateCamera(CameraUpdate.newLatLngBounds(bounds, 72));
    } catch (_) {}
  }

  Future<void> beginNavigation() async {
    if (activePlace == null) return;
    isNavigating = true;
    refreshAll();
    try {
      final c = await googleMapController.future;
      await c.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(activePlace!.lat, activePlace!.lng),
            zoom: 14.5,
            tilt: 45,
            bearing: 20,
          ),
        ),
      );
    } catch (_) {}
  }

  void exitNavigation() {
    isNavigating = false;
    refreshAll();
  }

  void clearDirections() {
    activePlace = null;
    isNavigating = false;
    polylines = {};
    _rebuildMarkers();
    refreshAll();
  }

  String etaFor(NearbyPlace place) {
    final minutes = (place.distanceKm / 0.45).round().clamp(3, 90);
    return '$minutes min';
  }

  Future<void> openExternalMaps(NearbyPlace place) async {
    final uri = provider == MapProviderType.yandex && isYandexReady
        ? Uri.parse(
            'https://yandex.com/maps/?rtext=~${place.lat},${place.lng}',
          )
        : Uri.parse(
            'https://www.google.com/maps/dir/?api=1&destination=${place.lat},${place.lng}',
          );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> openYandexMapsApp() async {
    if (!isYandexReady) {
      await setProvider(MapProviderType.yandex);
      return;
    }
    await setProvider(MapProviderType.yandex);
  }
}
