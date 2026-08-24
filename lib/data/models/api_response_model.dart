import 'package:flutter/foundation.dart';

abstract class Serializable {
  Map<String, dynamic> toJson();
}

/// Parses both Zeengo envelope (`success` / `data` / `error`) and legacy
/// braelo-style (`status` / `message` / `data` / `error`) bodies.
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

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) create,
  ) {
    try {
      debugPrint(
        '<<<<<<<<<<Debug: Parsing ApiResponse from JSON: $json>>>>>>>>>>',
      );

      // Zeengo Client API envelope
      if (json.containsKey('success')) {
        final success = json['success'] == true;
        final errorObj = json['error'];
        String errorMessage = '';
        if (errorObj is Map) {
          errorMessage = errorObj['message']?.toString() ??
              errorObj['code']?.toString() ??
              '';
        } else if (errorObj is String) {
          errorMessage = errorObj;
        }

        final rawData = json['data'];
        return ApiResponse<T>(
          status: success ? 200 : 400,
          message: errorMessage.isNotEmpty
              ? errorMessage
              : (success ? 'OK' : 'Request failed'),
          data: success && rawData is Map<String, dynamic>
              ? create(rawData)
              : null,
          error: errorMessage,
        );
      }

      // Legacy / fallback shape
      final rawData = json['data'];
      return ApiResponse<T>(
        status: _asInt(json['status']) ?? 0,
        message: json['message']?.toString() ?? '',
        data: rawData is Map<String, dynamic> ? create(rawData) : null,
        error: json['error']?.toString() ?? '',
      );
    } catch (e, stacktrace) {
      debugPrint(
        '<<<<<<<<<<Error: Failed to parse ApiResponse from JSON.>>>>>>>>>>',
      );
      debugPrint('<<<<<<<<<<Exception: $e>>>>>>>>>>');
      debugPrint('<<<<<<<<<<Stack Trace: $stacktrace>>>>>>>>>>');
      debugPrint('<<<<<<<<<<JSON Data: $json>>>>>>>>>>');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
        'error': error,
      };

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
