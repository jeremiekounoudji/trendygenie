import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/company_controller.dart';
import '../../../../controllers/category_controller.dart';
import '../../../../controllers/business_controller.dart';
import '../../../../utils/globalVariable.dart';
import '../../../../widgets/general_widgets/shimmer.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'create_business_page.dart';
import '../../../../../widgets/business/business_card.dart';
import 'widgets/index.dart';

class BusinessSection extends StatefulWidget {
  const BusinessSection({super.key});

  @override
  State<BusinessSection> createState() => _BusinessSectionState();
}

class _BusinessSectionState extends State<BusinessSection> {
  final CompanyController companyController = Get.find<CompanyController>();
  final CategoryController categoryController = Get.put(CategoryController());
  final BusinessController businessController = Get.put(BusinessController());
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    await businessController.fetchBusinesses();
    await categoryController.fetchCategories();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: firstColor,
        elevation: 0,
        title: CustomText(
          text: 'Business Management',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomPopup(
              barrierColor: Colors.black12,
              backgroundColor: whiteColor,
              arrowColor: whiteColor,
              showArrow: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              contentDecoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              content: Container(
                width: 200,
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFilterOption('All', 'all', Icons.all_inclusive),
                    _buildFilterOption('Active', 'active', Icons.check_circle),
                    _buildFilterOption('Pending', 'pending', Icons.pending),
                    _buildFilterOption('Rejected', 'rejected', Icons.cancel),
                    _buildFilterOption('Suspended', 'suspended', Icons.pause_circle),
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: firstColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.list_outlined, color: whiteColor),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'business_section_fab',
        backgroundColor: firstColor,
        child: Icon(Icons.add, color: whiteColor),
        onPressed: () => Get.to(() => const CreateBusinessPage()),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildBusinessStats(),
              const SizedBox(height: 24),
              _buildBusinessesList(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFilterOption(String label, String status, IconData icon) {
    return Obx(() {
      final isSelected = businessController.selectedStatusFilter.value == status;
      return FilterOption(
        label: label,
        status: status,
        icon: icon,
        isSelected: isSelected,
        onTap: () {
          businessController.selectedStatusFilter.value = status;
          Navigator.pop(context);
        },
      );
    });
  }
  
  Widget _buildHeader() {
    return const BusinessHeader();
  }
  
  Widget _buildBusinessStats() {
    return Obx(() {
      return BusinessStatsGrid(
        isLoading: businessController.isLoading.value,
        stats: businessController.businessStats,
      );
    });
  }
  
  Widget _buildBusinessesList() {
    return Obx(() {
      if (businessController.isLoading.value) {
        return _buildLoadingShimmer();
      }

      final businesses = businessController.filteredBusinesses;
      if (businesses.isEmpty) {
        return Center(
          child: CustomText(
            text: 'No businesses found',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.grey[600]!,
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: businesses.length,
        itemBuilder: (context, index) {
          final business = businesses[index];
          return BusinessCard(
            business: business,
            index: index,
            businessController: businessController,
          );
        },
      );
    });
  }
  
  Widget _buildLoadingShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: LoadingShimmer(
          h: 180,
          w: double.infinity,
        ),
      ),
    );
  }
} 