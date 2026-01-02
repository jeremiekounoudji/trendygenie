import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/service_item.dart';
import '../../../utils/globalVariable.dart';

class ServiceImageHeader extends StatelessWidget {
  final ServiceItem service;

  const ServiceImageHeader({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: _buildServiceImage(),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: whiteColor,
                  radius: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: blackColor, size: 20),
                    onPressed: () => Get.back(),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: whiteColor,
                  radius: 20,
                  child: IconButton(
                    icon: Icon(Icons.favorite_border_outlined,
                        color: blackColor, size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceImage() {
    if (service.images.isEmpty) {
      return _buildPlaceholderImage();
    }

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey[300],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          service.images.first,
          height: 400,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('Image loading error: $error');
            return _buildPlaceholderImage();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, 
               color: Colors.grey[600], size: 64),
          const SizedBox(height: 8),
          Text('Image not available', 
               style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}