import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../data/constants.dart';
import '../utils/values/env.dart';
import 'auth_controller.dart';
import 'notification_controller.dart';

/// Socket.IO `/ws` — notifications realtime.
class SocketController extends GetxController with WidgetsBindingObserver {
  SocketController({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  io.Socket? _socket;
  final isConnected = false.obs;

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

  /// Cold start / login / resume: refresh token + socket.
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

    disconnect();

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
    if (socket == null) {
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
  }

  void reconnectWithLatestToken() => connect();
}
