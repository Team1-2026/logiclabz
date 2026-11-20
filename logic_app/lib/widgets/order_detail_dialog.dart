import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';

class OrderDetailDialog extends StatelessWidget {
  final OrderModel order;

  const OrderDetailDialog({super.key, required this.order});

  static void show(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (ctx) => OrderDetailDialog(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final cust = order.customer;
    final items = order.items;

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shopping_bag_outlined, color: Color(0xFF38BDF8), size: 24),
                      const SizedBox(width: 8),
                      Text(
                        order.orderNumber,
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
              const SizedBox(height: 12),

              // Badges Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: order.isCompleted
                          ? const Color(0xFF10B981).withValues(alpha: 0.2)
                          : const Color(0xFFF59E0B).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        color: order.isCompleted ? const Color(0xFF34D399) : const Color(0xFFFBBF24),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: order.isSynced
                          ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                          : const Color(0xFF64748B).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.isSynced ? 'ERP: ${order.erpOrderId ?? 'SYNCED'}' : 'LOCAL ONLY',
                      style: TextStyle(
                        color: order.isSynced ? const Color(0xFF60A5FA) : const Color(0xFF94A3B8),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (order.createdAt != null)
                    Text(
                      'Created: ${order.createdAt!.length > 10 ? order.createdAt!.substring(0, 10) : order.createdAt}',
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                    ),
                ],
              ),
              const Divider(color: Color(0xFF334155), height: 24),

              // Customer Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CUSTOMER INFORMATION', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      cust?['name']?.toString() ?? 'Client',
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    if (cust?['company_name'] != null && cust!['company_name'].toString().isNotEmpty)
                      Text(
                        cust['company_name'].toString(),
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (cust?['email'] != null) ...[
                          const Icon(Icons.email_outlined, color: Colors.grey, size: 14),
                          const SizedBox(width: 4),
                          Text(cust!['email'].toString(), style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                          const SizedBox(width: 14),
                        ],
                        if (cust?['phone'] != null) ...[
                          const Icon(Icons.phone_outlined, color: Colors.grey, size: 14),
                          const SizedBox(width: 4),
                          Text(cust!['phone'].toString(), style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Line Items
              const Text('ORDER ITEMS', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (items.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Service Deployment Package', style: TextStyle(color: Colors.white, fontSize: 13)),
                      Text(currencyFormatter.format(order.totalAmount), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    children: items.map((it) {
                      final itemMap = it is Map ? it : {};
                      final name = itemMap['item_name'] ?? itemMap['name'] ?? itemMap['product']?['name'] ?? 'Item';
                      final code = itemMap['item_code'] ?? itemMap['code'] ?? itemMap['product']?['code'] ?? '';
                      final qty = itemMap['quantity'] ?? 1;
                      final unitPrice = double.tryParse(itemMap['unit_price']?.toString() ?? '') ?? 0.0;
                      final lineTotal = double.tryParse(itemMap['total_price']?.toString() ?? '') ?? (unitPrice * qty);

                      return ListTile(
                        dense: true,
                        title: Text(name.toString(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                        subtitle: code.toString().isNotEmpty ? Text(code.toString(), style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)) : null,
                        trailing: Text(
                          '${qty}x  ${currencyFormatter.format(lineTotal)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 16),

              // Notes
              if (order.notes != null && order.notes!.isNotEmpty) ...[
                const Text('NOTES / SCOPE', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.notes!,
                    style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Total Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF131C31),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(
                      currencyFormatter.format(order.totalAmount),
                      style: const TextStyle(color: Color(0xFF10B981), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Close Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
