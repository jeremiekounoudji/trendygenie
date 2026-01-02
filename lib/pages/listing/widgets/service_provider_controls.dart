import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/service_item.dart';
import '../../../models/business_model.dart';
import '../../../utils/globalVariable.dart';
import '../../../controllers/services_controller.dart';
import '../../../controllers/business_controller.dart';
import '../../provider_dashboard/sections/services/edit_service_page.dart';

class ServiceProviderControls extends StatelessWidget {
  final ServiceItem service;
  final ServicesController servicesController;

  const ServiceProviderControls({
    super.key,
    required this.service,
    required this.servicesController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: firstColor, size: 24),
              const SizedBox(width: 8),
              CustomText(
                text: "Service Management",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(
            text: "Manage your service settings, edit details, or request deletion. Changes may require admin approval.",
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _editService(),
                  icon: const Icon(Icons.edit, size: 20),
                  label: const Text('Edit Service'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: firstColor,
                    foregroundColor: whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showDeleteConfirmation(),
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red[700],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.red[300]!),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _editService() async {
    // First try to get business from service
    BusinessModel? business = service.business;
    
    // If not available, try to fetch from BusinessController
    if (business == null && service.businessId != null) {
      try {
        final businessController = Get.find<BusinessController>();
        // Try to find the business in the controller's list
        business = businessController.businesses.firstWhereOrNull(
          (b) => b.id == service.businessId
        );
        
        // If still not found, fetch from database
        if (business == null) {
          final response = await servicesController.supabase
              .from('businesses')
              .select('*, category:categories(*)')
              .eq('id', service.businessId!)
              .maybeSingle();
          
          if (response != null) {
            business = BusinessModel.fromJson(response);
          }
        }
      } catch (e) {
        // Silently handle error
      }
    }
    
    if (business != null) {
      Get.to(() => EditServicePage(
        business: business!,
        service: service,
      ));
    } else {
      Get.snackbar(
        'Error',
        'Unable to load business information. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 48,
              ),
              const SizedBox(height: 16),
              CustomText(
                text: 'Delete Service',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              const SizedBox(height: 12),
              CustomText(
                text: 'Are you sure you want to delete this service? This will mark it for deletion and an admin will review it.',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600],
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: 'Note: Services with ongoing orders cannot be deleted.',
                fontSize: 12,
                color: Colors.red[600],
                align: TextAlign.center,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: CustomText(
                        text: 'Cancel',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _deleteService(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteService() async {
    Get.back(); // Close dialog
    
    try {
      // Check for ongoing orders first
      final hasOngoingOrders = await _checkForOngoingOrders();
      
      if (hasOngoingOrders) {
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.block,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  CustomText(
                    text: 'Cannot Delete Service',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                  const SizedBox(height: 12),
                  CustomText(
                    text: 'This service has ongoing orders and cannot be deleted at this time. Please wait for all orders to be completed before attempting to delete.',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                    align: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: firstColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Understood'),
                  ),
                ],
              ),
            ),
          ),
        );
        return;
      }

      // Mark service for deletion
      final success = await servicesController.requestServiceDeletion(service.id!);
      
      if (success != null) {
        Get.snackbar(
          'Success',
          'Service marked for deletion. An admin will review your request.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: firstColor,
          colorText: Colors.white,
        );
        Get.back(); // Go back to previous screen
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete service. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while deleting the service.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> _checkForOngoingOrders() async {
    try {
      // Check if service has any pending or accepted orders
      final response = await servicesController.supabase
          .from('orders')
          .select('id')
          .eq('service_id', service.id!)
          .inFilter('status', ['pending', 'accepted'])
          .limit(1);
      
      return (response as List).isNotEmpty;
    } catch (e) {
      // If we can't check, assume there might be ongoing orders for safety
      return true;
    }
  }
}