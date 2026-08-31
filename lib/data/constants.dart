import '../utils/values/env.dart';

class Constants {
  /// API root from `.env` (`BASE_URL`).
  static String get baseUrl => Env.baseUrl;

  /// Socket.IO URL from `.env` (`SOCKET_URL`).
  static String get socketUrl => Env.socketUrl;
  // ── Auth endpoints ────────────────────────────────────────────────────────
  static const String clientLogin = '/auth/client/login';
  static const String refresh = '/auth/refresh';

  // ── Client home ───────────────────────────────────────────────────────────
  static const String clientHome = '/client/home';

  // ── Notifications ─────────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String notificationsReadAll = '/notifications/read-all';

  static String notificationRead(String id) => '/notifications/$id/read';

  // ── SharedPreferences keys ────────────────────────────────────────────────
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String userId = 'userId';
  static const String userFullName = 'userFullName';
  static const String userPhone = 'userPhone';
  static const String userEmail = 'userEmail';
  static const String userPreferredLang = 'userPreferredLang';
  static const String bookingId = 'bookingId';
  static const String znCode = 'znCode';
  static const String bookingStatus = 'bookingStatus';
  static const String firstTimeWalkThrough = 'firstTimeWalkThrough';
  static const String fcmToken = 'fcmToken';
}
