import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/payment_model.dart';
import '../../models/user_model.dart';
import '../../models/order_model.dart' hide PaymentStatus;
import '../../models/enums.dart';
import '../../utils/globalVariable.dart';
import '../../utils/currency_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class PaymentDetailsBottomSheet extends StatelessWidget {
  final PaymentModel payment;

  const PaymentDetailsBottomSheet({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(payment.status);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with amount and status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: CurrencyHelper.formatPrice(payment.amount, payment.currency),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                          ),
                          if (payment.transactionFee > 0)
                            CustomText(
                              text: 'Fee: ${CurrencyHelper.formatPrice(payment.transactionFee, payment.currency)}',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]!,
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            CustomText(
                              text: _getFormattedStatus(payment.status),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Transaction Info Section
                  _buildSectionTitle('Transaction Details', Icons.receipt_long),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Payment Method', _getFormattedProvider(payment.paymentProvider)),
                        const SizedBox(height: 12),
                        _buildInfoRow('Transaction ID', '#${payment.id.substring(0, 8)}'),
                        const SizedBox(height: 12),
                        _buildInfoRow('Date', _formatDateTime(payment.createdAt)),
                        if (payment.description != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoRow('Description', payment.description!),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Customer Info Section
                  if (payment.customer != null) ...[
                    _buildSectionTitle('Customer Information', Icons.person),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[100]!),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow('Name', payment.customer!.fullName),
                          ...[
                          const SizedBox(height: 12),
                          _buildInfoRow('Email', payment.customer!.email),
                        ],
                          ...[
                          const SizedBox(height: 12),
                          _buildInfoRow('Phone', payment.customer!.phoneNumber),
                        ],
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Order Info Section
                  if (payment.order != null) ...[
                    _buildSectionTitle('Order Details', Icons.shopping_bag),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[100]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Order ID', '#${payment.order!.id.substring(0, 8)}'),
                          const SizedBox(height: 12),
                          _buildInfoRow('Status', payment.order!.status.name),
                          const SizedBox(height: 12),
                          _buildInfoRow('Date', _formatDateTime(payment.order!.createdAt)),
                          const SizedBox(height: 16),
                          const CustomText(
                            text: 'Service',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 8),
                          if (payment.order?.service != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomText(
                                      text: payment.order!.service!.title,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[700]!,
                                    ),
                                  ),
                                  CustomText(
                                    text: CurrencyHelper.formatPrice(payment.order!.service!.promotionalPrice, payment.order!.service!.currency),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[900],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Row(
                    children: [
                      if (payment.receiptUrl != null)
                        Expanded(
                          child: InkWell(
                            onTap: () => _launchURL(payment.receiptUrl!),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: firstColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.receipt, size: 20, color: firstColor),
                                  const SizedBox(width: 8),
                                  CustomText(
                                    text: 'View Receipt',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: firstColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (payment.receiptUrl != null && payment.customer != null)
                        const SizedBox(width: 12),
                      if (payment.customer != null)
                        Expanded(
                          child: InkWell(
                            onTap: () => _contactCustomer(payment.customer!),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.chat_outlined, 
                                    size: 20, 
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 8),
                                  CustomText(
                                    text: 'Contact Customer',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          CustomText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: CustomText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600]!,
          ),
        ),
        Expanded(
          flex: 3,
          child: CustomText(
            text: value,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final dateFormatter = DateFormat.yMMMd(); // e.g., "Apr 21, 2024"
    final timeFormatter = DateFormat.jm();    // e.g., "2:45 PM"
    
    final date = dateFormatter.format(dateTime);
    final time = timeFormatter.format(dateTime);
    return '$date at $time';
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar(
        'Error',
        'Could not open receipt',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _contactCustomer(UserModel customer) {
    if (customer.phoneNumber.isNotEmpty) {
      launch('tel:${customer.phoneNumber}');
    } else if (customer.email.isNotEmpty) {
      launch('mailto:${customer.email}');
    } else {
      Get.snackbar(
        'Error',
        'No contact information available',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.refunded:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getFormattedStatus(PaymentStatus status) {
    return status.name[0].toUpperCase() + status.name.substring(1);
  }

  String _getFormattedProvider(PaymentProvider provider) {
    String name = provider.name.replaceAll('_', ' ');
    return name[0].toUpperCase() + name.substring(1);
  }
} 