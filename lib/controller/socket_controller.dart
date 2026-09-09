import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../data/constants.dart';
import '../utils/values/env.dart';
import 'chat_controller.dart';
import 'notification_controller.dart';

/// Socket.IO `/ws` — notifications + chat realtime.
class SocketController extends GetxController {
  SocketController({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  io.Socket? _socket;
  final isConnected = false.obs;

  @override
  void onClose() {
    disconnect();
    super.onClose();
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

    disconnect();

    debugPrint('====> SOCKET connecting to $url');
    _socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .enableForceNew()
          .build(),
    );

    _socket!
      ..onConnect((_) {
        isConnected.value = true;
        debugPrint('====> SOCKET connected');
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
        // Use print (not debugPrint) — rapid identical pulses get throttled/dropped on Android.
        // ignore: avoid_print
        print('====> SOCKET IN chat.typing: $data');
        if (Get.isRegistered<ChatController>()) {
          Get.find<ChatController>().handleTyping(data);
        } else {
          // ignore: avoid_print
          print('====> SOCKET IN chat.typing ignored: ChatController not registered');
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

  void disconnect() {
    final socket = _socket;
    if (socket == null) return;
    try {
      socket.clearListeners();
      socket.disconnect();
      socket.dispose();
    } catch (e) {
      debugPrint('====> SOCKET disconnect error: $e');
    }
    _socket = null;
    isConnected.value = false;
  }

  void reconnectWithLatestToken() => connect();

  void joinConversation(String conversationId) {
    _emit('chat.join', {'conversationId': conversationId});
  }

  void leaveConversation(String conversationId) {
    _emit('chat.leave', {'conversationId': conversationId});
  }

  void emitTyping(String conversationId) {
    _emit('chat.typing', {'conversationId': conversationId});
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
