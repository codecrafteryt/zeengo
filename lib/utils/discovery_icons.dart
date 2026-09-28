import 'package:flutter/material.dart';

IconData discoveryIcon(String? key, [IconData fallback = Icons.place_outlined]) {
  switch (key) {
    case 'hotel_outlined':
      return Icons.hotel_outlined;
    case 'directions_car_outlined':
      return Icons.directions_car_outlined;
    case 'place_outlined':
      return Icons.place_outlined;
    case 'restaurant_outlined':
      return Icons.restaurant_outlined;
    case 'confirmation_number_outlined':
      return Icons.confirmation_number_outlined;
    case 'tour_outlined':
      return Icons.tour_outlined;
    case 'train_outlined':
      return Icons.train_outlined;
    case 'star_outline':
      return Icons.star_outline;
    case 'cloud_outlined':
      return Icons.cloud_outlined;
    case 'favorite_outline':
      return Icons.favorite_outline;
    case 'groups_outlined':
      return Icons.groups_outlined;
    case 'auto_awesome_outlined':
      return Icons.auto_awesome_outlined;
    case 'person_pin_circle_outlined':
      return Icons.person_pin_circle_outlined;
    case 'payments_outlined':
      return Icons.payments_outlined;
    case 'notifications_none_outlined':
      return Icons.notifications_none_outlined;
    case 'local_cafe_outlined':
      return Icons.local_cafe_outlined;
    case 'shopping_bag_outlined':
      return Icons.shopping_bag_outlined;
    case 'sentiment_satisfied_alt_outlined':
      return Icons.sentiment_satisfied_alt_outlined;
    case 'mosque':
      return Icons.mosque;
    case 'local_pharmacy_outlined':
      return Icons.local_pharmacy_outlined;
    case 'storefront_outlined':
      return Icons.storefront_outlined;
    case 'currency_exchange_outlined':
      return Icons.currency_exchange_outlined;
    case 'subway_outlined':
      return Icons.subway_outlined;
    default:
      return fallback;
  }
}

Map<String, dynamic>? unwrapClientV2Data(dynamic body) {
  if (body is! Map) return null;
  final map = Map<String, dynamic>.from(body);
  if (map['success'] == true && map['data'] is Map) {
    return Map<String, dynamic>.from(map['data'] as Map);
  }
  return null;
}
