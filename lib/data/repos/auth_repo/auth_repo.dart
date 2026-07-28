
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import '../../api_provider/api_provider.dart';

class AuthRepo extends GetxService {
  ApiProvider apiProvider;
  AuthRepo({required this.apiProvider,});

  // Future<Response> checkSession({required String refreshToken}) async {
  //   final Map<String, dynamic> body = {
  //     'refresh': refreshToken,
  //   };
  //
  //   final Map<String, String> headers = {
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //   };
  //
  //   return await apiProvider.postData(Constants.session, body: body, headers: headers);
  // }
  //
  //
  // Future<Response> registerRepo({
  //   required String name,
  //   required String email,
  //   required String password
  // }) async {
  //   return await apiProvider.postData(Constants.register, body: {
  //     "email": email,
  //     "name": name,
  //     "password": password,
  //   });}

}