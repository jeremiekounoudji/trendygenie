import 'package:flutter/material.dart';
import '../../../../../../widgets/general_widgets/shimmer.dart';

class TransactionLoadingState extends StatelessWidget {
  const TransactionLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: LoadingShimmer(
            h: 100,
            w: double.infinity,
          ),
        );
      },
    );
  }
} 