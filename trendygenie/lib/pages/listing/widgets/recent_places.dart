import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../controllers/recent_places_controller.dart';
import '../../../models/business_model.dart';
import '../../../utils/globalVariable.dart';
import '../../../widgets/general_widgets/common_image.dart';
import '../../../widgets/general_widgets/shimmer.dart';
import '../company_services_page.dart';
import '../see_all_selected_category_companies.dart';

class RecentPlaces extends StatefulWidget {
  const RecentPlaces({super.key});

  @override
  State<RecentPlaces> createState() => _RecentPlacesState();
}

class _RecentPlacesState extends State<RecentPlaces> {
  final RecentPlacesController controller = Get.put(RecentPlacesController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      controller.fetchRecentHotels(loadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  double getImageHeight(int index) => (index % 3 + 1) * 80.0;
  double getContainerHeight(int index) => getImageHeight(index) + 80.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Recent Hotels',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              TextButton(
                onPressed: () => Get.to(() => SeeAllSelectedCategoryCompanies(
                      categoryTitle: "Recent Hotels",
                      businesses: controller.businesses,
                      isLoading: controller.isLoading.value,
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
          Obx(() {
            if (controller.isLoading.value && controller.businesses.isEmpty) {
              return _buildLoadingGrid();
            }
            
            return MasonryGridView.count(
              shrinkWrap: true,
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.businesses.take(5).length,
              itemBuilder: (context, index) {
                final business = controller.businesses[index];
                final imageHeight = getImageHeight(index);
                final containerHeight = getContainerHeight(index);

                return _buildBusinessCard(business, imageHeight, containerHeight);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return MasonryGridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return LoadingShimmer(
          h: getContainerHeight(index),
          w: double.infinity,
        );
      },
    );
  }

  Widget _buildBusinessCard(BusinessModel business, double imageHeight, double containerHeight) {
    return InkWell(
      onTap: () => Get.to(() => CompanyServicesPage(
        companyId: business.companyId, 
        categoryName: business.category?.name ?? "", 
        companyName: business.name,
        business: business, // Pass the business data
      )),
      child: Container(
        height: containerHeight,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImageWidget(
              isLocalImage: false,
              onlineImagePath: business.logoUrl ?? '',
              rounded: 16,
              height: imageHeight,
              width: double.infinity,
              loadingWidget: LoadingShimmer(h: imageHeight, w: double.infinity),
              errorWidget: Container(
                color: Colors.grey[300],
                height: imageHeight,
                child: const Icon(Icons.error, color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: business.name,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    align: TextAlign.left,
                    max: 2,
                    color: blackColor,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: business.address,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: blackColor.withOpacity(.5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          CustomText(
                            text: business.rating.toString(),
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
} 