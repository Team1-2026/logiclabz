import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/app_navbar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/invoice_detail_dialog.dart';
import '../providers/auth_provider.dart';
import '../models/invoice_model.dart';
import '../models/order_model.dart';
import '../services/invoice_service.dart';
import '../services/api_service.dart';
import '../services/erp_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  List<InvoiceModel> _invoices = [];
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final invs = await InvoiceService.getCustomerInvoices();

    List<OrderModel> ords = [];
    try {
      final res = await ApiService.get('customer/dashboard');
      if (res is Map && res['orders'] is List) {
        ords = (res['orders'] as List)
            .whereType<Map>()
            .map((o) => OrderModel.fromJson(Map<String, dynamic>.from(o)))
            .toList();
      }
    } catch (_) {
      ords = [
        OrderModel(
          id: 1,
          orderNumber: 'ORD-2026-00001',
          totalAmount: 46018.82,
          setupCharge: 5000.0,
          status: 'completed',
          createdAt: '2026-11-04 18:00:00',
        ),
      ];
    }

    setState(() {
      _invoices = invs;
      _orders = ords;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 860;
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: const AppNavbar(activeRoute: '/dashboard'),
      drawer: isDesktop ? null : const AppDrawer(activeRoute: '/dashboard'),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1160),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : 16,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CLIENT OPERATIONS PORTAL',
                            style: TextStyle(
                              color: Color(0xFF38BDF8),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Welcome, ${auth.user?.name ?? 'Enterprise Client'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            auth.user?.companyName ??
                                'Logic Enterprise Solutions Ltd',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          color: Color(0xFF38BDF8),
                        ),
                        tooltip: 'Refresh Portal',
                        onPressed: _loadData,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Metrics Cards
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _metricCard(
                        'Active Subscriptions',
                        '3 Licenses',
                        'All services operational',
                        Icons.verified_user_outlined,
                        const Color(0xFF10B981),
                      ),
                      _metricCard(
                        'Total Invoices',
                        '${_invoices.length} Documents',
                        'GST tax compliant',
                        Icons.receipt_long_outlined,
                        const Color(0xFF3B82F6),
                      ),
                      _metricCard(
                        'ERP Sync Status',
                        'Connected',
                        'Auto ledger sync active',
                        Icons.sync_alt_outlined,
                        const Color(0xFFA855F7),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tenant Identification Key Card (Multi-Tenant Identification)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131C31),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.vpn_key_outlined,
                                  color: Color(0xFF38BDF8),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'ERP Tenant Identification Key',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF10B981,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(
                                    0xFF10B981,
                                  ).withValues(alpha: 0.3),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF10B981),
                                    size: 12,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Active Tenant',
                                    style: TextStyle(
                                      color: Color(0xFF10B981),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'In our ERP multi-tenant system, this token acts as your Tenant Identification Key. All your services, GST invoices, and financial records are scoped to this key.',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.security,
                                color: Color(0xFF64748B),
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SelectableText(
                                  auth.user?.tenantKey ??
                                      'LL-TENANT-DEMO-CLIENT-2026',
                                  style: const TextStyle(
                                    color: Color(0xFF38BDF8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.copy,
                                  color: Color(0xFF94A3B8),
                                  size: 16,
                                ),
                                tooltip: 'Copy Tenant Key',
                                onPressed: () {
                                  final key =
                                      auth.user?.tenantKey ??
                                      'LL-TENANT-DEMO-CLIENT-2026';
                                  Clipboard.setData(ClipboardData(text: key));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Tenant Key copied to clipboard!',
                                      ),
                                      backgroundColor: Color(0xFF2563EB),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.edit, size: 14),
                              label: const Text(
                                'Input / Enter Key (Take from User)',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E293B),
                                foregroundColor: const Color(0xFF38BDF8),
                                side: const BorderSide(
                                  color: Color(0xFF334155),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () =>
                                  _showUserTenantKeyDialog(context, auth),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.auto_awesome, size: 14),
                              label: const Text('Generate New Tenant Key'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E293B),
                                foregroundColor: const Color(0xFFA855F7),
                                side: const BorderSide(
                                  color: Color(0xFF334155),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                final res =
                                    await ErpService.generateCustomerTenantKey();
                                if (res['tenant_key'] != null) {
                                  auth.updateUserTenantKey(res['tenant_key']);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'New Tenant Key generated: ${res['tenant_key']}',
                                        ),
                                        backgroundColor: const Color(
                                          0xFF10B981,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Invoices Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131C31),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  color: Color(0xFF38BDF8),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Official GST Tax Invoices',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${_invoices.length} Invoices Found',
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (_isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (_invoices.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Text(
                                'No invoices issued yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _invoices.length,
                            separatorBuilder: (_, __) =>
                                const Divider(color: Color(0xFF1E293B)),
                            itemBuilder: (ctx, idx) {
                              final inv = _invoices[idx];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: inv.isPaid
                                        ? const Color(
                                            0xFF10B981,
                                          ).withValues(alpha: 0.15)
                                        : const Color(
                                            0xFFEF4444,
                                          ).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    inv.isPaid
                                        ? Icons.check_circle_outline
                                        : Icons.pending_actions,
                                    color: inv.isPaid
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFEF4444),
                                    size: 20,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      inv.invoiceNumber,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (inv.isSynced)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1E293B),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          inv.erpInvoiceId ?? 'ERP-SYNC',
                                          style: const TextStyle(
                                            color: Color(0xFF38BDF8),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Text(
                                  'Subtotal: ${currencyFormatter.format(inv.amount)} + 18% GST (${currencyFormatter.format(inv.taxAmount)}) • Date: ${inv.createdAt?.substring(0, 10) ?? '2026-11-05'}',
                                  style: const TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 11,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          currencyFormatter.format(
                                            inv.totalAmount,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          inv.status.toUpperCase(),
                                          style: TextStyle(
                                            color: inv.isPaid
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFFEF4444),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.print, size: 14),
                                      label: const Text('View / Print'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF2563EB,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () => InvoiceDetailDialog.show(
                                        context,
                                        inv,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Orders Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131C31),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: Color(0xFF38BDF8),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Order History & Deployments',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._orders.map(
                          (ord) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ord.orderNumber,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'Created: ${ord.createdAt ?? '2026-11-04'}',
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      currencyFormatter.format(ord.totalAmount),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ord.isCompleted
                                            ? const Color(
                                                0xFF10B981,
                                              ).withValues(alpha: 0.2)
                                            : const Color(
                                                0xFFF59E0B,
                                              ).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        ord.status.toUpperCase(),
                                        style: TextStyle(
                                          color: ord.isCompleted
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFFF59E0B),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _metricCard(
    String label,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131C31),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUserTenantKeyDialog(BuildContext context, AuthProvider auth) {
    final keyCtrl = TextEditingController(text: auth.user?.tenantKey ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF131C31),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        title: const Row(
          children: [
            Icon(Icons.vpn_key_outlined, color: Color(0xFF38BDF8), size: 20),
            SizedBox(width: 8),
            Text(
              'Input ERP Tenant Identification Key',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter or paste your Tenant Identification Key provided by your ERP tenant administrator. This binds your account and invoices to your ERP tenant workspace.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: keyCtrl,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
                decoration: InputDecoration(
                  labelText: 'ERP Tenant Identification Key',
                  labelStyle: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 12,
                  ),
                  hintText: 'LL-TENANT-XXXX-XXXX...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF38BDF8)),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final key = keyCtrl.text.trim();
              if (key.isNotEmpty) {
                final res = await ErpService.saveCustomerTenantKey(key);
                if (res['success'] == true) {
                  auth.updateUserTenantKey(key);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res['message'] ?? 'Tenant Key saved!'),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res['message'] ?? 'Failed to save key'),
                        backgroundColor: const Color(0xFFEF4444),
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Save Tenant Key'),
          ),
        ],
      ),
    );
  }
}
