import '../api_response_model.dart';

/// `POST /auth/logout` response `data`: `{ "message": "Logged out successfully" }`
class LogoutModel extends Serializable {
  String? message;

  LogoutModel({this.message});

  factory LogoutModel.fromJson(Map<String, dynamic> json) => LogoutModel(
        message: json['message']?.toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
