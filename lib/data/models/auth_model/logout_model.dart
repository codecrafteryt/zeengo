
/*
  ---------------------------------------
  Project: Braelo Mobile Application
  Date: Sep 29, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: Logout Model.
*/
import '../api_response_model.dart';

class LogoutResponseModel extends Serializable {
  final int status;
  final String message;
  final String error;
  final LogoutData data;

  LogoutResponseModel({
    required this.status,
    required this.message,
    required this.error,
    required this.data,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) {
    return LogoutResponseModel(
      status: json['status'],
      message: json['message'],
      error: json['error'],
      data: LogoutData.fromJson(json['data']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'error': error,
      'data': data.toJson(),
    };
  }
}

class LogoutData extends Serializable {
  final String refreshToken;

  LogoutData({
    required this.refreshToken,
  });

  factory LogoutData.fromJson(Map<String, dynamic> json) {
    return LogoutData(
      refreshToken: json['refresh_token'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
    };
  }
}
