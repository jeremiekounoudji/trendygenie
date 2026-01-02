import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../utils/globalVariable.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.accepted:
        return firstColor;
      case OrderStatus.completed:
        return thirdColor;
      case OrderStatus.rejected:
        return redColor;
      case OrderStatus.cancelled:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM dd, yyyy');
    final statusColor = _getStatusColor(order.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.receipt, color: statusColor),
        ),
        title: Row(
          children: [
            CustomText(
              text: 'Order #${order.id.substring(0, 8)}',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
            const SizedBox(width: 8),
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
                text: order.status.toString().split('.').last.capitalize!,
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
            const SizedBox(height: 4),
            CustomText(
              text: order.customer?.fullName ?? 'Unknown Customer',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]!,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: formatter.format(order.orderDate),
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600]!,
            ),
          ],
        ),
        trailing: CustomText(
          text: '\$${order.totalAmount.toStringAsFixed(2)}',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: firstColor,
        ),
        onTap: onTap,
      ),
    );
  }
} 