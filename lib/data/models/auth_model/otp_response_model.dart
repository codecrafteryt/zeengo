class OtpResponseModel {
  final String message;
  final int status;

  OtpResponseModel({
    required this.message,
    required this.status,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      message: json['message'].toString(),
      status: json['status'] ?? 200,  // Default to 200 if not provided
    );
  }
}
