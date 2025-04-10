import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/pages/listing/service_details_page.dart';
import 'package:trendygenie/widgets/general_widgets/common_image.dart';
import 'package:trendygenie/widgets/general_widgets/shimmer.dart';

import '../../utils/globalVariable.dart';
import '../../widgets/general_widgets/textfield.dart';
import '../../controllers/services_controller.dart';

class CategoryServicesPage extends StatefulWidget {
  final String categoryTitle;
  final String categoryId;

  const CategoryServicesPage({
    Key? key,
    required this.categoryTitle,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<CategoryServicesPage> createState() => _CategoryServicesPageState();
}

class _CategoryServicesPageState extends State<CategoryServicesPage> {
  final ServicesController servicesController = Get.find<ServicesController>();
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      servicesController.fetchServices(null, widget.categoryId, loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: bgColor,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: blackColor),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      text: widget.categoryTitle,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            CustomTextField(
              controller: searchController,
              hintText: 'Search in ${widget.categoryTitle}',
              prefixIcon: const Icon(Icons.search),
              radius: 12,
              filled: true,
              fillColor: bgColor,
              borderColor: Colors.transparent,
              showLabel: false,
              onChanged: (value) {
                // TODO: Implement search
              },
            ),

            const SizedBox(height: 16),

            // Services Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FutureBuilder<bool>(
                  future: servicesController.fetchServices(null, widget.categoryId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingGrid();
                    }

                    return Obx(() {
                      final services = servicesController.servicesMap[widget.categoryId] ?? [];
                      
                      if (services.isEmpty) {
                        return Center(
                          child: CustomText(
                            text: 'No services found',
                            color: firstColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }

                      return MasonryGridView.count(
                        controller: _scrollController,
                        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        itemCount: services.length + (servicesController.hasMoreRestaurants.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= services.length) {
                            return _buildLoadingItem(index);
                          }
                          return _buildServiceItem(services[index], index);
                        },
                      );
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return MasonryGridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: 6,
      itemBuilder: (context, index) => _buildLoadingItem(index),
    );
  }

  Widget _buildServiceItem(ServiceItem service, int index) {
    double imageHeight = (index % 3 + 1) * 80.0;

    return GestureDetector(
      onTap: () => Get.to(() => ServiceDetailsPage(service: service)),
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: mediumBorder,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonImageWidget(
              isLocalImage: false,
              onlineImagePath: service.image,
              rounded: 16,
              height: imageHeight,
              width: double.infinity,
              loadingWidget: LoadingShimmer(h: imageHeight, w: double.infinity),
              errorWidget: Container(
                color: Colors.grey[300],
                height: imageHeight,
                child: Icon(Icons.error, color: redColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: service.title,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                    max: 2,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: '€${service.price}',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: blackColor.withOpacity(.7),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          CustomText(
                            text: service.rating.toString(),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    
  }

  Widget _buildLoadingItem(int index) {
    double height = (index % 3 + 1) * 80.0 + 80.0;
    return LoadingShimmer(
      h: height,
      w: double.infinity,
    );
  }
} 