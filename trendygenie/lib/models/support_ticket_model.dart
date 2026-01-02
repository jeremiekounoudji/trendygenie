class SupportTicket {
  final String? id;
  final String subject;
  final String message;
  final String status;
  final String providerId;
  final DateTime createdAt;
  final List<TicketReply>? replies;

  SupportTicket({
    this.id,
    required this.subject,
    required this.message,
    this.status = 'open',
    required this.providerId,
    DateTime? createdAt,
    this.replies,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'],
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? 'open',
      providerId: json['provider_id'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      replies: json['replies'] != null
          ? List<TicketReply>.from(
              json['replies'].map((x) => TicketReply.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'message': message,
      'status': status,
      'provider_id': providerId,
      'created_at': createdAt.toIso8601String(),
      'replies': replies?.map((x) => x.toJson()).toList(),
    };
  }
}

class TicketReply {
  final String? id;
  final String message;
  final String userId;
  final bool isAdmin;
  final DateTime createdAt;

  TicketReply({
    this.id,
    required this.message,
    required this.userId,
    this.isAdmin = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory TicketReply.fromJson(Map<String, dynamic> json) {
    return TicketReply(
      id: json['id'],
      message: json['message'] ?? '',
      userId: json['user_id'] ?? '',
      isAdmin: json['is_admin'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'user_id': userId,
      'is_admin': isAdmin,
      'created_at': createdAt.toIso8601String(),
    };
  }
} 