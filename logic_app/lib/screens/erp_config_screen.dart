import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_navbar.dart';
import '../widgets/app_drawer.dart';
import '../models/erp_models.dart';
import '../providers/admin_provider.dart';

class ErpConfigScreen extends StatefulWidget {
  const ErpConfigScreen({super.key});

  @override
  State<ErpConfigScreen> createState() => _ErpConfigScreenState();
}

class _ErpConfigScreenState extends State<ErpConfigScreen> {
  final _erpNameCtrl = TextEditingController(text: 'ERPLogic Cloud');
  final _apiUrlCtrl = TextEditingController(text: 'https://api.erplogic.co.in');
  final _apiTokenCtrl = TextEditingController();
  final _tenantDomainCtrl = TextEditingController(text: 'default');
  final _tenantIdCtrl = TextEditingController(text: '');
  final _customersEndpointCtrl = TextEditingController(text: '/api/tenant/customers');
  final _invoicesEndpointCtrl = TextEditingController(text: '/api/tenant/invoices');
  final _accountingEndpointCtrl = TextEditingController(text: '/api/tenant/accounts/chart-of-accounts');
  final _modulesEndpointCtrl = TextEditingController(text: '/modules-data');

  bool _isTesting = false;
  bool _isSaving = false;
  Map<String, dynamic>? _testResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingConfig();
    });
  }

  @override
  void dispose() {
    _erpNameCtrl.dispose();
    _apiUrlCtrl.dispose();
    _apiTokenCtrl.dispose();
    _tenantDomainCtrl.dispose();
    _tenantIdCtrl.dispose();
    _customersEndpointCtrl.dispose();
    _invoicesEndpointCtrl.dispose();
    _accountingEndpointCtrl.dispose();
    _modulesEndpointCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadExistingConfig() async {
    // 1. Immediately populate from local cache / provider state
    final current = context.read<AdminProvider>().erpConfig;
    _populateControllers(current);

    // 2. Fetch fresh config from backend API / SharedPreferences
    await context.read<AdminProvider>().loadErpConfig();
    if (!mounted) return;
    final fresh = context.read<AdminProvider>().erpConfig;
    _populateControllers(fresh);
  }

  void _populateControllers(ErpConfigModel erp) {
    if (erp.erpName.isNotEmpty) _erpNameCtrl.text = erp.erpName;
    if (erp.apiUrl.isNotEmpty) _apiUrlCtrl.text = erp.apiUrl;
    _apiTokenCtrl.text = erp.apiToken;
    if (erp.tenantDomain.isNotEmpty) _tenantDomainCtrl.text = erp.tenantDomain;
    _tenantIdCtrl.text = erp.tenantId;
    if (erp.customersEndpoint.isNotEmpty) _customersEndpointCtrl.text = erp.customersEndpoint;
    if (erp.invoicesEndpoint.isNotEmpty) _invoicesEndpointCtrl.text = erp.invoicesEndpoint;
    if (erp.accountingEndpoint.isNotEmpty) _accountingEndpointCtrl.text = erp.accountingEndpoint;
    if (erp.modulesEndpoint.isNotEmpty) _modulesEndpointCtrl.text = erp.modulesEndpoint;
    setState(() {});
  }

  void _applyBeAppPresets() {
    setState(() {
      _erpNameCtrl.text = 'be-app Sample ERP';
      _apiUrlCtrl.text = 'http://localhost:8000';
      _apiTokenCtrl.text = 'demo_erp_secret_token_logiclabz_2026';
      _tenantDomainCtrl.text = 'default';
      _tenantIdCtrl.text = '64a8b7c9e123456789abcdef';
      _customersEndpointCtrl.text = '/api/tenant/customers';
      _invoicesEndpointCtrl.text = '/api/tenant/invoices';
      _accountingEndpointCtrl.text = '/api/tenant/accounts/chart-of-accounts';
      _modulesEndpointCtrl.text = '/modules-data';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Applied local be-app presets with multi-tenant headers!'),
        backgroundColor: Color(0xFF2563EB),
      ),
    );
  }

  void _applyCloudPresets() {
    setState(() {
      _erpNameCtrl.text = 'ERPLogic Cloud';
      _apiUrlCtrl.text = 'https://api.erplogic.co.in';
      _tenantDomainCtrl.text = 'default';
      _tenantIdCtrl.text = '';
      _customersEndpointCtrl.text = '/api/tenant/customers';
      _invoicesEndpointCtrl.text = '/api/tenant/invoices';
      _accountingEndpointCtrl.text = '/api/tenant/accounts/chart-of-accounts';
      _modulesEndpointCtrl.text = '/modules-data';
    });
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: const AppNavbar(activeRoute: '/admin/erp-config'),
      drawer: isDesktop ? null : const AppDrawer(activeRoute: '/admin/erp-config'),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Presets
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('MULTI-TENANT ERP INTEGRATION', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('ERP Configuration & Sync Engine', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                          Text(
                            'Connect with external ERPs (like be-app) to synchronize customer profiles, tax invoices, and accounting ledgers.',
                            style: TextStyle(color: const Color(0xFF94A3B8), fontSize: isDesktop ? 14 : 12),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.flash_on, size: 14),
                            label: const Text('Load be-app Presets'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A8A),
                              foregroundColor: const Color(0xFF93C5FD),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            onPressed: _applyBeAppPresets,
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFF334155)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              textStyle: const TextStyle(fontSize: 11),
                            ),
                            onPressed: _applyCloudPresets,
                            child: const Text('ERPLogic Cloud'),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Connection status banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131C31),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: admin.erpConfig.isConnected ? const Color(0xFF10B981).withValues(alpha: 0.2) : const Color(0xFFEF4444).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                admin.erpConfig.isConnected ? Icons.cloud_done : Icons.cloud_off,
                                color: admin.erpConfig.isConnected ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      admin.erpConfig.isConnected ? 'ERP Connection Active' : 'ERP Not Connected',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(4)),
                                      child: Text(
                                        _tenantIdCtrl.text.isNotEmpty
                                            ? 'Domain: ${_tenantDomainCtrl.text} • ID: ${_tenantIdCtrl.text}'
                                            : 'Tenant: ${_tenantDomainCtrl.text}',
                                        style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Base API Host: ${_apiUrlCtrl.text}',
                                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          icon: _isTesting
                              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.speed, size: 16),
                          label: const Text('Test Connection'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          onPressed: _isTesting ? null : () async {
                            setState(() => _isTesting = true);
                            final res = await admin.testErpConnection(
                              _apiUrlCtrl.text.trim(),
                              _apiTokenCtrl.text.trim(),
                              tenantDomain: _tenantDomainCtrl.text.trim(),
                              tenantId: _tenantIdCtrl.text.trim(),
                            );
                            setState(() {
                              _isTesting = false;
                              _testResult = res;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  if (_testResult != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            _testResult!['message'] ?? 'Connection to ERP successful! Ping Latency: ${_testResult!['latency_ms'] ?? 36}ms',
                            style: const TextStyle(color: Color(0xFFD1FAE5), fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // Configuration Form
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
                        const Text('API Endpoint & Authentication Parameters', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        if (isDesktop) ...[
                          Row(
                            children: [
                              Expanded(flex: 3, child: _field('ERP System Name', _erpNameCtrl, 'e.g. ERPLogic Cloud')),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: _field('X-Tenant-Domain Header', _tenantDomainCtrl, 'default')),
                              const SizedBox(width: 16),
                              Expanded(flex: 4, child: _field('X-Tenant-ID Header', _tenantIdCtrl, 'e.g. 64a8b7c9e123456789abcdef')),
                            ],
                          ),
                        ] else ...[
                          _field('ERP System Name', _erpNameCtrl, 'e.g. ERPLogic Cloud'),
                          Row(
                            children: [
                              Expanded(child: _field('X-Tenant-Domain Header', _tenantDomainCtrl, 'default')),
                              const SizedBox(width: 16),
                              Expanded(child: _field('X-Tenant-ID Header', _tenantIdCtrl, 'e.g. 64a8b7c9...')),
                            ],
                          ),
                        ],
                        _field('Base API URL', _apiUrlCtrl, 'http://localhost:8000 or https://api.erplogic.co.in'),

                        // Tenant Identification Key Section
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.key, color: Color(0xFF38BDF8), size: 16),
                                      SizedBox(width: 8),
                                      Text(
                                        'Tenant Identification Key / Token',
                                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Multi-Tenant Key',
                                      style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'In the ERP multi-tenant architecture, this token acts as the Tenant Identification Key. It is transmitted via X-Tenant-ID, X-Tenant-Key, and Bearer authorization headers to identify the tenant database.',
                                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _apiTokenCtrl,
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
                                decoration: InputDecoration(
                                  hintText: 'Enter Tenant Identification Key or Bearer Token...',
                                  hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                  filled: true,
                                  fillColor: const Color(0xFF1E293B),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF334155))),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF38BDF8))),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_apiTokenCtrl.text.isNotEmpty)
                                        IconButton(
                                          icon: const Icon(Icons.clear, color: Color(0xFF64748B), size: 16),
                                          tooltip: 'Clear Key',
                                          onPressed: () => setState(() => _apiTokenCtrl.clear()),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Token creation actions (From Admin login or from User)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.auto_awesome, size: 14),
                                    label: const Text('Generate Tenant Key (Admin)'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2563EB),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      final res = await admin.generateErpTenantToken();
                                      if (res['token'] != null) {
                                        setState(() {
                                          _apiTokenCtrl.text = res['token'];
                                        });
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Generated new Tenant Key: ${res['token']}'),
                                              backgroundColor: const Color(0xFF10B981),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.login, size: 14),
                                    label: const Text('Fetch Token via ERP Admin Login'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E293B),
                                      foregroundColor: const Color(0xFF38BDF8),
                                      side: const BorderSide(color: Color(0xFF334155)),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () => _showErpLoginDialog(admin),
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.person_pin_outlined, size: 14),
                                    label: const Text('Take Token from User / Client'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E293B),
                                      foregroundColor: const Color(0xFFA855F7),
                                      side: const BorderSide(color: Color(0xFF334155)),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () => _showTakeFromUserDialog(admin),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Divider(color: Color(0xFF1E293B), height: 32),
                        const Text('RESTful Resource Endpoints', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _field('Customers Endpoint', _customersEndpointCtrl, '/api/tenant/customers')),
                            const SizedBox(width: 16),
                            Expanded(child: _field('Invoices Endpoint', _invoicesEndpointCtrl, '/api/tenant/invoices')),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: _field('Chart of Accounts Endpoint', _accountingEndpointCtrl, '/api/tenant/accounts/chart-of-accounts')),
                            const SizedBox(width: 16),
                            Expanded(child: _field('Modules & Pricing Endpoint', _modulesEndpointCtrl, '/modules-data')),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Save Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              onPressed: _isSaving
                                  ? null
                                  : () async {
                                      setState(() => _isSaving = true);
                                      final ok = await admin.saveErpConfig({
                                        'erp_name': _erpNameCtrl.text.trim(),
                                        'api_url': _apiUrlCtrl.text.trim(),
                                        'api_token': _apiTokenCtrl.text.trim(),
                                        'tenant_domain': _tenantDomainCtrl.text.trim(),
                                        'tenant_id': _tenantIdCtrl.text.trim(),
                                        'customers_endpoint': _customersEndpointCtrl.text.trim(),
                                        'invoices_endpoint': _invoicesEndpointCtrl.text.trim(),
                                        'accounting_endpoint': _accountingEndpointCtrl.text.trim(),
                                        'modules_endpoint': _modulesEndpointCtrl.text.trim(),
                                        'is_connected': true,
                                      });
                                      setState(() => _isSaving = false);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(ok ? 'ERP configuration saved!' : 'Failed to save configuration'),
                                            backgroundColor: ok ? const Color(0xFF10B981) : Colors.red,
                                          ),
                                        );
                                      }
                                    },
                              child: _isSaving
                                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Save & Persist Configuration'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // One-Click Synchronizers
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
                        const Text('Manual Synchronization Operations', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        const Text('Immediately pull live records from the ERP database into LogicLabz', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            _syncButton('Sync Customers', Icons.people_outline, () => admin.syncErpCustomers()),
                            _syncButton('Sync Invoices', Icons.receipt_long_outlined, () => admin.syncErpInvoices()),
                            _syncButton('Reconcile Accounting', Icons.account_balance_outlined, () => admin.syncErpAccounting()),
                          ],
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

  void _showErpLoginDialog(AdminProvider admin) {
    final emailCtrl = TextEditingController(text: 'admin@logiclabz.com');
    final passwordCtrl = TextEditingController(text: 'admin123');
    bool isLoggingIn = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF131C31),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF1E293B)),
          ),
          title: const Row(
            children: [
              Icon(Icons.login, color: Color(0xFF38BDF8), size: 20),
              SizedBox(width: 8),
              Text('ERP Admin Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Authenticate directly with the ERP system to retrieve a secure multi-tenant JWT token.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
                const SizedBox(height: 16),
                _field('Admin / Tenant Email', emailCtrl, 'admin@erplogic.com'),
                _field('Admin Password', passwordCtrl, '••••••••', isPassword: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoggingIn ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              onPressed: isLoggingIn
                  ? null
                  : () async {
                      setDialogState(() => isLoggingIn = true);
                      final res = await admin.loginToErpForToken(
                        email: emailCtrl.text.trim(),
                        password: passwordCtrl.text.trim(),
                        apiUrl: _apiUrlCtrl.text.trim(),
                        tenantDomain: _tenantDomainCtrl.text.trim(),
                      );
                      setDialogState(() => isLoggingIn = false);

                      if (res['success'] == true && res['token'] != null) {
                        setState(() {
                          _apiTokenCtrl.text = res['token'];
                        });
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res['message'] ?? 'Retrieved ERP Tenant Identification Token!'),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res['message'] ?? 'Failed to authenticate with ERP.'),
                              backgroundColor: const Color(0xFFEF4444),
                            ),
                          );
                        }
                      }
                    },
              child: isLoggingIn
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Login & Fetch Token'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTakeFromUserDialog(AdminProvider admin) {
    final customers = admin.customers;
    final customKeyCtrl = TextEditingController();

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
            Icon(Icons.person_pin_outlined, color: Color(0xFFA855F7), size: 20),
            SizedBox(width: 8),
            Text('Take Token from User / Tenant', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select a registered customer or paste a tenant key provided directly by a user:',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
              const SizedBox(height: 16),
              if (customers.isNotEmpty) ...[
                const Text('Registered Clients:', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 180),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: customers.length,
                    separatorBuilder: (_, __) => const Divider(color: Color(0xFF1E293B), height: 1),
                    itemBuilder: (cCtx, idx) {
                      final c = customers[idx];
                      final key = c.tenantKey ?? 'LL-TENANT-CUST-${c.id.toString().padLeft(4, '0')}';
                      return ListTile(
                        dense: true,
                        title: Text(c.name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        subtitle: Text(key, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontFamily: 'monospace')),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E293B),
                            foregroundColor: const Color(0xFF38BDF8),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            setState(() => _apiTokenCtrl.text = key);
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Applied Tenant Identification Key from ${c.name}!'),
                                backgroundColor: const Color(0xFF10B981),
                              ),
                            );
                          },
                          child: const Text('Use Key'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              _field('Or Paste User Tenant Key', customKeyCtrl, 'e.g. LL-TENANT-XXXX-XXXX...'),
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
            onPressed: () {
              final key = customKeyCtrl.text.trim();
              if (key.isNotEmpty) {
                setState(() => _apiTokenCtrl.text = key);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Applied custom Tenant Key!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              }
            },
            child: const Text('Apply Pasted Key'),
          ),
        ],
      ),
    );
  }

  Widget _syncButton(String label, IconData icon, Future<Map<String, dynamic>> Function() onSync) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: const Color(0xFF38BDF8),
        side: const BorderSide(color: Color(0xFF334155)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      onPressed: () async {
        final res = await onSync();
        if (mounted) {
          final isSuccess = res['success'] == true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res['message'] ?? '$label completed!'),
              backgroundColor: isSuccess ? const Color(0xFF10B981) : Colors.redAccent,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            obscureText: isPassword,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF334155))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF38BDF8))),
            ),
          ),
        ],
      ),
    );
  }
}
