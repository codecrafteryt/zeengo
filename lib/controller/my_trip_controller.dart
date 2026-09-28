import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/api_provider/api_provider.dart';
import '../data/models/my_trip/my_trip_static_data.dart';
import '../data/repos/client_v2_repo/client_v2_repo.dart';
import '../utils/discovery_icons.dart';

class MyTripController extends GetxController {
  MyTripController({ClientV2Repo? clientV2Repo})
      : clientV2Repo = clientV2Repo ?? Get.find<ClientV2Repo>();

  final ClientV2Repo clientV2Repo;

  final selectedDayIndex = 0.obs;
  final isLoading = false.obs;
  final days = <TripDay>[...MyTripStaticData.days].obs;
  final subtitle = MyTripStaticData.subtitle.obs;

  TripDay get selectedDay =>
      days[selectedDayIndex.value.clamp(0, days.isEmpty ? 0 : days.length - 1)];

  int get tripDayCount => days.isEmpty ? MyTripStaticData.tripDaysCount : days.length;

  @override
  void onInit() {
    super.onInit();
    fetchTrip();
  }

  Future<void> fetchTrip() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final response = await clientV2Repo.fetchTrip();
      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) return;
      final data = unwrapClientV2Data(response.body);
      if (data == null) return;

      final rawDays = data['days'];
      if (rawDays is List && rawDays.isNotEmpty) {
        days.assignAll(
          rawDays
              .whereType<Map>()
              .map((e) => TripDay.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
        if (selectedDayIndex.value >= days.length) {
          selectedDayIndex.value = 0;
        }
      }
      final sub = data['subtitle']?.toString();
      if (sub != null && sub.isNotEmpty) subtitle.value = sub;
    } catch (e, st) {
      debugPrint('MyTripController.fetchTrip error: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  void selectDay(int index) {
    if (index < 0 || index >= days.length) return;
    selectedDayIndex.value = index;
  }

  void openStop(TripStop stop) {
    Get.snackbar(
      'My Trip',
      stop.title,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> openDayOnYandexMaps(TripDay day) async {
    final withCoords = day.stops.where((s) => s.lat != null && s.lng != null);
    if (withCoords.isEmpty) {
      Get.snackbar(
        'My Trip',
        'No map points for this day.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final points = withCoords.map((s) => '${s.lng},${s.lat}').join('~');
    final first = withCoords.first;
    final appUri = Uri.parse(
      'yandexmaps://maps.yandex.ru/?pt=$points&z=12&l=map',
    );
    final webUri = Uri.parse(
      'https://yandex.com/maps/?pt=${first.lng},${first.lat}&z=12&l=map',
    );

    try {
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    final ok = await launchUrl(webUri, mode: LaunchMode.externalApplication);
    if (!ok) {
      Get.snackbar(
        'My Trip',
        'Could not open Yandex Maps.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
