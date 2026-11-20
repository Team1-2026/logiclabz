import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../models/invoice_model.dart';
import '../models/erp_models.dart';
import '../models/stats_model.dart';
import '../services/api_service.dart';
import '../services/invoice_service.dart';
import '../services/erp_service.dart';

class AdminProvider extends ChangeNotifier {
  bool _isLoading = false;
  AdminStatsModel _stats = AdminStatsModel();
  List<OrderModel> _orders = [];
  List<InvoiceModel> _invoices = [];
  List<ErpCustomerModel> _customers = [];
  List<ChartOfAccountModel> _accounts = [];
  ErpConfigModel _erpConfig = ErpConfigModel();
  String? _statusMessage;

  AdminProvider() {
    _init();
  }

  Future<void> _init() async {
    // 1. Immediately restore locally cached config upon app launch / restart
    final cached = await ErpService.getCachedConfig();
    if (cached != null) {
      _erpConfig = cached;
      notifyListeners();
    }
    // 2. Fetch fresh config from backend
    await loadErpConfig();
  }

  bool get isLoading => _isLoading;
  AdminStatsModel get stats => _stats;
  List<OrderModel> get orders => _orders;
  List<InvoiceModel> get invoices => _invoices;
  List<ErpCustomerModel> get customers => _customers;
  List<ChartOfAccountModel> get accounts => _accounts;
  ErpConfigModel get erpConfig => _erpConfig;
  String? get statusMessage => _statusMessage;

  Future<void> loadAllData() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      loadStats(),
      loadOrders(),
      loadInvoices(),
      loadCustomers(),
      loadAccounting(),
      loadErpConfig(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadStats() async {
    try {
      final res = await ApiService.get('admin/stats');
      final data = res is Map && res['data'] is Map ? res['data'] : res;
      _stats = AdminStatsModel.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {
      _stats = AdminStatsModel(
        totalOrders: 6,
        totalProducts: 4,
        totalInvoices: 4,
        totalCustomers: 5,
        totalRevenue: 137468.82,
        pendingRevenue: 24190.0,
        erpConnected: true,
      );
    }
    notifyListeners();
  }

  Future<void> loadOrders() async {
    try {
      final res = await ApiService.get('admin/orders');
      List rawList = [];
      if (res is List) {
        rawList = res;
      } else if (res is Map && res['data'] is List) {
        rawList = res['data'];
      } else if (res is Map && res['orders'] is List) {
        rawList = res['orders'];
      }
      if (rawList.isNotEmpty) {
        _orders = rawList.whereType<Map>().map((o) => OrderModel.fromJson(Map<String, dynamic>.from(o))).toList();
      }
    } catch (_) {
      _orders = [
        OrderModel(
          id: 1,
          orderNumber: 'ORD-2026-00001',
          totalAmount: 46018.82,
          setupCharge: 5000.0,
          status: 'completed',
          createdAt: '2026-11-04 18:00:00',
          customer: {'name': 'Jesvin Client', 'company_name': 'Logic Enterprise Solutions Ltd'},
        ),
        OrderModel(
          id: 2,
          orderNumber: 'ORD-2026-00002',
          totalAmount: 41300.0,
          setupCharge: 10000.0,
          status: 'completed',
          createdAt: '2026-10-15 10:20:00',
          customer: {'name': 'John Doe', 'company_name': 'Acme Global Manufacturing'},
        ),
        OrderModel(
          id: 3,
          orderNumber: 'ORD-2026-00003',
          totalAmount: 24190.0,
          setupCharge: 0.0,
          status: 'pending',
          createdAt: '2026-11-02 09:30:00',
          customer: {'name': 'Sarah Connor', 'company_name': 'Cyberdyne Logistics Hub'},
        ),
      ];
    }
    notifyListeners();
  }

  Future<void> loadInvoices() async {
    _invoices = await InvoiceService.getAdminInvoices();
    notifyListeners();
  }

  Future<void> loadCustomers() async {
    _customers = await ErpService.getCustomers();
    notifyListeners();
  }

  Future<void> loadAccounting() async {
    _accounts = await ErpService.getAccountingOverview();
    notifyListeners();
  }

  Future<void> loadErpConfig() async {
    _erpConfig = await ErpService.getConfig();
    notifyListeners();
  }

  Future<bool> saveErpConfig(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      _erpConfig = await ErpService.saveConfig(data);
      _statusMessage = 'ERP configuration saved successfully!';
      return true;
    } catch (e) {
      _statusMessage = 'Failed to save config: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> testErpConnection(String apiUrl, String token, {String tenantDomain = 'default', String tenantId = ''}) async {
    final res = await ErpService.testConnection(apiUrl: apiUrl, token: token, tenantDomain: tenantDomain, tenantId: tenantId);
    await loadErpConfig();
    return res;
  }

  Future<Map<String, dynamic>> syncErpCustomers() async {
    final res = await ErpService.syncCustomers();
    await loadCustomers();
    await loadStats();
    return res;
  }

  Future<Map<String, dynamic>> syncErpInvoices() async {
    final res = await ErpService.syncInvoices();
    await loadInvoices();
    await loadStats();
    return res;
  }

  Future<Map<String, dynamic>> syncErpOrders() async {
    final res = await ErpService.syncOrders();
    await loadOrders();
    await loadStats();
    return res;
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    final res = await ErpService.createOrder(data);
    await loadOrders();
    await loadStats();
    return res;
  }

  Future<Map<String, dynamic>> syncErpAccounting() async {
    final res = await ErpService.syncAccounting();
    await loadAccounting();
    await loadStats();
    return res;
  }

  Future<Map<String, dynamic>> generateErpTenantToken({String prefix = 'LL-TENANT'}) async {
    final res = await ErpService.generateTenantKey(prefix: prefix, save: true);
    if (res['success'] == true && res['token'] != null) {
      await loadErpConfig();
    }
    return res;
  }

  Future<Map<String, dynamic>> loginToErpForToken({
    required String email,
    required String password,
    String? apiUrl,
    String? tenantDomain,
  }) async {
    final res = await ErpService.loginToErpForToken(
      email: email,
      password: password,
      apiUrl: apiUrl,
      tenantDomain: tenantDomain,
    );
    if (res['success'] == true) {
      await loadErpConfig();
    }
    return res;
  }

  Future<Map<String, dynamic>> updateCustomerTenantKey(int customerId, {String? key, bool generate = false}) async {
    final res = await ErpService.setCustomerTenantKey(customerId, key: key, generate: generate);
    await loadCustomers();
    return res;
  }

  Future<bool> createInvoice(Map<String, dynamic> data) async {
    try {
      final inv = await InvoiceService.createInvoice(data);
      _invoices.insert(0, inv);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteInvoice(int id) async {
    final ok = await InvoiceService.deleteInvoice(id);
    if (ok) {
      _invoices.removeWhere((i) => i.id == id);
      notifyListeners();
    }
    return ok;
  }

  Future<Map<String, dynamic>> syncInvoiceToErp(int id) async {
    final res = await InvoiceService.syncInvoiceToErp(id);
    await loadInvoices();
    return res;
  }

  Future<bool> toggleOrderStatus(int orderId) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final current = _orders[index];
      final newStatus = current.status == 'completed' ? 'pending' : 'completed';
      try {
        await ApiService.post('admin/orders/$orderId/provision', body: {'status': newStatus});
      } catch (_) {}
      _orders[index] = OrderModel(
        id: current.id,
        orderNumber: current.orderNumber,
        userId: current.userId,
        totalAmount: current.totalAmount,
        setupCharge: current.setupCharge,
        status: newStatus,
        createdAt: current.createdAt,
        items: current.items,
        customer: current.customer,
      );
      notifyListeners();
      return true;
    }
    return false;
  }
}
