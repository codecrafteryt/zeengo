import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api_provider/api_provider.dart';
import '../data/constants.dart';
import '../data/models/api_response_model.dart';
import '../data/models/chat_model/chat_model.dart';
import '../data/repos/chat_repo/chat_repo.dart';
import 'home_controller.dart';
import 'language_controller.dart';
import 'socket_controller.dart';

class ChatController extends GetxController {
  ChatController({
    required this.chatRepo,
    required this.sharedPreferences,
  });

  final ChatRepo chatRepo;
  final SharedPreferences sharedPreferences;

  final isLoading = false.obs;
  final isSending = false.obs;
  final errorMessage = RxnString();
  final conversation = Rxn<ChatConversation>();
  final messages = <ChatApiMessage>[].obs;
  final supportTyping = false.obs;

  Timer? _typingThrottle;
  Timer? _typingHide;
  String? _joinedConversationId;

  String get myClientId =>
      sharedPreferences.getString(Constants.userId) ?? '';

  String get _lang {
    if (Get.isRegistered<LanguageController>()) {
      return Get.find<LanguageController>().isArabic ? 'ar' : 'en';
    }
    return 'en';
  }

  @override
  void onClose() {
    leaveThread();
    _typingThrottle?.cancel();
    _typingHide?.cancel();
    super.onClose();
  }

  /// Open booking support thread + load history + socket join.
  Future<void> openSupportThread() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final bookingId = await _resolveBookingId();
      if (bookingId == null || bookingId.isEmpty) {
        errorMessage.value = 'No active booking for chat.';
        return;
      }

      final threadRes = await chatRepo.openBookingThread(bookingId);
      if (!ApiProvider.isSuccessfulHttpStatus(threadRes.statusCode) ||
          threadRes.body is! Map) {
        errorMessage.value = 'Unable to open support chat.';
        return;
      }

      final thread = ApiResponse.fromJson(
        Map<String, dynamic>.from(threadRes.body as Map),
        ChatConversation.fromJson,
      );
      if (thread.data == null || (thread.data!.id ?? '').isEmpty) {
        errorMessage.value =
            thread.error.isNotEmpty ? thread.error : 'Unable to open chat.';
        return;
      }

      conversation.value = thread.data;
      await _loadMessages(thread.data!.id!);
      _joinSocket(thread.data!.id!);
      await _markLatestRead();
    } catch (e, st) {
      debugPrint('ChatController.openSupportThread error: $e\n$st');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadMessages(String conversationId) async {
    final res = await chatRepo.fetchMessages(conversationId, limit: 50);
    if (!ApiProvider.isSuccessfulHttpStatus(res.statusCode) ||
        res.body is! Map) {
      messages.clear();
      return;
    }
    final body = Map<String, dynamic>.from(res.body as Map);
    final raw = body['data'];
    messages.assignAll(ChatApiMessage.listFrom(raw));
  }

  Future<String?> _resolveBookingId() async {
    final cached = sharedPreferences.getString(Constants.bookingId);
    if (cached != null && cached.isNotEmpty) return cached;
    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>().home.value;
      final id = home?.bookingId?.trim();
      if (id != null && id.isNotEmpty) {
        await sharedPreferences.setString(Constants.bookingId, id);
        return id;
      }
      if (Get.find<HomeController>().home.value == null) {
        await Get.find<HomeController>().fetchHome(showLoader: false);
        final again = Get.find<HomeController>().home.value?.bookingId?.trim();
        if (again != null && again.isNotEmpty) {
          await sharedPreferences.setString(Constants.bookingId, again);
          return again;
        }
      }
    }
    return null;
  }

  void _joinSocket(String conversationId) {
    if (!Get.isRegistered<SocketController>()) return;
    final socket = Get.find<SocketController>();
    if (_joinedConversationId != null &&
        _joinedConversationId != conversationId) {
      socket.leaveConversation(_joinedConversationId!);
    }
    socket.joinConversation(conversationId);
    _joinedConversationId = conversationId;
  }

  void leaveThread() {
    final id = _joinedConversationId;
    if (id != null && Get.isRegistered<SocketController>()) {
      Get.find<SocketController>().leaveConversation(id);
    }
    _joinedConversationId = null;
    supportTyping.value = false;
  }

  Future<void> sendMessage(String text) async {
    final body = text.trim();
    final convId = conversation.value?.id;
    if (body.isEmpty || convId == null || convId.isEmpty) return;
    if (isSending.value) return;

    isSending.value = true;
    debugPrint(
      '====> CHAT OUT sendMessage conversationId=$convId body=$body',
    );
    try {
      final res = await chatRepo.sendMessage(convId, body: body);
      debugPrint(
        '====> CHAT OUT sendMessage status=${res.statusCode} body=${res.body}',
      );
      if (!ApiProvider.isSuccessfulHttpStatus(res.statusCode) ||
          res.body is! Map) {
        errorMessage.value = 'Failed to send message.';
        return;
      }
      final model = ApiResponse.fromJson(
        Map<String, dynamic>.from(res.body as Map),
        ChatApiMessage.fromJson,
      );
      if (model.data != null) {
        debugPrint(
          '====> CHAT OUT parsed message: ${model.data!.toJson()}',
        );
        _upsertMessage(model.data!);
        await markRead(model.data!.id!);
      }
    } catch (e, st) {
      debugPrint('ChatController.sendMessage error: $e\n$st');
      errorMessage.value = e.toString();
    } finally {
      isSending.value = false;
    }
  }

  Future<void> markRead(String lastMessageId) async {
    final convId = conversation.value?.id;
    if (convId == null || lastMessageId.isEmpty) return;
    try {
      await chatRepo.markRead(convId, lastMessageId: lastMessageId);
    } catch (e) {
      debugPrint('ChatController.markRead error: $e');
    }
  }

  Future<void> _markLatestRead() async {
    if (messages.isEmpty) return;
    final lastId = messages.last.id;
    if (lastId != null && lastId.isNotEmpty) await markRead(lastId);
  }

  void onComposerChanged(String text) {
    final convId = conversation.value?.id;
    if (convId == null || text.trim().isEmpty) return;
    if (_typingThrottle?.isActive ?? false) return;
    _typingThrottle = Timer(const Duration(milliseconds: 800), () {});
    if (Get.isRegistered<SocketController>()) {
      Get.find<SocketController>().emitTyping(convId);
    }
  }

  void handleMessageNew(dynamic raw) {
    debugPrint('====> CHAT IN handleMessageNew raw=$raw');
    final msg = _parseMessage(raw);
    if (msg == null) return;
    debugPrint('====> CHAT IN message.new parsed: ${msg.toJson()}');
    final openId = conversation.value?.id;
    if (openId == null || msg.conversationId != openId) {
      debugPrint(
        '====> CHAT IN message.new ignored (openId=$openId msgConv=${msg.conversationId})',
      );
      return;
    }
    _upsertMessage(msg);
    if (!msg.isMine(myClientId) && msg.id != null) {
      markRead(msg.id!);
    }
  }

  void handleMessageTranslated(dynamic raw) {
    debugPrint('====> CHAT IN handleMessageTranslated raw=$raw');
    final msg = _parseMessage(raw);
    if (msg == null || msg.id == null) return;
    debugPrint('====> CHAT IN message.translated parsed: ${msg.toJson()}');
    final i = messages.indexWhere((m) => m.id == msg.id);
    if (i >= 0) {
      messages[i] = msg;
      messages.refresh();
    }
  }

  void handleTyping(dynamic raw) {
    if (raw is! Map) return;
    final map = Map<String, dynamic>.from(raw);
    final convId = map['conversationId']?.toString();
    final userType = map['userType']?.toString();
    if (convId != conversation.value?.id) return;
    if (userType != 'staff') return;
    supportTyping.value = true;
    _typingHide?.cancel();
    _typingHide = Timer(const Duration(seconds: 3), () {
      supportTyping.value = false;
    });
  }

  void handleMessageRead(dynamic raw) {
    // Optional read receipts — no UI dependency yet.
    debugPrint('====> CHAT message.read: $raw');
  }

  void _upsertMessage(ChatApiMessage msg) {
    if (msg.id != null) {
      final exists = messages.any((m) => m.id == msg.id);
      if (exists) return;
    }
    messages.add(msg);
  }

  ChatApiMessage? _parseMessage(dynamic raw) {
    if (raw is! Map) return null;
    try {
      return ChatApiMessage.fromJson(Map<String, dynamic>.from(raw));
    } catch (e) {
      debugPrint('====> CHAT parse message error: $e');
      return null;
    }
  }

  String bubbleText(ChatApiMessage msg) => msg.displayText(_lang);
}
