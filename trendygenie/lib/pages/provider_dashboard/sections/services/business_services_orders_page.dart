import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/pages/provider_dashboard/sections/services/tabs/orders_tab.dart';
import 'package:trendygenie/pages/provider_dashboard/sections/services/tabs/transactions_tab.dart';
import '../../../../../controllers/business_controller.dart';
import '../../../../../controllers/services_controller.dart';
import '../../../../../controllers/order_controller.dart';
import '../../../../../controllers/payment_controller.dart';
import '../../../../../models/business_model.dart';
import '../../../../../utils/globalVariable.dart';
import 'tabs/services_tab.dart';

class BusinessServicesOrdersPage extends StatefulWidget {
  final BusinessModel business;

  const BusinessServicesOrdersPage({
    super.key,
    required this.business,
  });

  @override
  State<BusinessServicesOrdersPage> createState() => _BusinessServicesOrdersPageState();
}

class _BusinessServicesOrdersPageState extends State<BusinessServicesOrdersPage> {
  final ServicesController servicesController = Get.put(ServicesController());
  final OrderController orderController = Get.put(OrderController());
  final PaymentController paymentController = Get.put(PaymentController());
  final ScrollController _scrollController = ScrollController();
  
  // Track pagination separately for each tab
  final RxInt servicesPage = 0.obs;
  final RxInt ordersPage = 0.obs;
  final RxInt transactionsPage = 0.obs;
  
  static const int itemsPerPage = 10;
  
  // Use RxInt to track selected index
  final RxInt selectedIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Initial load of data
    _loadInitialData();
  }
  
  void _loadInitialData() {
    // Load initial services data
    servicesController.fetchServicesForBusiness(
      widget.business.id!, servicesPage.value, itemsPerPage);
      
    // Preload orders data for smoother tab switching
    orderController.fetchBusinessOrders(
      widget.business.id!, ordersPage.value, itemsPerPage);
      
    // Preload transactions data for smoother tab switching
    paymentController.getPaymentsByBusinessId(widget.business.id!);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (selectedIndex.value == 0) {
        // Services tab - load more services
        _loadMoreServices();
      } else if (selectedIndex.value == 1) {
        // Orders tab - load more orders
        _loadMoreOrders();
      } else if (selectedIndex.value == 2) {
        // Transactions tab - load more transactions
        _loadMoreTransactions();
      }
    }
  }
  
  void _loadMoreServices() {
    servicesPage.value++;
    servicesController.fetchServicesForBusiness(
      widget.business.id!, servicesPage.value, itemsPerPage);
  }
  
  void _loadMoreOrders() {
    ordersPage.value++;
    orderController.fetchBusinessOrders(
      widget.business.id!, ordersPage.value, itemsPerPage);
  }
  
  void _loadMoreTransactions() {
    transactionsPage.value++;
    paymentController.getPaymentsByBusinessId(widget.business.id!);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: CustomText(
          text: widget.business.name,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab selector buttons
          Container(
            color: whiteColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => _buildTabButton(
                    0,
                    'Services',
                    Icons.business_center,
                  )),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() => _buildTabButton(
                    1,
                    'Orders',
                    Icons.receipt_long,
                  )),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() => _buildTabButton(
                    2,
                    'Transactions',
                    Icons.payments_outlined,
                  )),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: Obx(() {
              if (selectedIndex.value == 0) {
                return ServicesTab(
                  business: widget.business,
                  servicesController: servicesController,
                  scrollController: _scrollController,
                  onLoadMore: _loadMoreServices,
                );
              } else if (selectedIndex.value == 1) {
                return OrdersTab(
                  business: widget.business,
                  orderController: orderController,
                  scrollController: _scrollController,
                  onLoadMore: _loadMoreOrders,
                );
              } else {
                return TransactionsTab(
                  business: widget.business,
                  paymentController: paymentController,
                  scrollController: _scrollController,
                  onLoadMore: _loadMoreTransactions,
                );
              }
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabButton(int index, String title, IconData icon) {
    final bool isSelected = selectedIndex.value == index;
    
    return GestureDetector(
      onTap: () {
        selectedIndex.value = index;
        // Reset scroll position when switching tabs
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? firstColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: firstColor,
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? whiteColor : firstColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            CustomText(
              text: title,
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? whiteColor : firstColor,
            ),
          ],
        ),
      ),
    );
  }
} 