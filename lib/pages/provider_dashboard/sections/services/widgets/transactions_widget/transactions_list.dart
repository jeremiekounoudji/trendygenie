import 'package:flutter/material.dart';
import '../../../../../../models/payment_model.dart';
import '../../../../../../models/enums.dart';
import '../../../../../../widgets/payment_card/payment_card.dart';

class TransactionsList extends StatelessWidget {
  final List<PaymentModel> payments;
  final Function(String, PaymentStatus) onUpdateStatus;

  const TransactionsList({
    super.key,
    required this.payments,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PaymentCard(
            payment: payment,
            onUpdateStatus: onUpdateStatus,
          ),
        );
      },
    );
  }
} 