import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/admin_provider.dart';

class CreateInvoiceDialog extends StatefulWidget {
  const CreateInvoiceDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const CreateInvoiceDialog(),
    );
  }

  @override
  State<CreateInvoiceDialog> createState() => _CreateInvoiceDialogState();
}

class _CreateInvoiceDialogState extends State<CreateInvoiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceNumberCtrl = TextEditingController(text: 'INV-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch % 9999}');
  final _amountCtrl = TextEditingController(text: '25000');
  final _descriptionCtrl = TextEditingController(text: 'Enterprise ERP Implementation & Module Licenses');
  final _dueDateCtrl = TextEditingController(text: '2026-12-15');
  final _notesCtrl = TextEditingController(text: 'Net 30 payment terms via ICICI bank transfer or gateway');

  final String _status = 'unpaid';
  bool _pushToErp = true;
  int _selectedCustomerId = 1;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _invoiceNumberCtrl.dispose();
    _amountCtrl.dispose();
    _descriptionCtrl.dispose();
    _dueDateCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final customers = admin.customers;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    final double subtotal = double.tryParse(_amountCtrl.text) ?? 0.0;
    final double cgst = subtotal * 0.09;
    final double sgst = subtotal * 0.09;
    final double tax = cgst + sgst;
    final double total = subtotal + tax;

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
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
                        Icon(Icons.post_add, color: Color(0xFF38BDF8), size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Generate Tax Invoice',
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
                      isExpanded: true,
                      dropdownColor: const Color(0xFF1E293B),
                      value: customers.any((c) => c.id == _selectedCustomerId) ? _selectedCustomerId : (customers.isNotEmpty ? customers.first.id : 1),
                      items: customers.map((c) {
                        return DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(
                            '${c.name} (${c.companyName ?? 'Individual'})',
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCustomerId = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Invoice Number & Due Date Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Invoice Number', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _invoiceNumberCtrl,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: _inputDecoration('e.g. INV-2026-004'),
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Due Date', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _dueDateCtrl,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: _inputDecoration('YYYY-MM-DD'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amount (Subtotal)
                const Text('Taxable Subtotal (₹)', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: _inputDecoration('Amount in INR'),
                  onChanged: (_) => setState(() {}),
                  validator: (v) => double.tryParse(v ?? '') == null ? 'Enter valid amount' : null,
                ),
                const SizedBox(height: 16),

                // Description
                const Text('Line Item Description', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _descriptionCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: _inputDecoration('e.g. Enterprise ERP Setup & Licenses'),
                ),
                const SizedBox(height: 16),

                // Tax Calculation Summary Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    children: [
                      _previewRow('Taxable Subtotal:', currencyFormatter.format(subtotal)),
                      const SizedBox(height: 4),
                      _previewRow('CGST (9%):', currencyFormatter.format(cgst)),
                      const SizedBox(height: 4),
                      _previewRow('SGST (9%):', currencyFormatter.format(sgst)),
                      const Divider(color: Color(0xFF334155), height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Grand Total (Incl. 18% GST):', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(
                            currencyFormatter.format(total),
                            style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Push to ERP Checkbox
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _pushToErp,
                  activeColor: const Color(0xFF2563EB),
                  title: const Text('Push Directly to ERP (be-app)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Automatically syncs this tax invoice into the ERP billing ledger', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  onChanged: (v) => setState(() => _pushToErp = v ?? true),
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() => _isSubmitting = true);
                                final success = await admin.createInvoice({
                                  'invoice_number': _invoiceNumberCtrl.text.trim(),
                                  'user_id': _selectedCustomerId,
                                  'amount': subtotal,
                                  'tax_amount': tax,
                                  'total_amount': total,
                                  'due_date': _dueDateCtrl.text.trim(),
                                  'status': _status,
                                  'notes': _notesCtrl.text.trim(),
                                  'push_to_erp': _pushToErp,
                                  'items': [
                                    {
                                      'description': _descriptionCtrl.text.trim(),
                                      'quantity': 1,
                                      'unit_price': subtotal,
                                      'total': subtotal,
                                    }
                                  ]
                                });
                                setState(() => _isSubmitting = false);
                                if (mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(success ? 'Invoice generated successfully!' : 'Failed to create invoice'),
                                      backgroundColor: success ? const Color(0xFF10B981) : Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                      child: _isSubmitting
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Create & Issue Invoice'),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  Widget _previewRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
