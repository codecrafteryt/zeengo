import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../data/api_provider/api_provider.dart';
import '../data/models/api_response_model.dart';
import '../data/models/task_model/ops_task_model.dart';
import '../data/repos/task_repo/task_repo.dart';
import 'home_controller.dart';

class TaskController extends GetxController {
  TaskController({required this.taskRepo});

  final TaskRepo taskRepo;

  /// `open` | `done` | `all`
  final filter = 'open'.obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = RxnString();
  final items = <OpsTask>[].obs;
  final znCode = ''.obs;
  final bookingId = ''.obs;

  int _page = 1;
  bool _hasMore = true;

  /// Prefill Open tab from home `tasks` so UI matches Today's Schedule immediately.
  void seedFromHome() {
    if (!Get.isRegistered<HomeController>()) return;
    final home = Get.find<HomeController>();
    if (home.znCode.value.isNotEmpty) {
      znCode.value = home.znCode.value;
    }
    if (filter.value == 'open' && home.openTasks.isNotEmpty) {
      items.assignAll(home.openTasks.toList());
    }
  }

  Future<void> setFilter(String value) async {
    if (filter.value == value) return;
    filter.value = value;
    if (value == 'open') seedFromHome();
    await fetchTasks(showLoader: items.isEmpty);
  }

  Future<void> fetchTasks({bool showLoader = true}) async {
    if (showLoader) isLoading.value = true;
    errorMessage.value = null;
    _page = 1;
    _hasMore = true;

    try {
      final response = await taskRepo.fetchTasks(
        filter: filter.value,
        page: 1,
        limit: 20,
      );

      debugPrint(
        '====> TASKS status=${response.statusCode} body=${response.body}',
      );

      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) {
        errorMessage.value = 'Unable to load tasks.';
        if (items.isEmpty) items.clear();
        return;
      }

      final body = response.body;
      if (body is! Map) {
        errorMessage.value = 'Invalid tasks response.';
        return;
      }

      final result = OpsTaskListResult.fromEnvelope(
        Map<String, dynamic>.from(body),
      );
      if (!result.success) {
        errorMessage.value =
            result.error.isNotEmpty ? result.error : 'Unable to load tasks.';
        return;
      }

      items.assignAll(result.items);
      znCode.value = result.znCode?.trim() ?? znCode.value;
      bookingId.value = result.bookingId?.trim() ?? '';
      final total = result.meta?.total;
      _hasMore = total == null
          ? result.items.length >= 20
          : result.items.length < total;
    } catch (e, st) {
      debugPrint('TaskController.fetchTasks error: $e\n$st');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore.value || isLoading.value) return;
    isLoadingMore.value = true;
    try {
      final next = _page + 1;
      final response = await taskRepo.fetchTasks(
        filter: filter.value,
        page: next,
        limit: 20,
      );
      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) return;
      final body = response.body;
      if (body is! Map) return;

      final result = OpsTaskListResult.fromEnvelope(
        Map<String, dynamic>.from(body),
      );
      if (!result.success) return;

      items.addAll(result.items);
      _page = next;
      final total = result.meta?.total;
      _hasMore = total == null
          ? result.items.length >= 20
          : items.length < total;
    } catch (e, st) {
      debugPrint('TaskController.loadMore error: $e\n$st');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<OpsTask?> fetchTaskDetail(String id) async {
    try {
      final response = await taskRepo.fetchTask(id);
      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) return null;
      final body = response.body;
      if (body is! Map) return null;
      final model = ApiResponse.fromJson(
        Map<String, dynamic>.from(body),
        OpsTask.fromJson,
      );
      return model.data;
    } catch (e, st) {
      debugPrint('TaskController.fetchTaskDetail error: $e\n$st');
      return null;
    }
  }
}
