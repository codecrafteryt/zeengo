import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/explore_russia/explore_russia_static_data.dart';

class ExploreRussiaController extends GetxController {
  final selectedFilterId = RxnString('family');

  List<ExploreRussiaFilter> get filters => ExploreRussiaStaticData.filters;

  ExploreRussiaFilter? get activeFilter {
    final id = selectedFilterId.value;
    if (id == null) return null;
    try {
      return filters.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  List<ExploreRussiaPlace> get filteredPlaces {
    final id = selectedFilterId.value;
    return ExploreRussiaStaticData.places
        .where((p) => p.matchesFilter(id))
        .toList();
  }

  int get matchCount => filteredPlaces.length;

  String get statusTitle => activeFilter?.statusTitle ?? activeFilter?.label ?? 'All';

  void selectFilter(String id) {
    selectedFilterId.value = id;
  }

  void clearFilter() {
    selectedFilterId.value = null;
  }

  void openPlace(ExploreRussiaPlace place) {
    Get.snackbar(
      'Explore Russia',
      place.title,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}
