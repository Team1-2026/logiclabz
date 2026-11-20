class ErpConfigModel {
  final int? id;
  final String erpName;
  final String apiUrl;
  final String apiToken;
  final String tenantDomain;
  final String tenantId;
  final String customersEndpoint;
  final String invoicesEndpoint;
  final String accountingEndpoint;
  final String modulesEndpoint;
  final bool isConnected;
  final String? lastConnectionTestAt;
  final String? lastCustomersSyncAt;
  final String? lastInvoicesSyncAt;
  final String? lastAccountingSyncAt;
  final List<dynamic> syncLogs;

  ErpConfigModel({
    this.id,
    this.erpName = 'ERPLogic Cloud',
    this.apiUrl = 'https://api.erplogic.co.in',
    this.apiToken = '',
    this.tenantDomain = 'default',
    this.tenantId = '',
    this.customersEndpoint = '/api/tenant/customers',
    this.invoicesEndpoint = '/api/tenant/invoices',
    this.accountingEndpoint = '/api/tenant/accounts/chart-of-accounts',
    this.modulesEndpoint = '/modules-data',
    this.isConnected = false,
    this.lastConnectionTestAt,
    this.lastCustomersSyncAt,
    this.lastInvoicesSyncAt,
    this.lastAccountingSyncAt,
    this.syncLogs = const [],
  });

  factory ErpConfigModel.fromJson(Map<String, dynamic> json) {
    return ErpConfigModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      erpName: json['erp_name']?.toString() ?? 'ERPLogic Cloud',
      apiUrl: json['api_url']?.toString() ?? 'https://api.erplogic.co.in',
      apiToken: json['api_token']?.toString() ?? '',
      tenantDomain: json['tenant_domain']?.toString() ?? 'default',
      tenantId: json['tenant_id']?.toString() ?? json['x_tenant_id']?.toString() ?? '',
      customersEndpoint: json['customers_endpoint']?.toString() ?? '/api/tenant/customers',
      invoicesEndpoint: json['invoices_endpoint']?.toString() ?? '/api/tenant/invoices',
      accountingEndpoint: json['accounting_endpoint']?.toString() ?? '/api/tenant/accounts/chart-of-accounts',
      modulesEndpoint: json['modules_endpoint']?.toString() ?? '/modules-data',
      isConnected: json['is_connected'] == true || json['is_connected'] == 1,
      lastConnectionTestAt: json['last_connection_test_at']?.toString(),
      lastCustomersSyncAt: json['last_customers_sync_at']?.toString(),
      lastInvoicesSyncAt: json['last_invoices_sync_at']?.toString(),
      lastAccountingSyncAt: json['last_accounting_sync_at']?.toString(),
      syncLogs: json['sync_logs'] is List ? json['sync_logs'] : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'erp_name': erpName,
      'api_url': apiUrl,
      'api_token': apiToken,
      'tenant_domain': tenantDomain,
      'tenant_id': tenantId,
      'customers_endpoint': customersEndpoint,
      'invoices_endpoint': invoicesEndpoint,
      'accounting_endpoint': accountingEndpoint,
      'modules_endpoint': modulesEndpoint,
      'is_connected': isConnected,
    };
  }
}

class ErpCustomerModel {
  final int id;
  final String name;
  final String email;
  final String? companyName;
  final String? phone;
  final String? gstin;
  final String? erpCustomerId;
  final String? erpSyncedAt;
  final String? apiToken;
  final String? address;
  final double? balance;

  String? get tenantKey => apiToken;

  String get displayEmail {
    if (email.endsWith('@erplogic.internal')) {
      return phone != null && phone!.isNotEmpty ? phone! : 'ERP Customer (No email)';
    }
    return email;
  }

  ErpCustomerModel({
    required this.id,
    required this.name,
    required this.email,
    this.companyName,
    this.phone,
    this.gstin,
    this.erpCustomerId,
    this.erpSyncedAt,
    this.apiToken,
    this.address,
    this.balance,
  });

  factory ErpCustomerModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    int parsedId = 0;
    if (rawId is int) {
      parsedId = rawId;
    } else if (rawId != null) {
      parsedId = int.tryParse(rawId.toString()) ?? 0;
    }

    final rawBalance = json['balance'];
    double? parsedBalance;
    if (rawBalance is num) {
      parsedBalance = rawBalance.toDouble();
    } else if (rawBalance != null) {
      parsedBalance = double.tryParse(rawBalance.toString());
    }

    final erpId = json['erp_customer_id']?.toString() ??
        json['_id']?.toString() ??
        (rawId is String && rawId.length > 10 ? rawId : null);

    return ErpCustomerModel(
      id: parsedId,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? json['company']?.toString(),
      phone: json['phone']?.toString(),
      gstin: json['gstin']?.toString() ?? json['gst_number']?.toString(),
      erpCustomerId: erpId,
      erpSyncedAt: json['erp_synced_at']?.toString(),
      apiToken: json['api_token']?.toString() ?? json['tenant_key']?.toString(),
      address: json['billing_address']?.toString() ?? json['address']?.toString(),
      balance: parsedBalance,
    );
  }
}

class ChartOfAccountModel {
  final String code;
  final String name;
  final String type; // 'asset' | 'liability' | 'income' | 'expense'
  final double balance;

  ChartOfAccountModel({
    required this.code,
    required this.name,
    required this.type,
    required this.balance,
  });

  factory ChartOfAccountModel.fromJson(Map<String, dynamic> json) {
    return ChartOfAccountModel(
      code: json['code']?.toString() ?? json['account_number']?.toString() ?? '',
      name: json['name']?.toString() ?? json['account_name']?.toString() ?? 'Account',
      type: json['type']?.toString() ?? 'asset',
      balance: json['balance'] is num
          ? (json['balance'] as num).toDouble()
          : double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
    );
  }
}
