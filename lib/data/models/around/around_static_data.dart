import 'package:flutter/material.dart';

class AroundPlace {
  const AroundPlace({
    required this.id,
    required this.title,
    required this.description,
    required this.area,
    required this.distanceLabel,
    required this.walkLabel,
    required this.badge,
    required this.section,
    required this.imageUrl,
    required this.lat,
    required this.lng,
    this.category = 'Sight',
    this.openLabel = 'Open all day',
    this.priceLabel = 'Free entry',
    this.arabicDescription,
    this.isFree = true,
  });

  final String id;
  final String title;
  final String description;
  final String area;
  final String distanceLabel;
  final String walkLabel;
  final String badge;
  final String section; // under6 | shortWalk | shortRide
  final String imageUrl;
  final double lat;
  final double lng;
  final String category;
  final String openLabel;
  final String priceLabel;
  final String? arabicDescription;
  final bool isFree;
}

class AroundCategory {
  const AroundCategory({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

class AroundStaticData {
  AroundStaticData._();

  static const redSquareLat = 55.7539;
  static const redSquareLng = 37.6208;

  static const categories = [
    AroundCategory(id: 'food', label: 'Food', icon: Icons.restaurant_outlined),
    AroundCategory(id: 'coffee', label: 'Coffee', icon: Icons.local_cafe_outlined),
    AroundCategory(id: 'shopping', label: 'Shopping', icon: Icons.shopping_bag_outlined),
    AroundCategory(id: 'places', label: 'Places', icon: Icons.place_outlined),
    AroundCategory(id: 'kids', label: 'Kids', icon: Icons.sentiment_satisfied_alt_outlined),
    AroundCategory(id: 'mosque', label: 'Mosque', icon: Icons.mosque),
    AroundCategory(id: 'pharmacy', label: 'Pharmacy', icon: Icons.local_pharmacy_outlined),
    AroundCategory(id: 'supermarket', label: 'Supermarket', icon: Icons.storefront_outlined),
    AroundCategory(id: 'exchange', label: 'Exchange', icon: Icons.currency_exchange_outlined),
    AroundCategory(id: 'metro', label: 'Metro', icon: Icons.subway_outlined),
  ];

  static const places = [
    AroundPlace(
      id: 'red_square',
      title: 'Red Square',
      description: 'The heart of Moscow, where every visit starts.',
      arabicDescription: 'قلب موسكو، حيث تبدأ كل زيارة.',
      area: 'Okhotny Ryad',
      distanceLabel: '0 m away',
      walkLabel: '1 min walk',
      badge: 'Free',
      section: 'under6',
      imageUrl:
          'https://images.unsplash.com/photo-1513326738677-b964603b136d?w=400',
      lat: 55.7539,
      lng: 37.6208,
      isFree: true,
      priceLabel: 'Free entry',
    ),
    AroundPlace(
      id: 'gum',
      title: 'GUM',
      description: 'The most beautiful arcade on the square.',
      area: 'Ploshchad Revolyutsii',
      distanceLabel: '89 m away',
      walkLabel: '2 min walk',
      badge: 'Free',
      section: 'under6',
      imageUrl:
          'https://images.unsplash.com/photo-1547447134-cd3f5c716030?w=400',
      lat: 55.7546,
      lng: 37.6214,
      isFree: true,
    ),
    AroundPlace(
      id: 'st_basil',
      title: "St Basil's Cathedral",
      description: 'The most photographed roofline in Russia.',
      area: 'Kitay-Gorod',
      distanceLabel: '212 m away',
      walkLabel: '4 min walk',
      badge: 'Ticket',
      section: 'under6',
      imageUrl:
          'https://images.unsplash.com/photo-1520106212299-d99c43f456d6?w=400',
      lat: 55.7525,
      lng: 37.6231,
      isFree: false,
      priceLabel: 'Ticketed entry',
    ),
    AroundPlace(
      id: 'kremlin',
      title: 'Moscow Kremlin',
      description: 'Fortress, cathedrals and the Armoury.',
      area: 'Aleksandrovsky Sad',
      distanceLabel: '295 m away',
      walkLabel: '5 min walk',
      badge: 'Ticket',
      section: 'under6',
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      lat: 55.7520,
      lng: 37.6175,
      isFree: false,
      priceLabel: 'Ticketed entry',
    ),
    AroundPlace(
      id: 'nikolskaya',
      title: 'Nikolskaya Street',
      description: 'The lit-up pedestrian street, cafes all day.',
      area: 'Lubyanka',
      distanceLabel: '303 m away',
      walkLabel: '5 min walk',
      badge: 'Free',
      section: 'under6',
      imageUrl:
          'https://images.unsplash.com/photo-1526481280695-3c4694932771?w=400',
      lat: 55.7570,
      lng: 37.6230,
      isFree: true,
    ),
    AroundPlace(
      id: 'metro_ring',
      title: 'Metro ring stations',
      description: 'An underground museum on a normal commute.',
      area: 'Ring line',
      distanceLabel: '304 m away',
      walkLabel: '5 min walk',
      badge: 'Free',
      section: 'under6',
      imageUrl:
          'https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=400',
      lat: 55.7550,
      lng: 37.6180,
      isFree: true,
    ),
    AroundPlace(
      id: 'zaryadye',
      title: 'Zaryadye Park',
      description: 'Floating bridge and the best Kremlin views.',
      area: 'Kitay-Gorod',
      distanceLabel: '606 m away',
      walkLabel: '8 min walk',
      badge: 'Free',
      section: 'shortWalk',
      imageUrl:
          'https://images.unsplash.com/photo-1513889961551-628c1e5e2ee9?w=400',
      lat: 55.7510,
      lng: 37.6280,
      isFree: true,
    ),
    AroundPlace(
      id: 'bolshoi',
      title: 'Bolshoi Theatre',
      description: 'World-famous ballet and opera house.',
      area: 'Teatralnaya',
      distanceLabel: '650 m away',
      walkLabel: '9 min walk',
      badge: 'Ticket',
      section: 'shortWalk',
      imageUrl:
          'https://images.unsplash.com/photo-1503095396549-807759245b35?w=400',
      lat: 55.7594,
      lng: 37.6196,
      isFree: false,
      priceLabel: 'Ticketed entry',
    ),
    AroundPlace(
      id: 'childrens_store',
      title: 'Central Children’s Store',
      description: 'Toys and a rooftop view in the centre.',
      area: 'Lubyanka',
      distanceLabel: '734 m away',
      walkLabel: '10 min walk',
      badge: 'Free',
      section: 'shortRide',
      imageUrl:
          'https://images.unsplash.com/photo-1513889961551-628c1e5e2ee9?w=400',
      lat: 55.7595,
      lng: 37.6260,
      isFree: true,
    ),
    AroundPlace(
      id: 'tretyakov',
      title: 'Tretyakov Gallery',
      description: 'Classic Russian art.',
      area: 'Tretyakovskaya',
      distanceLabel: '1.4 km away',
      walkLabel: '18 min walk',
      badge: 'Ticket',
      section: 'shortRide',
      imageUrl:
          'https://images.unsplash.com/photo-1513326738677-b964603b136d?w=400',
      lat: 55.7415,
      lng: 37.6208,
      isFree: false,
      priceLabel: 'Ticketed entry',
    ),
    AroundPlace(
      id: 'christ_cathedral',
      title: 'Cathedral of Christ the Saviour',
      description: 'The largest cathedral in Russia, free entry.',
      area: 'Kropotkinskaya',
      distanceLabel: '1.4 km away',
      walkLabel: '18 min walk',
      badge: 'Free',
      section: 'shortRide',
      imageUrl:
          'https://images.unsplash.com/photo-1520106212299-d99c43f456d6?w=400',
      lat: 55.7447,
      lng: 37.6055,
      isFree: true,
    ),
    AroundPlace(
      id: 'pushkin',
      title: 'Pushkin Museum',
      description: 'World art next to the cathedral.',
      area: 'Kropotkinskaya',
      distanceLabel: '1.4 km away',
      walkLabel: '18 min walk',
      badge: 'Ticket',
      section: 'shortRide',
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      lat: 55.7473,
      lng: 37.6051,
      isFree: false,
      priceLabel: 'Ticketed entry',
    ),
    AroundPlace(
      id: 'uzbekistan',
      title: 'Restaurant Uzbekistan',
      description: 'Uzbek kitchen, confirm halal when booking.',
      area: 'Tsvetnoy Bulvar',
      distanceLabel: '1.5 km away',
      walkLabel: '20 min walk',
      badge: 'Ticket',
      section: 'shortRide',
      imageUrl:
          'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400',
      lat: 55.7700,
      lng: 37.6200,
      category: 'Food',
      isFree: false,
      priceLabel: 'Reservation',
    ),
    AroundPlace(
      id: 'krasny',
      title: 'Krasny Oktyabr',
      description: 'Old chocolate factory, now cafes and views.',
      area: 'Kropotkinskaya',
      distanceLabel: '1.6 km away',
      walkLabel: '22 min walk',
      badge: 'Free',
      section: 'shortRide',
      imageUrl:
          'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=400',
      lat: 55.7400,
      lng: 37.6100,
      isFree: true,
    ),
    AroundPlace(
      id: 'arbat',
      title: 'Old Arbat',
      description: 'Pedestrian street with souvenirs and street art.',
      area: 'Arbatskaya',
      distanceLabel: '1.8 km away',
      walkLabel: '24 min walk',
      badge: 'Free',
      section: 'shortRide',
      imageUrl:
          'https://images.unsplash.com/photo-1502680390469-be75c86b636f?w=400',
      lat: 55.7520,
      lng: 37.5910,
      isFree: true,
    ),
  ];

  static List<AroundPlace> bySection(String section) =>
      places.where((p) => p.section == section).toList();
}
