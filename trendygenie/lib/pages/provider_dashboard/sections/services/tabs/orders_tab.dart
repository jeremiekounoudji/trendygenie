import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/order_controller.dart';
import '../../../../../models/business_model.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../widgets/general_widgets/shimmer.dart';
import '../../../../../widgets/order/order_card.dart';

class OrdersTab extends StatefulWidget {
  final BusinessModel business;
  final OrderController orderController;
  final ScrollController scrollController;
  final Function onLoadMore;

  const OrdersTab({
    super.key,
    required this.business,
    required this.orderController,
    required this.scrollController,
    required this.onLoadMore,
  });

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: widget.orderController.fetchBusinessOrders(widget.business.id!, 0, 10),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        return Obx(() {
          if (widget.orderController.businessOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, 
                    size: 64, 
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  CustomText(
                    text: 'No orders available',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]!,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: widget.orderController.businessOrders.length + 1,
            itemBuilder: (context, index) {
              if (index == widget.orderController.businessOrders.length) {
                return widget.orderController.isLoading.value
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: LoadingShimmer(h: 4, w: 40),
                      ),
                    )
                  : const SizedBox.shrink();
              }
              
              final order = widget.orderController.businessOrders[index];
              return OrderCard(
                order: order,
                onTap: () {
                  // Navigate to order details
                },
              );
            },
          );
        });
      },
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
            h: 100,
            w: double.infinity,
          ),
        );
      },
    );
  }
} 