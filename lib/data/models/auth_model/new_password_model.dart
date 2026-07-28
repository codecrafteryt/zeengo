// new_password_model.dart
import 'dart:convert';
import '../api_response_model.dart';

// Function to parse JSON response into NewPasswordModel object
NewPasswordModel newPasswordModelFromJson(String str) =>
    NewPasswordModel.fromJson(json.decode(str));

// Function to convert NewPasswordModel object into JSON string
String newPasswordModelToJson(NewPasswordModel data) =>
    json.encode(data.toJson());

class NewPasswordModel extends Serializable {
  int status;
  String message;
  dynamic error; // Error can be null or of other types based on API response
  NewPasswordData? data; // Make data nullable to handle cases where it might be null

  NewPasswordModel({
    required this.status,
    required this.message,
    this.error,
    this.data,
  });

  // Factory method to create an instance from JSON
  factory NewPasswordModel.fromJson(Map<String, dynamic> json) => NewPasswordModel(
    status: json["status"] ?? 0,
    message: json["message"] ?? "",
    error: json["error"],
    data: json["data"] != null ? NewPasswordData.fromJson(json["data"]) : null, // Check if data is null before parsing
  );

  // Method to convert object to JSON
  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "error": error,
    "data": data?.toJson(), // Use a null-aware operator
  };
}

class NewPasswordData {
  String email;

  NewPasswordData({
    required this.email,
  });

  // Factory method to create NewPasswordData from JSON
  factory NewPasswordData.fromJson(Map<String, dynamic> json) => NewPasswordData(
    email: json["email"] ?? "", // Safely access the email field
  );

  // Method to convert object to JSON
  Map<String, dynamic> toJson() => {
    "email": email,
  };
}
