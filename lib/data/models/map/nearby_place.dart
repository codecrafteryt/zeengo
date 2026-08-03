enum MapProviderType { google, yandex }

enum PlaceCategory { all, mosques, halal, atm, malls }

class NearbyPlace {
  const NearbyPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryLabelKey,
    required this.lat,
    required this.lng,
    required this.distanceKm,
  });

  final String id;
  final String name;
  final PlaceCategory category;
  final String categoryLabelKey;
  final double lat;
  final double lng;
  final double distanceKm;
}
