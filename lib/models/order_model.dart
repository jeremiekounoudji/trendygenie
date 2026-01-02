import 'company_model.dart';
import 'service_item.dart';
import 'user_model.dart';

enum OrderStatus {
  pending,
  accepted,
  rejected,
  completed,
  cancelled
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded
}

class OrderModel {
  final String id;
  final String customerId;
  final String businessId;
  final String serviceId;
  final DateTime orderDate;
  final double totalAmount;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Related entities
  final UserModel? customer;
  final CompanyModel? business;
  final ServiceItem? service;
  
  OrderModel({
    required this.id,
    required this.customerId,
    required this.businessId,
    required this.serviceId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.rejectionReason,
    this.customer,
    this.business,
    this.service,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse DateTime
    DateTime parseDateTime(String? dateStr) {
      if (dateStr == null) return DateTime.now();
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return DateTime.now();
      }
    }

    // Helper function to safely parse double
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // Simple status mapping
    OrderStatus getOrderStatus(String? status) {
      switch(status?.toLowerCase()) {
        case 'pending': return OrderStatus.pending;
        case 'accepted': return OrderStatus.accepted;
        case 'rejected': return OrderStatus.rejected;
        case 'completed': return OrderStatus.completed;
        case 'cancelled': return OrderStatus.cancelled;
        default: return OrderStatus.pending;
      }
    }

    // Simple payment status mapping
    PaymentStatus getPaymentStatus(String? status) {
      switch(status?.toLowerCase()) {
        case 'completed': return PaymentStatus.completed;
        case 'failed': return PaymentStatus.failed;
        case 'refunded': return PaymentStatus.refunded;
        default: return PaymentStatus.pending;
      }
    }

    return OrderModel(
      id: json['id']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      businessId: json['business_id']?.toString() ?? '',
      serviceId: json['service_id']?.toString() ?? '',
      orderDate: parseDateTime(json['order_date']?.toString()),
      totalAmount: parseDouble(json['total_amount']),
      status: getOrderStatus(json['status']?.toString()),
      paymentStatus: getPaymentStatus(json['payment_status']?.toString()),
      createdAt: parseDateTime(json['created_at']?.toString()),
      updatedAt: parseDateTime(json['updated_at']?.toString()),
      rejectionReason: json['rejection_reason']?.toString(),
      customer: json['customer'] != null 
          ? UserModel.fromJson(Map<String, dynamic>.from(json['customer']))
          : null,
      business: json['business'] != null 
          ? CompanyModel.fromJson(Map<String, dynamic>.from(json['business']))
          : null,
      service: json['service'] != null 
          ? ServiceItem.fromJson(Map<String, dynamic>.from(json['service']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'business_id': businessId,
      'service_id': serviceId,
      'order_date': orderDate.toIso8601String(),
      'total_amount': totalAmount,
      'status': status.name, // Using enum name directly
      'payment_status': paymentStatus.name, // Using enum name directly
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? businessId,
    String? serviceId,
    DateTime? orderDate,
    double? totalAmount,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? customer,
    CompanyModel? business,
    ServiceItem? service,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      businessId: businessId ?? this.businessId,
      serviceId: serviceId ?? this.serviceId,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      customer: customer ?? this.customer,
      business: business ?? this.business,
      service: service ?? this.service,
    );
  }
} 