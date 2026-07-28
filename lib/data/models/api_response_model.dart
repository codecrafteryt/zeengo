
// abstract class Serializable {
//   Map<String, dynamic> toJson();
// }
//
// class ApiResponse<T extends Serializable> {
//   int status;
//   String message;
//   String error;
//   T? data;
//
//   ApiResponse(
//       {required this.status,
//         required this.message,
//         this.data,
//         required this.error});
//
//   factory ApiResponse.fromJson(
//       Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
//     return ApiResponse<T>(
//       status: json["status"],
//       message: json["message"],
//       data: create(json["data"]),
//       error: json["error"] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "data": data!.toJson(),
//     "error": error,
//   };
// }

import 'package:flutter/cupertino.dart';

abstract class Serializable {
  Map<String, dynamic> toJson();
}

class ApiResponse<T extends Serializable> {
  int status;
  String message;
  String error;
  T? data;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    required this.error,
  });

  /// Enhanced fromJson with error handling and debug logging
  factory ApiResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    try {
      // Initial debug print to log incoming JSON data
      debugPrint("<<<<<<<<<<Debug: Parsing ApiResponse from JSON: $json>>>>>>>>>>");
      return ApiResponse<T>(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? create(json["data"]) : null,
        error: json["error"] ?? "",
      );
    } catch (e, stacktrace) {
      // Print a detailed error message and stack trace for debugging
      debugPrint("<<<<<<<<<<Error: Failed to parse ApiResponse from JSON.>>>>>>>>>>");
      debugPrint("<<<<<<<<<<Exception: $e>>>>>>>>>>");
      debugPrint("<<<<<<<<<<Stack Trace: $stacktrace>>>>>>>>>>");
      debugPrint("<<<<<<<<<<JSON Data: $json>>>>>>>>>>");
      // Optionally, rethrow or handle the error as required
      rethrow; // Rethrow if you want to handle it at a higher level
    }
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "error": error,
  };
}
