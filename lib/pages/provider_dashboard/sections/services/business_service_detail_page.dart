import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/models/business_model.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/utils/currency_helper.dart';
import 'package:trendygenie/controllers/services_controller.dart';
import 'widgets/service_image_carousel.dart';
import 'widgets/service_header_info.dart';
import 'widgets/service_section_card.dart';
import 'widgets/service_features_section.dart';
import 'widgets/service_property_details.dart';
import 'widgets/service_food_details.dart';
import 'widgets/service_action_buttons.dart';

class BusinessServiceDetailPage extends StatefulWidget {
  final ServiceItem service;
  final BusinessModel business;

  const BusinessServiceDetailPage({
    super.key,
    required this.service,
    required this.business,
  });

  @override
  State<BusinessServiceDetailPage> createState() => _BusinessServiceDetailPageState();
}

class _BusinessServiceDetailPageState extends State<BusinessServiceDetailPage> {
  final PageController _pageController = PageController();
  final RxInt _currentPage = 0.obs;
  final ServicesController servicesController = Get.put(ServicesController());
  final RxBool isLoading = false.obs;
  late Rx<ServiceItem> currentService;

  @override
  void initState() {
    super.initState();
    currentService = widget.service.obs;
  }

  void updateService(ServiceItem updatedService) {
    currentService.value = updatedService;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Obx(() => _buildBody()),
    );
  }

  Widget _buildBody() {
    final service = currentService.value;
    
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  ServiceImageCarousel(
                    images: service.images,
                    pageController: _pageController,
                    currentPage: _currentPage,
                  ),
                  _buildNavigationButtons(),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ServiceHeaderInfo(service: service),
                        const SizedBox(height: 20),
                        ServiceFeaturesSection(service: service),
                        ServiceSectionCard(
                          title: 'Description',
                          customColor: Colors.green,
                          children: [
                            CustomText(
                              text: service.description,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: blackColor.withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                        ServiceSectionCard(
                          title: 'Pricing Details',
                          customColor: Colors.orange,
                          children: [
                            _buildPriceRow('Normal Price', CurrencyHelper.formatPrice(service.normalPrice, service.currency)),
                            _buildPriceRow('Promotional Price', CurrencyHelper.formatPrice(service.promotionalPrice, service.currency)),
                          ],
                        ),
                        ServicePropertyDetails(service: service),
                        ServiceFoodDetails(service: service),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ServiceActionButtons(
            service: service,
            business: widget.business,
            servicesController: servicesController,
            isLoading: isLoading,
            onServiceUpdated: updateService,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Positioned.fill(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCircleButton(
                icon: Icons.arrow_back,
                onTap: () => Get.back(),
              ),
              _buildCircleButton(
                icon: Icons.more_horiz,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, color: blackColor, size: 20),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CustomText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
          const Spacer(),
          CustomText(
            text: value,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: firstColor,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
