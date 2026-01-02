import 'package:flutter/material.dart';
import '../../../../../models/enums.dart';
import '../../../../../models/business_model.dart';
import '../../../../../widgets/general_widgets/shimmer.dart';
import 'large_stat_card.dart';
import 'stat_card.dart';

class BusinessStatsGrid extends StatelessWidget {
  final bool isLoading;
  final Map<String, int> stats;

  const BusinessStatsGrid({
    super.key,
    required this.isLoading,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: List.generate(
          5,
          (index) => const LoadingShimmer(h: 100, w: double.infinity),
        ),
      );
    }

    return Column(
      children: [
        LargeStatCard(
          title: 'Total',
          count: stats['total'] ?? 0,
          color: Colors.blue,
          icon: Icons.business,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Active',
                count: stats['active'] ?? 0,
                color: BusinessModel.getStatusColor(BusinessStatus.active),
                icon: Icons.check_circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: 'Pending',
                count: stats['pending'] ?? 0,
                color: BusinessModel.getStatusColor(BusinessStatus.pending),
                icon: Icons.pending,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Rejected',
                count: stats['rejected'] ?? 0,
                color: BusinessModel.getStatusColor(BusinessStatus.rejected),
                icon: Icons.cancel,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: 'Suspended',
                count: stats['suspended'] ?? 0,
                color: BusinessModel.getStatusColor(BusinessStatus.suspended),
                icon: Icons.pause_circle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
