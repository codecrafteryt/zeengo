import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_provider/api_provider.dart';
import '../../constants.dart';

class TaskRepo extends GetxService {
  TaskRepo({
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

  /// `GET /client/tasks?filter=&page=&limit=`
  Future<Response> fetchTasks({
    String filter = 'all',
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    return await apiProvider.getData(
      Constants.clientTasks,
      query: {
        'filter': filter,
        'page': '$page',
        'limit': '$limit',
        if (status != null && status.isNotEmpty) 'status': status,
      },
      headers: _authHeaders,
    );
  }

  /// `GET /client/tasks/:id`
  Future<Response> fetchTask(String id) async {
    return await apiProvider.getData(
      Constants.clientTask(id),
      headers: _authHeaders,
    );
  }
}
