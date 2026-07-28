import 'dart:convert';
import '../api_response_model.dart';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel extends Serializable {
  String? email;
  Token? token;
  bool? businessStatus;
  String? name;
  String? businessName;
  bool? isWarned;
  bool? isBanned;

  LoginModel({
    this.email,
    this.token,
    this.businessStatus,
    this.name,
    this.businessName,
    this.isWarned,
    this.isBanned,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        // Use null-aware operators to prevent null values from causing errors
        email: json["email"] ?? '', // Default to empty string if null
        token: json["token"] != null ? Token.fromJson(json["token"]) : null,
        businessStatus: json['user_status'] is bool ? json['user_status'] : null,
        name: json["name"],
        businessName: json["business_name"],
        isWarned: json['is_warned'] is bool ? json['is_warned'] : null,
        isBanned: json['is_banned'] is bool ? json['is_banned'] : null,
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "token": token?.toJson(), // Use null-aware access
        "user_status": businessStatus,
        "name": name,
        "business_name": businessName,
        "is_warned": isWarned,
        "is_banned": isBanned,
      };
}

class Token {
  String? refresh; // Make refresh token nullable
  String? access; // Make access token nullable

  Token({
    this.refresh,
    this.access,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        // Handle null cases by assigning empty strings or keeping null
        refresh: json["refresh"] ?? '', // Default to empty string if null
        access: json["access"] ?? '', // Default to empty string if null
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };
}
