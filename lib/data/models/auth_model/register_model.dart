// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

import '../api_response_model.dart';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel extends Serializable {
  String email;
  Token token;
  bool? businessStatus;
  String name;

  RegisterModel({
    required this.email,
    required this.token,
    this.businessStatus,
    required this.name,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        email: json["email"],
        token: Token.fromJson(json["token"]),
        businessStatus: json['user_status'] is bool ? json['user_status'] : null,
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "token": token.toJson(),
        "user_status": businessStatus,
        "name": name,
      };
}

class Token {
  String refresh;
  String access;

  Token({
    required this.refresh,
    required this.access,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        refresh: json["refresh"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };
}
