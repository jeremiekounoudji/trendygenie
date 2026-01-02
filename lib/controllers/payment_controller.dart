import 'dart:developer';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment_model.dart';
import '../models/enums.dart';
import '../utils/utility.dart';

class PaymentController extends GetxController {
  // Access Supabase client
  final supabase = Supabase.instance.client;
  final utility = Get.put(Utility());
  
  // Observables
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<PaymentModel> payments = <PaymentModel>[].obs;
  
  // Pagination control
  final RxInt currentPage = 0.obs;
  final RxBool hasMoreData = true.obs;
  final int itemsPerPage = 10;
  
  // Payment metrics
  final RxDouble totalRevenue = 0.0.obs;
  final RxDouble totalFees = 0.0.obs;
  final RxInt totalTransactions = 0.obs;
  final RxInt pendingTransactions = 0.obs;

  // Create a new payment
  Future<bool> createPayment({
    required String orderId,
    required String customerId,
    String? businessId,
    String? companyId,
    required double amount,
    String currency = 'USD',
    required String paymentMethod,
    required PaymentProvider paymentProvider,
    String? providerPaymentId,
    PaymentStatus status = PaymentStatus.pending,
    double transactionFee = 0.0,
    String? description,
    String? receiptUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final paymentData = {
        'order_id': orderId,
        'customer_id': customerId,
        'amount': amount,
        'currency': currency,
        'payment_method': paymentMethod,
        'payment_provider': paymentProvider.name,
        'status': status.name,
        'transaction_fee': transactionFee,
        'description': description,
        'receipt_url': receiptUrl,
        'metadata': metadata,
      };

      // Add optional fields if not null
      if (businessId != null) paymentData['business_id'] = businessId;
      if (companyId != null) paymentData['company_id'] = companyId;
      if (providerPaymentId != null) paymentData['provider_payment_id'] = providerPaymentId;

      final data = await supabase
          .from('payments')
          .insert(paymentData)
          .select()
          .single();

      final newPayment = PaymentModel.fromJson(data);
      payments.insert(0, newPayment); // Add to the beginning of the list
      
      // Show success message
      utility.showSnack('Success', 'Payment created successfully', 3);
      
      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error creating payment: $e');
      isLoading.value = false;
      error.value = 'Failed to create payment: $e';
      
      // Show error message
      utility.showSnack('Error', 'Failed to create payment: $e', 3, true);
      
      return false;
    }
  }

  // Get paginated payments by business ID
  Future<bool> getPaymentsByBusinessId(String businessId, {bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        hasMoreData.value = true;
        payments.clear();
      }
      
      if (!hasMoreData.value) return true; // No more data to fetch
      
      isLoading.value = true;
      error.value = '';

      final data = await supabase
          .from('payments')
          .select('''
            *,
            order:orders!order_id(*),
            customer:users!customer_id(*),
            business:businesses!business_id(*),
            company:companies!company_id(*)
          ''')
          .eq('business_id', businessId)
          .order('created_at', ascending: false)
          .range(currentPage.value * itemsPerPage, (currentPage.value + 1) * itemsPerPage - 1);

      final dataList = data as List;
      
      if (dataList.isEmpty) {
        hasMoreData.value = false;
      } else {
        final newPayments = dataList
            .map((json) => PaymentModel.fromJson(json))
            .toList();
        
        payments.addAll(newPayments);
        currentPage.value++; // Increment page for next fetch
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error fetching payments by business ID: $e');
      isLoading.value = false;
      error.value = 'Failed to fetch payments: $e';
      return false;
    }
  }

  // Get paginated payments by company ID
  Future<bool> getPaymentsByCompanyId(String companyId, {bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        hasMoreData.value = true;
        payments.clear();
      }
      
      if (!hasMoreData.value) return true; // No more data to fetch
      
      isLoading.value = true;
      error.value = '';
      log('companyId from payment controller: $companyId');


      final data = await supabase
          .from('payments')
          .select('''
            *,
            order:orders!order_id(*),
            customer:users!customer_id(*),
            business:businesses!business_id(*),
            company:companies!company_id(*)
          ''')
          .eq('company_id', companyId)
          .order('created_at', ascending: false)
          .range(currentPage.value * itemsPerPage, (currentPage.value + 1) * itemsPerPage - 1);

      log('response from payment controller: $data');

      final dataList = data as List;
      
      if (dataList.isEmpty) {
        hasMoreData.value = false;
      } else {
        final newPayments = dataList
            .map((json) => PaymentModel.fromJson(json))
            .toList();
        
        payments.addAll(newPayments);
        currentPage.value++; // Increment page for next fetch
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error fetching payments by company ID: $e');
      isLoading.value = false;
      error.value = 'Failed to fetch payments: $e';
      return false;
    }
  }

  // Update payment status
  Future<bool> updatePaymentStatus(String paymentId, PaymentStatus status) async {
    try {
      isLoading.value = true;
      error.value = '';

      await supabase
          .from('payments')
          .update({'status': status.name})
          .eq('id', paymentId);

      // Update the local payment in the list
      final index = payments.indexWhere((payment) => payment.id == paymentId);
      if (index != -1) {
        final updatedPayment = payments[index].copyWith(status: status);
        payments[index] = updatedPayment;
      }

      // Show success message
      utility.showSnack('Success', 'Payment status updated successfully', 3);
      
      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error updating payment status: $e');
      isLoading.value = false;
      error.value = 'Failed to update payment status: $e';
      
      // Show error message
      utility.showSnack('Error', 'Failed to update payment status: $e', 3, true);
      
      return false;
    }
  }
  
  // Get payment metrics
  Future<bool> getPaymentMetrics(String entityId, {bool isCompany = false}) async {
    try {
      isLoading.value = true;
      error.value = '';

      final queryField = isCompany ? 'company_id' : 'business_id';
      
      // Get total revenue
      final revenueData = await supabase
          .from('payments')
          .select('amount')
          .eq(queryField, entityId)
          .eq('status', PaymentStatus.completed.name);
      
      final revenueList = revenueData as List;
      totalRevenue.value = revenueList.fold(0.0, (sum, item) => sum + (double.tryParse(item['amount'].toString()) ?? 0.0));
      
      // Get total transaction fees
      final feesData = await supabase
          .from('payments')
          .select('transaction_fee')
          .eq(queryField, entityId)
          .eq('status', PaymentStatus.completed.name);
      
      final feesList = feesData as List;
      totalFees.value = feesList.fold(0.0, (sum, item) => sum + (double.tryParse(item['transaction_fee'].toString()) ?? 0.0));
      
      // Get total transactions count
      final transactionsData = await supabase
          .from('payments')
          .select()
          .eq(queryField, entityId);
      
      totalTransactions.value = (transactionsData as List).length;
      
      // Get pending transactions count
      final pendingData = await supabase
          .from('payments')
          .select()
          .eq(queryField, entityId)
          .eq('status', PaymentStatus.pending.name);
      
      pendingTransactions.value = (pendingData as List).length;

      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error fetching payment metrics: $e');
      isLoading.value = false;
      error.value = 'Failed to fetch payment metrics: $e';
      return false;
    }
  }
} 