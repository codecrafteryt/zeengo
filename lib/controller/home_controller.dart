import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api_provider/api_provider.dart';
import '../data/constants.dart';
import '../data/models/api_response_model.dart';
import '../data/models/home_model/home_model.dart';
import '../data/repos/home_repo/home_repo.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  HomeController({
    required this.homeRepo,
    required this.sharedPreferences,
  });

  final HomeRepo homeRepo;
  final SharedPreferences sharedPreferences;

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

  @override
  void onInit() {
    super.onInit();
    fetchHome();
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
