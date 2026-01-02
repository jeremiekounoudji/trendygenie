import 'package:flutter/material.dart';
import '../../../../../models/enums.dart';
import '../../../../../models/business_model.dart';
import '../../../../../utils/globalVariable.dart';

class StatusCard extends StatelessWidget {
  final BusinessStatus status;

  const StatusCard({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = status.toString().split('.').last;
    final capitalizedStatus = statusText[0].toUpperCase() + statusText.substring(1);
    final statusColor = BusinessModel.getStatusColor(status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(_getStatusIcon(status), color: statusColor, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: capitalizedStatus,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
              CustomText(
                text: _getStatusDescription(status),
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600]!,
              ),
            ],
          ),
        ],
      ),
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

  String _getStatusDescription(BusinessStatus status) {
    switch (status) {
      case BusinessStatus.active:
        return 'Your business is live and operational';
      case BusinessStatus.pending:
        return 'Awaiting approval from administrators';
      case BusinessStatus.rejected:
        return 'Your business application was not approved';
      case BusinessStatus.suspended:
        return 'Your business is temporarily suspended';
      default:
        return 'Status unknown';
    }
  }
}
