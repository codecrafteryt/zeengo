import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/api_provider/api_provider.dart';
import '../data/models/around/around_static_data.dart';
import '../data/repos/client_v2_repo/client_v2_repo.dart';
import '../utils/discovery_icons.dart';
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
  AroundController({ClientV2Repo? clientV2Repo})
      : clientV2Repo = clientV2Repo ?? Get.find<ClientV2Repo>();

  final ClientV2Repo clientV2Repo;

  final locationState = AroundLocationState.notRequested.obs;
  final originLabel = 'Red Square'.obs;
  final usingDeviceLocation = false.obs;
  final selectedCategory = RxnString();
  final originLat = AroundStaticData.redSquareLat.obs;
  final originLng = AroundStaticData.redSquareLng.obs;
  final isLoading = false.obs;

  final categories = <AroundCategory>[...AroundStaticData.categories].obs;
  final under6 = <AroundPlace>[].obs;
  final shortWalk = <AroundPlace>[].obs;
  final shortRide = <AroundPlace>[].obs;

  @override
  void onInit() {
    super.onInit();
    under6.assignAll(AroundStaticData.bySection('under6'));
    shortWalk.assignAll(AroundStaticData.bySection('shortWalk'));
    shortRide.assignAll(AroundStaticData.bySection('shortRide'));
    fetchPlaces();
  }

  Future<void> fetchPlaces() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final response = await clientV2Repo.fetchPlaces(
        lat: originLat.value,
        lng: originLng.value,
        category: selectedCategory.value,
      );
      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) return;
      final data = unwrapClientV2Data(response.body);
      if (data == null) return;

      final cats = data['categories'];
      if (cats is List && cats.isNotEmpty) {
        categories.assignAll(
          cats
              .whereType<Map>()
              .map((e) => AroundCategory.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
      }

      final sections = data['sections'];
      if (sections is Map) {
        List<AroundPlace> parse(String key) {
          final raw = sections[key];
          if (raw is! List) return [];
          return raw
              .whereType<Map>()
              .map((e) => AroundPlace.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }

        under6.assignAll(parse('under6'));
        shortWalk.assignAll(parse('shortWalk'));
        shortRide.assignAll(parse('shortRide'));
      }

      final origin = data['origin'];
      if (origin is Map && origin['label'] != null) {
        originLabel.value = origin['label'].toString();
      }
    } catch (e, st) {
      debugPrint('AroundController.fetchPlaces error: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

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
    final label = categories
        .firstWhere(
          (c) => c.id == id,
          orElse: () => AroundCategory(
            id: id,
            label: id,
            icon: Icons.place_outlined,
          ),
        )
        .label;
    snack(label);
    fetchPlaces();
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
      await fetchPlaces();
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
