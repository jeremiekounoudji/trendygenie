import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/spacer.dart';
import 'package:trendygenie/controllers/services_controller.dart';
import 'package:trendygenie/controllers/auth_controller.dart';
import 'widgets/service_image_header.dart';
import 'widgets/service_basic_info.dart';
import 'widgets/service_characteristics.dart';
import 'widgets/service_provider_controls.dart';
import 'widgets/service_location_section.dart';
import 'widgets/service_bottom_bar.dart';

class ServiceDetailsPage extends StatefulWidget {
  final ServiceItem service;

  const ServiceDetailsPage({
    super.key,
    required this.service,
  });

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  final ServicesController _servicesController = Get.put(ServicesController());
  final AuthController _authController = Get.find<AuthController>();

  bool get _isProvider {
    final currentUser = _authController.currentUser.value;
    return currentUser != null && 
           (currentUser.userMetadata?['user_type'] == 'provider' || 
            widget.service.providerId == currentUser.id);
  }

  @override
  void initState() {
    super.initState();
    // Increment view count when service details page is opened
    if (widget.service.id != null) {
      _servicesController.incrementViewCount(widget.service.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and top buttons
            ServiceImageHeader(service: widget.service),

            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic service information
                  ServiceBasicInfo(service: widget.service),

                  // Description
                  const Verticalspace(h: 20),
                  CustomText(
                    text: widget.service.description,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[900],
                  ),

                  Divider(height: 48, color: Colors.grey[300]),

                  // Characteristics
                  ServiceCharacteristics(service: widget.service),

                  Divider(height: 48, color: Colors.grey[300]),

                  // Location section
                  ServiceLocationSection(service: widget.service),

                  // Provider Controls (only visible to service owner)
                  if (_isProvider) ...[
                    Divider(height: 48, color: Colors.grey[300]),
                    ServiceProviderControls(
                      service: widget.service,
                      servicesController: _servicesController,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ServiceBottomBar(service: widget.service),
    );
  }
}