import '../utils/values/env.dart';

class Constants {
  /// API root from `.env` (`BASE_URL`), e.g. `…/api/v1`.
  static String get baseUrl => Env.baseUrl;

  /// Socket.IO URL from `.env` (`SOCKET_URL`).
  static String get socketUrl => Env.socketUrl;

  // ═══════════════════════════════════════════════════════════════════════════
  // V1 — existing client / ops APIs (DO NOT change paths; keep for legacy flows)
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Auth endpoints (v1) ───────────────────────────────────────────────────
  static const String clientLogin = '/auth/client/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // ── Client home / ops (v1 booking portal) ────────────────────────────────
  /// Trip summary for booked guest (ZN, balance, today program, tasks, driver).
  static const String clientHome = '/client/home';

  // ── Client ops tasks (v1) ─────────────────────────────────────────────────
  static const String clientTasks = '/client/tasks';
  static String clientTask(String id) => '/client/tasks/$id';

  // ── Client suggestions — booking notes (v1) ───────────────────────────────
  static const String clientSuggestions = '/client/suggestions';

  // ── Notifications (v1) ────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String notificationsReadAll = '/notifications/read-all';

  static String notificationRead(String id) => '/notifications/$id/read';

  // ── Chat (v1) ─────────────────────────────────────────────────────────────
  static const String chatConversations = '/chat/conversations';
  static String chatBookingThread(String bookingId) =>
      '/chat/bookings/$bookingId/thread';
  static String chatMessages(String conversationId) =>
      '/chat/conversations/$conversationId/messages';
  static String chatRead(String conversationId) =>
      '/chat/conversations/$conversationId/read';

  // ═══════════════════════════════════════════════════════════════════════════
  // V2 — aLo discovery app (Home / Around / Explore Russia / My Trip)
  // Base: BASE_URL already includes `/api/v1` → full path `/api/v1/client/v2/…`
  // Public (no JWT required). Does not replace v1 `/client/*`.
  // ═══════════════════════════════════════════════════════════════════════════

  /// Home discovery feed: chips, categories, rails, food, services.
  static const String clientV2Home = '/client/v2/home';

  /// Places list / nearby. Query: `lat`, `lng`, `section`, `category`, `homeRail`.
  static const String clientV2Places = '/client/v2/places';

  /// Single place by slug or id.
  static String clientV2Place(String slugOrId) =>
      '/client/v2/places/$slugOrId';

  /// Explore Russia destinations. Query: `filter` (near_me|today|daylight|family).
  static const String clientV2Destinations = '/client/v2/destinations';

  /// Curated My Trip day timeline + stops (maps-ready coords).
  static const String clientV2Trip = '/client/v2/trip';

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
