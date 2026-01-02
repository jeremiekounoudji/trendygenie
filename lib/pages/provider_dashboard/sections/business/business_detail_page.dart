import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/business_controller.dart';
import '../../../../controllers/services_controller.dart';
import '../../../../controllers/order_controller.dart';
import '../../../../models/enums.dart';
import '../../../../utils/globalVariable.dart';
import '../../../../widgets/general_widgets/common_button.dart';
import '../../../../widgets/general_widgets/success_bottom_sheet.dart';
import '../../widgets/business_action_sheet.dart';
import 'edit_business_page.dart';
import '../services/add_service_page.dart';
import 'widgets/index.dart';

class BusinessDetailPage extends StatefulWidget {
  final int businessIndex;
  
  const BusinessDetailPage({
    super.key,
    required this.businessIndex,
  });

  @override
  State<BusinessDetailPage> createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  final BusinessController businessController = Get.find<BusinessController>();
  final ServicesController servicesController = Get.put(ServicesController());
  final OrderController orderController = Get.put(OrderController());
  // late BusinessModel business;
  
  // Add loading states for each action
  final RxBool isActivationLoading = false.obs;
  final RxBool isSuspendLoading = false.obs;
  final RxBool isDeleteLoading = false.obs;

  @override
  void initState() {
    super.initState();
    businessController.selectedBusiness.value = businessController.businesses[widget.businessIndex];
    orderController.fetchBusinessOrders(businessController.selectedBusiness.value!.id!, 0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Obx(() {
        return CustomScrollView(
          slivers: [
            // App Bar with business logo background
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: Stack(
                clipBehavior: Clip.none,
                children: [
                  FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Business Logo as background
                        if (businessController.selectedBusiness.value?.logoUrl != null && businessController.selectedBusiness.value!.logoUrl!.isNotEmpty)
                          Image.network(
                            businessController.selectedBusiness.value!.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: firstColor.withOpacity(0.1),
                              child: Icon(
                                Icons.business,
                                color: firstColor,
                                size: 100,
                              ),
                            ),
                          )
                        else
                          Container(
                            color: firstColor.withOpacity(0.1),
                            child: Icon(
                              Icons.business,
                              color: firstColor,
                              size: 100,
                            ),
                          ),
                        // Gradient overlay for better text visibility
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.black.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Rating Button in bottom-right corner
                  Positioned(
                    bottom: -12,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: firstColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            // Handle rating tap if needed
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded, color: Colors.amber[600], size: 20),
                                const SizedBox(width: 4),
                                CustomText(
                                  text: businessController.selectedBusiness.value?.rating.toStringAsFixed(1) ?? '0.0',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: whiteColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: whiteColor),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.more_vert, color: whiteColor),
                  onPressed: () => _showMoreOptions(),
                ),
              ],
            ),
            
            // Business Profile Section
            SliverToBoxAdapter(
              child: Container(
                color: whiteColor,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Business Name and Verification
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            text: businessController.selectedBusiness.value?.name ?? 'No Name',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                          ),
                        ),
                        if (businessController.selectedBusiness.value?.status == BusinessStatus.active)
                          Icon(Icons.verified, color: firstColor, size: 24),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Business Category (like @theunderdog in the screenshot)
                    CustomText(
                      text: businessController.selectedBusiness.value?.category?.name ?? 'No Category',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]!,
                    ),
                    const SizedBox(height: 12),
                    
                    // Business Description
                    CustomText(
                      text: businessController.selectedBusiness.value?.description ?? 'No Description',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[800]!,
                    ),
                    const SizedBox(height: 16),
                    
                    // Rating Stars and Reviews
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: firstColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.verified, color: firstColor, size: 16),
                              const SizedBox(width: 8),
                              CustomText(
                                text: businessController.selectedBusiness.value?.status.toString().split('.').last.capitalize ?? 'No Status',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: firstColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                      // divider
                    Divider(
                      color: greyColor,
                      height: 20,
                    ),
                    const SizedBox(height: 10),
                    
                    // Metrics Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildMetricItem(
                          icon: Icons.business_center_rounded,
                          value: '${servicesController.services.length}',
                          label: 'services',
                          iconColor: Colors.blue[600]!,
                        ),
                        const SizedBox(width: 32),
                        _buildMetricItem(
                          icon: Icons.shopping_bag_rounded,
                          value: '${orderController.businessOrders.length}',
                          label: 'orders',
                          iconColor: Colors.purple[600]!,
                        ),
                        const SizedBox(width: 32),
                        _buildMetricItem(
                          icon: _getStatusIcon(businessController.selectedBusiness.value?.status ?? BusinessStatus.active),
                          value: businessController.selectedBusiness.value?.category?.name ?? 'No Category',
                          label: 'category',
                          iconColor: Colors.orange[600]!,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                      Divider(
                      color: greyColor,
                      height: 20,
                    ),
                    const SizedBox(height: 10),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CommonButton(
                            text: 'Edit Business',
                            textColor: whiteColor,
                            bgColor: firstColor,
                            onTap: () => Get.to(() => EditBusinessPage(business: businessController.selectedBusiness.value!)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add_business, color: Colors.green),
                            onPressed: () => Get.to(() => AddServicePage(business: businessController.selectedBusiness.value!)),
                            tooltip: 'Add Service',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: firstColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.share, color: firstColor),
                            onPressed: () {
                              // Implement share functionality
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Contact Information Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(20),
                color: whiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Contact Information',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(Icons.email, 'Email', businessController.selectedBusiness.value?.contactEmail ?? 'No email'),
                    _buildContactItem(Icons.phone, 'Phone', businessController.selectedBusiness.value?.contactPhone.join(', ') ?? 'No phone'),
                    _buildContactItem(Icons.location_on, 'Address', businessController.selectedBusiness.value?.address ?? 'No address'),
                  ],
                ),
              ),
            ),
            
            // Business Status Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(20),
                color: whiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Business Status',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                    const SizedBox(height: 16),
                    _buildStatusCard(),
                    const SizedBox(height: 20),
                    // Business Options
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Business Options',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: blackColor,
                          ),
                          const SizedBox(height: 16),
                          if (businessController.selectedBusiness.value?.status != BusinessStatus.active)
                            _buildOptionButton(
                              label: 'Request Activation',
                              color: Colors.green[400]!,
                              onTap: () => _showSubscriptionSheet('Request Activation'),
                              isLoading: isActivationLoading,
                            ),
                          if (businessController.selectedBusiness.value?.status != BusinessStatus.suspended)
                            _buildOptionButton(
                              label: 'Suspend Business',
                              color: Colors.orange[400]!,
                              onTap: () => _showSubscriptionSheet('Suspend Business'),
                              isLoading: isSuspendLoading,
                            ),
                          _buildOptionButton(
                            label: 'Delete Business',
                            color: redColor,
                            onTap: () => _showDeleteConfirmation(),
                            isLoading: isDeleteLoading,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return MetricItem(
      icon: icon,
      value: value,
      label: label,
      iconColor: iconColor,
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return ContactItem(icon: icon, label: label, value: value);
  }

  Widget _buildStatusCard() {
    return StatusCard(
      status: businessController.selectedBusiness.value?.status ?? BusinessStatus.active,
    );
  }

  void _showMoreOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (businessController.selectedBusiness.value?.status != BusinessStatus.active)
              _buildOptionItem(
                icon: Icons.check_circle,
                label: 'Request Activation',
                color: Colors.green,
                onTap: () {
                  Get.back();
                  businessController.changeBusinessStatus(businessController.selectedBusiness.value!.id!, 'pending');
                },
              ),
            if (businessController.selectedBusiness.value?.status != BusinessStatus.suspended)
              _buildOptionItem(
                icon: Icons.pause_circle,
                label: 'Suspend Business',
                color: Colors.orange,
                onTap: () {
                  Get.back();
                  businessController.changeBusinessStatus(businessController.selectedBusiness.value!.id!, 'suspended');
                },
              ),
            _buildOptionItem(
              icon: Icons.delete,
              label: 'Delete Business',
              color: redColor,
              onTap: () {
                Get.back();
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OptionItem(icon: icon, label: label, color: color, onTap: onTap);
  }

  void _showDeleteConfirmation() {
    DeleteConfirmationDialog.show(
      businessId: businessController.selectedBusiness.value!.id!,
      businessName: businessController.selectedBusiness.value?.name ?? '',
      businessController: businessController,
    );
  }

  IconData _getStatusIcon(BusinessStatus status) {
    switch (status) {
      case BusinessStatus.active:
        return Icons.check_circle;
      case BusinessStatus.pending:
        return Icons.pending;
      case BusinessStatus.rejected:
        return Icons.cancel;
      case BusinessStatus.suspended:
        return Icons.pause_circle;
      default:
        return Icons.help;
    }
  }

  Widget _buildOptionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
    required RxBool isLoading,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CommonButton(
        text: label,
        textColor: whiteColor,
        bgColor: color,
        width: double.infinity,
        verticalPadding: 15,
        radius: 10,
        isLoading: isLoading,
        onTap: onTap,
      ),
    );
  }

  void _showSubscriptionSheet(String action) {
    Get.bottomSheet(
      BusinessActionSheet(
        business: businessController.selectedBusiness.value!,
        action: action,
        onActionPressed: () async {
          Get.back();
          if (action == 'Request Activation') {
            isActivationLoading.value = true;
            final success = await businessController.changeBusinessStatus(businessController.selectedBusiness.value!.id!, 'pending');
            isActivationLoading.value = false;
            if (success) {
           SuccessBottomSheet.show(
                title: "Business Activated",
                message: "Your business has been activated. You can now start receiving orders.",
                buttonText: "Back to Business",
                onButtonTap: () {
                  Get.back(); // Close bottom sheet
                },
              );
            }
          } else if (action == 'Suspend Business') {
            isSuspendLoading.value = true;
            final success = await businessController.changeBusinessStatus(businessController.selectedBusiness.value!.id!, 'suspended');
            isSuspendLoading.value = false;
            if (success) {
              SuccessBottomSheet.show(
                title: "Business Suspended",
                message: "Your business has been suspended. You can request reactivation at any time.",
                buttonText: "Back to Business",
                onButtonTap: () {
                  Get.back(); // Close bottom sheet
                },
              );
            }
          }
        },
      ),
    );
  }
} 