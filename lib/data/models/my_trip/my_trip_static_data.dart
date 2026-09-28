class TripStop {
  const TripStop({
    required this.title,
    this.subtitle,
    this.lat,
    this.lng,
  });

  final String title;
  final String? subtitle;
  final double? lat;
  final double? lng;

  factory TripStop.fromJson(Map<String, dynamic> json) {
    double? asDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return TripStop(
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      lat: asDouble(json['lat']),
      lng: asDouble(json['lng']),
    );
  }
}

class TripDay {
  const TripDay({
    required this.dayNumber,
    required this.title,
    required this.mosqueKm,
    required this.stops,
  });

  final int dayNumber;
  final String title;
  final double mosqueKm;
  final List<TripStop> stops;

  int get stopCount => stops.length;

  String get mosqueLabel =>
      'MOSQUE ${mosqueKm.toStringAsFixed(mosqueKm == mosqueKm.roundToDouble() ? 1 : 1)} KM';

  String get mosqueShortLabel => '${mosqueKm.toStringAsFixed(1)} km';

  factory TripDay.fromJson(Map<String, dynamic> json) {
    final rawStops = json['stops'];
    final stops = rawStops is List
        ? rawStops
            .whereType<Map>()
            .map((e) => TripStop.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <TripStop>[];
    final mosque = json['mosqueKm'];
    return TripDay(
      dayNumber: (json['dayNumber'] is num)
          ? (json['dayNumber'] as num).toInt()
          : int.tryParse(json['dayNumber']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      mosqueKm: mosque is num
          ? mosque.toDouble()
          : double.tryParse(mosque?.toString() ?? '') ?? 0,
      stops: stops,
    );
  }
}

class MyTripStaticData {
  MyTripStaticData._();

  static const tripDaysCount = 3;
  static const subtitle = 'Kids, food and the nearest mosque for every day.';

  static const days = [
    TripDay(
      dayNumber: 1,
      title: 'The heart of Moscow',
      mosqueKm: 1.0,
      stops: [
        TripStop(
          title: 'Nikulin Circus',
          subtitle: 'Tsvetnoy Boulevard',
          lat: 55.7705,
          lng: 37.6200,
        ),
        TripStop(
          title: 'GUM Ice Rink',
          subtitle: 'Red Square',
          lat: 55.7546,
          lng: 37.6214,
        ),
        TripStop(
          title: 'Central Children’s Store',
          subtitle: 'Lubyanka',
          lat: 55.7595,
          lng: 37.6260,
        ),
        TripStop(
          title: 'Red Square',
          subtitle: 'Okhotny Ryad',
          lat: 55.7539,
          lng: 37.6208,
        ),
      ],
    ),
    TripDay(
      dayNumber: 2,
      title: 'VDNKh with the family',
      mosqueKm: 3.1,
      stops: [
        TripStop(
          title: 'Moskvarium',
          subtitle: 'VDNKh',
          lat: 55.8320,
          lng: 37.6290,
        ),
        TripStop(
          title: 'Sun of Moscow wheel',
          subtitle: 'VDNKh',
          lat: 55.8300,
          lng: 37.6310,
        ),
        TripStop(
          title: 'VDNKh park',
          subtitle: 'VDNKh',
          lat: 55.8260,
          lng: 37.6370,
        ),
        TripStop(
          title: 'Uryuk',
          subtitle: 'Uzbek kitchen',
          lat: 55.8280,
          lng: 37.6350,
        ),
      ],
    ),
    TripDay(
      dayNumber: 3,
      title: 'Moscow City and Victory Park',
      mosqueKm: 3.7,
      stops: [
        TripStop(
          title: 'Panorama360',
          subtitle: 'Federation Tower',
          lat: 55.7494,
          lng: 37.5370,
        ),
        TripStop(
          title: 'Afimall City',
          subtitle: 'Moscow City',
          lat: 55.7490,
          lng: 37.5390,
        ),
        TripStop(
          title: 'Victory Park',
          subtitle: 'Poklonnaya Hill',
          lat: 55.7310,
          lng: 37.5050,
        ),
        TripStop(
          title: 'Dagestanskaya Lavka',
          subtitle: 'Dagestani food',
          lat: 55.7400,
          lng: 37.5200,
        ),
      ],
    ),
  ];
}
