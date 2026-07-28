
import '../api_response_model.dart';

class PhoneNumberModel extends Serializable {
  int? status;
  String? message;
  String? error;
  Data? data;

  PhoneNumberModel({this.status, this.message, this.error, this.data});

  factory PhoneNumberModel.fromJson(Map<String, dynamic> json) => PhoneNumberModel(
    status: json['status'],
    message: json['message'],
    error: json['error'],
    data: json['data'] != null ? Data.fromJson(json['data']) : null,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'error': error,
    'data': data?.toJson(),
  };
}

class Data {
  String? phone;
  Token? token;

  Data({this.phone, this.token});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    phone: json['phone'],
    token: json['token'] != null ? Token.fromJson(json['token']) : null,
  );

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'token': token?.toJson(),
  };
}

class Token {
  String? refresh;
  String? access;

  Token({this.refresh, this.access});

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    refresh: json['refresh'],
    access: json['access'],
  );

  Map<String, dynamic> toJson() => {
    'refresh': refresh,
    'access': access,
  };
}
