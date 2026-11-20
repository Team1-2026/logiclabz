import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/app_navbar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/invoice_detail_dialog.dart';
import '../widgets/create_invoice_dialog.dart';
import '../widgets/create_order_dialog.dart';
import '../widgets/order_detail_dialog.dart';
import '../widgets/edit_product_dialog.dart';
import '../services/api_service.dart';
import '../models/erp_models.dart';
import '../providers/admin_provider.dart';
import '../providers/catalog_provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadAllData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: const AppNavbar(activeRoute: '/admin'),
      drawer: isDesktop ? null : const AppDrawer(activeRoute: '/admin'),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Title & Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('EXECUTIVE CONTROL TOWER', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('Enterprise Admin Console', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                          Text(
                            'Manage orders, configure products & setup costs, reconcile 18% GST invoices, and oversee ERP sync.',
                            style: TextStyle(color: const Color(0xFF94A3B8), fontSize: isDesktop ? 14 : 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.sync_alt, size: 16),
                            label: const Text('ERP Settings'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E293B),
                              foregroundColor: const Color(0xFF38BDF8),
                              side: const BorderSide(color: Color(0xFF334155)),
                            ),
                            onPressed: () => Navigator.pushNamed(context, '/admin/erp-config'),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            tooltip: 'Refresh All Data',
                            onPressed: () => admin.loadAllData(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Metrics Summary Banner
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _kpiCard('Total Revenue', currencyFormatter.format(admin.stats.totalRevenue), 'Processed & Synced', Icons.account_balance_wallet, const Color(0xFF10B981)),
                      _kpiCard('Active Orders', '${admin.orders.length}', 'Customer deployments', Icons.shopping_bag_outlined, const Color(0xFF3B82F6)),
                      _kpiCard('Tax Invoices', '${admin.invoices.length}', 'GST 18% reconciled', Icons.receipt_long, const Color(0xFFF59E0B)),
                      _kpiCard('ERP Integration', admin.stats.erpConnected ? 'Connected' : 'Standalone', 'be-app / default tenant', Icons.cloud_sync, const Color(0xFFA855F7)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Tab Navigation
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF131C31),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: !isDesktop,
                      indicatorColor: const Color(0xFF38BDF8),
                      indicatorWeight: 3,
                      labelColor: const Color(0xFF38BDF8),
                      unselectedLabelColor: const Color(0xFF94A3B8),
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      tabs: const [
                        Tab(icon: Icon(Icons.receipt, size: 16), text: 'Invoices & GST'),
                        Tab(icon: Icon(Icons.shopping_bag_outlined, size: 16), text: 'Orders'),
                        Tab(icon: Icon(Icons.inventory_2_outlined, size: 16), text: 'Products & Modules'),
                        Tab(icon: Icon(Icons.people_alt_outlined, size: 16), text: 'ERP Customers'),
                        Tab(icon: Icon(Icons.account_tree_outlined, size: 16), text: 'ERP Accounting'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tab Views
                  SizedBox(
                    height: 650,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _invoicesTab(context, admin),
                        _ordersTab(context, admin),
                        _productsTab(context),
                        _customersTab(context, admin),
                        _accountingTab(context, admin),
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

  // 1. Invoices & GST Tab
  Widget _invoicesTab(BuildContext context, AdminProvider admin) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131C31),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Invoices Management & ERP Synchronization', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Generate Invoice'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                onPressed: () => CreateInvoiceDialog.show(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: admin.invoices.isEmpty
                ? const Center(child: Text('No invoices found', style: TextStyle(color: Colors.grey)))
                : ListView.separated(
                    itemCount: admin.invoices.length,
                    separatorBuilder: (_, __) => const Divider(color: Color(0xFF1E293B)),
                    itemBuilder: (ctx, idx) {
                      final inv = admin.invoices[idx];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: inv.isPaid ? const Color(0xFF10B981).withValues(alpha: 0.2) : const Color(0xFFEF4444).withValues(alpha: 0.2),
                          child: Icon(
                            inv.isPaid ? Icons.check : Icons.schedule,
                            color: inv.isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            size: 18,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(inv.invoiceNumber, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(width: 8),
                            if (inv.isProforma)
                              Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'PROFORMA',
                                  style: TextStyle(
                                    color: Color(0xFFFBBF24),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: inv.isSynced ? const Color(0xFF2563EB).withValues(alpha: 0.2) : const Color(0xFF334155),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                inv.isSynced ? 'ERP: ${inv.erpInvoiceId ?? 'SYNCED'}' : 'LOCAL ONLY',
                                style: TextStyle(
                                  color: inv.isSynced ? const Color(0xFF60A5FA) : const Color(0xFF94A3B8),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${inv.customer?['company_name'] ?? inv.customer?['name'] ?? 'Logic Enterprise'} • Subtotal: ${currencyFormatter.format(inv.amount)} + Tax: ${currencyFormatter.format(inv.taxAmount)}',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(currencyFormatter.format(inv.totalAmount), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                Text(inv.status.toUpperCase(), style: TextStyle(color: inv.isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.print, size: 18, color: Color(0xFF38BDF8)),
                              tooltip: 'Print GST Receipt',
                              onPressed: () => InvoiceDetailDialog.show(context, inv),
                            ),
                            if (!inv.isSynced)
                              IconButton(
                                icon: const Icon(Icons.cloud_upload_outlined, size: 18, color: Color(0xFFA855F7)),
                                tooltip: 'Push to ERP',
                                onPressed: () async {
                                  final res = await admin.syncInvoiceToErp(inv.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(res['message'] ?? 'Invoice synced to ERP!'), backgroundColor: const Color(0xFF10B981)),
                                    );
                                  }
                                },
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                              tooltip: 'Delete',
                              onPressed: () => admin.deleteInvoice(inv.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 2. Orders Tab
  Widget _ordersTab(BuildContext context, AdminProvider admin) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131C31),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Customer Deployment Orders', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Customer Deployment Orders', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    '${admin.orders.length} orders total • ${admin.orders.where((o) => o.isSynced).length} synchronized with ERP',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.sync, size: 14),
                    label: const Text('Sync Orders'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: const Color(0xFF38BDF8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 11),
                    ),
                    onPressed: () async {
                      final res = await admin.syncErpOrders();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(res['message'] ?? 'Orders synchronized from ERP!'),
                            backgroundColor: res['success'] == true ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        );
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Create Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => CreateOrderDialog.show(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: admin.orders.isEmpty
                ? const Center(child: Text('No orders found', style: TextStyle(color: Colors.grey)))
                : ListView.separated(
                    itemCount: admin.orders.length,
                    separatorBuilder: (_, __) => const Divider(color: Color(0xFF1E293B)),
                    itemBuilder: (ctx, idx) {
                      final ord = admin.orders[idx];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => OrderDetailDialog.show(context, ord),
                        leading: CircleAvatar(
                          backgroundColor: ord.isCompleted ? const Color(0xFF10B981).withValues(alpha: 0.2) : const Color(0xFFF59E0B).withValues(alpha: 0.2),
                          backgroundColor: ord.isCompleted
                              ? const Color(0xFF10B981).withValues(alpha: 0.2)
                              : const Color(0xFFF59E0B).withValues(alpha: 0.2),
                          child: Icon(
                            ord.isCompleted ? Icons.check_circle_outline : Icons.pending_outlined,
                            color: ord.isCompleted ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                            size: 18,
                          ),
                        ),
                        title: Text(ord.orderNumber, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        title: Row(
                          children: [
                            Text(ord.orderNumber, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: ord.isSynced
                                    ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                                    : const Color(0xFF334155),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                ord.isSynced
                                    ? 'ERP: ${ord.erpOrderId != null && ord.erpOrderId!.length > 10 ? '${ord.erpOrderId!.substring(0, 8)}...' : (ord.erpOrderId ?? 'SYNCED')}'
                                    : 'LOCAL',
                                style: TextStyle(
                                  color: ord.isSynced ? const Color(0xFF60A5FA) : const Color(0xFF94A3B8),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${ord.customer?['company_name'] ?? 'Client'} • Created: ${ord.createdAt ?? '2026-11-04'}',
                          '${ord.customer?['company_name'] ?? ord.customer?['name'] ?? 'Client'} • Created: ${ord.createdAt != null && ord.createdAt!.length > 10 ? ord.createdAt!.substring(0, 10) : (ord.createdAt ?? '2026-11-04')}',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(currencyFormatter.format(ord.totalAmount), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ord.isCompleted ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () => admin.toggleOrderStatus(ord.id),
                              child: Text(ord.isCompleted ? 'COMPLETED' : 'PENDING'),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.info_outline, color: Color(0xFF38BDF8), size: 18),
                              tooltip: 'View Order Details',
                              onPressed: () => OrderDetailDialog.show(context, ord),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 3. Products & Modules Tab
  Widget _productsTab(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131C31),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Catalog Products, Pricing & Modules', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${catalog.products.length} Products Active in Store', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Product & Service'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                onPressed: () => EditProductDialog.show(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: catalog.products.length,
              separatorBuilder: (_, __) => const Divider(color: Color(0xFF1E293B)),
              itemBuilder: (ctx, idx) {
                final p = catalog.products[idx];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.layers, color: Color(0xFF38BDF8), size: 20),
                  ),
                  title: Row(
                    children: [
                      Text(p.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(4)),
                        child: Text(p.category, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9)),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Base: ${currencyFormatter.format(p.basePrice)} • Setup Cost: ${currencyFormatter.format(p.setupCharge)} • ${p.modulesSchema.length} Modules',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Color(0xFF38BDF8), size: 18),
                        tooltip: 'Edit Product & Configure Modules',
                        onPressed: () => EditProductDialog.show(context, product: p),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                        tooltip: 'Delete Product',
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (dCtx) => AlertDialog(
                              backgroundColor: const Color(0xFF0F172A),
                              title: const Text('Delete Product?', style: TextStyle(color: Colors.white, fontSize: 16)),
                              content: Text('Are you sure you want to delete "${p.title}"?', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(dCtx, false), child: const Text('Cancel')),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                                  onPressed: () => Navigator.pop(dCtx, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            try {
                              await ApiService.delete('admin/products/${p.id}');
                            } catch (_) {}
                            catalog.loadCatalog();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 4. ERP Customers Tab
  Widget _customersTab(BuildContext context, AdminProvider admin) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131C31),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Customers Synced from ERP (be-app)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                icon: const Icon(Icons.sync, size: 14),
                label: const Text('Sync Customers'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: const Color(0xFF38BDF8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 11),
                ),
                onPressed: () async {
                  final res = await admin.syncErpCustomers();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(res['message'] ?? 'Customers synced from ERP!'), backgroundColor: const Color(0xFF10B981)),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: admin.customers.isEmpty
                ? const Center(child: Text('No ERP customers synced', style: TextStyle(color: Colors.grey)))
                : ListView.separated(
                    itemCount: admin.customers.length,
                    separatorBuilder: (_, __) => const Divider(color: Color(0xFF1E293B)),
                    itemBuilder: (ctx, idx) {
                      final c = admin.customers[idx];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF2563EB),
                          child: Text(c.name.isNotEmpty ? c.name[0].toUpperCase() : 'C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(c.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${c.companyName ?? 'Individual'} • ${c.displayEmail}${c.gstin != null && c.gstin!.isNotEmpty ? ' • GST: ${c.gstin}' : ''}${c.balance != null ? ' • Bal: ₹${c.balance!.toStringAsFixed(2)}' : ''}',
                              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.key, size: 12, color: Color(0xFF38BDF8)),
                                const SizedBox(width: 4),
                                SelectableText(
                                  c.tenantKey ?? 'LL-TENANT-CUST-${c.id.toString().padLeft(4, '0')}',
                                  style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontFamily: 'monospace'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(4)),
                              child: Text(c.erpCustomerId ?? 'ERP-CUST', style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit_note, color: Color(0xFF38BDF8), size: 20),
                              tooltip: 'Manage Tenant Key (Admin / User input)',
                              onPressed: () => _showCustomerTenantKeyDialog(context, admin, c),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 5. ERP Accounting Tab
  Widget _accountingTab(BuildContext context, AdminProvider admin) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131C31),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Chart of Accounts & Ledger Balances', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                icon: const Icon(Icons.sync, size: 14),
                label: const Text('Reconcile Ledger'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: const Color(0xFF38BDF8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 11),
                ),
                onPressed: () async {
                  final res = await admin.syncErpAccounting();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(res['message'] ?? 'Chart of Accounts reconciled!'), backgroundColor: const Color(0xFF10B981)),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: admin.accounts.isEmpty
                ? const Center(child: Text('No accounting accounts found', style: TextStyle(color: Colors.grey)))
                : ListView.separated(
                    itemCount: admin.accounts.length,
                    separatorBuilder: (_, __) => const Divider(color: Color(0xFF1E293B)),
                    itemBuilder: (ctx, idx) {
                      final acc = admin.accounts[idx];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(6)),
                          child: Text(acc.code, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        title: Text(acc.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text(acc.type.toUpperCase(), style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                        trailing: Text(
                          currencyFormatter.format(acc.balance),
                          style: TextStyle(
                            color: acc.type == 'asset' || acc.type == 'income' ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _kpiCard(String label, String value, String subtitle, IconData icon, Color color) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF131C31),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomerTenantKeyDialog(BuildContext context, AdminProvider admin, ErpCustomerModel customer) {
    final keyCtrl = TextEditingController(text: customer.tenantKey ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF131C31),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        title: Row(
          children: [
            const Icon(Icons.key, color: Color(0xFF38BDF8), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Tenant Key: ${customer.name}',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
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
                'This key identifies this client/tenant in the ERP multi-tenant architecture. You can generate a new key or enter/paste a key taken directly from the customer.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: keyCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
                decoration: InputDecoration(
                  labelText: 'Tenant Identification Key',
                  labelStyle: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12),
                  hintText: 'LL-TENANT-XXXX-XXXX...',
                  hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF334155))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF38BDF8))),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.auto_awesome, size: 14),
                label: const Text('Generate New Key for Client'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF38BDF8),
                  side: const BorderSide(color: Color(0xFF38BDF8)),
                ),
                onPressed: () async {
                  final res = await admin.updateCustomerTenantKey(customer.id, generate: true);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(res['message'] ?? 'Generated new key!'), backgroundColor: const Color(0xFF10B981)),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final key = keyCtrl.text.trim();
              if (key.isNotEmpty) {
                final res = await admin.updateCustomerTenantKey(customer.id, key: key);
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res['message'] ?? 'Tenant key saved!'), backgroundColor: const Color(0xFF10B981)),
                  );
                }
              }
            },
            child: const Text('Save Key (Take from User)'),
          ),
        ],
      ),
    );
  }
}
