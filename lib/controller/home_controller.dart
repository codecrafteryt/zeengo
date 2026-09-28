import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api_provider/api_provider.dart';
import '../data/constants.dart';
import '../data/models/alo_home/alo_home_static_data.dart';
import '../data/models/api_response_model.dart';
import '../data/models/home_model/home_model.dart';
import '../data/models/task_model/ops_task_model.dart';
import '../data/repos/home_repo/home_repo.dart';
import '../data/repos/client_v2_repo/client_v2_repo.dart';
import '../utils/discovery_icons.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  HomeController({
    required this.homeRepo,
    required this.sharedPreferences,
    ClientV2Repo? clientV2Repo,
  }) : clientV2Repo = clientV2Repo ?? Get.find<ClientV2Repo>();

  final HomeRepo homeRepo;
  final SharedPreferences sharedPreferences;
  final ClientV2Repo clientV2Repo;

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final home = Rxn<HomeModel>();

  // ── UI-ready fields (Explore binds to these) ─────────────────────────────
  final clientName = ''.obs;
  final znCode = ''.obs;
  final packageLabel = ''.obs;
  final daysLeftLabel = '0'.obs;
  final guestsLabel = '0'.obs;
  final dueLabel = '\$0'.obs;
  final paidLabelAmount = '\$0'.obs;
  final totalLabelAmount = '\$0'.obs;
  final paymentProgress = 0.0.obs;
  final scheduleDateLabel = ''.obs;
  final todayProgram = <TodayProgramItem>[].obs;
  final openTasks = <OpsTask>[].obs;

  // ── aLo Home UI state (fed by /client/v2/home, static fallback) ───────────
  final plannerTab = AloPlannerTab.move.obs;
  final selectedFilter = 'In daylight'.obs;
  final promoVisible = true.obs;
  final selectedSuit = 'Rainy day'.obs;
  final discoveryLoading = false.obs;

  final quickChips = <String>[...AloHomeStaticData.quickChips].obs;
  final categories = <AloCategoryItem>[...AloHomeStaticData.categories].obs;
  final moscowNow = <AloPlaceCard>[...AloHomeStaticData.moscowNow].obs;
  final closeToCentre = <AloPlaceCard>[...AloHomeStaticData.closeToCentre].obs;
  final firstTime = <AloPlaceCard>[...AloHomeStaticData.firstTime].obs;
  final withKids = <AloPlaceCard>[...AloHomeStaticData.withKids].obs;
  final food = <AloFoodCard>[...AloHomeStaticData.food].obs;
  final suitYou = <AloSuitCard>[...AloHomeStaticData.suitYou].obs;
  final services = <AloServiceTile>[...AloHomeStaticData.services].obs;

  // ── Airbnb-style search planner ──────────────────────────────────────────
  final searchFrom = 'Your location · Moscow'.obs;
  final searchTo = ''.obs;
  final checkIn = Rxn<DateTime>(DateTime.now().add(const Duration(days: 1)));
  final checkOut = Rxn<DateTime>(DateTime.now().add(const Duration(days: 3)));
  final adults = 2.obs;
  final children = 0.obs;
  final infants = 0.obs;

  static const fromSuggestions = [
    'Your location · Moscow',
    'Red Square',
    'Moscow City',
    'VDNKh',
    'Sheremetyevo Airport',
    'Domodedovo Airport',
  ];

  static const toSuggestions = [
    'Red Square',
    'St Basil’s Cathedral',
    'Tretyakov Gallery',
    'VDNKh',
    'Moscow City',
    'Gorky Park',
    'St Petersburg',
    'Kazan',
  ];

  int get totalGuests => adults.value + children.value;

  String get searchSummary {
    final to = searchTo.value.trim().isEmpty ? 'Anywhere' : searchTo.value;
    final guests = totalGuests == 1 ? '1 guest' : '$totalGuests guests';
    return '$to · ${_shortDate(checkIn.value)} · $guests';
  }

  String get dateRangeLabel {
    final a = checkIn.value;
    final b = checkOut.value;
    if (a == null) return 'Add dates';
    if (b == null) return _shortDate(a);
    return '${_shortDate(a)} – ${_shortDate(b)}';
  }

  String get guestsLabelSearch {
    final parts = <String>[
      '${adults.value} adult${adults.value == 1 ? '' : 's'}',
    ];
    if (children.value > 0) {
      parts.add(
        '${children.value} child${children.value == 1 ? '' : 'ren'}',
      );
    }
    if (infants.value > 0) {
      parts.add(
        '${infants.value} infant${infants.value == 1 ? '' : 's'}',
      );
    }
    return parts.join(' · ');
  }

  void setPlannerTab(AloPlannerTab tab) => plannerTab.value = tab;
  void setFilter(String filter) => selectedFilter.value = filter;
  void dismissPromo() => promoVisible.value = false;
  void setSuit(String title) => selectedSuit.value = title;

  void setSearchFrom(String v) => searchFrom.value = v;
  void setSearchTo(String v) => searchTo.value = v;
  void setCheckIn(DateTime? d) => checkIn.value = d;
  void setCheckOut(DateTime? d) => checkOut.value = d;

  void setAdults(int v) => adults.value = v.clamp(1, 16);
  void setChildren(int v) => children.value = v.clamp(0, 10);
  void setInfants(int v) => infants.value = v.clamp(0, 5);

  void applySearch() {
    snack('Searching · $searchSummary');
  }

  String _shortDate(DateTime? d) {
    if (d == null) return 'Add dates';
    return '${d.day} ${_months[d.month - 1]}';
  }

  void snack(String message) {
    Get.snackbar(
      'aLo',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchDiscoveryHome();
  }

  /// Loads aLo Home discovery feed (`GET /client/v2/home`). Keeps static fallback.
  Future<void> fetchDiscoveryHome() async {
    if (discoveryLoading.value) return;
    discoveryLoading.value = true;
    try {
      final response = await clientV2Repo.fetchHome();
      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) return;
      final data = unwrapClientV2Data(response.body);
      if (data == null) return;

      List<Map<String, dynamic>> maps(dynamic raw) => raw is List
          ? raw
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
          : <Map<String, dynamic>>[];

      final chips = data['quickChips'];
      if (chips is List && chips.isNotEmpty) {
        quickChips.assignAll(chips.map((e) => e.toString()).toList());
      }
      final cats = maps(data['categories']);
      if (cats.isNotEmpty) {
        categories.assignAll(cats.map(AloCategoryItem.fromJson));
      }
      final suits = maps(data['suitYou']);
      if (suits.isNotEmpty) {
        suitYou.assignAll(suits.map(AloSuitCard.fromJson));
      }
      final svcs = maps(data['services']);
      if (svcs.isNotEmpty) {
        services.assignAll(svcs.map(AloServiceTile.fromJson));
      }

      List<AloPlaceCard> places(String key) =>
          maps(data[key]).map(AloPlaceCard.fromJson).toList();

      final mn = places('moscowNow');
      if (mn.isNotEmpty) moscowNow.assignAll(mn);
      final cc = places('closeToCentre');
      if (cc.isNotEmpty) closeToCentre.assignAll(cc);
      final ft = places('firstTime');
      if (ft.isNotEmpty) firstTime.assignAll(ft);
      final wk = places('withKids');
      if (wk.isNotEmpty) withKids.assignAll(wk);

      final foodMaps = maps(data['food']);
      if (foodMaps.isNotEmpty) {
        food.assignAll(foodMaps.map(AloFoodCard.fromJson));
      }
    } catch (e, st) {
      debugPrint('HomeController.fetchDiscoveryHome error: $e\n$st');
    } finally {
      discoveryLoading.value = false;
    }
  }

  Future<void> fetchHome({bool showLoader = true}) async {
    if (isLoading.value) return;
    if (showLoader) isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await homeRepo.fetchHome();
      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) {
        errorMessage.value = _extractError(response.body) ??
            'Unable to load home. Please try again.';
        return;
      }

      final body = response.body;
      if (body is! Map<String, dynamic>) {
        errorMessage.value = 'Invalid home response.';
        return;
      }

      final model = ApiResponse.fromJson(body, HomeModel.fromJson);
      if (model.status != 200 || model.data == null) {
        errorMessage.value =
            model.error.isNotEmpty ? model.error : model.message;
        return;
      }

      _applyHome(model.data!);
    } catch (e, st) {
      debugPrint('HomeController.fetchHome error: $e\n$st');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _applyHome(HomeModel data) {
    home.value = data;

    clientName.value = data.clientName?.trim() ?? '';
    znCode.value = data.znCode?.trim() ?? '';

    if (data.bookingId != null && data.bookingId!.isNotEmpty) {
      sharedPreferences.setString(Constants.bookingId, data.bookingId!);
    }
    if (data.znCode != null && data.znCode!.isNotEmpty) {
      sharedPreferences.setString(Constants.znCode, data.znCode!);
    }
    if (data.status != null && data.status!.isNotEmpty) {
      sharedPreferences.setString(Constants.bookingStatus, data.status!);
    }
    if (data.clientName != null && data.clientName!.isNotEmpty) {
      sharedPreferences.setString(Constants.userFullName, data.clientName!);
    }

    packageLabel.value = _buildPackageLabel(data);
    daysLeftLabel.value = '${data.daysLeft ?? 0}';
    guestsLabel.value = '${data.displayGuests}';

    final due = data.balance?.due ?? 0;
    final paid = data.balance?.paid ?? 0;
    final total = data.balance?.total ?? 0;
    dueLabel.value = _money(due);
    paidLabelAmount.value = _money(paid);
    totalLabelAmount.value = _money(total);
    paymentProgress.value =
        total > 0 ? (paid.toDouble() / total.toDouble()).clamp(0.0, 1.0) : 0.0;

    todayProgram.assignAll(data.todayProgram);
    openTasks.assignAll(data.tasks);
    scheduleDateLabel.value = _scheduleDateLabel(data);

    if (Get.isRegistered<AuthController>()) {
      final auth = Get.find<AuthController>();
      if (clientName.value.isNotEmpty) auth.userName.value = clientName.value;
      if (znCode.value.isNotEmpty) auth.znCode.value = znCode.value;
    }
  }

  String _buildPackageLabel(HomeModel data) {
    final name = data.packageName?.trim() ?? '';
    final date = _formatShortDate(data.arrivalDate);
    if (name.isEmpty && date.isEmpty) return '—';
    if (name.isEmpty) return date;
    if (date.isEmpty) return name;
    return '$name - $date';
  }

  String _scheduleDateLabel(HomeModel data) {
    if (data.todayProgram.isNotEmpty) {
      final fromItem = data.todayProgram.first.itemDate;
      final formatted = _formatShortDate(fromItem);
      if (formatted.isNotEmpty) return formatted;
    }
    return _formatShortDate(DateTime.now().toIso8601String().split('T').first);
  }

  static const _months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _formatShortDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    try {
      final dt = DateTime.parse(raw.trim());
      return '${dt.day} ${_months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw.trim();
    }
  }

  String _money(num value) {
    if (value == value.roundToDouble()) {
      return '\$${value.round()}';
    }
    return '\$${value.toStringAsFixed(2)}';
  }

  String? _extractError(dynamic body) {
    if (body is! Map) return null;
    final error = body['error'];
    if (error is Map) {
      return error['message']?.toString() ?? error['code']?.toString();
    }
    if (error is String && error.isNotEmpty) return error;
    final message = body['message']?.toString();
    if (message != null && message.isNotEmpty) return message;
    return null;
  }
}
