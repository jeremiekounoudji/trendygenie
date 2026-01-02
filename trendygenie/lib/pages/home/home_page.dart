import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:trendygenie/controllers/category_controller.dart';
import 'package:trendygenie/controllers/location_controller.dart';
import 'package:trendygenie/controllers/services_controller.dart';
import 'package:trendygenie/pages/home/widget/home_bottom_panel.dart';
import 'package:trendygenie/pages/home/widget/home_map_widget.dart';
import 'package:trendygenie/pages/home/widget/location_refresh_button.dart';
import 'package:trendygenie/utils/globalVariable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final CategoryController categoryController = Get.put(CategoryController());
  final ServicesController servicesController = Get.put(ServicesController());
  final LocationController locationController = Get.put(LocationController());
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Listen to location changes to update map
    ever(locationController.currentLatitude, (_) => _updateMapLocation());
    ever(locationController.currentLongitude, (_) => _updateMapLocation());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When app resumes from settings, retry getting location
    if (state == AppLifecycleState.resumed) {
      locationController.onAppResumed();
    }
  }

  void _updateMapLocation() {
    if (locationController.hasLocation) {
      _mapController.move(
        LatLng(
          locationController.currentLatitude.value!,
          locationController.currentLongitude.value!,
        ),
        15.0,
      );
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: categoryController.error.value,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: redColor,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => categoryController.fetchCategories(),
            icon: const Icon(Icons.refresh),
            label: CustomText(
              text: 'Retry',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: whiteColor,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: firstColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          CustomText(
            text: 'Loading...',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        // Map - always visible
        Obx(() => HomeMapWidget(
          mapController: _mapController,
          latitude: locationController.currentLatitude.value,
          longitude: locationController.currentLongitude.value,
          isLoading: locationController.isLoadingLocation.value,
        )),

        // Refresh location button
        Positioned(
          top: 50,
          right: 16,
          child: SafeArea(
            child: Obx(() => LocationRefreshButton(
              isLoading: locationController.isLoadingLocation.value,
              onPressed: locationController.retryLocation,
            )),
          ),
        ),

        // Bottom panel
        Positioned(
          bottom: 0,
          left: 5,
          right: 5,
          child: Obx(() => HomeBottomPanel(
            currentAddress: locationController.currentAddress.value,
            isLoadingLocation: locationController.isLoadingLocation.value,
            locationPermissionDenied: locationController.locationPermissionDenied.value,
            onRetryLocation: locationController.retryLocation,
          )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<bool>>(
        future: Future.wait([
          categoryController.fetchCategories(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasError || snapshot.data?.contains(false) == true) {
            return _buildErrorState();
          }

          return _buildHomeContent();
        },
      ),
    );
  }
}