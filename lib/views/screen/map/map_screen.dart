import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/map_controller.dart';
import '../../../data/enus.dart';
import '../../../data/models/map/nearby_place.dart';
import '../../../utils/values/air_bnb_style.dart';
import '../../../utils/values/app_palette.dart';
import '../../widgets/custom_header_bar_widget.dart';
import '../../widgets/custom_text_widget.dart';
import '../../widgets/map/map_category_chips.dart';
import '../../widgets/map/map_directions_sheet.dart';
import '../../widgets/map/map_location_header.dart';
import '../../widgets/map/map_place_tile.dart';
import '../../widgets/map/map_provider_switch.dart';

/// Host that only mounts [MapScreen] while the Map tab is visible.
/// Keeps the native Google Maps PlatformView out of the tree on other tabs,
/// which stops Android `FrameEvents / updateAcquireFence` spam.
class MapTabHost extends StatelessWidget {
  const MapTabHost({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return ColoredBox(color: AppPalette.of(context).scaffold);
    }
    return const MapScreen();
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<MapController>()
        ? Get.find<MapController>()
        : Get.put(
            MapController(sharedPreferences: Get.find<SharedPreferences>()),
            permanent: true,
          );
  }

  @override
  void dispose() {
    _controller.onMapDisposed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final mapTopPad = top + 150.h;
    final mapBottomPad = 240.h;

    return Scaffold(
      backgroundColor: AppPalette.of(context).scaffold,
      body: Stack(
        children: [
          GetBuilder<MapController>(
            init: _controller,
            id: MapController.mapLayerId,
            builder: (ctrl) {
              final navigating = ctrl.isNavigating;
              return RepaintBoundary(
                child: GoogleMap(
                  key: const ValueKey('zeengo_google_map'),
                  initialCameraPosition: const CameraPosition(
                    target: MapController.moscowCenter,
                    zoom: 12.2,
                  ),
                  padding: navigating
                      ? EdgeInsets.only(top: top + 56)
                      : EdgeInsets.only(
                          top: mapTopPad,
                          bottom: mapBottomPad,
                        ),
                  style: kAirbnbLikeMapStyle,
                  markers: ctrl.markers,
                  polylines: ctrl.polylines,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  buildingsEnabled: false,
                  trafficEnabled: false,
                  indoorViewEnabled: false,
                  liteModeEnabled: false,
                  onMapCreated: ctrl.onMapCreated,
                ),
              );
            },
          ),
          GetBuilder<MapController>(
            id: MapController.mapUiId,
            builder: (ctrl) {
              if (ctrl.isNavigating) {
                return SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                      child: CustomHeaderBarWidget(
                        onLeadingTap: ctrl.exitNavigation,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                );
              }
              return Stack(
                children: [
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MapProviderSwitch(
                            value: ctrl.provider,
                            onChanged: ctrl.setProvider,
                          ),
                          SizedBox(height: 10.h),
                          MapLocationHeader(
                            city: 'Moscow, Russia',
                            coords: '55.7558°N, 37.6173°E',
                            isDriverActive: true,
                            onOpenYandex: () async {
                              await ctrl.openYandexMapsApp();
                              if (!ctrl.isYandexReady) {
                                Get.snackbar(
                                  Enus.yandexMaps.tr,
                                  Enus.yandexKeyMissing.tr,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _BottomPanel(
                      bottomPad: bottom,
                      controller: ctrl,
                    ),
                  ),
                  if (ctrl.activePlace != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h + bottom),
                        child: MapDirectionsSheet(
                          place: ctrl.activePlace!,
                          etaLabel: ctrl.etaFor(ctrl.activePlace!),
                          distanceLabel:
                              '${ctrl.activePlace!.distanceKm.toStringAsFixed(1)} km',
                          providerLabel:
                              ctrl.provider == MapProviderType.google
                                  ? Enus.googleMaps.tr
                                  : Enus.yandexMaps.tr,
                          onStart: ctrl.beginNavigation,
                          onOpenExternal: () =>
                              ctrl.openExternalMaps(ctrl.activePlace!),
                          onClose: ctrl.clearDirections,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({
    required this.bottomPad,
    required this.controller,
  });

  final double bottomPad;
  final MapController controller;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final places = controller.filteredPlaces;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      height: 0.40.sh,
      margin: EdgeInsets.only(
        bottom: controller.activePlace == null ? 0 : 118.h,
      ),
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h + bottomPad),
      decoration: BoxDecoration(
        color: palette.scaffold,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border(
          top: BorderSide(color: palette.border.withValues(alpha: 0.6)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 28,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: palette.border,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          CustomTextWidget(
            Enus.nearbyPlaces.tr,
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
          SizedBox(height: 12.h),
          MapCategoryChips(
            selected: controller.selectedCategory,
            onChanged: controller.setCategory,
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: places.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 28.sp,
                          color: palette.textSecondary,
                        ),
                        SizedBox(height: 8.h),
                        CustomTextWidget(
                          Enus.noPlacesFound.tr,
                          color: palette.textSecondary,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: places.length,
                    itemBuilder: (_, i) => MapPlaceTile(
                      place: places[i],
                      index: i,
                      onDirections: () =>
                          controller.startDirections(places[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
