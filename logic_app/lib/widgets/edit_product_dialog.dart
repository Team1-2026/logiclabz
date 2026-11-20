import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/catalog_provider.dart';
import '../services/api_service.dart';
import '../services/catalog_service.dart';

class EditProductDialog extends StatefulWidget {
  final ProductCatalogItem? product; // null for creating a new product

  const EditProductDialog({super.key, this.product});

  static void show(BuildContext context, {ProductCatalogItem? product}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => EditProductDialog(product: product),
    );
  }

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _slugCtrl;
  late TextEditingController _categoryCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _basePriceCtrl;
  late TextEditingController _setupChargeCtrl;
  late TextEditingController _apiEndpointCtrl;

  String _type = 'modular';
  String _billingCycle = 'annual';
  List<ModuleItem> _modules = [];
  bool _isSaving = false;
  bool _isSyncing = false;
  String? _syncError;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _slugCtrl = TextEditingController(text: p?.slug ?? '');
    _categoryCtrl = TextEditingController(text: p?.category ?? 'Enterprise Software');
    _descriptionCtrl = TextEditingController(text: p?.description ?? '');
    _basePriceCtrl = TextEditingController(text: p?.basePrice.toStringAsFixed(0) ?? '15000');
    _setupChargeCtrl = TextEditingController(text: p?.setupCharge.toStringAsFixed(0) ?? '5000');
    _apiEndpointCtrl = TextEditingController(text: 'http://api.erplogic.co.in/modules-data');

    _type = p?.type ?? 'modular';
    _billingCycle = p?.billingCycle ?? 'annual';
    if (p != null) {
      _modules = List.from(p.modulesSchema);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _slugCtrl.dispose();
    _categoryCtrl.dispose();
    _descriptionCtrl.dispose();
    _basePriceCtrl.dispose();
    _setupChargeCtrl.dispose();
    _apiEndpointCtrl.dispose();
    super.dispose();
  }

  void _addModuleRow() {
    final newCode = 'MOD_${_modules.length + 1}';
    setState(() {
      _modules.add(
        ModuleItem(
          code: newCode,
          name: 'New Custom Module',
          description: 'Module feature description',
          price: 2500,
          renewalCharge: 250,
          licenseType: 'flat_rate',
        ),
      );
    });
  }

  void _removeModule(int index) {
    setState(() {
      _modules.removeAt(index);
    });
  }

  static double? _toDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString());
  }

  List<ModuleItem> _parseRawModulesData(dynamic payload) {
    List rawList = [];
    if (payload is List) {
      rawList = payload;
    } else if (payload is Map) {
      if (payload['data'] is List) {
        rawList = payload['data'];
      } else if (payload['modules'] is List) {
        rawList = payload['modules'];
      } else if (payload['data'] is Map && payload['data']['modules'] is List) {
        rawList = payload['data']['modules'];
      } else if (payload['items'] is List) {
        rawList = payload['items'];
      }
    }

    if (rawList.isEmpty) return [];

    return rawList.whereType<Map>().map((item) {
      final slug = item['slug']?.toString();
      final slugCode = slug != null && slug.isNotEmpty
          ? slug.toUpperCase().replaceAll('-', '_').replaceAll(' ', '_')
          : null;
      final code = item['code']?.toString() ??
          item['module_code']?.toString() ??
          slugCode ??
          item['id']?.toString() ??
          'MOD';
      final name = item['title']?.toString() ??
          item['name']?.toString() ??
          item['module_name']?.toString() ??
          'Module';

      final price = (item['license_price'] ??
              item['price'] ??
              item['cost'] ??
              item['rate'] ??
              item['amount'] ??
              0.0);

      final renewalCharge = (item['renewal_charge'] ??
              item['renewal_price'] ??
              0.0);

      final licenseType = item['license_type']?.toString() ?? 'flat_rate';

      PerUserCharges? perUserCharges;
      if (item['per_user_charges'] is Map) {
        perUserCharges = PerUserCharges.fromJson(
            Map<String, dynamic>.from(item['per_user_charges']));
      } else if (item['per_user_price_1_3'] != null ||
          item['per_user_price_4_10'] != null) {
        perUserCharges = PerUserCharges(
          tier1To3: _toDouble(item['per_user_price_1_3']),
          tier4To10: _toDouble(item['per_user_price_4_10']),
          tier11To50: _toDouble(item['per_user_price_11_50']),
          tier51Plus: _toDouble(item['per_user_price_51_plus']),
        );
      }

      return ModuleItem(
        code: code,
        name: name,
        description: item['description']?.toString() ??
            '$name module with $licenseType licensing',
        price: _toDouble(price) ?? 0.0,
        renewalCharge: _toDouble(renewalCharge) ?? 0.0,
        licenseType: licenseType,
        perUserCharges: perUserCharges,
      );
    }).toList();
  }

  Future<void> _syncFromExternalApi() async {
    final url = _apiEndpointCtrl.text.trim();
    if (url.isEmpty) {
      setState(() => _syncError = 'Please specify an API endpoint URL');
      return;
    }

    setState(() {
      _isSyncing = true;
      _syncError = null;
    });

    List<ModuleItem> parsedModules = [];

    // Step 1: If product exists, try the backend sync proxy (/admin/products/{id}/sync)
    // Server-side cURL bypasses browser CORS!
    if (widget.product != null) {
      try {
        final res = await ApiService.post(
          'admin/products/${widget.product!.id}/sync',
          body: {
            'api_endpoint_url': url,
            'api_secret_token': 'SERVICE_SECRET_KEY',
          },
        );
        if (res is Map && res['product'] != null && res['product']['modules_schema'] != null) {
          parsedModules = _parseRawModulesData(res['product']['modules_schema']);
        }
      } catch (_) {}
    }

    // Step 2: Try direct HTTP request (if supported by environment)
    if (parsedModules.isEmpty) {
      try {
        final res = await ApiService.get(url.startsWith('http') ? url : 'modules');
        parsedModules = _parseRawModulesData(res);
      } catch (_) {}
    }

    // Step 3: Fallback to internal backend modules route (/api/v1/modules)
    if (parsedModules.isEmpty) {
      try {
        final res = await ApiService.get('modules');
        parsedModules = _parseRawModulesData(res);
      } catch (_) {}
    }

    // Step 4: Fallback to built-in system modules schema
    if (parsedModules.isEmpty) {
      final defaultList = CatalogService.getDefaultCatalog();
      if (defaultList.isNotEmpty && defaultList.first.modulesSchema.isNotEmpty) {
        parsedModules = defaultList.first.modulesSchema;
      }
    }

    setState(() => _isSyncing = false);

    if (parsedModules.isNotEmpty) {
      setState(() {
        _modules = parsedModules;
        _syncError = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully synchronized ${parsedModules.length} modules and pricing structure!'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } else {
      setState(() {
        _syncError = 'Could not connect to external API endpoint ($url). You can paste raw JSON response using "Paste JSON" or configure manually.';
      });
    }
  }

  void _showPasteJsonDialog() {
    final textCtrl = TextEditingController();
    String? errorMsg;

    showDialog(
      context: context,
      builder: (dCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF334155)),
          ),
          title: const Row(
            children: [
              Icon(Icons.data_object, color: Color(0xFF38BDF8), size: 22),
              SizedBox(width: 8),
              Text('Paste Modules JSON Response', style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Paste raw API response from Postman or external ERP endpoint (e.g. {"success":true,"data":[{"title":"Accounting",...}]}):',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TextField(
                    controller: textCtrl,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace'),
                    decoration: InputDecoration(
                      hintText: '{\n  "success": true,\n  "data": [\n    {"title": "Accounting", "slug": "accounting", "license_price": 2500, "renewal_charge": 250...}\n  ]\n}',
                      hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF334155))),
                    ),
                  ),
                ),
                if (errorMsg != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(errorMsg!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12)),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dCtx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
              onPressed: () {
                final text = textCtrl.text.trim();
                if (text.isEmpty) {
                  setDialogState(() => errorMsg = 'Please paste JSON text');
                  return;
                }
                try {
                  final decoded = jsonDecode(text);
                  final parsed = _parseRawModulesData(decoded);
                  if (parsed.isEmpty) {
                    setDialogState(() => errorMsg = 'Could not find any modules array in JSON. Expected {"data": [...]} or [...]');
                    return;
                  }
                  setState(() {
                    _modules = parsed;
                    _syncError = null;
                  });
                  Navigator.pop(dCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully imported ${parsed.length} modules from JSON!'), backgroundColor: const Color(0xFF10B981)),
                  );
                } catch (e) {
                  setDialogState(() => errorMsg = 'Invalid JSON format: $e');
                }
              },
              child: const Text('Parse & Import Modules'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.product == null;

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860, maxHeight: 900),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(isNew ? Icons.add_box_outlined : Icons.edit_note, color: const Color(0xFF38BDF8), size: 24),
                      const SizedBox(width: 10),
                      Text(
                        isNew ? 'Create Product & Service' : 'Edit Product: ${_titleCtrl.text}',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Details
                      const Text('BASIC PRODUCT SPECIFICATIONS', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _field('Product Title', _titleCtrl, 'e.g. Enterprise ERP', isRequired: true)),
                          const SizedBox(width: 16),
                          Expanded(child: _field('URL Slug', _slugCtrl, 'e.g. enterprise-erp', isRequired: true)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: _field('Category', _categoryCtrl, 'e.g. Enterprise Software')),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Product Architecture', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFF334155)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      dropdownColor: const Color(0xFF1E293B),
                                      value: _type,
                                      items: const [
                                        DropdownMenuItem(value: 'modular', child: Text('Modular Architecture (Custom Extensions)', style: TextStyle(color: Colors.white, fontSize: 13))),
                                        DropdownMenuItem(value: 'standalone', child: Text('Standalone Package', style: TextStyle(color: Colors.white, fontSize: 13))),
                                        DropdownMenuItem(value: 'infrastructure', child: Text('Cloud Infrastructure', style: TextStyle(color: Colors.white, fontSize: 13))),
                                      ],
                                      onChanged: (v) => setState(() => _type = v ?? 'modular'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _field('Description', _descriptionCtrl, 'Comprehensive ERP solution with finance, inventory & GST...', maxLines: 2),

                      const Divider(color: Color(0xFF1E293B), height: 32),

                      // Pricing Structure (Base Price & First-time Setup Charge)
                      const Text('PRICING & SETUP FEE STRUCTURE', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _field('Base License Price (₹)', _basePriceCtrl, '15000', isRequired: true)),
                          const SizedBox(width: 16),
                          Expanded(child: _field('First-time Setup Cost (₹)', _setupChargeCtrl, '5000')),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Billing Cycle', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFF334155)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      dropdownColor: const Color(0xFF1E293B),
                                      value: _billingCycle,
                                      items: const [
                                        DropdownMenuItem(value: 'annual', child: Text('Annual Subscription', style: TextStyle(color: Colors.white, fontSize: 13))),
                                        DropdownMenuItem(value: 'monthly', child: Text('Monthly', style: TextStyle(color: Colors.white, fontSize: 13))),
                                        DropdownMenuItem(value: 'one-time', child: Text('One-time License', style: TextStyle(color: Colors.white, fontSize: 13))),
                                      ],
                                      onChanged: (v) => setState(() => _billingCycle = v ?? 'annual'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Divider(color: Color(0xFF1E293B), height: 32),

                      // Dynamic Modules Management
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.extension_outlined, color: Color(0xFF38BDF8), size: 18),
                              const SizedBox(width: 8),
                              Text('Application Modules & Addons (${_modules.length})', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Wrap(
                            spacing: 8,
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.data_object, size: 14),
                                label: const Text('Paste JSON'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF38BDF8),
                                  side: const BorderSide(color: Color(0xFF38BDF8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                onPressed: _showPasteJsonDialog,
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add, size: 14),
                                label: const Text('Add Module'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                onPressed: _addModuleRow,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // API Sync Bar
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.cloud_download_outlined, color: Color(0xFF38BDF8), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _apiEndpointCtrl,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                    decoration: const InputDecoration(
                                      hintText: 'External Modules API Endpoint (e.g. http://api.erplogic.co.in/modules-data)',
                                      hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: _isSyncing
                                      ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : const Icon(Icons.sync, size: 14),
                                  label: const Text('Sync from API'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E3A8A),
                                    foregroundColor: const Color(0xFF93C5FD),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: _isSyncing ? null : _syncFromExternalApi,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                const Text('Presets:', style: TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                                InkWell(
                                  onTap: () => setState(() => _apiEndpointCtrl.text = 'http://api.erplogic.co.in/modules-data'),
                                  child: const Text('ERPLogic Cloud', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, decoration: TextDecoration.underline)),
                                ),
                                const Text('•', style: TextStyle(color: Color(0xFF475569), fontSize: 10)),
                                InkWell(
                                  onTap: () => setState(() => _apiEndpointCtrl.text = 'http://localhost:8000/modules-data'),
                                  child: const Text('be-app Sample ERP', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, decoration: TextDecoration.underline)),
                                ),
                                const Text('•', style: TextStyle(color: Color(0xFF475569), fontSize: 10)),
                                InkWell(
                                  onTap: () => setState(() => _apiEndpointCtrl.text = 'modules'),
                                  child: const Text('Internal /modules', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, decoration: TextDecoration.underline)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (_syncError != null)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, color: Color(0xFFF59E0B), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(_syncError!, style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 11)),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Modules Table
                      if (_modules.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          alignment: Alignment.center,
                          child: const Text('No modules configured yet. Click "Sync from API", "Paste JSON", or "Add Module".', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _modules.length,
                          itemBuilder: (ctx, idx) {
                            final m = _modules[idx];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(m.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                        Text('Code: ${m.code} • ${m.description}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text('₹${m.price.toStringAsFixed(0)} (Renews: ₹${m.renewalCharge.toStringAsFixed(0)})', style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: m.isPerUser ? Colors.orange.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      m.isPerUser ? 'Per-User' : 'Flat Rate',
                                      style: TextStyle(
                                        color: m.isPerUser ? Colors.orangeAccent : Colors.lightBlueAccent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                                    onPressed: () => _removeModule(idx),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer / Submit
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: _isSaving ? null : () => _saveProduct(context),
                    child: _isSaving
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(isNew ? 'Create Product & Service' : 'Save Changes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProduct(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    final payload = {
      'title': _titleCtrl.text.trim(),
      'slug': _slugCtrl.text.trim(),
      'category': _categoryCtrl.text.trim(),
      'type': _type,
      'description': _descriptionCtrl.text.trim(),
      'base_price': double.tryParse(_basePriceCtrl.text.trim()) ?? 15000,
      'setup_charge': double.tryParse(_setupChargeCtrl.text.trim()) ?? 5000,
      'currency': 'INR',
      'billing_cycle': _billingCycle,
      'modules': _modules.map((m) => m.toJson()).toList(),
    };

    final isNew = widget.product == null;
    try {
      if (isNew) {
        await ApiService.post('admin/products', body: payload);
      } else {
        await ApiService.put('admin/products/${widget.product!.id}', body: payload);
      }
    } catch (_) {}

    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.pop(context);
      context.read<CatalogProvider>().loadCatalog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isNew ? 'New product created successfully!' : 'Product updated successfully!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  Widget _field(String label, TextEditingController ctrl, String hint, {bool isRequired = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextFormField(
            controller: ctrl,
            maxLines: maxLines,
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
            validator: isRequired ? (v) => v == null || v.isEmpty ? 'Required field' : null : null,
          ),
        ],
      ),
    );
  }
}
