import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_provider/api_provider.dart';
import '../../constants.dart';

class NotificationRepo extends GetxService {
  NotificationRepo({
    required this.apiProvider,
    required this.sharedPreferences,
  });

  final ApiProvider apiProvider;
  final SharedPreferences sharedPreferences;

  Map<String, String> get _authHeaders {
    final token = sharedPreferences.getString(Constants.accessToken) ?? '';
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// `GET /notifications?page=&limit=&filter=`
  Future<Response> fetchNotifications({
    int page = 1,
    int limit = 20,
    String filter = 'all',
  }) async {
    return await apiProvider.getData(
      Constants.notifications,
      query: {
        'page': '$page',
        'limit': '$limit',
        'filter': filter,
      },
      headers: _authHeaders,
    );
  }

  /// `GET /notifications/unread-count`
  Future<Response> fetchUnreadCount() async {
    return await apiProvider.getData(
      Constants.notificationsUnreadCount,
      headers: _authHeaders,
    );
  }

  /// `POST /notifications/:id/read`
  Future<Response> markRead(String id) async {
    return await apiProvider.postData(
      Constants.notificationRead(id),
      body: const <String, dynamic>{},
      headers: _authHeaders,
    );
  }

  /// `POST /notifications/read-all`
  Future<Response> markAllRead() async {
    return await apiProvider.postData(
      Constants.notificationsReadAll,
      body: const <String, dynamic>{},
      headers: _authHeaders,
    );
  }
}
