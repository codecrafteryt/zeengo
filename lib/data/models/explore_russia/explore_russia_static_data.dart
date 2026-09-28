class ExploreRussiaPlace {
  const ExploreRussiaPlace({
    required this.id,
    required this.title,
    required this.tags,
    this.imageUrl,
    this.usePlaceholder = false,
    this.nearMe = false,
    this.today = false,
    this.daylight = false,
  });

  final String id;
  final String title;
  final List<String> tags;
  final String? imageUrl;
  final bool usePlaceholder;
  final bool nearMe;
  final bool today;
  final bool daylight;

  String get tagsLabel => tags.join(' · ');

  bool get isFamily => tags.contains('Family');
  bool get isOutside => tags.contains('Outside');

  bool matchesFilter(String? filterId) {
    if (filterId == null || filterId.isEmpty) return true;
    switch (filterId) {
      case 'near_me':
        return nearMe;
      case 'today':
        return today;
      case 'daylight':
        return daylight || isOutside;
      case 'family':
        return isFamily;
      default:
        return tags.any((t) => t.toLowerCase() == filterId.toLowerCase());
    }
  }
}

class ExploreRussiaFilter {
  const ExploreRussiaFilter({
    required this.id,
    required this.label,
    this.statusTitle,
  });

  final String id;
  final String label;
  final String? statusTitle;
}

class ExploreRussiaStaticData {
  ExploreRussiaStaticData._();

  static const filters = [
    ExploreRussiaFilter(
      id: 'near_me',
      label: 'Near me',
      statusTitle: 'Nearby',
    ),
    ExploreRussiaFilter(
      id: 'today',
      label: 'Today',
      statusTitle: 'Open today',
    ),
    ExploreRussiaFilter(
      id: 'daylight',
      label: 'In daylight',
      statusTitle: 'Best in daylight',
    ),
    ExploreRussiaFilter(
      id: 'family',
      label: 'Family',
      statusTitle: 'With kids',
    ),
  ];

  static const places = [
    ExploreRussiaPlace(
      id: 'nikulin',
      title: 'Nikulin Circus',
      tags: ['Family'],
      usePlaceholder: true,
      nearMe: true,
      today: true,
    ),
    ExploreRussiaPlace(
      id: 'dream_island',
      title: 'Dream Island Park',
      tags: ['Family', 'Outside'],
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600',
      nearMe: false,
      today: true,
      daylight: true,
    ),
    ExploreRussiaPlace(
      id: 'dolphinarium',
      title: 'Moscow Dolphinarium',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=600',
      nearMe: true,
      today: true,
    ),
    ExploreRussiaPlace(
      id: 'bear_park',
      title: 'Bear Sanctuary',
      tags: ['Family', 'Outside'],
      imageUrl:
          'https://images.unsplash.com/photo-1525382455947-f319bc05fb35?w=600',
      daylight: true,
      today: true,
    ),
    ExploreRussiaPlace(
      id: 'tiger_park',
      title: 'Tiger Park',
      tags: ['Family', 'Outside'],
      imageUrl:
          'https://images.unsplash.com/photo-1561731216-c3c7aac53d54?w=600',
      daylight: true,
      today: true,
    ),
    ExploreRussiaPlace(
      id: 'husky_park',
      title: 'Husky Park',
      tags: ['Family', 'Outside'],
      imageUrl:
          'https://images.unsplash.com/photo-1547407139-3c921a66005c?w=600',
      daylight: true,
      today: false,
    ),
    ExploreRussiaPlace(
      id: 'zaryadye_flight',
      title: 'Zaryadye Flight',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1513889961551-628c1e5e2ee9?w=600',
      nearMe: true,
      today: true,
      daylight: true,
    ),
    ExploreRussiaPlace(
      id: 'zaryadye_ice',
      title: 'Zaryadye Ice Cave',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1483664852095-d6cc68707026?w=600',
      nearMe: true,
      today: true,
    ),
    ExploreRussiaPlace(
      id: 'cosmonautics',
      title: 'Cosmonautics Museum',
      tags: ['Family'],
      usePlaceholder: true,
      today: true,
      daylight: true,
    ),
    ExploreRussiaPlace(
      id: 'planetarium',
      title: 'Moscow Planetarium',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=600',
      today: true,
      nearMe: true,
    ),
    ExploreRussiaPlace(
      id: 'zoo',
      title: 'Moscow Zoo',
      tags: ['Family', 'Outside'],
      imageUrl:
          'https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=600',
      nearMe: true,
      today: true,
      daylight: true,
    ),
    ExploreRussiaPlace(
      id: 'moskvarium',
      title: 'Moskvarium',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1544551763-77ef2d0cfc6c?w=600',
      today: true,
      daylight: true,
    ),
    ExploreRussiaPlace(
      id: 'nikulin_tsvetnoy',
      title: 'Nikulin Circus Tsvetnoy',
      tags: ['Family'],
      usePlaceholder: true,
      nearMe: true,
      today: true,
    ),
    ExploreRussiaPlace(
      id: 'puppet',
      title: 'Puppet Theatre',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=600',
      today: false,
      nearMe: true,
    ),
    ExploreRussiaPlace(
      id: 'durov',
      title: 'Durov Animal Theatre',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1503095396549-807759245b35?w=600',
      today: true,
      nearMe: true,
    ),
    ExploreRussiaPlace(
      id: 'cosmos_pavilion',
      title: 'Cosmos Pavilion',
      tags: ['Family'],
      usePlaceholder: true,
      daylight: true,
      today: true,
    ),
    ExploreRussiaPlace(
      id: 'robostation',
      title: 'Robostation',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=600',
      today: true,
    ),
    ExploreRussiaPlace(
      id: 'smile_park',
      title: 'Smile Park',
      tags: ['Family', 'Outside'],
      imageUrl:
          'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=600',
      daylight: true,
      today: true,
    ),
    ExploreRussiaPlace(
      id: 'escape_quest',
      title: 'Escape Quest',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=600',
      today: true,
      nearMe: true,
    ),
    ExploreRussiaPlace(
      id: 'crocus',
      title: 'Crocus Oceanarium',
      tags: ['Family', 'Outside'],
      imageUrl:
          'https://images.unsplash.com/photo-1583212292454-1fe6229603b7?w=600',
      daylight: true,
      today: true,
    ),
    ExploreRussiaPlace(
      id: 'paleontology',
      title: 'Paleontology Museum',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600',
      today: true,
      daylight: true,
    ),
    ExploreRussiaPlace(
      id: 'ice_show',
      title: 'Ice Show',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=600',
      today: true,
      nearMe: false,
    ),
    ExploreRussiaPlace(
      id: 'anvio_vr',
      title: 'Anvio VR',
      tags: ['Family'],
      imageUrl:
          'https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac?w=600',
      today: true,
      nearMe: true,
    ),
    ExploreRussiaPlace(
      id: 'patriot',
      title: 'Patriot Park',
      tags: ['Family', 'Outside'],
      imageUrl:
          'https://images.unsplash.com/photo-1513326738677-b964603b136d?w=600',
      daylight: true,
      today: true,
    ),
  ];
}
