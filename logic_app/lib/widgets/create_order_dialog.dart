import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/admin_provider.dart';
import '../services/erp_service.dart';

class CreateOrderDialog extends StatefulWidget {
  const CreateOrderDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const CreateOrderDialog(),
    );
  }

  @override
  State<CreateOrderDialog> createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends State<CreateOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityCtrl = TextEditingController(text: '1');
  final _unitPriceCtrl = TextEditingController(text: '15000');
  final _notesCtrl = TextEditingController(text: 'Deployment order placed via LogicLabz Admin Console');

  int? _selectedCustomerId;
  String? _selectedErpCustomerId;
  String _selectedProductId = '69b7db106508aed9af043bf9'; // Default: Static Website
  String _selectedProductName = 'Static Website';
  String _selectedProductCode = 'Stc-Web';
  String _status = 'completed';
  bool _isSubmitting = false;
  bool _isLoadingProducts = true;
  List<Map<String, dynamic>> _erpProducts = [];

  final List<Map<String, dynamic>> _fallbackProducts = [
    {
      'id': '69b7db106508aed9af043bf9',
      'name': 'Static Website',
      'code': 'Stc-Web',
      'price': 15000,
    },
    {
      'id': '69b7dcc006e1a25ca50e0959',
      'name': 'Dynamic Website',
      'code': 'Dyn Web',
      'price': 20000,
    },
    {
      'id': '69b7df2639c3713c910bc677',
      'name': 'Application Developement',
      'code': 'AppDev',
      'price': 50000,
    },
    {
      'id': '6a225a219d362a04b00624a7',
      'name': 'Domain Service',
      'code': 'TLD',
      'price': 1273,
    },
    {
      'id': '69f37704d19830c9c70fd0f8',
      'name': 'Server Space',
      'code': 'SS',
      'price': 2500,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final prods = await ErpService.getProducts();
    if (mounted) {
      setState(() {
        _erpProducts = prods.isNotEmpty ? prods : _fallbackProducts;
        _isLoadingProducts = false;
        if (_erpProducts.isNotEmpty) {
          final first = _erpProducts.first;
          _selectedProductId = first['id']?.toString() ?? '';
          _selectedProductName = first['name']?.toString() ?? '';
          _selectedProductCode = first['code']?.toString() ?? 'ERP-PROD';
          _unitPriceCtrl.text = (first['price'] ?? 15000).toString();
        }
      });
    }
  }

  @override
  void dispose() {
    _quantityCtrl.dispose();
    _unitPriceCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final customers = admin.customers;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    if (_selectedCustomerId == null && customers.isNotEmpty) {
      _selectedCustomerId = customers.first.id;
      _selectedErpCustomerId = customers.first.erpCustomerId;
    }

    final double qty = double.tryParse(_quantityCtrl.text) ?? 1.0;
    final double unitPrice = double.tryParse(_unitPriceCtrl.text) ?? 0.0;
    final double total = qty * unitPrice;

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shopping_cart_checkout, color: Color(0xFF38BDF8), size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Create Order (Sync to ERP)',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF334155), height: 24),

                // Multi-Tenant ERP Notice
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.cloud_sync, color: Color(0xFF38BDF8), size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This order will be automatically dispatched to external ERP (api.erplogic.co.in) via POST /api/tenant/orders.',
                          style: TextStyle(color: Color(0xFF93C5FD), fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Customer Selection
                const Text('Select Customer', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedCustomerId,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF1E293B),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      items: customers.map((c) {
                        return DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(
                            '${c.name} (${(c.companyName?.isNotEmpty ?? false) ? c.companyName : 'Individual'}) ${c.erpCustomerId != null ? '• [ERP]' : ''}',
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedCustomerId = val;
                            final matched = customers.firstWhere((c) => c.id == val, orElse: () => customers.first);
                            _selectedErpCustomerId = matched.erpCustomerId;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Product Selection
                const Text('Select Product / Service (ERP Catalog)', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: _isLoadingProducts
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                              SizedBox(width: 10),
                              Text('Loading ERP products...', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        )
                      : DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedProductId,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF1E293B),
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                            items: _erpProducts.map((p) {
                              final price = p['price'] ?? 0;
                              return DropdownMenuItem<String>(
                                value: p['id'].toString(),
                                child: Text(
                                  '${p['name']} (${p['code'] ?? 'PROD'}) • ₹$price',
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                final matched = _erpProducts.firstWhere((p) => p['id'].toString() == val, orElse: () => _erpProducts.first);
                                setState(() {
                                  _selectedProductId = val;
                                  _selectedProductName = matched['name']?.toString() ?? '';
                                  _selectedProductCode = matched['code']?.toString() ?? 'ERP-PROD';
                                  _unitPriceCtrl.text = (matched['price'] ?? 0).toString();
                                });
                              }
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 16),

                // Quantity and Unit Price
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Quantity', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _quantityCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: _inputDeco('1'),
                            onChanged: (_) => setState(() {}),
                            validator: (v) => (v == null || v.isEmpty || int.tryParse(v) == null || int.parse(v) < 1) ? 'Min 1' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Unit Price (₹)', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _unitPriceCtrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: _inputDeco('0.00'),
                            onChanged: (_) => setState(() {}),
                            validator: (v) => (v == null || v.isEmpty || double.tryParse(v) == null) ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Status', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF334155)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _status,
                                isExpanded: true,
                                dropdownColor: const Color(0xFF1E293B),
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                items: const [
                                  DropdownMenuItem(value: 'completed', child: Text('Completed', style: TextStyle(color: Colors.white, fontSize: 13))),
                                  DropdownMenuItem(value: 'pending', child: Text('Pending', style: TextStyle(color: Colors.white, fontSize: 13))),
                                ],
                                onChanged: (v) => setState(() => _status = v ?? 'completed'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Notes / Scope
                const Text('Order Notes / Scope', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: _inputDeco('Customer requirements or deliverables...'),
                ),
                const SizedBox(height: 16),

                // Total Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Grand Total (INR)', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            currencyFormatter.format(total),
                            style: const TextStyle(color: Color(0xFF10B981), fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${qty.toInt()} × ${_selectedProductCode.isNotEmpty ? _selectedProductCode : 'ITEM'}',
                          style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: _isSubmitting
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.cloud_upload_outlined, size: 16),
                      label: Text(_isSubmitting ? 'Creating in ERP...' : 'Create Order & Sync to ERP'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _isSubmitting ? null : _submitOrder,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final admin = context.read<AdminProvider>();
    final qty = int.tryParse(_quantityCtrl.text) ?? 1;
    final unitPrice = double.tryParse(_unitPriceCtrl.text) ?? 0.0;

    final payload = {
      'customer_id': _selectedErpCustomerId ?? _selectedCustomerId,
      'user_id': _selectedCustomerId,
      'status': _status,
      'notes': _notesCtrl.text.trim(),
      'items': [
        {
          'product_id': _selectedProductId,
          'product_name': _selectedProductName,
          'product_code': _selectedProductCode,
          'quantity': qty,
          'unit_price': unitPrice,
        }
      ],
    };

    final res = await admin.createOrder(payload);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (res['success'] == true) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Order created and synchronized with ERP!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Failed to create order.'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF38BDF8)),
      ),
    );
  }
}
