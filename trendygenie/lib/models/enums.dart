enum UserType {
  customer,
  provider,
  admin;
  
}

enum CompanyStatus {
  pending,
  approved,
  rejected,
  suspended;
  
 
}

enum BusinessStatus {
  pending,
  active,
  rejected,
  suspended,
  removed,
  deleted;
} 

enum ServiceStatus {
  pending,
  active,
  rejected,
  suspended,
  deleted,
  requestDeletion;
} 

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
  cancelled,
  processing;
}

enum PaymentProvider {
  stripe,
  paypal,
  cash,
  bank_transfer,
  square,
  razorpay,
  flutterwave,
  mpesa,
  google_pay,
  apple_pay;
} 