import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();

  static String get baseUrl =>
      dotenv.env['BASE_URL']?.trim() ?? '';

  /// Socket.IO namespace (`/ws`), e.g. `https://host/ws`.
  static String get socketUrl => dotenv.env['SOCKET_URL']?.trim() ?? '';

  static String get googleMapsApiKey =>
      dotenv.env['GOOGLE_MAPS_API_KEY']?.trim() ?? '';

  static String get yandexMapsApiKey =>
      dotenv.env['YANDEX_MAPS_API_KEY']?.trim() ?? '';

  static String get stripePublishableKey =>
      dotenv.env['STRIPE_PUBLISHABLE_KEY']?.trim() ?? '';

  /// Backend endpoint that returns `{ "client_secret": "..." }` for PaymentIntent.
  static String get stripePaymentIntentUrl =>
      dotenv.env['STRIPE_PAYMENT_INTENT_URL']?.trim() ?? '';
}
