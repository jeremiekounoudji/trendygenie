import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:trendygenie/controllers/category_controller.dart';
import 'package:trendygenie/controllers/services_controller.dart';
import 'package:trendygenie/pages/home/widget/restaurant_card.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/pages/listing/listing_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryController categoryController = Get.put(CategoryController());
  final ServicesController servicesController = Get.put(ServicesController());
  final TextEditingController searchController = TextEditingController();
  final double _centerLat = 48.8566;
  final double _centerLng = 2.3522;
  String currentAddress = 'St. Margareth, NY';

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
        OpenStreetMapSearchAndPick(
          buttonColor: firstColor,
          buttonText: 'Set Current Location',
          onPicked: (pickedData) {
            setState(() {
              currentAddress = pickedData.addressName;
            });
          },
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: const [],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 5,
          right: 5,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
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
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Your Location',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                          CustomText(
                            text: currentAddress,
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
                ),
                const SizedBox(height: 16),
                Row(
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
                ),
                const SizedBox(height: 8),
                // SizedBox(
                //   height: 120,
                //   child: Obx(() => ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: servicesController.services.length,
                //     itemBuilder: (context, index) {
                //       return CompanyCard(
                //         company: servicesController.services[index],
                //       );
                //     },
                //   )),
                // ),
              ],
            ),
          ),
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
          // servicesController.fetchServices(null, null),
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
