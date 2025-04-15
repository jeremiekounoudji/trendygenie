import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/company_controller.dart';
import '../../../controllers/category_controller.dart';
import '../../../models/company_model.dart';
import '../../../utils/globalVariable.dart';
import '../../../widgets/general_widgets/common_button.dart';
import '../../../widgets/general_widgets/shimmer.dart';

class BusinessSection extends StatefulWidget {
  const BusinessSection({Key? key}) : super(key: key);

  @override
  State<BusinessSection> createState() => _BusinessSectionState();
}

class _BusinessSectionState extends State<BusinessSection> {
  final CompanyController companyController = Get.find<CompanyController>();
  final CategoryController categoryController = Get.put(CategoryController());
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final userId = companyController.supabase.auth.currentUser!.id;
    await companyController.getCompanyByOwner(userId);
    await categoryController.fetchCategories();
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildCreateBusinessButton(),
            const SizedBox(height: 24),
            _buildBusinessesList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Business Management',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 8),
        CustomText(
          text: 'Create and manage your businesses',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.grey[600]!,
        ),
      ],
    );
  }
  
  Widget _buildCreateBusinessButton() {
    return CommonButton(
      text: 'Create New Business',
      textColor: whiteColor,
      bgColor: firstColor,
      onTap: () {
        // Navigate to create business page
        // Get.to(() => CreateBusinessPage());
      },
    );
  }
  
  Widget _buildBusinessesList() {
    return Obx(() {
      if (companyController.isLoading.value) {
        return _buildLoadingShimmer();
      }
      
      if (companyController.error.value.isNotEmpty) {
        return Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: redColor),
              const SizedBox(height: 16),
              CustomText(
                text: 'Error loading businesses',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: redColor,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: companyController.error.value,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600]!,
              ),
            ],
          ),
        );
      }
      
      if (companyController.ownerCompaniesMap.isEmpty) {
        return Center(
          child: Column(
            children: [
              Icon(Icons.business, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              CustomText(
                text: 'No businesses found',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]!,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: 'Create your first business to get started',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600]!,
              ),
            ],
          ),
        );
      }
      
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: companyController.ownerCompaniesMap.length,
        itemBuilder: (context, index) {
          final business = companyController.ownerCompaniesMap[index];
          return _buildBusinessCard(business);
        },
      );
    });
  }
  
  Widget _buildLoadingShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: LoadingShimmer(
          h: 120,
          w: double.infinity,
        ),
      ),
    );
  }
  
  Widget _buildBusinessCard(CompanyModel business) {
    // Define status color and text based on company status
    Color statusColor;
    switch (business.status) {
      case CompanyStatus.pending:
        statusColor = Colors.orange;
        break;
      case CompanyStatus.approved:
        statusColor = firstColor;
        break;
      case CompanyStatus.rejected:
        statusColor = redColor;
        break;
      case CompanyStatus.suspended:
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.grey;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: mediumBorder,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: firstColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: business.companyLogo != null && business.companyLogo!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    business.companyLogo!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.business,
                      color: firstColor,
                      size: 30,
                    ),
                  ),
                )
              : Icon(
                  Icons.business,
                  color: firstColor,
                  size: 30,
                ),
        ),
        title: Row(
          children: [
            Expanded(
              child: CustomText(
                text: business.name,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomText(
                text: business.status.toString().split('.').last.capitalize!,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            CustomText(
              text: business.category?.name ?? 'No Category',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]!,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                CustomText(
                  text: 'Created: ',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600]!,
                ),
                CustomText(
                  text: '${business.createdAt.day}/${business.createdAt.month}/${business.createdAt.year}',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600]!,
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: firstColor),
          onPressed: () {
            // Navigate to edit business page
            // Get.to(() => EditBusinessPage(business: business));
          },
        ),
        onTap: () {
          // Navigate to business detail page
          // Get.to(() => BusinessDetailPage(business: business));
        },
      ),
    );
  }
} 