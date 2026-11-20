import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/invoice_model.dart';

class InvoiceDetailDialog extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceDetailDialog({super.key, required this.invoice});

  static void show(BuildContext context, InvoiceModel invoice) {
    showDialog(
      context: context,
      builder: (ctx) => InvoiceDetailDialog(invoice: invoice),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final isPaid = invoice.isPaid;

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 850),
        child: Column(
          children: [
            // Header bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.receipt_long, color: Color(0xFF38BDF8), size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'TAX INVOICE: ${invoice.invoiceNumber}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.print, size: 16),
                        label: const Text('Print / PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tax Invoice sent to system printer / PDF generator!'),
                              backgroundColor: Color(0xFF10B981),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Invoice Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header info & Status Stamp
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1D4ED8),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(Icons.bolt, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'LogicLabz Technologies',
                                    style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Text('Tower B, Tech Innovation Hub, SmartCity', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              const Text('Kochi, Kerala, India - 682050', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              const Text('GSTIN: 32AABCL1234F1Z0', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 12)),
                              const Text('Email: accounts@logiclabz.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isPaid ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                                  border: Border.all(color: isPaid ? const Color(0xFF22C55E) : const Color(0xFFEF4444)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isPaid ? 'PAID' : 'PAYMENT DUE',
                                  style: TextStyle(
                                    color: isPaid ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              if (invoice.isSynced) ...[
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFF93C5FD)),
                                  ),
                                  child: Text(
                                    'ERP ID: ${invoice.erpInvoiceId ?? 'ERP-SYNCED'}',
                                    style: const TextStyle(color: Color(0xFF1D4ED8), fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text('Date: ${invoice.createdAt?.substring(0, 10) ?? '2026-11-05'}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              if (invoice.dueDate != null)
                                Text('Due Date: ${invoice.dueDate}', style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),

                      const Divider(color: Color(0xFFE2E8F0), height: 32),

                      // Billed To Box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('BILLED TO:', style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    invoice.customer?['company_name'] ?? 'Logic Enterprise Solutions Ltd',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                                  ),
                                  Text(invoice.customer?['name'] ?? 'Jesvin Client', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                                  Text(invoice.customer?['email'] ?? 'client@logiclabz.com', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('CUSTOMER GSTIN:', style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(
                                  invoice.customer?['gstin'] ?? '29ABCDE1234F1Z5',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                                ),
                                if (invoice.paymentMethod != null)
                                  Text('Payment: ${invoice.paymentMethod}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Items Table
                      Table(
                        border: TableBorder(
                          bottom: const BorderSide(color: Color(0xFFCBD5E1)),
                          horizontalInside: const BorderSide(color: Color(0xFFF1F5F9)),
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                            children: [
                              _tableHeader('Item & Description'),
                              _tableHeader('Qty', align: TextAlign.center),
                              _tableHeader('Rate', align: TextAlign.right),
                              _tableHeader('Amount', align: TextAlign.right),
                            ],
                          ),
                          if (invoice.items.isNotEmpty)
                            ...invoice.items.map((item) => TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                      child: Text(item.description, style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                      child: Text('${item.quantity}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                      child: Text(currencyFormatter.format(item.unitPrice), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                      child: Text(currencyFormatter.format(item.total), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    ),
                                  ],
                                ))
                          else
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                  child: Text('Enterprise Software & ERP Subscription Package', style: TextStyle(fontSize: 12, color: Color(0xFF1E293B))),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                  child: Text('1', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                  child: Text(currencyFormatter.format(invoice.amount), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                  child: Text(currencyFormatter.format(invoice.amount), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                ),
                              ],
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Totals & Tax Calculation Breakdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 280,
                            child: Column(
                              children: [
                                _summaryRow('Subtotal (Taxable):', currencyFormatter.format(invoice.amount)),
                                const SizedBox(height: 4),
                                _summaryRow('CGST (9.0%):', currencyFormatter.format(invoice.cgst)),
                                const SizedBox(height: 4),
                                _summaryRow('SGST (9.0%):', currencyFormatter.format(invoice.sgst)),
                                const Divider(color: Color(0xFFCBD5E1), height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                                    Text(
                                      currencyFormatter.format(invoice.totalAmount),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D4ED8)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Footer & Bank Details
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('REMITTANCE BANK DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                SizedBox(height: 2),
                                Text('ICICI Bank Ltd | Current A/c: 000205001234', style: TextStyle(fontSize: 11, color: Colors.black87)),
                                Text('IFSC: ICIC0000002 | Branch: Infopark, Kochi', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('AUTHORIZED SIGNATORY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                SizedBox(height: 4),
                                Text('LogicLabz Tech Finance', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
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
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(String title, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Text(
        title,
        textAlign: align,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A), fontWeight: FontWeight.w500)),
      ],
    );
  }
}
