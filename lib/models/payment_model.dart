import 'dart:convert' as convert;
import 'enums.dart';
import 'order_model.dart' hide PaymentStatus; // Hide PaymentStatus from order_model
import 'user_model.dart';
import 'business_model.dart';
import 'company_model.dart';

class PaymentModel {
  final String id;
  final String orderId;
  final String customerId;
  final String? businessId;
  final String? companyId;
  final double amount;
  final String currency;
  final String paymentMethod;
  final PaymentProvider paymentProvider;
  final String? providerPaymentId;
  final PaymentStatus status;
  final double transactionFee;
  final String? description;
  final String? receiptUrl;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Related entities
  final OrderModel? order;
  final UserModel? customer;
  final BusinessModel? business;
  final CompanyModel? company;

  PaymentModel({
    required this.id,
    required this.orderId,
    required this.customerId,
    this.businessId,
    this.companyId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.paymentProvider,
    this.providerPaymentId,
    required this.status,
    required this.transactionFee,
    this.description,
    this.receiptUrl,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.order,
    this.customer,
    this.business,
    this.company,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
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

    // Parse payment provider
    PaymentProvider getPaymentProvider(String? provider) {
      switch(provider?.toLowerCase()) {
        case 'stripe': return PaymentProvider.stripe;
        case 'paypal': return PaymentProvider.paypal;
        case 'bank_transfer': return PaymentProvider.bank_transfer;
        case 'square': return PaymentProvider.square;
        case 'razorpay': return PaymentProvider.razorpay;
        case 'flutterwave': return PaymentProvider.flutterwave;
        case 'mpesa': return PaymentProvider.mpesa;
        case 'google_pay': return PaymentProvider.google_pay;
        case 'apple_pay': return PaymentProvider.apple_pay;
        default: return PaymentProvider.cash;
      }
    }

    // Parse payment status
    PaymentStatus getPaymentStatus(String? status) {
      switch(status?.toLowerCase()) {
        case 'completed': return PaymentStatus.completed;
        case 'failed': return PaymentStatus.failed;
        case 'refunded': return PaymentStatus.refunded;
        case 'cancelled': return PaymentStatus.cancelled;
        case 'processing': return PaymentStatus.processing;
        default: return PaymentStatus.pending;
      }
    }

    // Parse metadata
    Map<String, dynamic>? parseMetadata(dynamic data) {
      if (data == null) return null;
      if (data is Map) return Map<String, dynamic>.from(data);
      if (data is String) {
        try {
          return convert.json.decode(data) as Map<String, dynamic>;
        } catch (_) {
          return null;
        }
      }
      return null;
    }

    return PaymentModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      businessId: json['business_id']?.toString(),
      companyId: json['company_id']?.toString(),
      amount: parseDouble(json['amount']),
      currency: json['currency']?.toString() ?? 'USD',
      paymentMethod: json['payment_method']?.toString() ?? 'cash',
      paymentProvider: getPaymentProvider(json['payment_provider']?.toString()),
      providerPaymentId: json['provider_payment_id']?.toString(),
      status: getPaymentStatus(json['status']?.toString()),
      transactionFee: parseDouble(json['transaction_fee']),
      description: json['description']?.toString(),
      receiptUrl: json['receipt_url']?.toString(),
      metadata: parseMetadata(json['metadata']),
      createdAt: parseDateTime(json['created_at']?.toString()),
      updatedAt: parseDateTime(json['updated_at']?.toString()),
      order: json['order'] != null 
          ? OrderModel.fromJson(Map<String, dynamic>.from(json['order']))
          : null,
      customer: json['customer'] != null 
          ? UserModel.fromJson(Map<String, dynamic>.from(json['customer']))
          : null,
      business: json['business'] != null 
          ? BusinessModel.fromJson(Map<String, dynamic>.from(json['business']))
          : null,
      company: json['company'] != null 
          ? CompanyModel.fromJson(Map<String, dynamic>.from(json['company']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'id': id,
      'order_id': orderId,
      'customer_id': customerId,
      'amount': amount,
      'currency': currency,
      'payment_method': paymentMethod,
      'payment_provider': paymentProvider.name,
      'status': status.name,
      'transaction_fee': transactionFee,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };

    // Add optional fields if not null
    if (businessId != null) data['business_id'] = businessId;
    if (companyId != null) data['company_id'] = companyId;
    if (providerPaymentId != null) data['provider_payment_id'] = providerPaymentId;
    if (description != null) data['description'] = description;
    if (receiptUrl != null) data['receipt_url'] = receiptUrl;
    if (metadata != null) data['metadata'] = metadata;

    return data;
  }

  PaymentModel copyWith({
    String? id,
    String? orderId,
    String? customerId,
    String? businessId,
    String? companyId,
    double? amount,
    String? currency,
    String? paymentMethod,
    PaymentProvider? paymentProvider,
    String? providerPaymentId,
    PaymentStatus? status,
    double? transactionFee,
    String? description,
    String? receiptUrl,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    OrderModel? order,
    UserModel? customer,
    BusinessModel? business,
    CompanyModel? company,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      businessId: businessId ?? this.businessId,
      companyId: companyId ?? this.companyId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentProvider: paymentProvider ?? this.paymentProvider,
      providerPaymentId: providerPaymentId ?? this.providerPaymentId,
      status: status ?? this.status,
      transactionFee: transactionFee ?? this.transactionFee,
      description: description ?? this.description,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      order: order ?? this.order,
      customer: customer ?? this.customer,
      business: business ?? this.business,
      company: company ?? this.company,
    );
  }
} 