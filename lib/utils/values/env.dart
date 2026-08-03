import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();

  static String get googleMapsApiKey =>
      dotenv.env['GOOGLE_MAPS_API_KEY']?.trim() ?? '';

  static String get yandexMapsApiKey =>
      dotenv.env['YANDEX_MAPS_API_KEY']?.trim() ?? '';
}
