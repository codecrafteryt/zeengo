import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_provider/api_provider.dart';
import '../../constants.dart';

class HomeRepo extends GetxService {
  HomeRepo({
    required this.apiProvider,
    required this.sharedPreferences,
  });

  final ApiProvider apiProvider;
  final SharedPreferences sharedPreferences;

  /// `GET /client/home` — Bearer client JWT.
  Future<Response> fetchHome() async {
    final token = sharedPreferences.getString(Constants.accessToken) ?? '';
    return await apiProvider.getData(
      Constants.clientHome,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }
}
