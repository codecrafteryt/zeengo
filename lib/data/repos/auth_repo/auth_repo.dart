import 'package:get/get.dart';

import '../../api_provider/api_provider.dart';
import '../../constants.dart';

class AuthRepo extends GetxService {
  AuthRepo({required this.apiProvider});

  final ApiProvider apiProvider;

  /// `POST /auth/client/login` — body: `{ phone, bookingCode }`.
  Future<Response> loginRepo({
    required String phone,
    required String bookingCode,
  }) async {
    return await apiProvider.postData(
      Constants.clientLogin,
      body: {
        'phone': phone,
        'bookingCode': bookingCode,
      },
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }
}
