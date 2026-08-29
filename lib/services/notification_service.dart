import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/constants.dart';
import '../firebase_options.dart';

/// Top-level FCM background handler (must be a top-level / static function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.setupLocalNotificationsOnly();
  await NotificationService.instance.showRemoteMessage(message);
}

/// Push + local notifications for:
/// - foreground (app open)
/// - background (app minimized)
/// - terminated / killed
class NotificationService extends GetxService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'zeengo_default',
    'Zeengo Notifications',
    description: 'Trip updates, chats, and alerts',
    importance: Importance.high,
  );

  bool _initialized = false;
  bool _localReady = false;

  final fcmToken = ''.obs;

  Future<NotificationService> init() async {
    if (_initialized) return this;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await setupLocalNotificationsOnly();
    await _requestPermissions();
    await _configureFcmHandlers();
    await _persistToken(await _messaging.getToken());

    _messaging.onTokenRefresh.listen(_persistToken);

    _initialized = true;
    debugPrint('====> NotificationService ready. FCM: ${fcmToken.value}');
    return this;
  }

  /// Safe to call from background isolate (no GetX prefs dependency).
  Future<void> setupLocalNotificationsOnly() async {
    if (_localReady) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _local.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    final androidPlugin = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_channel);

    _localReady = true;
  }

  Future<void> _requestPermissions() async {
    // iOS / macOS alert permissions via FCM
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint(
      '====> FCM permission: ${settings.authorizationStatus}',
    );

    // Android 13+ runtime notification permission
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _configureFcmHandlers() async {
    // App OPEN (foreground) — system tray often suppressed; show local popup.
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint(
        '====> FCM foreground: ${message.messageId} '
        '${message.notification?.title}',
      );
      await showRemoteMessage(message);
    });

    // App in BACKGROUND — user taps the system notification.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('====> FCM opened from background: ${message.messageId}');
      _handleMessageNavigation(message.data);
    });

    // App was TERMINATED / KILLED — launched by tapping a notification.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      debugPrint('====> FCM opened from terminated: ${initial.messageId}');
      // Delay until first frame / GetMaterialApp is up.
      Future<void>.delayed(const Duration(milliseconds: 800), () {
        _handleMessageNavigation(initial.data);
      });
    }
  }

  Future<void> showRemoteMessage(RemoteMessage message) async {
    await setupLocalNotificationsOnly();

    final notification = message.notification;
    final title = notification?.title ??
        message.data['title']?.toString() ??
        'Zeengo';
    final body = notification?.body ??
        message.data['body']?.toString() ??
        message.data['message']?.toString() ??
        '';

    if (title.isEmpty && body.isEmpty) return;

    final id = message.hashCode & 0x7fffffff;
    final payload = jsonEncode(message.data);

    await _local.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    final raw = response.payload;
    if (raw == null || raw.isEmpty) return;
    try {
      final data = jsonDecode(raw);
      if (data is Map<String, dynamic>) {
        _handleMessageNavigation(data);
      }
    } catch (e) {
      debugPrint('====> Notification tap payload error: $e');
    }
  }

  void _handleMessageNavigation(Map<String, dynamic> data) {
    debugPrint('====> Notification navigation data: $data');
    // Hook for future deep-links (chat, booking, pay, etc.).
    final route = data['route']?.toString() ?? data['screen']?.toString();
    if (route == null || route.isEmpty) return;
    // Example: Get.toNamed(route);
  }

  Future<void> _persistToken(String? token) async {
    if (token == null || token.isEmpty) return;
    fcmToken.value = token;
    try {
      if (Get.isRegistered<SharedPreferences>()) {
        await Get.find<SharedPreferences>().setString(
          Constants.fcmToken,
          token,
        );
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(Constants.fcmToken, token);
      }
    } catch (e) {
      debugPrint('====> Failed to persist FCM token: $e');
    }
    debugPrint('====> FCM token: $token');
  }

  Future<String?> getToken() => _messaging.getToken();

  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);
}
