import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/payment_controller.dart';
import '../../../../../models/business_model.dart';
import '../../../../../models/enums.dart';
import '../../../../../models/payment_model.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../widgets/general_widgets/shimmer.dart';
import '../../../../../widgets/payment_card/payment_card.dart';

class TransactionsTab extends StatefulWidget {
  final BusinessModel business;
  final PaymentController paymentController;
  final ScrollController scrollController;
  final Function onLoadMore;

  const TransactionsTab({
    super.key,
    required this.business,
    required this.paymentController,
    required this.scrollController,
    required this.onLoadMore,
  });

  @override
  State<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  final RxString selectedFilter = 'all'.obs;
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: widget.paymentController.getPaymentsByBusinessId(widget.business.id!, refresh: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        return Obx(() {
          if (widget.paymentController.payments.isEmpty) {
            return Column(
              children: [
                _buildFilterChips(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_balance_wallet_outlined, 
                          size: 64, 
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                          text: 'No transactions available',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          final filteredPayments = _getFilteredPayments();

          if (filteredPayments.isEmpty) {
            return Column(
              children: [
                _buildFilterChips(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_alt_outlined, 
                          size: 64, 
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                          text: 'No transactions matching the filter',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              _buildFilterChips(),
              _buildTransactionMetrics(),
              Expanded(
                child: ListView.builder(
                  controller: widget.scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredPayments.length + 1,
                  itemBuilder: (context, index) {
                    if (index == filteredPayments.length) {
                      return widget.paymentController.isLoading.value
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(color: firstColor),
                            ),
                          )
                        : const SizedBox.shrink();
                    }
                    
                    final payment = filteredPayments[index];
                    return PaymentCard(
                      payment: payment,
                      onUpdateStatus: _updatePaymentStatus,
                    );
                  },
                ),
              ),
            ],
          );
        });
      },
    );
  }

  List<PaymentModel> _getFilteredPayments() {
    if (selectedFilter.value == 'all') {
      return widget.paymentController.payments;
    }

    return widget.paymentController.payments.where((payment) {
      return payment.status.name.toLowerCase() == selectedFilter.value.toLowerCase();
    }).toList();
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            'All',
            isSelected: selectedFilter.value == 'all',
            onSelected: (selected) {
              if (selected) {
                selectedFilter.value = 'all';
              }
            },
          ),
          const SizedBox(width: 8),
          ...PaymentStatus.values.map((status) {
            final statusName = status.name.toLowerCase();
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                _getFormattedStatus(status),
                isSelected: selectedFilter.value == statusName,
                chipColor: _getStatusColor(status),
                onSelected: (selected) {
                  selectedFilter.value = selected ? statusName : 'all';
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTransactionMetrics() {
    // Calculate metrics for filtered transactions
    final filteredPayments = _getFilteredPayments();
    final totalAmount = filteredPayments.fold(0.0, (sum, payment) => sum + payment.amount);
    final completedCount = filteredPayments.where((p) => p.status == PaymentStatus.completed).length;
    final pendingCount = filteredPayments.where((p) => p.status == PaymentStatus.pending).length;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem('Total', '\$${totalAmount.toStringAsFixed(2)}', Icons.attach_money),
          _buildMetricItem('Completed', '$completedCount', Icons.check_circle_outline, color: Colors.green),
          _buildMetricItem('Pending', '$pendingCount', Icons.pending_outlined, color: Colors.orange),
        ],
      ),
    );
  }
  
  Widget _buildMetricItem(String title, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? firstColor, size: 22),
        const SizedBox(height: 4),
        CustomText(
          text: value,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        CustomText(
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.grey[600]!,
        ),
      ],
    );
  }

  void _updatePaymentStatus(String paymentId, PaymentStatus newStatus) {
    widget.paymentController.updatePaymentStatus(paymentId, newStatus);
  }

  Widget _buildFilterChip(String label, {
    required bool isSelected,
    required Function(bool) onSelected,
    Color? chipColor,
  }) {
    return FilterChip(
      label: CustomText(
        text: label,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isSelected ? Colors.white : chipColor ?? firstColor,
      ),
      selected: isSelected,
      selectedColor: chipColor ?? firstColor,
      backgroundColor: Colors.white,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: chipColor ?? firstColor, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onSelected: onSelected,
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: LoadingShimmer(
            h: 120,
            w: double.infinity,
          ),
        );
      },
    );
  }
} 