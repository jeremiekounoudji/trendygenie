import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/company_controller.dart';
import '../../../../controllers/payment_controller.dart';
import '../../../../models/enums.dart';
import '../../../../models/payment_model.dart';
import '../../../../utils/globalVariable.dart';
import '../../../../widgets/general_widgets/shimmer.dart';
import '../../../../widgets/payment_card/payment_card.dart';
import 'package:flutter_popup/flutter_popup.dart';
import '../../sections/services/widgets/transactions_widget/index.dart';

class TransactionsSection extends StatefulWidget {
  const TransactionsSection({super.key});

  @override
  State<TransactionsSection> createState() => _TransactionsSectionState();
}

class _TransactionsSectionState extends State<TransactionsSection> {
  final PaymentController paymentController = Get.put(PaymentController());
  final CompanyController companyController = Get.find<CompanyController>();
  final ScrollController _scrollController = ScrollController();
  
  final RxString selectedFilter = 'all'.obs;
  final RxString selectedDateRange = 'all'.obs;
  final RxBool isLoading = false.obs;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }
  
  Future<void> _loadInitialData() async {
    if (companyController.company.value?.id == null) {
      await companyController.fetchCompany();
    }
    
    if (companyController.company.value?.id != null) {
      final companyId = companyController.company.value!.id!;
      await paymentController.getPaymentsByCompanyId(companyId, refresh: true);
      await paymentController.getPaymentMetrics(companyId, isCompany: true);
    }
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreTransactions();
    }
  }
  
  void _loadMoreTransactions() {
    if (companyController.company.value?.id != null && !paymentController.isLoading.value) {
      final companyId = companyController.company.value!.id!;
      paymentController.getPaymentsByCompanyId(companyId);
    }
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
   
      body: RefreshIndicator(
      onRefresh: _loadInitialData,
      child: Obx(() {
        // Check if company data is loaded
        if (companyController.isLoading.value && companyController.company.value == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        // If no company found, show a message
        if (companyController.company.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business_outlined, size: 72, color: Colors.grey[400]),
                const SizedBox(height: 16),
                CustomText(
                  text: 'No company found',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]!,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _loadInitialData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: firstColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }
        
        // Make the entire content scrollable
        return SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildDashboardMetrics(),
                const SizedBox(height: 16),
                _buildFilterBar(),
                const SizedBox(height: 16),
                _buildTransactionsList(),
                // Add loading indicator at the bottom
                if (paymentController.isLoading.value && paymentController.hasMoreData.value)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(color: firstColor),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    )   
    );
  }
  
  Widget _buildHeader() {
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
  
  Widget _buildDashboardMetrics() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Revenue',
                    '\$${paymentController.totalRevenue.value.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Transaction Fees',
                    '\$${paymentController.totalFees.value.toStringAsFixed(2)}',
                    Icons.account_balance,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Transactions',
                    paymentController.totalTransactions.value.toString(),
                    Icons.receipt_long,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Pending Transactions',
                    paymentController.pendingTransactions.value.toString(),
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
  
  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return MetricCard(
      title: title,
      value: value,
      icon: icon,
      color: color,
    );
  }
  
  Widget _buildFilterBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Transactions History',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
            
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Date filter button
                CustomPopup(
                  content: Builder(
                    builder: (context) {
                      return Container(
                        width: 200,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Filter by Date',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                            ),
                            const SizedBox(height: 12),
                            _buildDateOptionItem('All Time', 'all', () {
                              Navigator.of(context).pop();
                            }),
                            _buildDateOptionItem('Today', 'today', () {
                              Navigator.of(context).pop();
                            }),
                            _buildDateOptionItem('This Week', 'week', () {
                              Navigator.of(context).pop();
                            }),
                            _buildDateOptionItem('This Month', 'month', () {
                              Navigator.of(context).pop();
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.date_range, color: firstColor, size: 20),
                        const SizedBox(width: 4),
                        CustomText(
                          text: _getDateRangeText(),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Status filter button
                CustomPopup(
                  content: Builder(
                    builder: (context) {
                      return Container(
                        width: 200,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            const SizedBox(height: 12),
                            _buildStatusOptionItem('All', 'all', null, () {
                              Navigator.of(context).pop();
                            }),
                            ...PaymentStatus.values.map((status) {
                              return _buildStatusOptionItem(
                                _getFormattedStatus(status),
                                status.name.toLowerCase(),
                                _getStatusColor(status),
                                () {
                                  Navigator.of(context).pop();
                                },
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list, color: firstColor, size: 20),
                        const SizedBox(width: 4),
                        CustomText(
                          text: _getStatusFilterText(),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ],
    );
  }
  
  Widget _buildDateOptionItem(String label, String value, VoidCallback hidePopup) {
    return DateOptionItem(
      label: label,
      value: value,
      hidePopup: hidePopup,
      selectedValue: selectedDateRange.value,
      onValueChanged: (val) => selectedDateRange.value = val,
      onLoadInitialData: _loadInitialData,
    );
  }
  
  Widget _buildStatusOptionItem(String label, String value, Color? color, VoidCallback hidePopup) {
    return StatusOptionItem(
      label: label,
      value: value,
      color: color,
      hidePopup: hidePopup,
      selectedValue: selectedFilter.value,
      onValueChanged: (val) => selectedFilter.value = val,
    );
  }
  
  String _getDateRangeText() {
    switch (selectedDateRange.value) {
      case 'today':
        return 'Today';
      case 'week':
        return 'This Week';
      case 'month':
        return 'This Month';
      default:
        return 'All Time';
    }
  }
  
  String _getStatusFilterText() {
    if (selectedFilter.value == 'all') {
      return 'All Status';
    } else {
      // Capitalize first letter
      return selectedFilter.value[0].toUpperCase() + selectedFilter.value.substring(1);
    }
  }
  
  Widget _buildTransactionsList() {
    final filteredPayments = _getFilteredPayments();
    
    if (paymentController.isLoading.value && paymentController.payments.isEmpty) {
      return _buildLoadingState();
    }
    
    if (filteredPayments.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              CustomText(
                text: 'No transactions found matching your filters',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  selectedFilter.value = 'all';
                  selectedDateRange.value = 'all';
                  _loadInitialData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: firstColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      children: filteredPayments.map((payment) => PaymentCard(
        payment: payment, 
        onUpdateStatus: _updatePaymentStatus,
      )).toList(),
    );
  }
  
  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        3,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: LoadingShimmer(
            h: 120,
            w: double.infinity,
          ),
        ),
      ),
    );
  }
  
  void _updatePaymentStatus(String paymentId, PaymentStatus newStatus) {
    paymentController.updatePaymentStatus(paymentId, newStatus).then((success) {
      if (success) {
        // Refresh metrics
        if (companyController.company.value?.id != null) {
          paymentController.getPaymentMetrics(
            companyController.company.value!.id!, 
            isCompany: true
          );
        }
      }
    });
  }
  
  List<PaymentModel> _getFilteredPayments() {
    // First filter by status
    List<PaymentModel> statusFiltered = selectedFilter.value == 'all'
        ? paymentController.payments
        : paymentController.payments.where((payment) {
            return payment.status.name.toLowerCase() == selectedFilter.value.toLowerCase();
          }).toList();
    
    // Then filter by date range
    if (selectedDateRange.value == 'all') {
      return statusFiltered;
    }
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return statusFiltered.where((payment) {
      final paymentDate = DateTime(
        payment.createdAt.year, 
        payment.createdAt.month, 
        payment.createdAt.day
      );
      
      if (selectedDateRange.value == 'today') {
        return paymentDate.isAtSameMomentAs(today);
      } else if (selectedDateRange.value == 'week') {
        final weekStart = today.subtract(Duration(days: today.weekday - 1));
        return paymentDate.isAfter(weekStart.subtract(const Duration(days: 1))) && 
               paymentDate.isBefore(weekStart.add(const Duration(days: 7)));
      } else if (selectedDateRange.value == 'month') {
        return paymentDate.year == today.year && paymentDate.month == today.month;
      }
      
      return true;
    }).toList();
  }
  
  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.processing:
        return Colors.blue;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.refunded:
        return Colors.purple;
      case PaymentStatus.cancelled:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getFormattedStatus(PaymentStatus status) {
    return status.name[0].toUpperCase() + status.name.substring(1);
  }

} 