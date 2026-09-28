import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/my_trip/my_trip_static_data.dart';

class MyTripController extends GetxController {
  final selectedDayIndex = 0.obs;

  List<TripDay> get days => MyTripStaticData.days;

  TripDay get selectedDay => days[selectedDayIndex.value.clamp(0, days.length - 1)];

  int get tripDayCount => MyTripStaticData.tripDaysCount;

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
