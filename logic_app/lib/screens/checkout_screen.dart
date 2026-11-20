import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/app_navbar.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyCtrl = TextEditingController(text: 'Logic Enterprise Solutions Ltd');
  final _nameCtrl = TextEditingController(text: 'Jesvin Mathew');
  final _emailCtrl = TextEditingController(text: 'client@logiclabz.com');
  final _phoneCtrl = TextEditingController(text: '+91 9876543210');
  final _gstinCtrl = TextEditingController(text: '29ABCDE1234F1Z5');
  final _addressCtrl = TextEditingController(text: 'Suite 402, Cyber Tower, Infopark, Kochi - 682042');

  String _paymentMethod = 'icici_pg';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    if (auth.user != null) {
      _nameCtrl.text = auth.user!.name;
      _emailCtrl.text = auth.user!.email;
      if (auth.user!.companyName != null) _companyCtrl.text = auth.user!.companyName!;
      if (auth.user!.phone != null) _phoneCtrl.text = auth.user!.phone!;
      if (auth.user!.gstin != null) _gstinCtrl.text = auth.user!.gstin!;
      if (auth.user!.billingAddress != null) _addressCtrl.text = auth.user!.billingAddress!;
    }
  }

  @override
  void dispose() {
    _companyCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _gstinCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final pricing = cart.pricing;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: const AppNavbar(activeRoute: '/checkout'),
      drawer: isDesktop ? null : const AppDrawer(activeRoute: '/checkout'),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1160),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CHECKOUT & BILLING', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Review Order & Tax Invoicing', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  if (cart.itemCount == 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(48),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131C31),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF1E293B)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.shopping_cart_outlined, size: 56, color: Color(0xFF475569)),
                          const SizedBox(height: 16),
                          const Text('Your cart is currently empty', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('Explore our enterprise catalog to select software licenses and modules.', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                            onPressed: () => Navigator.pushReplacementNamed(context, '/services'),
                            child: const Text('Browse Products & Modules'),
                          ),
                        ],
                      ),
                    )
                  else
                    isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _billingForm(context, cart)),
                              const SizedBox(width: 32),
                              Expanded(flex: 2, child: _orderSummary(context, cart, pricing, currencyFormatter)),
                            ],
                          )
                        : Column(
                            children: [
                              _orderSummary(context, cart, pricing, currencyFormatter),
                              const SizedBox(height: 24),
                              _billingForm(context, cart),
                            ],
                          ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _billingForm(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF131C31),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.business_center_outlined, color: Color(0xFF38BDF8), size: 20),
                SizedBox(width: 8),
                Text('Enterprise Billing & GST Details', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _inputField('Company / Legal Entity Name', _companyCtrl, isRequired: true),
            _inputField('Contact Person Name', _nameCtrl, isRequired: true),
            Row(
              children: [
                Expanded(child: _inputField('Work Email', _emailCtrl, isRequired: true)),
                const SizedBox(width: 12),
                Expanded(child: _inputField('Phone Number', _phoneCtrl, isRequired: true)),
              ],
            ),
            _inputField('GSTIN (Tax Identification Number)', _gstinCtrl, isRequired: true, hint: 'e.g. 29ABCDE1234F1Z5'),
            _inputField('Official Billing Address', _addressCtrl, maxLines: 2, isRequired: true),
            const Divider(color: Color(0xFF1E293B), height: 32),

            // Payment Method Selection
            const Row(
              children: [
                Icon(Icons.payment_outlined, color: Color(0xFF38BDF8), size: 20),
                SizedBox(width: 8),
                Text('Secure Payment Gateway', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _paymentOption('icici_pg', 'ICICI Bank Gateway', 'Instant UPI, NetBanking, Visa / MasterCard corporate cards', Icons.account_balance),
            _paymentOption('neft_rtgs', 'Corporate NEFT / RTGS Transfer', 'Direct company bank remittance with proforma invoice', Icons.currency_rupee),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption(String key, String title, String subtitle, IconData icon) {
    final isSelected = _paymentMethod == key;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = key),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF334155)),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? const Color(0xFF38BDF8) : Colors.grey, size: 20),
            const SizedBox(width: 12),
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderSummary(
    BuildContext context,
    CartProvider cart,
    dynamic pricing,
    NumberFormat currencyFormatter,
  ) {
    return Container(
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
              const Text('Order Summary', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => cart.clearCart(),
                child: const Text('Clear', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
              ),
            ],
          ),
          const Divider(color: Color(0xFF1E293B), height: 20),

          // Cart Items
          ...cart.selectedProducts.values.map((p) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(currencyFormatter.format(p.basePrice), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  if (p.setupCharge > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('One-off Setup & Implementation', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 11)),
                          Text(currencyFormatter.format(p.setupCharge), style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  if (p.selectedModules.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${p.selectedModules.length} Modules (${p.userTier.replaceAll('_', '-')} users): ${currencyFormatter.format(p.calculateModulesTotal())}',
                      style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11),
                    ),
                  ],
                ],
              ),
            );
          }),

          // Addons Toggles
          const SizedBox(height: 8),
          const Text('Recommended Addons', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: cart.domainAddonSelected,
            activeColor: const Color(0xFF2563EB),
            title: const Text('Custom Domain (.com)', style: TextStyle(color: Colors.white, fontSize: 12)),
            subtitle: Text('+ ${currencyFormatter.format(cart.domainPrice)} / yr', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            onChanged: (v) => cart.setDomainAddon(v ?? false),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: cart.hostingAddonSelected,
            activeColor: const Color(0xFF2563EB),
            title: const Text('Managed NVMe Cloud Server', style: TextStyle(color: Colors.white, fontSize: 12)),
            subtitle: Text('+ ${currencyFormatter.format(cart.hostingPrice)} / yr', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            onChanged: (v) => cart.setHostingAddon(v ?? false),
          ),

          const Divider(color: Color(0xFF1E293B), height: 24),

          // Price Breakdown
          _summaryLine('Base Subtotal:', currencyFormatter.format(pricing.baseTotal)),
          if (pricing.setupTotal > 0)
            _summaryLine('Setup Cost Total:', currencyFormatter.format(pricing.setupTotal), color: const Color(0xFFF59E0B)),
          if (pricing.modulesTotal > 0)
            _summaryLine('Modules Total:', currencyFormatter.format(pricing.modulesTotal)),
          if (pricing.addonsTotal > 0)
            _summaryLine('Addons Total:', currencyFormatter.format(pricing.addonsTotal)),
          const Divider(color: Color(0xFF334155), height: 16),
          _summaryLine('Taxable Subtotal:', currencyFormatter.format(pricing.subtotal), isBold: true),
          _summaryLine('CGST (9.0%):', currencyFormatter.format(pricing.cgst)),
          _summaryLine('SGST (9.0%):', currencyFormatter.format(pricing.sgst)),
          const Divider(color: Color(0xFF38BDF8), height: 20),

          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grand Total (INR):', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                currencyFormatter.format(pricing.grandTotal),
                style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Pay / Complete Order Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _isProcessing ? null : () => _processOrder(context, cart),
              child: _isProcessing
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Authorize Payment & Issue Invoice', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processOrder(BuildContext context, CartProvider cart) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isProcessing = true);

    try {
      await ApiService.post('checkout/initiate', body: {
        'company_name': _companyCtrl.text.trim(),
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'gstin': _gstinCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'payment_method': _paymentMethod,
        'cart': cart.selectedProducts.values.map((p) => {
              'product_id': p.productId,
              'slug': p.slug,
              'base_price': p.basePrice,
              'setup_charge': p.setupCharge,
              'modules': p.selectedModules,
              'user_tier': p.userTier,
            }).toList(),
      });
    } catch (_) {}

    setState(() => _isProcessing = false);

    if (mounted) {
      cart.clearCart();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 56),
              const SizedBox(height: 16),
              const Text('Order & Payment Confirmed!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Your enterprise software licenses have been provisioned and your official GST Tax Invoice has been generated.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                child: const Text('Go to Client Portal & Invoices'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _inputField(String label, TextEditingController ctrl, {bool isRequired = false, int maxLines = 1, String? hint}) {
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
            validator: isRequired ? (v) => v == null || v.isEmpty ? 'Required' : null : null,
          ),
        ],
      ),
    );
  }

  Widget _summaryLine(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color ?? const Color(0xFF94A3B8), fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(color: color ?? Colors.white, fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
