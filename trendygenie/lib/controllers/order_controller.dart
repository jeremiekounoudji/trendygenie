import 'dart:developer';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  // Access Supabase client with admin privileges for orders
  // This is a workaround for RLS issues
  final supabase = Supabase.instance.client;
  
  // Observables
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<OrderModel> recentOrders = <OrderModel>[].obs;
  final RxList<OrderModel> businessOrders = <OrderModel>[].obs;
  
  // Dashboard metrics
  final RxInt totalBusinesses = 0.obs;
  final RxInt totalOrders = 0.obs;
  final RxDouble totalAmountGenerated = 0.0.obs;
  final RxInt totalClients = 0.obs;

  // Fetch recent orders for a provider
  Future<bool> fetchRecentOrders(String providerId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await supabase
          .from('orders')
          .select('''
            *,
            customer:users!orders_customer_id_fkey(*),
            business:businesses!orders_business_id_fkey (
              *,
              company:companies!businesses_company_id_fkey (
                *,
                category:categories (
                  *
                )
              )
            ),
            service:services!orders_service_id_fkey (
              *
            )
          ''')
          .eq('business.company.owner_id', providerId)
          .order('order_date', ascending: false)
          .limit(10);

      final dataList = data as List;
      
      // Log for debugging
      log('Found ${dataList.length} orders');
      log('Found ${dataList.toString()} orders');
      
      // Even if we get empty data, it's still a successful response
      recentOrders.value = dataList
          .map((json) {
            try {
              log('dghdghgdhdghdError parsing order: ${json.runtimeType.toString()}');
              return OrderModel.fromJson(json);
            } catch (e) {
              log('dghdghgdhdghdError parsing order: $e');
              return null;
            }
          })
          .whereType<OrderModel>()
          .toList();

      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error fetching recent orders: $e');
      isLoading.value = false;
      error.value = 'Failed to fetch recent orders: $e';
      return false;
    }
  }

  // Fetch orders for a specific business with pagination
  Future<bool> fetchBusinessOrders(String businessId, int page, int limit, {String? status}) async {
    try {
      isLoading.value = true;
      error.value = '';

      var query = supabase.from('orders').select('*');

      // Apply filters
      query = query.eq('business_id', businessId);
      if (status != null) {
        query = query.eq('status', status);
      }

      // Apply order and range in one chain
      final data = await query
          .order('order_date', ascending: false)
          .range(page * limit, (page + 1) * limit - 1);

      final newOrders = (data as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();
      
      if (page == 0) {
        businessOrders.value = newOrders;
      } else {
        businessOrders.addAll(newOrders);
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error fetching business orders: $e');
      isLoading.value = false;
      error.value = 'Failed to fetch business orders: $e';
      return false;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status, {String? rejectionReason}) async {
    try {
      isLoading.value = true;
      error.value = '';

      final updateData = {
        'status': status.toString().split('.').last,
        if (rejectionReason != null) 'rejection_reason': rejectionReason,
      };

      await supabase
          .from('orders')
          .update(updateData)
          .eq('id', orderId);

      // Update the local order in the lists
      final recentIndex = recentOrders.indexWhere((order) => order.id == orderId);
      if (recentIndex != -1) {
        final updatedOrder = recentOrders[recentIndex].copyWith(
          status: status,
          rejectionReason: rejectionReason,
        );
        recentOrders[recentIndex] = updatedOrder;
      }

      final businessIndex = businessOrders.indexWhere((order) => order.id == orderId);
      if (businessIndex != -1) {
        final updatedOrder = businessOrders[businessIndex].copyWith(
          status: status,
          rejectionReason: rejectionReason,
        );
        businessOrders[businessIndex] = updatedOrder;
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error updating order status: $e');
      isLoading.value = false;
      error.value = 'Failed to update order status: $e';
      return false;
    }
  }

  // Fetch dashboard metrics for a provider
  Future<bool> fetchDashboardMetrics(String providerId) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Get total businesses count
      final businessesData = await supabase
          .from('companies')
          .select('id')
          .eq('owner_id', providerId);
      
      final businesses = businessesData as List;
      totalBusinesses.value = businesses.length;
      
      if (businesses.isEmpty) {
        totalOrders.value = 0;
        totalAmountGenerated.value = 0.0;
        totalClients.value = 0;
        isLoading.value = false;
        return true;
      }

      // Get metrics using the stored function
      final metricsData = await supabase
          .rpc('get_provider_metrics', params: {
            'provider_id': providerId,
          })
          .maybeSingle();
      
      if (metricsData == null) {
        totalOrders.value = 0;
        totalAmountGenerated.value = 0.0;
        totalClients.value = 0;
        isLoading.value = false;
        return true;
      }

      final metrics = metricsData as Map<String, dynamic>;
      
      // Handle type casting carefully
      totalOrders.value = (metrics['total_orders'] ?? 0).toInt();
      // Convert numeric amount to double
      totalAmountGenerated.value = (metrics['total_amount'] ?? 0).toDouble();
      totalClients.value = (metrics['unique_clients'] ?? 0).toInt();

      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error fetching dashboard metrics: $e');
      isLoading.value = false;
      error.value = 'Failed to fetch dashboard metrics: $e';
      return false;
    }
  }
} 