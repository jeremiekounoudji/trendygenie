import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/controllers/category_controller.dart';
import 'package:trendygenie/controllers/services_controller.dart';
import 'package:trendygenie/pages/home/widget/food_card2.dart';
import '../../../utils/globalVariable.dart';
import '../category_services_page.dart';
import 'package:shimmer/shimmer.dart';

class ServicesList extends StatefulWidget {
  final String categoryTitle;
  final String categoryId;
  
  const ServicesList({
    Key? key,
    required this.categoryTitle,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  final ServicesController serviceController = Get.find<ServicesController>();
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
      serviceController.fetchServices(null, widget.categoryId, loadMore: true);
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 20,
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: widget.categoryTitle,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              TextButton(
                onPressed: () => Get.to(() => CategoryServicesPage(
                  categoryTitle: widget.categoryTitle,
                  categoryId: widget.categoryId,
                )),
                child: CustomText(
                  text: "See all",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: firstColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 230,
            child: FutureBuilder<bool>(
              future: serviceController.fetchServices(null, widget.categoryId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerLoading();
                }

                if (snapshot.hasError || !snapshot.data!) {
                  return Center(
                    child: CustomText(
                      text: serviceController.error.value,
                      color: redColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }

                return Obx(() {
                  final services = serviceController.servicesMap[widget.categoryId] ?? [];
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

                  return ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: services.length + (serviceController.hasMoreRestaurants.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= services.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return FoodCard2(service: services[index]);
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
