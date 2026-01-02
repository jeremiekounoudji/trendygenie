import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controllers/payment_controller.dart';
import 'metric_card.dart';

class DashboardMetrics extends StatelessWidget {
  final PaymentController paymentController;

  const DashboardMetrics({
    super.key,
    required this.paymentController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Total Revenue',
                    value: '\$${paymentController.totalRevenue.value.toStringAsFixed(2)}',
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MetricCard(
                    title: 'Transaction Fees',
                    value: '\$${paymentController.totalFees.value.toStringAsFixed(2)}',
                    icon: Icons.account_balance,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Total Transactions',
                    value: paymentController.totalTransactions.value.toString(),
                    icon: Icons.receipt_long,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MetricCard(
                    title: 'Pending Transactions',
                    value: paymentController.pendingTransactions.value.toString(),
                    icon: Icons.pending_actions,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
} 