import '../../../data/enus.dart';
import '../../../data/models/map/nearby_place.dart';

class NearbyPlacesData {
  NearbyPlacesData._();

  static const List<NearbyPlace> moscow = [
    NearbyPlace(
      id: 'mosque_1',
      name: 'Moscow Cathedral Mosque',
      category: PlaceCategory.mosques,
      categoryLabelKey: Enus.catMosque,
      lat: 55.7794,
      lng: 37.6270,
      distanceKm: 2.1,
    ),
    NearbyPlace(
      id: 'mosque_2',
      name: 'Historical Mosque of Moscow',
      category: PlaceCategory.mosques,
      categoryLabelKey: Enus.catMosque,
      lat: 55.7420,
      lng: 37.6230,
      distanceKm: 3.4,
    ),
    NearbyPlace(
      id: 'halal_1',
      name: 'Al-Medina Halal',
      category: PlaceCategory.halal,
      categoryLabelKey: Enus.catHalal,
      lat: 55.7600,
      lng: 37.6100,
      distanceKm: 1.4,
    ),
    NearbyPlace(
      id: 'atm_1',
      name: 'Sberbank ATM',
      category: PlaceCategory.atm,
      categoryLabelKey: Enus.catAtm,
      lat: 55.7510,
      lng: 37.6200,
      distanceKm: 0.8,
    ),
    NearbyPlace(
      id: 'mall_1',
      name: 'GUM Shopping Mall',
      category: PlaceCategory.malls,
      categoryLabelKey: Enus.catMall,
      lat: 55.7546,
      lng: 37.6214,
      distanceKm: 1.1,
    ),
  ];
}
