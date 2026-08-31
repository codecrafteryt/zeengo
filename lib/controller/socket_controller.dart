import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../data/constants.dart';
import '../utils/values/env.dart';
import 'notification_controller.dart';

/// Realtime Socket.IO client for `notification.new` (and future events).
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

    // Reconnect with fresh token after login/session renew.
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
}
