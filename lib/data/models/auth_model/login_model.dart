import 'dart:convert';

import '../api_response_model.dart';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str) as Map<String, dynamic>);

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

/// Auth payload for login / refresh `data`.
/// Login: `{ accessToken, refreshToken, user, booking? }`
/// Refresh: `{ accessToken, refreshToken }`
class LoginModel extends Serializable {
  String? accessToken;
  String? refreshToken;
  ClientUser? user;
  LoginBooking? booking;

  LoginModel({
    this.accessToken,
    this.refreshToken,
    this.user,
    this.booking,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        accessToken: json['accessToken']?.toString(),
        refreshToken: json['refreshToken']?.toString(),
        user: json['user'] is Map<String, dynamic>
            ? ClientUser.fromJson(json['user'] as Map<String, dynamic>)
            : null,
        booking: json['booking'] is Map<String, dynamic>
            ? LoginBooking.fromJson(json['booking'] as Map<String, dynamic>)
            : null,
      );

  @override
  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'user': user?.toJson(),
        'booking': booking?.toJson(),
      };
}

class ClientUser extends Serializable {
  String? id;
  String? fullName;
  String? phone;
  String? email;
  String? nationality;
  String? whatsapp;
  String? phoneVerifiedAt;
  String? emailVerifiedAt;
  String? preferredLang;
  String? createdAt;
  String? updatedAt;

  ClientUser({
    this.id,
    this.fullName,
    this.phone,
    this.email,
    this.nationality,
    this.whatsapp,
    this.phoneVerifiedAt,
    this.emailVerifiedAt,
    this.preferredLang,
    this.createdAt,
    this.updatedAt,
  });

  factory ClientUser.fromJson(Map<String, dynamic> json) => ClientUser(
        id: json['id']?.toString(),
        fullName: json['fullName']?.toString(),
        phone: json['phone']?.toString(),
        email: json['email']?.toString(),
        nationality: json['nationality']?.toString(),
        whatsapp: json['whatsapp']?.toString(),
        phoneVerifiedAt: json['phoneVerifiedAt']?.toString(),
        emailVerifiedAt: json['emailVerifiedAt']?.toString(),
        preferredLang: json['preferredLang']?.toString(),
        createdAt: json['createdAt']?.toString(),
        updatedAt: json['updatedAt']?.toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'phone': phone,
        'email': email,
        'nationality': nationality,
        'whatsapp': whatsapp,
        'phoneVerifiedAt': phoneVerifiedAt,
        'emailVerifiedAt': emailVerifiedAt,
        'preferredLang': preferredLang,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class LoginBooking extends Serializable {
  String? id;
  String? znCode;
  String? status;

  LoginBooking({
    this.id,
    this.znCode,
    this.status,
  });

  factory LoginBooking.fromJson(Map<String, dynamic> json) => LoginBooking(
        id: json['id']?.toString(),
        znCode: json['znCode']?.toString(),
        status: json['status']?.toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'znCode': znCode,
        'status': status,
      };
}
