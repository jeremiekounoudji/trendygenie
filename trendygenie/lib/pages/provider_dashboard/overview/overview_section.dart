import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/order_controller.dart';
import '../../../controllers/company_controller.dart';
import '../../../utils/globalVariable.dart';
import '../../../widgets/general_widgets/shimmer.dart';
import '../widgets/dashboard_metric_card.dart';
import '../widgets/recent_orders_list.dart';

class OverviewSection extends StatefulWidget {
  const OverviewSection({super.key});

  @override
  State<OverviewSection> createState() => _OverviewSectionState();
}

class _OverviewSectionState extends State<OverviewSection> {
  final OrderController orderController = Get.put(OrderController());
  final CompanyController companyController = Get.find<CompanyController>();
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final userId = Get.find<CompanyController>().supabase.auth.currentUser!.id;
    await orderController.fetchDashboardMetrics(userId);
    await orderController.fetchRecentOrders(userId);
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildDashboardMetrics(),
            const SizedBox(height: 32),
            _buildRecentOrdersSection(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Provider Dashboard',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 8),
        CustomText(
          text: 'Monitor your business performance and manage orders',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.grey[600]!,
        ),
      ],
    );
  }
  
  Widget _buildDashboardMetrics() {
    return Obx(() {
      if (orderController.isLoading.value && 
          orderController.totalBusinesses.value == 0) {
        return _buildMetricsLoadingShimmer();
      }
      
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          DashboardMetricCard(
            title: 'Total Businesses',
            value: orderController.totalBusinesses.value.toString(),
            icon: Icons.business,
            color: firstColor,
          ),
          DashboardMetricCard(
            title: 'Total Orders',
            value: orderController.totalOrders.value.toString(),
            icon: Icons.shopping_cart,
            color: secondColor,
          ),
          DashboardMetricCard(
            title: 'Total Revenue',
            value: '\$${orderController.totalAmountGenerated.value.toStringAsFixed(2)}',
            icon: Icons.attach_money,
            color: thirdColor,
          ),
          DashboardMetricCard(
            title: 'Total Clients',
            value: orderController.totalClients.value.toString(),
            icon: Icons.people,
            color: Colors.purple,
          ),
        ],
      );
    });
  }
  
  Widget _buildMetricsLoadingShimmer() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        4, 
        (index) => const LoadingShimmer(
          h: 120,
          w: double.infinity,
        ),
      ),
    );
  }
  
  Widget _buildRecentOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Recent Orders',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (orderController.isLoading.value && 
              orderController.recentOrders.isEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: LoadingShimmer(
                  h: 80,
                  w: double.infinity,
                ),
              ),
            );
          }
          
          if (orderController.recentOrders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    Icon(Icons.hourglass_empty, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    CustomText(
                      text: 'No recent orders found',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]!,
                    ),
                  ],
                ),
              ),
            );
          }
          
          return RecentOrdersList(orders: orderController.recentOrders);
        }),
      ],
    );
  }
} 