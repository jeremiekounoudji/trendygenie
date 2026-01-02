import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/business_model.dart';
import '../../../models/enums.dart';
import '../../../utils/globalVariable.dart';
import '../../../widgets/general_widgets/common_button.dart';

class BusinessActionSheet extends StatelessWidget {
  final BusinessModel business;
  final String action;
  final VoidCallback onActionPressed;

  const BusinessActionSheet({
    super.key,
    required this.business,
    required this.action,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Business Logo and Name
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: business.logoUrl != null
                      ? DecorationImage(
                          image: NetworkImage(business.logoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: firstColor.withOpacity(0.1),
                ),
                child: business.logoUrl == null
                    ? Icon(Icons.business, color: firstColor)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: business.name,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                    CustomText(
                      text: business.category?.name ?? 'No Category',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]!,
                    ),
                  ],
                ),
              ),
              if (business.status == BusinessStatus.active)
                Icon(Icons.verified, color: firstColor),
            ],
          ),
          const SizedBox(height: 24),
          // Action Description
          CustomText(
            text: _getActionDescription(),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
          const SizedBox(height: 16),
          // Benefits List
          ..._buildBenefitsList(),
          const SizedBox(height: 24),
          // Action Button
          CommonButton(
            text: action,
            textColor: whiteColor,
            bgColor: _getActionColor(),
            onTap: onActionPressed,
            verticalPadding: 10,
            radius: 10,
          ),
        ],
      ),
    );
  }

  String _getActionDescription() {
    switch (action) {
      case 'Request Activation':
        return 'Request to activate your business';
      case 'Suspend Business':
        return 'Temporarily suspend your business';
      default:
        return 'Delete your business permanently';
    }
  }

  Color _getActionColor() {
    switch (action) {
      case 'Request Activation':
        return firstColor;
      case 'Suspend Business':
        return Colors.orange[400]!;
      default:
        return redColor;
    }
  }

  List<Widget> _buildBenefitsList() {
    final benefits = _getBenefits();
    
    return benefits.map((benefit) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: _getActionColor(),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomText(
                text: benefit,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800]!,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<String> _getBenefits() {
    switch (action) {
      case 'Request Activation':
        return [
          'Your business will be visible to customers',
          'Accept orders and provide services',
          'Manage your business profile',
        ];
      case 'Suspend Business':
        return [
          'Temporarily hide your business',
          'Pause accepting new orders',
          'Resume anytime',
        ];
      default:
        return [
          'Remove all business data',
          'Cancel active subscriptions',
          'This action cannot be undone',
        ];
    }
  }
} 