class SessionResponse {
  final String access;

  SessionResponse({required this.access});

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      access: json['access'] ?? '', // Default to an empty string if null
    );
  }
}
