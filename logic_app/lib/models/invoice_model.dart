class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double total;

  InvoiceItem({
    required this.description,
    this.quantity = 1,
    required this.unitPrice,
    required this.total,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      description: json['description']?.toString() ?? 'Service Item',
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      unitPrice: _toDouble(json['unit_price'] ?? json['price']),
      total: _toDouble(json['total'] ?? json['amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total': total,
    };
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }
}

class InvoiceModel {
  final int id;
  final String invoiceNumber;
  final int? userId;
  final int? orderId;
  final double amount;
  final double taxAmount;
  final double totalAmount;
  final String currency;
  final String status; // 'paid' | 'unpaid' | 'overdue'
  final String? paymentMethod;
  final String? erpInvoiceId;
  final String erpStatus; // 'synced' | 'local'
  final String? dueDate;
  final String? paidAt;
  final String? createdAt;
  final String? notes;
  final String? documentKind; // 'tax_invoice' | 'proforma'
  final String? invoiceType; // 'export' | 'b2c' | 'b2b'
  final double? paidAmount;
  final double? balanceAmount;
  final List<InvoiceItem> items;
  final Map<String, dynamic>? customer;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    this.userId,
    this.orderId,
    required this.amount,
    required this.taxAmount,
    required this.totalAmount,
    this.currency = 'INR',
    required this.status,
    this.paymentMethod,
    this.erpInvoiceId,
    this.erpStatus = 'local',
    this.dueDate,
    this.paidAt,
    this.createdAt,
    this.notes,
    this.documentKind,
    this.invoiceType,
    this.paidAmount,
    this.balanceAmount,
    this.items = const [],
    this.customer,
  });

  bool get isPaid => status.toLowerCase() == 'paid';
  bool get isSynced => erpStatus.toLowerCase() == 'synced';
  bool get isProforma => (documentKind?.toLowerCase() == 'proforma') || invoiceNumber.startsWith('PF-');

  double get cgst => taxAmount / 2.0;
  double get sgst => taxAmount / 2.0;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    List<InvoiceItem> parsedItems = [];
    final rawItems = json['items_data'] ?? json['items'];
    if (rawItems is List) {
      parsedItems = rawItems
          .whereType<Map>()
          .map((i) => InvoiceItem.fromJson(Map<String, dynamic>.from(i)))
          .toList();
    } else if (rawItems is Map && rawItems['items'] is List) {
      parsedItems = (rawItems['items'] as List)
          .whereType<Map>()
          .map((i) => InvoiceItem.fromJson(Map<String, dynamic>.from(i)))
          .toList();
    }

    final subtotal = InvoiceItem._toDouble(json['subtotal'] ?? json['amount'] ?? json['sub_total']);
    final tax = InvoiceItem._toDouble(json['tax_amount'] ?? json['tax_total'] ?? json['tax']);
    final grandTotal = InvoiceItem._toDouble(json['grand_total'] ?? json['total_amount'] ?? (subtotal + tax));
    final paid = InvoiceItem._toDouble(json['paid_amount'] ?? (json['items_data'] is Map ? json['items_data']['paid_amount'] : null));
    final balance = InvoiceItem._toDouble(json['balance_amount'] ?? (json['items_data'] is Map ? json['items_data']['balance_amount'] : null));

    String parsedStatus = 'unpaid';
    final rawStatus = json['status'];
    if (rawStatus is Map) {
      final slug = rawStatus['slug']?.toString().toLowerCase() ?? '';
      final name = rawStatus['name']?.toString().toLowerCase() ?? '';
      if ((slug.contains('paid') && !slug.contains('unpaid')) ||
          (name.contains('paid') && !name.contains('unpaid'))) {
        parsedStatus = 'paid';
      } else {
        parsedStatus = 'unpaid';
      }
    } else if (rawStatus != null && rawStatus.toString().isNotEmpty) {
      parsedStatus = rawStatus.toString().toLowerCase();
    } else {
      if (paid > 0 && balance == 0) {
        parsedStatus = 'paid';
      } else if (paid >= grandTotal && grandTotal > 0) {
        parsedStatus = 'paid';
      } else {
        parsedStatus = 'unpaid';
      }
    }

    final docKind = json['document_kind']?.toString() ??
        (json['items_data'] is Map ? json['items_data']['document_kind']?.toString() : null);

    final invType = json['invoice_type']?.toString() ??
        (json['items_data'] is Map ? json['items_data']['invoice_type']?.toString() : null);

    Map<String, dynamic>? parsedCustomer;
    if (json['customer'] is Map) {
      parsedCustomer = Map<String, dynamic>.from(json['customer']);
    } else if (json['user'] is Map) {
      parsedCustomer = Map<String, dynamic>.from(json['user']);
    } else if (json['items_data'] is Map && json['items_data']['customer'] is Map) {
      parsedCustomer = Map<String, dynamic>.from(json['items_data']['customer']);
    }

    final rawId = json['id'];
    int parsedId = 0;
    if (rawId is int) {
      parsedId = rawId;
    } else if (rawId != null) {
      parsedId = int.tryParse(rawId.toString()) ?? 0;
    }

    final erpId = json['erp_invoice_id']?.toString() ??
        (rawId is String && rawId.length > 10 ? rawId : null);

    return InvoiceModel(
      id: parsedId,
      invoiceNumber: json['invoice_number']?.toString() ?? 'INV-000',
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? ''),
      orderId: json['order_id'] is int ? json['order_id'] : int.tryParse(json['order_id']?.toString() ?? ''),
      amount: subtotal,
      taxAmount: tax,
      totalAmount: grandTotal,
      currency: json['currency']?.toString() ?? 'INR',
      status: parsedStatus,
      paymentMethod: json['payment_mode']?.toString() ?? json['payment_method']?.toString(),
      erpInvoiceId: erpId,
      erpStatus: json['erp_status']?.toString() ?? (erpId != null ? 'synced' : 'local'),
      dueDate: json['due_date']?.toString(),
      paidAt: json['paid_at']?.toString() ?? (parsedStatus == 'paid' ? json['date']?.toString() : null),
      createdAt: json['created_at']?.toString() ?? json['date']?.toString(),
      notes: json['notes']?.toString(),
      documentKind: docKind,
      invoiceType: invType,
      paidAmount: paid,
      balanceAmount: balance,
      items: parsedItems.isNotEmpty
          ? parsedItems
          : [
              InvoiceItem(
                description: (docKind == 'proforma' ? 'Proforma Invoice' : 'Tax Invoice') +
                    (invType != null ? ' - ${invType.toUpperCase()}' : ''),
                quantity: 1,
                unitPrice: subtotal,
                total: subtotal,
              )
            ],
      customer: parsedCustomer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'user_id': userId,
      'order_id': orderId,
      'amount': amount,
      'tax_amount': taxAmount,
      'total_amount': totalAmount,
      'currency': currency,
      'status': status,
      'payment_method': paymentMethod,
      'erp_invoice_id': erpInvoiceId,
      'erp_status': erpStatus,
      'due_date': dueDate,
      'paid_at': paidAt,
      'created_at': createdAt,
      'notes': notes,
      'document_kind': documentKind,
      'invoice_type': invoiceType,
      'paid_amount': paidAmount,
      'balance_amount': balanceAmount,
      'items_data': items.map((i) => i.toJson()).toList(),
      'user': customer,
      'customer': customer,
    };
  }
}
