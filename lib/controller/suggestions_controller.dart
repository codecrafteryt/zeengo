import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../data/api_provider/api_provider.dart';
import '../data/enus.dart';
import '../data/models/suggestion_tip.dart';
import '../data/repos/home_repo/home_repo.dart';

class SuggestionsController extends GetxController {
  SuggestionsController({required this.homeRepo});

  final HomeRepo homeRepo;

  final tips = <SuggestionTip>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final basedOnLabel = ''.obs;

  Future<void> loadTips() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = null;
    tips.clear();
    basedOnLabel.value = Enus.whatToDoNow.tr;

    try {
      final res = await homeRepo.fetchSuggestions();
      if (!ApiProvider.isSuccessfulHttpStatus(res.statusCode) ||
          res.body is! Map) {
        errorMessage.value = 'Unable to load suggestions.';
        return;
      }
      final body = Map<String, dynamic>.from(res.body as Map);
      if (body['success'] == false) {
        final err = body['error'];
        errorMessage.value = err is Map
            ? (err['message']?.toString() ?? 'Unable to load suggestions.')
            : 'Unable to load suggestions.';
        return;
      }
      final payload = body['data'];
      final list = payload is Map ? payload['data'] : null;
      tips.assignAll(SuggestionTip.listFrom(list));
    } catch (e, st) {
      debugPrint('SuggestionsController.loadTips error: $e\n$st');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void onTipAction(SuggestionTip tip) {}
}
