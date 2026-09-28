import 'package:flutter/material.dart';

enum AloPlannerTab { move, stay, doActivity }

class AloCategoryItem {
  const AloCategoryItem({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

class AloPlaceCard {
  const AloPlaceCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.badge,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final String? badge;
}

class AloFoodCard {
  const AloFoodCard({
    required this.title,
    required this.description,
    required this.location,
    this.halalFriendly = false,
  });

  final String title;
  final String description;
  final String location;
  final bool halalFriendly;
}

class AloSuitCard {
  const AloSuitCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.highlighted = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool highlighted;
}

class AloTimelineItem {
  const AloTimelineItem({
    required this.time,
    required this.status,
    required this.title,
    required this.subtitle,
    this.isNow = false,
  });

  final String time;
  final String status;
  final String title;
  final String subtitle;
  final bool isNow;
}

class AloServiceTile {
  const AloServiceTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class AloFxRate {
  const AloFxRate({
    required this.flag,
    required this.code,
    required this.rateLabel,
    required this.deltaLabel,
    this.down = true,
  });

  final String flag;
  final String code;
  final String rateLabel;
  final String deltaLabel;
  final bool down;
}

/// Static prototype content for aLo Home (screenshots).
class AloHomeStaticData {
  AloHomeStaticData._();

  static const quickChips = [
    'Halal food near me',
    'Red Square',
    'Car with driver',
    'What can I do today?',
    'Train to St Petersburg',
  ];

  static const categories = [
    AloCategoryItem(label: 'Stays', icon: Icons.hotel_outlined),
    AloCategoryItem(label: 'Car & driver', icon: Icons.directions_car_outlined),
    AloCategoryItem(label: 'Places', icon: Icons.place_outlined),
    AloCategoryItem(label: 'Food', icon: Icons.restaurant_outlined),
    AloCategoryItem(label: 'Experience', icon: Icons.confirmation_number_outlined),
    AloCategoryItem(label: 'Tours', icon: Icons.tour_outlined),
    AloCategoryItem(label: 'Trains', icon: Icons.train_outlined),
  ];

  static const filters = [
    'Near me',
    'Today',
    'In daylight',
    'Family',
    'Halal-friendly',
    'Best views',
    'Winter',
    'Kids',
  ];

  static const trustBadges = [
    (Icons.verified_user_outlined, 'Team inside Russia'),
    (Icons.chat_bubble_outline, 'Arabic support'),
  ];

  static const timeline = [
    AloTimelineItem(
      time: '13:00',
      status: 'NOW',
      title: 'River Cruise',
      subtitle: 'Moscow River sightseeing',
      isNow: true,
    ),
    AloTimelineItem(
      time: '15:50',
      status: 'AFTER THAT',
      title: 'Nikulin Circus',
      subtitle: 'Classic circus show',
    ),
    AloTimelineItem(
      time: '19:30',
      status: 'THIS EVENING',
      title: 'Moscow Cable Car',
      subtitle: 'Sparrow Hills ride',
    ),
  ];

  static const moscowNow = [
    AloPlaceCard(
      title: 'Tretyakov Gallery',
      subtitle: 'Culture · Inside Moscow',
      imageUrl:
          'https://images.unsplash.com/photo-1513326738677-b964603b136d?w=400',
    ),
    AloPlaceCard(
      title: 'St Basil Cathedral',
      subtitle: 'Culture · Red Square',
      imageUrl:
          'https://images.unsplash.com/photo-1520106212299-d99c43f456d6?w=400',
      badge: '-20%',
    ),
  ];

  static const suitYou = [
    AloSuitCard(
      title: 'First time in Moscow',
      subtitle: 'The essentials, in order',
      icon: Icons.star_outline,
    ),
    AloSuitCard(
      title: 'Rainy day',
      subtitle: 'Indoor picks that still feel special',
      icon: Icons.cloud_outlined,
      highlighted: true,
    ),
    AloSuitCard(
      title: 'Honeymoon',
      subtitle: 'Views, dinner and quiet evenings',
      icon: Icons.favorite_outline,
    ),
    AloSuitCard(
      title: 'With family',
      subtitle: 'Parks, animals and easy pacing',
      icon: Icons.groups_outlined,
    ),
  ];

  static const closeToCentre = [
    AloPlaceCard(
      title: 'Moscow Cable Car',
      subtitle: 'Views',
      imageUrl:
          'https://images.unsplash.com/photo-1547447134-cd3f5c716030?w=400',
    ),
    AloPlaceCard(
      title: 'Sun of Moscow Wheel',
      subtitle: 'Views',
      imageUrl:
          'https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=400',
    ),
    AloPlaceCard(
      title: 'Bolshoi Theatre',
      subtitle: 'Culture',
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    ),
  ];

  static const firstTime = [
    AloPlaceCard(
      title: 'River Cruise',
      subtitle: 'Tours',
      imageUrl:
          'https://images.unsplash.com/photo-1526481280695-3c4694932771?w=400',
    ),
    AloPlaceCard(
      title: 'Helicopter Tour',
      subtitle: 'Views · Outside',
      imageUrl:
          'https://images.unsplash.com/photo-1474302770737-173ee21bab63?w=400',
    ),
  ];

  static const food = [
    AloFoodCard(
      title: 'Uzbekistan',
      description: 'Uzbek classic, open since the 1950s',
      location: 'Neglinnaya · Centre',
      halalFriendly: true,
    ),
    AloFoodCard(
      title: 'Chaihona No.1',
      description: 'Plov, lagman and many branches',
      location: 'Citywide',
      halalFriendly: true,
    ),
  ];

  static const withKids = [
    AloPlaceCard(
      title: 'Nikulin Circus',
      subtitle: 'Family',
      imageUrl:
          'https://images.unsplash.com/photo-1503095396549-807759245b35?w=400',
    ),
    AloPlaceCard(
      title: 'Dream Island Park',
      subtitle: 'Family',
      imageUrl:
          'https://images.unsplash.com/photo-1513889961551-628c1e5e2ee9?w=400',
    ),
    AloPlaceCard(
      title: 'Dolphinarium',
      subtitle: 'Family',
      imageUrl:
          'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400',
    ),
  ];

  static const outOfCity = [
    AloPlaceCard(
      title: 'Flyboard',
      subtitle: 'Water · Outside',
      imageUrl:
          'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=400',
    ),
    AloPlaceCard(
      title: 'Jet Ski',
      subtitle: 'Water · Outside',
      imageUrl:
          'https://images.unsplash.com/photo-1502680390469-be75c86b636f?w=400',
    ),
  ];

  static const services = [
    AloServiceTile(
      title: 'Things to do',
      subtitle: '118 experiences',
      icon: Icons.auto_awesome_outlined,
    ),
    AloServiceTile(
      title: 'Hotels',
      subtitle: '149 hotels',
      icon: Icons.hotel_outlined,
    ),
    AloServiceTile(
      title: 'Cars & drivers',
      subtitle: '11 classes with driver',
      icon: Icons.directions_car_outlined,
    ),
    AloServiceTile(
      title: 'Guide service',
      subtitle: '12 Arabic guides',
      icon: Icons.person_pin_circle_outlined,
    ),
    AloServiceTile(
      title: 'Money now',
      subtitle: 'Live ₽ rates & paying',
      icon: Icons.payments_outlined,
    ),
    AloServiceTile(
      title: 'Happening now',
      subtitle: '50 live updates',
      icon: Icons.notifications_none_outlined,
    ),
  ];

  static const fxRates = [
    AloFxRate(
      flag: '🇸🇦',
      code: '1 SAR',
      rateLabel: '22.45 ₽',
      deltaLabel: '0.37%',
    ),
    AloFxRate(
      flag: '🇦🇪',
      code: '1 AED',
      rateLabel: '22.98 ₽',
      deltaLabel: '0.21%',
    ),
    AloFxRate(
      flag: '🇶🇦',
      code: '1 QAR',
      rateLabel: '23.12 ₽',
      deltaLabel: '0.18%',
    ),
  ];
}
