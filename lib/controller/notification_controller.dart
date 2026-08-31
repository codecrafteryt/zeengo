import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../data/api_provider/api_provider.dart';
import '../data/models/notification_model/notification_model.dart';
import '../data/repos/notification_repo/notification_repo.dart';

class NotificationController extends GetxController {
  NotificationController({required this.notificationRepo});

  final NotificationRepo notificationRepo;

  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final errorMessage = RxnString();
  final items = <AppNotification>[].obs;
  final unreadCount = 0.obs;
  final filter = 'all'.obs;

  int _page = 1;
  bool _hasMore = true;
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Called after login / session restore when a Bearer token is available.
  Future<void> bootstrapAfterAuth() async {
    await fetchNotifications(refresh: true);
    await fetchUnreadCount();
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      isRefreshing.value = true;
    } else if (isLoading.value) {
      return;
    } else {
      isLoading.value = true;
    }
    errorMessage.value = null;

    try {
      final response = await notificationRepo.fetchNotifications(
        page: 1,
        limit: 20,
        filter: filter.value,
      );
      debugPrint(
        '====> NOTIFICATIONS status=${response.statusCode} body=${response.body}',
      );

      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) {
        errorMessage.value = _extractError(response.body) ??
            'Unable to load notifications.';
        return;
      }

      final body = response.body;
      if (body is! Map<String, dynamic>) {
        errorMessage.value = 'Invalid notifications response.';
        return;
      }

      final result = NotificationListResult.fromEnvelope(body);
      if (!result.success) {
        errorMessage.value =
            result.error.isNotEmpty ? result.error : 'Request failed';
        return;
      }

      items.assignAll(result.items);
      _page = 1;
      final total = result.meta?.total ?? result.items.length;
      _hasMore = items.length < total;

      if (filter.value == 'unread') {
        unreadCount.value = result.meta?.total ?? result.items.length;
      }
    } catch (e, st) {
      debugPrint('NotificationController.fetchNotifications: $e\n$st');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore.value || isLoading.value) return;
    isLoadingMore.value = true;
    try {
      final nextPage = _page + 1;
      final response = await notificationRepo.fetchNotifications(
        page: nextPage,
        limit: 20,
        filter: filter.value,
      );
      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) return;
      final body = response.body;
      if (body is! Map<String, dynamic>) return;

      final result = NotificationListResult.fromEnvelope(body);
      if (!result.success) return;

      items.addAll(result.items);
      _page = nextPage;
      final total = result.meta?.total ?? items.length;
      _hasMore = items.length < total;
    } catch (e, st) {
      debugPrint('NotificationController.loadMore: $e\n$st');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final response = await notificationRepo.fetchUnreadCount();
      debugPrint(
        '====> UNREAD COUNT status=${response.statusCode} body=${response.body}',
      );
      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) return;

      final body = response.body;
      if (body is! Map) return;

      // Prefer dedicated unread-count endpoint.
      final data = body['data'];
      if (data is Map && data['count'] != null) {
        unreadCount.value = _asInt(data['count']) ?? 0;
        return;
      }

      // Fallback: filter=unread meta.total
      final unreadResponse = await notificationRepo.fetchNotifications(
        page: 1,
        limit: 1,
        filter: 'unread',
      );
      if (!ApiProvider.isSuccessfulHttpStatus(unreadResponse.statusCode)) {
        return;
      }
      final unreadBody = unreadResponse.body;
      if (unreadBody is Map<String, dynamic>) {
        final result = NotificationListResult.fromEnvelope(unreadBody);
        unreadCount.value = result.meta?.total ?? 0;
      }
    } catch (e, st) {
      debugPrint('NotificationController.fetchUnreadCount: $e\n$st');
    }
  }

  Future<void> setFilter(String value) async {
    if (filter.value == value) return;
    filter.value = value;
    await fetchNotifications(refresh: true);
  }

  Future<void> markAsRead(AppNotification notification) async {
    final id = notification.id;
    if (id == null || id.isEmpty || !notification.unread) return;

    final index = items.indexWhere((e) => e.id == id);
    if (index >= 0) {
      items[index].isRead = true;
      items[index].readAt = DateTime.now().toUtc().toIso8601String();
      items.refresh();
    }
    if (unreadCount.value > 0) unreadCount.value--;

    try {
      final response = await notificationRepo.markRead(id);
      debugPrint(
        '====> MARK READ status=${response.statusCode} body=${response.body}',
      );
      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) {
        await fetchNotifications(refresh: true);
        await fetchUnreadCount();
      }
    } catch (e, st) {
      debugPrint('NotificationController.markAsRead: $e\n$st');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await notificationRepo.markAllRead();
      debugPrint(
        '====> MARK ALL READ status=${response.statusCode} body=${response.body}',
      );
      if (!ApiProvider.isSuccessfulHttpStatus(response.statusCode)) return;

      for (final item in items) {
        item.isRead = true;
      }
      items.refresh();
      unreadCount.value = 0;
    } catch (e, st) {
      debugPrint('NotificationController.markAllAsRead: $e\n$st');
    }
  }

  /// Called by [SocketController] on `notification.new`.
  Future<void> handleRealtimeNotification(dynamic raw) async {
    try {
      Map<String, dynamic>? map;
      if (raw is Map<String, dynamic>) {
        map = raw;
      } else if (raw is Map) {
        map = Map<String, dynamic>.from(raw);
      }
      if (map == null) {
        debugPrint('====> SOCKET notification.new invalid payload: $raw');
        return;
      }

      final payload = _unwrapNotificationPayload(map);
      final notification = AppNotification.fromJson(payload);
      debugPrint(
        '====> REALTIME notification: ${notification.toJson()}',
      );

      final existingIndex =
          items.indexWhere((e) => e.id != null && e.id == notification.id);
      if (existingIndex >= 0) {
        items[existingIndex] = notification;
      } else {
        items.insert(0, notification);
      }
      items.refresh();

      if (notification.unread) {
        unreadCount.value = unreadCount.value + 1;
      }

      // Inbox updates from socket. Tray UI is handled by FCM to avoid
      // duplicate system notifications (socket + FCM both showing).
    } catch (e, st) {
      debugPrint('NotificationController.handleRealtimeNotification: $e\n$st');
    }
  }

  /// Prefer the notification row itself. Do NOT treat nested `data`
  /// (assignmentId/bookingId/…) as the notification — that caused the
  /// empty title/body → "Zeengo" duplicate tray item.
  Map<String, dynamic> _unwrapNotificationPayload(Map<String, dynamic> map) {
    final looksLikeNotification = map.containsKey('title') ||
        map.containsKey('type') ||
        map.containsKey('body') ||
        (map.containsKey('id') &&
            (map.containsKey('createdAt') || map.containsKey('isRead')));
    if (looksLikeNotification) return map;

    final inner = map['data'];
    if (inner is Map) {
      return Map<String, dynamic>.from(inner);
    }
    return map;
  }

  String? _extractError(dynamic body) {
    if (body is! Map) return null;
    final error = body['error'];
    if (error is Map && error['message'] != null) {
      return error['message'].toString();
    }
    if (body['message'] != null) return body['message'].toString();
    return null;
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
