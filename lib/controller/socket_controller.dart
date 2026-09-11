import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../data/constants.dart';
import '../utils/values/env.dart';
import 'auth_controller.dart';
import 'chat_controller.dart';
import 'notification_controller.dart';

/// Socket.IO `/ws` — notifications + chat realtime.
class SocketController extends GetxController with WidgetsBindingObserver {
  SocketController({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  io.Socket? _socket;
  final isConnected = false.obs;

  /// Last joined conversation — re-emitted after every (re)connect.
  String? _activeConversationId;

  DateTime? _lastResumeAt;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnect();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onAppResumed();
    }
  }

  /// Cold start / login / resume: refresh token + socket + open chat.
  Future<void> onAppResumed() async {
    final now = DateTime.now();
    if (_lastResumeAt != null &&
        now.difference(_lastResumeAt!) < const Duration(seconds: 2)) {
      return;
    }
    _lastResumeAt = now;

    if (Get.isRegistered<AuthController>()) {
      await Get.find<AuthController>().refreshTokensQuietly();
    }

    if (!isConnected.value || _socket == null) {
      connect();
    } else {
      _rejoinActiveConversation();
    }

    if (Get.isRegistered<ChatController>()) {
      await Get.find<ChatController>().onAppResumed();
    }
  }

  void connect() {
    final token = sharedPreferences.getString(Constants.accessToken) ?? '';
    final url = Env.socketUrl;
    if (token.isEmpty) {
      debugPrint('====> SOCKET skip connect: no access token');
      return;
    }
    if (url.isEmpty) {
      debugPrint('====> SOCKET skip connect: SOCKET_URL empty');
      return;
    }

    disconnect(clearActiveConversation: false);

    debugPrint('====> SOCKET connecting to $url');
    _socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableForceNew()
          .enableReconnection()
          .setReconnectionAttempts(20)
          .setReconnectionDelay(1000)
          .setAuth({'token': token})
          .build(),
    );

    _socket!
      ..onConnect((_) {
        isConnected.value = true;
        debugPrint('====> SOCKET connected');
        _rejoinActiveConversation();
      })
      ..onDisconnect((_) {
        isConnected.value = false;
        debugPrint('====> SOCKET disconnected');
      })
      ..onConnectError((err) {
        isConnected.value = false;
        debugPrint('====> SOCKET connect error: $err');
      })
      ..onError((err) {
        debugPrint('====> SOCKET error: $err');
      })
      ..on('reconnect', (_) {
        isConnected.value = true;
        debugPrint('====> SOCKET reconnected');
        _rejoinActiveConversation();
      })
      ..on('notification.new', (data) {
        debugPrint('====> SOCKET event notification.new: $data');
        if (Get.isRegistered<NotificationController>()) {
          Get.find<NotificationController>().handleRealtimeNotification(data);
        }
      })
      ..on('message.new', (data) {
        debugPrint('====> SOCKET IN message.new: $data');
        if (Get.isRegistered<ChatController>()) {
          Get.find<ChatController>().handleMessageNew(data);
        }
      })
      ..on('message.translated', (data) {
        debugPrint('====> SOCKET IN message.translated: $data');
        if (Get.isRegistered<ChatController>()) {
          Get.find<ChatController>().handleMessageTranslated(data);
        }
      })
      ..on('chat.typing', (data) {
        // ignore: avoid_print
        print('====> SOCKET IN chat.typing: $data');
        if (Get.isRegistered<ChatController>()) {
          Get.find<ChatController>().handleTyping(data);
        }
      })
      ..on('message.read', (data) {
        debugPrint('====> SOCKET IN message.read: $data');
        if (Get.isRegistered<ChatController>()) {
          Get.find<ChatController>().handleMessageRead(data);
        }
      })
      ..connect();
  }

  void disconnect({bool clearActiveConversation = true}) {
    final socket = _socket;
    if (socket == null) {
      if (clearActiveConversation) _activeConversationId = null;
      isConnected.value = false;
      return;
    }
    try {
      socket.clearListeners();
      socket.disconnect();
      socket.dispose();
    } catch (e) {
      debugPrint('====> SOCKET disconnect error: $e');
    }
    _socket = null;
    isConnected.value = false;
    if (clearActiveConversation) _activeConversationId = null;
  }

  void reconnectWithLatestToken() => connect();

  void joinConversation(String conversationId) {
    _activeConversationId = conversationId;
    _rejoinActiveConversation();
  }

  void leaveConversation(String conversationId) {
    if (_activeConversationId == conversationId) {
      _activeConversationId = null;
    }
    _emit('chat.leave', {'conversationId': conversationId});
  }

  void emitTyping(String conversationId) {
    _emit('chat.typing', {'conversationId': conversationId});
  }

  void _rejoinActiveConversation() {
    final id = _activeConversationId;
    if (id == null || id.isEmpty) return;
    _emit('chat.join', {'conversationId': id});
  }

  void _emit(String event, Map<String, dynamic> payload) {
    final socket = _socket;
    if (socket == null || !isConnected.value) {
      debugPrint('====> SOCKET skip emit $event (not connected)');
      return;
    }
    debugPrint('====> SOCKET OUT $event: $payload');
    socket.emit(event, payload);
  }
}
