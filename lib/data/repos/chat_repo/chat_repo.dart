import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_provider/api_provider.dart';
import '../../constants.dart';

class ChatRepo extends GetxService {
  ChatRepo({
    required this.apiProvider,
    required this.sharedPreferences,
  });

  final ApiProvider apiProvider;
  final SharedPreferences sharedPreferences;

  Map<String, String> get _authHeaders {
    final token = sharedPreferences.getString(Constants.accessToken) ?? '';
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// `GET /chat/conversations`
  Future<Response> fetchConversations() {
    return apiProvider.getData(
      Constants.chatConversations,
      headers: _authHeaders,
    );
  }

  /// `POST /chat/bookings/:bookingId/thread`
  Future<Response> openBookingThread(String bookingId) {
    return apiProvider.postData(
      Constants.chatBookingThread(bookingId),
      body: const {},
      headers: _authHeaders,
    );
  }

  /// `GET /chat/conversations/:id/messages`
  Future<Response> fetchMessages(
    String conversationId, {
    int limit = 50,
    String? before,
  }) {
    return apiProvider.getData(
      Constants.chatMessages(conversationId),
      query: {
        'limit': '$limit',
        if (before != null && before.isNotEmpty) 'before': before,
      },
      headers: _authHeaders,
    );
  }

  /// `POST /chat/conversations/:id/messages`
  Future<Response> sendMessage(
    String conversationId, {
    required String body,
    required String senderRole,
    List<Map<String, dynamic>> attachments = const [],
  }) {
    return apiProvider.postData(
      Constants.chatMessages(conversationId),
      body: {
        'body': body,
        'senderRole': senderRole,
        'attachments': attachments,
      },
      headers: _authHeaders,
    );
  }

  /// `POST /chat/conversations/:id/read`
  Future<Response> markRead(
    String conversationId, {
    required String lastMessageId,
  }) {
    return apiProvider.postData(
      Constants.chatRead(conversationId),
      body: {'lastMessageId': lastMessageId},
      headers: _authHeaders,
    );
  }
}
