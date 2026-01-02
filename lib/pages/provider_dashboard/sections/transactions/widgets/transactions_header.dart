import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';

class TransactionsHeader extends StatelessWidget {
  const TransactionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Transactions',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 8),
        CustomText(
          text: 'Track and manage your financial transactions',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.grey[600]!,
        ),
      ],
    );
  }
}
