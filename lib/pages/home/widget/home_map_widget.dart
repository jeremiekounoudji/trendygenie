import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trendygenie/utils/globalVariable.dart';

class HomeMapWidget extends StatelessWidget {
  final MapController mapController;
  final double? latitude;
  final double? longitude;
  final bool isLoading;

  const HomeMapWidget({
    super.key,
    required this.mapController,
    this.latitude,
    this.longitude,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    // Show loading placeholder if no location yet
    if (latitude == null || longitude == null) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              CustomText(
                text: 'Loading map...',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]!,
              ),
            ],
          ),
        ),
      );
    }

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(latitude!, longitude!),
        initialZoom: 15.0,
        minZoom: 3.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.trendygenie',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(latitude!, longitude!),
              width: 50,
              height: 50,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 50,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
