// otp_verification_model.dart
import 'dart:convert';
import '../api_response_model.dart';

// Function to parse JSON response into OtpVerificationModel object
OtpVerificationModel otpVerificationModelFromJson(String str) =>
    OtpVerificationModel.fromJson(json.decode(str));

// Function to convert OtpVerificationModel object into JSON string
String otpVerificationModelToJson(OtpVerificationModel data) =>
    json.encode(data.toJson());

class OtpVerificationModel extends Serializable {
  int status;
  String message;
  dynamic error; // Error can be null or of other types based on API response

  OtpVerificationModel({
    required this.status,
    required this.message,
    this.error,
  });

  // Factory method to create an instance from JSON
  factory OtpVerificationModel.fromJson(Map<String, dynamic> json) =>
      OtpVerificationModel(
        status: json["status"] ?? 0,
        message: json["message"] ?? "",
        error: json["error"],
      );

  // Method to convert object to JSON
  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "error": error,
  };
}
