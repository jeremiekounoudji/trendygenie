import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  // Observable variables
  final isLoadingLocation = true.obs;
  final locationPermissionDenied = false.obs;
  final currentLatitude = Rx<double?>(null);
  final currentLongitude = Rx<double?>(null);
  final currentAddress = Rx<String?>(null);
  final errorMessage = ''.obs;

  // Getters for convenience
  bool get hasLocation => currentLatitude.value != null && currentLongitude.value != null;
  String get locationString => hasLocation 
      ? '${currentLatitude.value!.toStringAsFixed(4)}, ${currentLongitude.value!.toStringAsFixed(4)}'
      : 'Location not available';

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      log('Error checking location service: $e');
      return false;
    }
  }

  /// Open device location settings
  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      log('Error opening location settings: $e');
    }
  }

  /// Open app settings for location permission
  Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
    } catch (e) {
      log('Error opening app settings: $e');
    }
  }

  /// Check current location permission status
  Future<LocationPermission> checkPermission() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      log('Error checking permission: $e');
      return LocationPermission.denied;
    }
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    try {
      return await Geolocator.requestPermission();
    } catch (e) {
      log('Error requesting permission: $e');
      return LocationPermission.denied;
    }
  }

  /// Get current GPS position
  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      log('Error getting current position: $e');
      return null;
    }
  }

  /// Main method to get current location with full permission handling
  Future<void> getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      locationPermissionDenied.value = false;
      errorMessage.value = '';

      // Step 1: Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('Location services are disabled, opening settings...');
        await openLocationSettings();
        isLoadingLocation.value = false;
        errorMessage.value = 'Location services disabled';
        return;
      }

      // Step 2: Check location permission
      LocationPermission permission = await checkPermission();
      log('Current permission status: $permission');

      if (permission == LocationPermission.denied) {
        log('Requesting location permission...');
        permission = await requestPermission();
        log('Permission after request: $permission');

        if (permission == LocationPermission.denied) {
          log('Location permission denied');
          isLoadingLocation.value = false;
          locationPermissionDenied.value = true;
          errorMessage.value = 'Location permission denied';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('Location permission permanently denied, opening app settings...');
        await openAppSettings();
        isLoadingLocation.value = false;
        locationPermissionDenied.value = true;
        errorMessage.value = 'Location permission permanently denied';
        return;
      }

      // Step 3: Get current position
      log('Getting current position...');
      Position? position = await getCurrentPosition();

      if (position != null) {
        log('Got location: ${position.latitude}, ${position.longitude}');
        
        currentLatitude.value = position.latitude;
        currentLongitude.value = position.longitude;
        currentAddress.value = locationString;
        locationPermissionDenied.value = false;
        errorMessage.value = '';
      } else {
        errorMessage.value = 'Could not get location';
      }
    } catch (e) {
      log('Error in getCurrentLocation: $e');
      errorMessage.value = 'Error getting location: $e';
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Retry getting location (useful for manual refresh)
  Future<void> retryLocation() async {
    await getCurrentLocation();
  }

  /// Clear location data
  void clearLocation() {
    currentLatitude.value = null;
    currentLongitude.value = null;
    currentAddress.value = null;
    locationPermissionDenied.value = false;
    errorMessage.value = '';
  }

  /// Update location when app resumes from settings
  void onAppResumed() {
    if (locationPermissionDenied.value || !hasLocation) {
      getCurrentLocation();
    }
  }
}