import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/selected_category_controller.dart';
import '../../models/company_model.dart';
import '../../utils/globalVariable.dart';
import '../../widgets/general_widgets/shimmer.dart';
import '../../widgets/general_widgets/textfield.dart';
import '../home/widget/restaurant_card.dart';

class SeeAllSelectedCategoryCompanies extends StatefulWidget {
  final String categoryTitle;

  const SeeAllSelectedCategoryCompanies({
    Key? key,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  State<SeeAllSelectedCategoryCompanies> createState() => _SeeAllSelectedCategoryCompaniesState();
}

class _SeeAllSelectedCategoryCompaniesState extends State<SeeAllSelectedCategoryCompanies> {
  late final SelectedCategoryController controller;
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(SelectedCategoryController(categoryName: widget.categoryTitle));
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      controller.fetchCompanies(loadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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
                  SizedBox(width: 16),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomTextField(
                controller: searchController,
                hintText: 'Search in ${widget.categoryTitle}',
                prefixIcon: Icon(Icons.search),
                radius: 12,
                filled: true,
                fillColor: bgColor,
                borderColor: Colors.transparent,
                showLabel: false,
                onChanged: (value) {
                  controller.searchCompanies(value!);
                },
              ),
            ),

            SizedBox(height: 16),

            // Companies List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  if (controller.isLoading.value && controller.companies.isEmpty) {
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: LoadingShimmer(
                          h: 100,
                          w: double.infinity,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: controller.companies.length + (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.companies.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CompanyCard(company: controller.companies[index]),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}