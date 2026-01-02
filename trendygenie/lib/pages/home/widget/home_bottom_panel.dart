import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/pages/listing/listing_page.dart';
import 'package:trendygenie/utils/globalVariable.dart';

class HomeBottomPanel extends StatelessWidget {
  final String? currentAddress;
  final bool isLoadingLocation;
  final bool locationPermissionDenied;
  final VoidCallback onRetryLocation;

  const HomeBottomPanel({
    super.key,
    this.currentAddress,
    required this.isLoadingLocation,
    required this.locationPermissionDenied,
    required this.onRetryLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLocationRow(),
          const SizedBox(height: 16),
          _buildPopularServicesHeader(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        Icon(
          locationPermissionDenied ? Icons.location_off : Icons.location_on,
          color: locationPermissionDenied ? Colors.red : Colors.blue,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'Your Location',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
              if (isLoadingLocation)
                Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      text: 'Getting your location...',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]!,
                    ),
                  ],
                )
              else if (locationPermissionDenied)
                GestureDetector(
                  onTap: onRetryLocation,
                  child: CustomText(
                    text: 'Tap to enable location',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: firstColor,
                  ),
                )
              else
                CustomText(
                  text: currentAddress ?? 'Location not available',
                  fontSize: 15,
                  max: 1,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => Get.to(() => ListingPage()),
          style: ElevatedButton.styleFrom(
            backgroundColor: firstColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
          child: CustomText(
            text: 'List Mode',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPopularServicesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: 'Popular Services',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        TextButton(
          onPressed: () {},
          child: CustomText(
            text: 'See All',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: firstColor,
          ),
        ),
      ],
    );
  }
}
