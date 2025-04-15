import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/order_controller.dart';
import '../../../controllers/services_controller.dart';
import '../../../models/company_model.dart';
import '../../../models/order_model.dart';
import '../../../models/service_item.dart';
import '../../../utils/globalVariable.dart';
import '../../../utils/utility.dart';
import '../../../widgets/general_widgets/common_button.dart';
import '../../../widgets/general_widgets/shimmer.dart';
import '../../../widgets/general_widgets/textfield.dart';
import 'add_service_page.dart';

class BusinessDetailPage extends StatefulWidget {
  final CompanyModel business;
  
  const BusinessDetailPage({
    Key? key,
    required this.business,
  }) : super(key: key);

  @override
  State<BusinessDetailPage> createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderController orderController = Get.put(OrderController());
  final ServicesController servicesController = Get.find<ServicesController>();
  final RxInt currentOrderPage = 0.obs;
  final RxInt currentServicePage = 0.obs;
  final int itemsPerPage = 10;
  final ScrollController _ordersScrollController = ScrollController();
  final ScrollController _servicesScrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
    
    _ordersScrollController.addListener(_onOrdersScroll);
    _servicesScrollController.addListener(_onServicesScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ordersScrollController.dispose();
    _servicesScrollController.dispose();
    super.dispose();
  }
  
  void _onOrdersScroll() {
    if (_ordersScrollController.position.pixels >= _ordersScrollController.position.maxScrollExtent - 200) {
      _loadMoreOrders();
    }
  }
  
  void _onServicesScroll() {
    if (_servicesScrollController.position.pixels >= _servicesScrollController.position.maxScrollExtent - 200) {
      _loadMoreServices();
    }
  }
  
  Future<void> _loadData() async {
    await orderController.fetchBusinessOrders(widget.business.id!, currentOrderPage.value, itemsPerPage);
    await servicesController.fetchServicesForBusiness(widget.business.id!, currentServicePage.value, itemsPerPage);
  }
  
  Future<void> _loadMoreOrders() async {
    if (!orderController.isLoading.value) {
      currentOrderPage.value++;
      await orderController.fetchBusinessOrders(widget.business.id!, currentOrderPage.value, itemsPerPage);
    }
  }
  
  Future<void> _loadMoreServices() async {
    if (!servicesController.isLoading.value) {
      currentServicePage.value++;
      await servicesController.fetchServicesForBusiness(widget.business.id!, currentServicePage.value, itemsPerPage);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: widget.business.name,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Get.back(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: firstColor,
          labelColor: firstColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Orders'),
            Tab(text: 'Services'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersTab(),
          _buildServicesTab(),
        ],
      ),
      floatingActionButton: Obx(() => _tabController.index == 1
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to add service for this business
                Get.to(() => AddServicePage(businessId: widget.business.id!));
              },
              backgroundColor: firstColor,
              child: const Icon(Icons.add),
            )
          : const SizedBox()),
    );
  }
  
  Widget _buildOrdersTab() {
    return RefreshIndicator(
      onRefresh: () async {
        currentOrderPage.value = 0;
        await orderController.fetchBusinessOrders(widget.business.id!, 0, itemsPerPage);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderFilters(),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (orderController.isLoading.value && orderController.businessOrders.isEmpty) {
                  return _buildOrdersLoadingShimmer();
                }
                
                if (orderController.businessOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        CustomText(
                          text: 'No orders found',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  controller: _ordersScrollController,
                  itemCount: orderController.businessOrders.length + (orderController.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == orderController.businessOrders.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(color: firstColor),
                        ),
                      );
                    }
                    return _buildOrderItem(orderController.businessOrders[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOrderFilters() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            hintText: 'Search orders',
            prefixIcon: Icon(Icons.search),
            radius: 8,
            onChanged: (value) {
              // Implement search functionality
            },
          ),
        ),
        const SizedBox(width: 16),
        PopupMenuButton<String>(
          icon: Icon(Icons.filter_list, color: firstColor),
          onSelected: (status) {
            // Filter orders by status
            currentOrderPage.value = 0;
            orderController.fetchBusinessOrders(
              widget.business.id!,
              0,
              itemsPerPage,
              status: status != 'all' ? status : null,
            );
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'all',
              child: Text('All Orders'),
            ),
            const PopupMenuItem(
              value: 'pending',
              child: Text('Pending'),
            ),
            const PopupMenuItem(
              value: 'accepted',
              child: Text('Accepted'),
            ),
            const PopupMenuItem(
              value: 'completed',
              child: Text('Completed'),
            ),
            const PopupMenuItem(
              value: 'rejected',
              child: Text('Rejected'),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildOrdersLoadingShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: LoadingShimmer(
          h: 120,
          w: double.infinity,
        ),
      ),
    );
  }
  
  Widget _buildOrderItem(OrderModel order) {
    final formatter = DateTime.now().difference(order.orderDate).inDays < 1
        ? 'Today'
        : DateTime.now().difference(order.orderDate).inDays < 2
            ? 'Yesterday'
            : '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}';
    
    // Define status color based on order status
    Color statusColor;
    switch (order.status) {
      case OrderStatus.pending:
        statusColor = Colors.orange;
        break;
      case OrderStatus.accepted:
        statusColor = firstColor;
        break;
      case OrderStatus.completed:
        statusColor = thirdColor;
        break;
      case OrderStatus.rejected:
        statusColor = redColor;
        break;
      case OrderStatus.cancelled:
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.grey;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: mediumBorder,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: 'Order #${order.id.substring(0, 8)}',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomText(
                        text: order.status.toString().split('.').last.capitalize!,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                CustomText(
                  text: formatter,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]!,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                CustomText(
                  text: order.customer?.fullName ?? 'Unknown Customer',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700]!,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.shopping_bag, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                CustomText(
                  text: order.service?.title ?? 'Unknown Service',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[700]!,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: '\$${order.totalAmount.toStringAsFixed(2)}',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: firstColor,
                ),
                if (order.status == OrderStatus.pending)
                  Row(
                    children: [
                      CommonButton(
                        text: 'Reject',
                        textColor: redColor,
                        bgColor: Colors.transparent,
                        haveBorder: true,
                        onTap: () => _showRejectOrderDialog(order),
                      ),
                      const SizedBox(width: 8),
                      CommonButton(
                        text: 'Accept',
                        textColor: whiteColor,
                        bgColor: firstColor,
                        onTap: () => _acceptOrder(order),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _acceptOrder(OrderModel order) async {
    final result = await orderController.updateOrderStatus(order.id, OrderStatus.accepted);
    if (result) {
      Get.find<Utility>().showSnack('Success', 'Order accepted successfully', 3);
    } else {
      Get.find<Utility>().showSnack('Error', orderController.error.value, 3, true);
    }
  }
  
  void _showRejectOrderDialog(OrderModel order) {
    final reasonController = TextEditingController();
    final isLoading = false.obs;
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: mediumBorder),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Reject Order',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: 'Please provide a reason for rejecting this order',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600]!,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: reasonController,
                hintText: 'Rejection reason',
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: CustomText(
                      text: 'Cancel',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700]!,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => CommonButton(
                    text: 'Reject Order',
                    textColor: whiteColor,
                    bgColor: redColor,
                    isLoading: isLoading,
                    onTap: () async {
                      if (reasonController.text.trim().isEmpty) {
                        Get.find<Utility>().showSnack('Error', 'Please provide a rejection reason', 3, true);
                        return;
                      }
                      
                      isLoading.value = true;
                      final result = await orderController.updateOrderStatus(
                        order.id,
                        OrderStatus.rejected,
                        rejectionReason: reasonController.text.trim(),
                      );
                      
                      isLoading.value = false;
                      if (result) {
                        Get.back();
                        Get.find<Utility>().showSnack('Success', 'Order rejected successfully', 3);
                      } else {
                        Get.find<Utility>().showSnack('Error', orderController.error.value, 3, true);
                      }
                    },
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildServicesTab() {
    return RefreshIndicator(
      onRefresh: () async {
        currentServicePage.value = 0;
        await servicesController.fetchServicesForBusiness(widget.business.id!, 0, itemsPerPage);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: 'Search services',
                    prefixIcon: Icon(Icons.search),
                    radius: 8,
                    onChanged: (value) {
                      // Implement search functionality
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (servicesController.isLoading.value && servicesController.services.isEmpty) {
                  return _buildServicesLoadingShimmer();
                }
                
                if (servicesController.services.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.room_service, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        CustomText(
                          text: 'No services found',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]!,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          text: 'Add services to your business',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  controller: _servicesScrollController,
                  itemCount: servicesController.services.length + (servicesController.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == servicesController.services.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(color: firstColor),
                        ),
                      );
                    }
                    return _buildServiceItem(servicesController.services[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildServicesLoadingShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: LoadingShimmer(
          h: 100,
          w: double.infinity,
        ),
      ),
    );
  }
  
  Widget _buildServiceItem(ServiceItem service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: mediumBorder,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: service.image.isNotEmpty
              ? Image.network(
                  service.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: firstColor.withOpacity(0.1),
                  child: Icon(Icons.room_service, color: firstColor),
                ),
        ),
        title: CustomText(
          text: service.title,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            CustomText(
              text: '\$${service.price.toStringAsFixed(2)}',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: firstColor,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.category, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                CustomText(
                  text: service.category.name,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600]!,
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: firstColor),
          onPressed: () {
            // Navigate to edit service page
            // Get.to(() => EditServicePage(service: service));
          },
        ),
        onTap: () {
          // Navigate to service details page
          // Get.to(() => ServiceDetailsPage(service: service));
        },
      ),
    );
  }
} 