import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../utils/global_variables.dart';
import '../../../widgets/responsive_layout.dart';
import '../../../widgets/stat_card.dart';
import '../../../widgets/animated_counter.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildStatCards(),
          const SizedBox(height: 24),
          _buildChartSection(),
          const SizedBox(height: 24),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GlobalVariables.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome back, John!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: GlobalVariables.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Last 30 Days',
                style: TextStyle(color: GlobalVariables.primaryColor),
              ),
              Icon(Icons.arrow_drop_down, color: GlobalVariables.primaryColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: ResponsiveLayout.isMobile(Get.context!) ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        StatCard(
          title: 'Total Sales',
          value: 2547,
          icon: Icons.shopping_cart,
          color: GlobalVariables.primaryColor,
          increase: 12.5,
        ),
        StatCard(
          title: 'Total Revenue',
          value: 15420,
          icon: Icons.attach_money,
          color: GlobalVariables.secondaryColor,
          increase: 8.2,
          isCurrency: true,
        ),
        StatCard(
          title: 'Total Orders',
          value: 1123,
          icon: Icons.local_shipping,
          color: GlobalVariables.accentColor,
          increase: -2.4,
        ),
        StatCard(
          title: 'Total Customers',
          value: 892,
          icon: Icons.people,
          color: Color(0xFF6C63FF),
          increase: 5.7,
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: GlobalVariables.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                // Chart configuration here
                // You'll need to implement the chart data based on your needs
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: GlobalVariables.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          // Add your activity list here
        ],
      ),
    );
  }
} 