import '../api_response_model.dart';

class ForgetPasswordModel extends Serializable {
  final String message;

  ForgetPasswordModel({required this.message});

  // Factory method to create an instance from JSON
  factory ForgetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordModel(
      message: json['message'] ?? '', // Provide a default value if 'message' is null
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
