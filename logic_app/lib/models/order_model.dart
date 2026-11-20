class OrderModel {
  final int id;
  final String orderNumber;
  final int? userId;
  final double totalAmount;
  final double setupCharge;
  final String status;
  final String? createdAt;
  final List<dynamic> items;
  final Map<String, dynamic>? customer;
  final String? erpOrderId;
  final String erpStatus;
  final String? notes;
  final String paymentMethod;
  final String paymentStatus;

  OrderModel({
    required this.id,
    required this.orderNumber,
    this.userId,
    required this.totalAmount,
    this.setupCharge = 0.0,
    required this.status,
    this.createdAt,
    this.items = const [],
    this.customer,
    this.erpOrderId,
    this.erpStatus = 'local',
    this.notes,
    this.paymentMethod = 'ERP Direct / Invoiced',
    this.paymentStatus = 'pending',
  });

  bool get isCompleted => status == 'completed' || status == 'active';
  bool get isSynced => erpStatus == 'synced' || (erpOrderId != null && erpOrderId!.isNotEmpty);

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? cust;
    if (json['user'] is Map) {
      cust = Map<String, dynamic>.from(json['user']);
    } else if (json['customer'] is Map) {
      cust = Map<String, dynamic>.from(json['customer']);
    } else if (json['metadata'] is Map && json['metadata']['customer'] is Map) {
      cust = Map<String, dynamic>.from(json['metadata']['customer']);
    }

    String? erpId = json['erp_order_id']?.toString();
    if (erpId == null && json['metadata'] is Map) {
      erpId = json['metadata']['erp_response']?['erp_order_id']?.toString() ??
          json['metadata']['erp_raw']?['id']?.toString();
    }

    return OrderModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      orderNumber: json['order_number']?.toString() ?? 'ORD-${json['id']}',
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? ''),
      totalAmount: _toDouble(json['total_amount'] ?? json['total']),
      setupCharge: _toDouble(json['setup_charge'] ?? 0.0),
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString(),
      items: json['items'] is List ? json['items'] : [],
      customer: cust,
      erpOrderId: erpId,
      erpStatus: json['erp_status']?.toString() ?? (erpId != null ? 'synced' : 'local'),
      notes: json['customer_notes']?.toString() ?? json['notes']?.toString(),
      paymentMethod: json['payment_method']?.toString() ?? 'ERP Direct / Invoiced',
      paymentStatus: json['payment_status']?.toString() ?? 'pending',
    );
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }
}
