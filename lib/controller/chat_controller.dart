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

  /// True while a staff peer is typing in the open conversation.
  final isPeerTyping = false.obs;

  /// Normalized channel of the typer: `admin` | `driver` | `splizer`.
  final typingChannel = RxnString();

  /// Raw staff role from `chat.typing` (admin | driver | splizer | …).
  final typingRole = RxnString();

  /// Display name for the typer (e.g. "Zeengo Admin"), when known.
  final typingSenderName = RxnString();

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
    _clearTyping();
  }

  /// Whether the open peer typing indicator belongs on [tab] (0/1/2).
  bool isTypingOnTab(int tab) {
    if (!isPeerTyping.value) return false;
    final channel = typingChannel.value;
    if (tab == 1) return channel == 'driver';
    if (tab == 2) return channel == 'splizer';
    return channel == 'admin';
  }

  Future<void> sendMessage(String text, {required String senderRole}) async {
    final body = text.trim();
    final convId = conversation.value?.id;
    if (body.isEmpty || convId == null || convId.isEmpty) return;
    if (isSending.value) return;

    isSending.value = true;
    debugPrint(
      '====> CHAT OUT sendMessage conversationId=$convId senderRole=$senderRole body=$body',
    );
    try {
      final res = await chatRepo.sendMessage(
        convId,
        body: body,
        senderRole: senderRole,
      );
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
    // Staff message ends the typing pulse for that channel.
    if (msg.senderType == 'staff' &&
        typingChannel.value == msg.inboxChannel) {
      _clearTyping();
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
    final map = _asStringKeyedMap(raw);
    // ignore: avoid_print
    print('====> CHAT handleTyping raw=$raw parsed=$map');
    if (map == null) {
      // ignore: avoid_print
      print('====> CHAT typing skipped: payload is not a Map');
      return;
    }

    final convId = map['conversationId']?.toString().trim();
    final userType = map['userType']?.toString().toLowerCase().trim();
    final role = (map['role'] ?? map['senderRole'])?.toString().trim();
    final userId = map['userId']?.toString().trim();
    final openId = conversation.value?.id?.trim();

    if (convId == null || convId.isEmpty) {
      // ignore: avoid_print
      print('====> CHAT typing skipped: missing conversationId');
      return;
    }
    if (openId == null || openId.isEmpty || convId != openId) {
      // ignore: avoid_print
      print(
        '====> CHAT typing skipped: conv mismatch openId=$openId eventId=$convId',
      );
      return;
    }
    // Only show peer typing — ignore own / non-staff pulses.
    if (userType != null &&
        userType.isNotEmpty &&
        userType != 'staff') {
      // ignore: avoid_print
      print('====> CHAT typing skipped: userType=$userType');
      return;
    }
    if (userId != null &&
        userId.isNotEmpty &&
        myClientId.isNotEmpty &&
        userId == myClientId) {
      // ignore: avoid_print
      print('====> CHAT typing skipped: own pulse userId=$userId');
      return;
    }

    final channel = ChatApiMessage.channelForRole(role);
    final name = _resolveTypingSenderName(
      userId: userId,
      channel: channel,
    );

    // ignore: avoid_print
    print(
      '====> CHAT typing SHOW channel=$channel role=$role '
      'userId=$userId name=$name',
    );

    typingChannel.value = channel;
    typingRole.value = role;
    typingSenderName.value = name;
    isPeerTyping.value = true;
    // Each socket pulse resets the hide window (staff may spam ~1s).
    _typingHide?.cancel();
    _typingHide = Timer(const Duration(milliseconds: 3000), _clearTyping);
  }

  /// Prefer known staff [senderName] for this typer / channel (e.g. "Zeengo Admin").
  String? _resolveTypingSenderName({
    required String? userId,
    required String channel,
  }) {
    if (userId != null && userId.isNotEmpty) {
      for (var i = messages.length - 1; i >= 0; i--) {
        final m = messages[i];
        if (m.senderType != 'staff') continue;
        if (m.senderStaffId == userId) {
          final n = m.senderName?.trim();
          if (n != null && n.isNotEmpty) return n;
        }
      }
    }
    for (var i = messages.length - 1; i >= 0; i--) {
      final m = messages[i];
      if (m.senderType != 'staff') continue;
      if (m.inboxChannel != channel) continue;
      final n = m.senderName?.trim();
      if (n != null && n.isNotEmpty) return n;
    }
    return null;
  }

  Map<String, dynamic>? _asStringKeyedMap(dynamic raw) {
    if (raw is Map) {
      try {
        return Map<String, dynamic>.from(raw);
      } catch (_) {
        return {
          for (final e in raw.entries) e.key.toString(): e.value,
        };
      }
    }
    return null;
  }

  void _clearTyping() {
    _typingHide?.cancel();
    _typingHide = null;
    isPeerTyping.value = false;
    typingChannel.value = null;
    typingRole.value = null;
    typingSenderName.value = null;
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
