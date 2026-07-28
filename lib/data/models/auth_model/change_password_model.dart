/*
  ---------------------------------------
  Project: Braelo Mobile Application
  Date: Sep 30, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: a model.
*/
import '../api_response_model.dart';

class ChangePasswordResponseModel extends Serializable {
  final int? status; // Nullable status
  final String message;
  final String? error; // Nullable error
  final ChangePasswordData data;

  ChangePasswordResponseModel({
    required this.status,
    required this.message,
    this.error,
    required this.data,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      status: json['status'] != null ? json['status'] as int? : null, // Safe casting
      message: json['message'] ?? 'No message provided', // Default message
      error: json['error'], // Keep nullable
      data: ChangePasswordData.fromJson(json['data'] ?? {}), // Safe parsing for data
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

class ChangePasswordData extends Serializable {
  final String email;

  ChangePasswordData({
    required this.email,
  });

  factory ChangePasswordData.fromJson(Map<String, dynamic> json) {
    return ChangePasswordData(
      email: json['email'] ?? 'No email provided', // Default email
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
