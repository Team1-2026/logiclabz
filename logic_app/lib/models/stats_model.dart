class AdminStatsModel {
  final int totalOrders;
  final int totalProducts;
  final int totalInvoices;
  final int totalCustomers;
  final double totalRevenue;
  final double pendingRevenue;
  final bool erpConnected;

  AdminStatsModel({
    this.totalOrders = 0,
    this.totalProducts = 0,
    this.totalInvoices = 0,
    this.totalCustomers = 0,
    this.totalRevenue = 0.0,
    this.pendingRevenue = 0.0,
    this.erpConnected = false,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalOrders: _toInt(json['total_orders'] ?? json['orders_count']),
      totalProducts: _toInt(json['total_products'] ?? json['products_count']),
      totalInvoices: _toInt(json['total_invoices'] ?? json['invoices_count']),
      totalCustomers: _toInt(json['total_customers'] ?? json['customers_count']),
      totalRevenue: _toDouble(json['total_revenue'] ?? json['revenue']),
      pendingRevenue: _toDouble(json['pending_revenue'] ?? json['receivables']),
      erpConnected: json['erp_connected'] == true,
    );
  }

  static int _toInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    return int.tryParse(val.toString()) ?? 0;
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }
}
