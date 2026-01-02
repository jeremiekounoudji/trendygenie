import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/payment_model.dart';
import '../../models/enums.dart';
import '../../utils/globalVariable.dart';
import '../../controllers/payment_controller.dart';
import 'payment_details_bottom_sheet.dart';

class PaymentCard extends StatelessWidget {
  final PaymentModel payment;
  final Function(String, PaymentStatus) onUpdateStatus;

  const PaymentCard({
    super.key,
    required this.payment,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(payment.status);
    final dateFormatter = DateFormat.yMMMd(); // e.g., "Apr 21, 2024"
    final timeFormatter = DateFormat.jm();    // e.g., "2:45 PM"
    
    final dateFormatted = dateFormatter.format(payment.createdAt);
    final timeFormatted = timeFormatter.format(payment.createdAt);
    
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          PaymentDetailsBottomSheet(payment: payment),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: const Offset(0, 1),
              blurRadius: 3,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _getPaymentIcon(payment.paymentProvider),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: payment.description ?? 'Payment #${payment.id.substring(0, 8)}',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: blackColor,
                                max: 1,
                              ),
                              CustomText(
                                text: 'Via ${_getFormattedProvider(payment.paymentProvider)}',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600]!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        text: '\$${payment.amount.toStringAsFixed(2)}',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: CustomText(
                          text: _getFormattedStatus(payment.status),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 6),
                      CustomText(
                        text: '$dateFormatted at $timeFormatted',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                  if (payment.transactionFee > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: CustomText(
                        text: 'Fee: \$${payment.transactionFee.toStringAsFixed(2)}',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700]!,
                      ),
                    ),
                ],
              ),
              if (payment.customer != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(Icons.person, size: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 6),
                      CustomText(
                        text: payment.customer!.fullName,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                ),
              if (payment.status == PaymentStatus.completed)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => onUpdateStatus(payment.id, PaymentStatus.refunded),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.replay_rounded,
                                size: 14,
                                color: Colors.purple[700],
                              ),
                              const SizedBox(width: 4),
                              CustomText(
                                text: 'Refund',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.purple[700]!,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPaymentIcon(PaymentProvider provider) {
    IconData iconData;
    Color iconColor;
    
    switch (provider) {
      case PaymentProvider.stripe:
        iconData = Icons.credit_card;
        iconColor = Colors.blue;
        break;
      case PaymentProvider.paypal:
        iconData = Icons.account_balance_wallet;
        iconColor = Colors.indigo;
        break;
      case PaymentProvider.cash:
        iconData = Icons.money;
        iconColor = Colors.green;
        break;
      case PaymentProvider.bank_transfer:
        iconData = Icons.account_balance;
        iconColor = Colors.blueGrey;
        break;
      case PaymentProvider.square:
        iconData = Icons.crop_square;
        iconColor = Colors.teal;
        break;
      case PaymentProvider.razorpay:
        iconData = Icons.payment;
        iconColor = Colors.deepPurple;
        break;
      case PaymentProvider.flutterwave:
        iconData = Icons.waves;
        iconColor = Colors.orange;
        break;
      case PaymentProvider.mpesa:
        iconData = Icons.phone_android;
        iconColor = Colors.green;
        break;
      case PaymentProvider.google_pay:
        iconData = Icons.g_mobiledata;
        iconColor = Colors.deepOrange;
        break;
      case PaymentProvider.apple_pay:
        iconData = Icons.apple;
        iconColor = Colors.black87;
        break;
      default:
        iconData = Icons.payment;
        iconColor = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }
  
  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.processing:
        return Colors.blue;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.refunded:
        return Colors.purple;
      case PaymentStatus.cancelled:
        return Colors.grey;
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