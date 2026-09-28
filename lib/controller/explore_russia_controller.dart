import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api_provider/api_provider.dart';
import '../data/models/explore_russia/explore_russia_static_data.dart';
import '../data/repos/client_v2_repo/client_v2_repo.dart';
import '../utils/discovery_icons.dart';

class ExploreRussiaController extends GetxController {
  ExploreRussiaController({ClientV2Repo? clientV2Repo})
      : clientV2Repo = clientV2Repo ?? Get.find<ClientV2Repo>();

  final ClientV2Repo clientV2Repo;

  final selectedFilterId = RxnString('family');
  final isLoading = false.obs;
  final filters = <ExploreRussiaFilter>[...ExploreRussiaStaticData.filters].obs;
  final places = <ExploreRussiaPlace>[...ExploreRussiaStaticData.places].obs;
  final statusTitleOverride = RxnString();

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
    return places.where((p) => p.matchesFilter(id)).toList();
  }

  int get matchCount => filteredPlaces.length;

  String get statusTitle =>
      statusTitleOverride.value ??
      activeFilter?.statusTitle ??
      activeFilter?.label ??
      'All';

  @override
  void onInit() {
    super.onInit();
    fetchDestinations();
  }

  Future<void> fetchDestinations() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final response = await clientV2Repo.fetchDestinations(
        filter: selectedFilterId.value,
      );
      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) return;
      final data = unwrapClientV2Data(response.body);
      if (data == null) return;

      final f = data['filters'];
      if (f is List && f.isNotEmpty) {
        filters.assignAll(
          f
              .whereType<Map>()
              .map(
                (e) =>
                    ExploreRussiaFilter.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList(),
        );
      }

      final list = data['data'];
      if (list is List) {
        places.assignAll(
          list
              .whereType<Map>()
              .map(
                (e) =>
                    ExploreRussiaPlace.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList(),
        );
      }

      final st = data['statusTitle']?.toString();
      if (st != null && st.isNotEmpty) statusTitleOverride.value = st;
    } catch (e, st) {
      debugPrint('ExploreRussiaController.fetchDestinations error: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(String id) {
    selectedFilterId.value = id;
    fetchDestinations();
  }

  void clearFilter() {
    selectedFilterId.value = null;
    fetchDestinations();
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
