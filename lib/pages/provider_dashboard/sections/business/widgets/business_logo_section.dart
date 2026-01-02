import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../models/business_model.dart';
import '../../../../../models/enums.dart';
import '../../../../../utils/globalVariable.dart';

class BusinessLogoSection extends StatelessWidget {
  final String? logoImagePath;
  final String? existingLogoUrl;
  final BusinessStatus status;
  final VoidCallback onTap;

  const BusinessLogoSection({
    super.key,
    this.logoImagePath,
    this.existingLogoUrl,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: whiteColor.withValues(alpha: 0.2),
          border: Border.all(color: firstColor.withValues(alpha: 0.8)),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          image: _getDecorationImage(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 30, color: firstColor),
            const SizedBox(height: 15),
            CustomText(
              text: "Change Business Logo",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: firstColor,
            ),
            const SizedBox(height: 20),
            _buildStatusBadge(),
          ],
        ),
      ),
    );
  }

  DecorationImage? _getDecorationImage() {
    if (logoImagePath != null) {
      return DecorationImage(
        image: FileImage(File(logoImagePath!)),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          firstColor.withValues(alpha: 0.1),
          BlendMode.srcOver,
        ),
      );
    } else if (existingLogoUrl != null) {
      return DecorationImage(
        image: NetworkImage(existingLogoUrl!),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          firstColor.withValues(alpha: 0.1),
          BlendMode.srcOver,
        ),
      );
    }
    return null;
  }

  Widget _buildStatusBadge() {
    final statusColor = BusinessModel.getStatusColor(status);
    final statusText = status.toString().split('.').last;
    final capitalizedStatus = statusText[0].toUpperCase() + statusText.substring(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: whiteColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(), color: statusColor, size: 18),
          const SizedBox(width: 8),
          CustomText(
            text: 'Status: $capitalizedStatus',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: statusColor,
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon() {
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
        return Icons.remove_circle;
    }
  }
}
