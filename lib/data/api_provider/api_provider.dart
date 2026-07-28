
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import '../constants.dart';

class ApiProvider extends GetConnect implements GetxService {
  ApiProvider() {
    httpClient.baseUrl = Constants.baseUrl;
    httpClient.timeout = const Duration(seconds: 60);
    httpClient.defaultContentType = 'application/json';
  }

  /// Any 2xx is treated as HTTP success (many POST APIs return 201, not only 200).
  static bool isSuccessfulHttpStatus(int? statusCode) {
    if (statusCode == null) return false;
    return statusCode >= 200 && statusCode < 300;
  }

  Future<Response> postData(String url,
      {required Map<String, dynamic> body,
        Map<String, String>? headers}) async {
    debugPrint(
        '====> API Call: [${Constants.baseUrl + url}]\n$body  \n $headers');

    var response = await post(url, body, headers: headers ?? {});
    print(response.statusCode);
    return handleData(url, response);
  }

  Future<Response> putData(String url,
      {required Map<String, dynamic> body,
        Map<String, String>? headers}) async {
    Get.log("in api client");
    debugPrint(
        '====> API Call: [${Constants.baseUrl + url}]\n$body  \n $headers');

    var response = await put(url, body, headers: headers ?? {});
    debugPrint(response.statusCode.toString());
    return handleData(url, response);
  }

  Future<Response> postFormData(String url,
      {required FormData body, Map<String, String>? headers}) async {
    debugPrint('====> API Call: [${Constants.baseUrl + url}]\n$body  \n $headers');
    var response = await post(url, body, headers: headers ?? {});
    Get.log('====> API Response: [${response.statusCode}] ${Constants.baseUrl + url}\n${response.body}');
    response = Response(
        body: response.body,
        statusCode: response.statusCode,
        request: response.request,
        headers: response.headers,
        statusText: response.statusText);
    debugPrint("Response: outside Isolate: ${response.toString()}");
    return handleData(url, response);
  }

  Future<Response> putFormData(String url,
      {required FormData body, Map<String, String>? headers}) async {
    debugPrint(
        '====> API Call: [${Constants.baseUrl + url}]\n$body  \n $headers');
    dynamic _body;
    Response _response;
    Response response = await put(url, body, headers: headers ?? {});
    _response = Response(
        body: response.body,
        statusCode: response.statusCode,
        request: response.request,
        headers: response.headers,
        statusText: response.statusText);
    debugPrint("Response: outside Isolate: ${_response.toString()}");
    // return _response;
    return handleData(url, _response);
  }

  Future<Response<dynamic>> getData(String url,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    debugPrint(
        '====> API Call: [${Constants.baseUrl + url}]\n$query  \n $headers');
    var response = await get(url, query: query, headers: headers ?? {});
    return handleData(url, response);
  }

  Future<Response<dynamic>> deleteData(String url,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    debugPrint(
        '====> API Call: [${Constants.baseUrl + url}]\n$query  \n $headers');
    var response = await delete(url, query: query, headers: headers ?? {});
    return handleData(url, response);
  }

  Future<Response<dynamic>> handleData(url, response) async {
    Response _response;

    debugPrint('====> API Response: [${response.statusCode}] ${Constants.baseUrl + url}\n${response.body}');

    if (!isSuccessfulHttpStatus(response.statusCode)) {
      _response = Response(
        body: {
          "status": "0",
          "message": "Some Error has occured\n",
          "data": {},
          "error": "Please try again later"
        },
        bodyString: "{}",
        request: Request(
            headers: response.request!.headers,
            method: response.request!.method,
            url: response.request!.url),
        headers: response.headers,
        statusCode: response.statusCode,
        statusText: response.statusText,
      );
    } else {
      final dynamic normalizedBody = _normalizeJsonBody(response.body);
      _response = Response(
        body: normalizedBody,
        bodyString: normalizedBody?.toString() ?? '',
        request: Request(
            headers: response.request!.headers,
            method: response.request!.method,
            url: response.request!.url),
        headers: response.headers,
        statusCode: response.statusCode,
        statusText: response.statusText,
      );
    }

    debugPrint(
        '====>After Decoding API Response: [${_response.statusCode}] ${Constants.baseUrl + url}\n====>After Decoding _Body ${_response.body}');
    return _response;
  }

  /// Keep Map as-is; decode JSON [String] to Map; avoid jsonDecode(null) crashes.
  static dynamic _normalizeJsonBody(dynamic body) {
    if (body == null) return null;
    if (body is Map) return body;
    if (body is String) {
      final String s = body.trim();
      if (s.isEmpty) return null;
      try {
        final dynamic decoded = jsonDecode(s);
        return decoded is Map ? decoded : body;
      } catch (_) {
        return body;
      }
    }
    return body;
  }

  _sendDataInBackGround(List<dynamic> args) async {
    SendPort responsePort = args[0];
    FormData data = args[1];
    dynamic func = args[2];
    dynamic url = args[3];
    dynamic headers = args[4];
    try {
      Get.log("isolates ");
      print(data.fields);
      Response response = await post(url, data, headers: headers ?? {});
      print("Response in Isolate: ${response.body}");
      // responsePort.send(response.body);
      Isolate.exit(responsePort, [
        response.body,
        response.statusCode,
        response.request,
        response.headers,
        response.statusText
      ]);
    } catch (e) {
      Get.log("isolates erroer ");
      debugPrint(e.toString());
      Isolate.exit(responsePort, null);
    }
  }

  _putDataInBackGround(List<dynamic> args) async {
    SendPort responsePort = args[0];
    FormData data = args[1];
    dynamic func = args[2];
    dynamic url = args[3];
    dynamic headers = args[4];
    try {
      print(data.fields);
      Response response = await put(url, data, headers: headers ?? {});
      print("Response in Isolate: ${response.body}");
      // responsePort.send(response.body);
      Isolate.exit(responsePort, [
        response.body,
        response.statusCode,
        response.request,
        response.headers,
        response.statusText
      ]);
    } catch (e) {
      debugPrint(e.toString());
      Isolate.exit(responsePort, null);
    }
  }
}