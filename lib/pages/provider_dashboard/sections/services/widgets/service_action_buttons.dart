import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../models/service_item.dart';
import '../../../../../models/business_model.dart';
import '../../../../../models/enums.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../widgets/general_widgets/common_button.dart';
import '../../../../../controllers/services_controller.dart';
import '../edit_service_page.dart';
import 'delete_service_dialog.dart';

class ServiceActionButtons extends StatelessWidget {
  final ServiceItem service;
  final BusinessModel business;
  final ServicesController servicesController;
  final RxBool isLoading;
  final Function(ServiceItem)? onServiceUpdated;

  const ServiceActionButtons({
    super.key,
    required this.service,
    required this.business,
    required this.servicesController,
    required this.isLoading,
    this.onServiceUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPendingDeletion = service.status == ServiceStatus.requestDeletion.name;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: isPendingDeletion ? _buildCancelDeletionButton() : _buildEditDeleteButtons(),
    );
  }

  Widget _buildEditDeleteButtons() {
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            text: 'Edit',
            onTap: () {
              Get.to(() => EditServicePage(
                business: business,
                service: service,
              ));
            },
            bgColor: firstColor,
            radius: 12,
            textColor: whiteColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CommonButton(
            text: 'Delete',
            onTap: () {
              Get.dialog(DeleteServiceDialog(
                serviceName: service.title,
                onConfirm: () async {
                  final updatedService = await servicesController.requestServiceDeletion(service.id ?? '');
                  
                  if (updatedService != null) {
                    onServiceUpdated?.call(updatedService);
                    Get.back(); // Close dialog
                  }
                },
              ));
            },
            bgColor: Colors.red,
            radius: 12,
            isLoading: isLoading,
            textColor: whiteColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCancelDeletionButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: CustomText(
                  text: "This service is pending deletion. You can cancel the request below.",
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.red.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CommonButton(
          text: 'Cancel Delete Request',
          onTap: () async {
            isLoading.value = true;
            final updatedService = await servicesController.cancelServiceDeletion(service.id ?? '');
            isLoading.value = false;
            
            if (updatedService != null) {
              onServiceUpdated?.call(updatedService);
            }
          },
          bgColor: Colors.orange,
          radius: 12,
          isLoading: isLoading,
          textColor: whiteColor,
        ),
      ],
    );
  }
}
