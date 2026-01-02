import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/business_model.dart';
import '../../../utils/globalVariable.dart';
import '../../../widgets/business/business_hours_display.dart';
import '../../provider_dashboard/sections/services/add_service_page.dart';

class BusinessDescriptionSection extends StatelessWidget {
  final BusinessModel? business;
  final bool isOwner;
  final String companyName;

  const BusinessDescriptionSection({
    super.key,
    this.business,
    required this.isOwner,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.business, color: firstColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomText(
                      text: business?.name ?? companyName,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomText(
                text: "This page contains all services offered by this business. ${isOwner ? 'You can manage your services here.' : 'Browse through available services below.'}",
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600]!,
                max: 3,
              ),
              if (isOwner && business != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Get.to(() => AddServicePage(business: business!)),
                        icon: Icon(Icons.add, size: 18, color: firstColor),
                        label: CustomText(
                          text: "Add New Service",
                          fontSize: 14,
                          color: firstColor,
                          fontWeight: FontWeight.w500,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: firstColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (business != null && business!.businessHours.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BusinessHoursDisplay(
              businessHours: business!.businessHours,
            ),
          ),
        ],
      ],
    );
  }
}