import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/around/around_static_data.dart';
import '../views/screen/around/around_place_detail_sheet.dart';

enum AroundLocationState {
  notRequested,
  requesting,
  granted,
  denied,
  permanentlyDenied,
  unavailable,
  error,
}

class AroundController extends GetxController {
  final locationState = AroundLocationState.notRequested.obs;
  final originLabel = 'Red Square'.obs;
  final usingDeviceLocation = false.obs;
  final selectedCategory = RxnString();
  final originLat = AroundStaticData.redSquareLat.obs;
  final originLng = AroundStaticData.redSquareLng.obs;

  List<AroundPlace> get under6 => AroundStaticData.bySection('under6');
  List<AroundPlace> get shortWalk => AroundStaticData.bySection('shortWalk');
  List<AroundPlace> get shortRide => AroundStaticData.bySection('shortRide');

  void snack(String message) {
    Get.snackbar(
      'Around me',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void selectCategory(String id) {
    selectedCategory.value = selectedCategory.value == id ? null : id;
    snack(AroundStaticData.categories.firstWhere((c) => c.id == id).label);
  }

  Future<void> useMyLocation() async {
    locationState.value = AroundLocationState.requesting;
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationState.value = AroundLocationState.unavailable;
        snack('Turn on GPS to use your location.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        locationState.value = AroundLocationState.denied;
        snack('Location permission denied. Using Red Square.');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        locationState.value = AroundLocationState.permanentlyDenied;
        snack('Location permanently denied. Open settings to enable.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      originLat.value = pos.latitude;
      originLng.value = pos.longitude;
      originLabel.value = 'Your location';
      usingDeviceLocation.value = true;
      locationState.value = AroundLocationState.granted;
      snack('Location updated.');
    } catch (e) {
      locationState.value = AroundLocationState.error;
      snack('Could not get location. Using Red Square.');
    }
  }

  Future<void> openYandexMaps(AroundPlace place) async {
    final appUri = Uri.parse(
      'yandexmaps://maps.yandex.ru/?pt=${place.lng},${place.lat}&z=16&l=map',
    );
    final webUri = Uri.parse(
      'https://yandex.com/maps/?pt=${place.lng},${place.lat}&z=16&l=map',
    );

    try {
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    final ok = await launchUrl(webUri, mode: LaunchMode.externalApplication);
    if (!ok) snack('Could not open Yandex Maps.');
  }

  void openPlaceDetail(AroundPlace place) {
    AroundPlaceDetailSheet.show(place);
  }

  void openAllPlaces() {
    snack('All places in Moscow');
  }
}
