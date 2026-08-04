import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/enus.dart';
import '../data/models/suggestion_tip.dart';
import '../utils/values/my_color.dart';

class SuggestionsController extends GetxController {
  final tips = <SuggestionTip>[].obs;
  final isLoading = false.obs;

  /// Header time label (static for now; API can override).
  final basedOnLabel = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTips();
  }

  Future<void> loadTips() async {
    isLoading.value = true;
    // Placeholder for future API call.
    await Future<void>.delayed(const Duration(milliseconds: 120));
    tips.assignAll(_staticTips());
    basedOnLabel.value = Enus.basedOnTime.trParams({
      'time': _nowLabel(),
    });
    isLoading.value = false;
  }

  void onTipAction(SuggestionTip tip) {
    Get.snackbar(
      tip.title,
      tip.actionLabel,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  String _nowLabel() {
    final n = TimeOfDay.now();
    final h = n.hourOfPeriod == 0 ? 12 : n.hourOfPeriod;
    final m = n.minute.toString().padLeft(2, '0');
    final p = n.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  List<SuggestionTip> _staticTips() {
    return [
      SuggestionTip(
        id: 'afternoon_activity',
        title: Enus.suggestionAfternoonTitle.tr,
        description: Enus.suggestionAfternoonDesc.tr,
        actionLabel: Enus.suggestionContactSplizer.tr,
        icon: Icons.theater_comedy_rounded,
        actionIcon: Icons.support_agent_rounded,
        iconColor: const Color(0xFFEC4899),
      ),
      SuggestionTip(
        id: 'currency_tip',
        title: Enus.suggestionCurrencyTitle.tr,
        description: Enus.suggestionCurrencyDesc.tr,
        actionLabel: Enus.suggestionAlfaBank.tr,
        icon: Icons.currency_exchange_rounded,
        actionIcon: Icons.location_on_outlined,
        iconColor: MyColors.green,
        actionValue: 'alfa_bank',
      ),
      SuggestionTip(
        id: 'transport_tip',
        title: Enus.suggestionTransportTitle.tr,
        description: Enus.suggestionTransportDesc.tr,
        actionLabel: Enus.suggestionNearestMetro.tr,
        icon: Icons.directions_subway_filled_rounded,
        actionIcon: Icons.map_outlined,
        iconColor: MyColors.darkPurple,
        actionValue: 'nearest_metro',
      ),
      SuggestionTip(
        id: 'photo_spot',
        title: Enus.suggestionPhotoTitle.tr,
        description: Enus.suggestionPhotoDesc.tr,
        actionLabel: Enus.suggestionSparrowHills.tr,
        icon: Icons.photo_camera_rounded,
        actionIcon: Icons.place_outlined,
        iconColor: const Color(0xFF38BDF8),
        actionValue: 'sparrow_hills',
      ),
    ];
  }
}
