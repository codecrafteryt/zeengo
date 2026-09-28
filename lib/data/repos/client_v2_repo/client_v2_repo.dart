import 'package:get/get.dart';

import '../../api_provider/api_provider.dart';
import '../../constants.dart';

/// Client discovery APIs under `/client/v2/*` (public).
class ClientV2Repo extends GetxService {
  ClientV2Repo({required this.apiProvider});

  final ApiProvider apiProvider;

  Map<String, String> get _headers => const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Future<Response> fetchHome() =>
      apiProvider.getData(Constants.clientV2Home, headers: _headers);

  Future<Response> fetchPlaces({
    double? lat,
    double? lng,
    String? section,
    String? category,
  }) {
    final q = <String, String>{};
    if (lat != null) q['lat'] = lat.toString();
    if (lng != null) q['lng'] = lng.toString();
    if (section != null && section.isNotEmpty) q['section'] = section;
    if (category != null && category.isNotEmpty) q['category'] = category;
    final qs = q.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    final path =
        qs.isEmpty ? Constants.clientV2Places : '${Constants.clientV2Places}?$qs';
    return apiProvider.getData(path, headers: _headers);
  }

  Future<Response> fetchDestinations({String? filter}) {
    final path = filter == null || filter.isEmpty
        ? Constants.clientV2Destinations
        : '${Constants.clientV2Destinations}?filter=${Uri.encodeQueryComponent(filter)}';
    return apiProvider.getData(path, headers: _headers);
  }

  Future<Response> fetchTrip() =>
      apiProvider.getData(Constants.clientV2Trip, headers: _headers);
}
