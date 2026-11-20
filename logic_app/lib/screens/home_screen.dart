import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/app_navbar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/demo_booking_dialog.dart';
import '../providers/catalog_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 860;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: const AppNavbar(activeRoute: '/'),
      drawer: isDesktop ? null : const AppDrawer(activeRoute: '/'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _heroSection(context, isDesktop),

            // Metrics / Badges bar
            _statsBar(context),

            // Featured Products & Solutions
            _featuredProductsSection(context, catalog),

            // Why LogicLabz Enterprise
            _featuresSection(context),

            // CTA Banner
            _ctaSection(context),

            // Footer
            _footerSection(context),
          ],
        ),
      ),
    );
  }

  Widget _heroSection(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 20,
        vertical: isDesktop ? 72 : 40,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F172A), Color(0xFF0B0F19)],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, color: Color(0xFF38BDF8), size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Modular Enterprise ERP • GST Compliant • Multi-Tenant',
                      style: TextStyle(color: Color(0xFF93C5FD), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: isDesktop ? 44 : 28,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                    letterSpacing: -1,
                  ),
                  children: const [
                    TextSpan(text: 'Modern Enterprise ERP &\n', style: TextStyle(color: Colors.white)),
                    TextSpan(
                      text: 'Intelligent Software Solutions',
                      style: TextStyle(
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Subtitle
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(
                  'Powering modern businesses with customizable modular enterprise software, automated multi-entity GST billing, multi-tenant database synchronization, and scalable cloud deployments.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: const Color(0xFF94A3B8), fontSize: isDesktop ? 16 : 14, height: 1.5),
                ),
              ),
              const SizedBox(height: 32),

              // Action buttons
              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.rocket_launch, size: 18),
                    label: const Text('Configure ERP & Modules'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/services'),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.play_circle_outline, size: 18),
                    label: const Text('Book Live Demo'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF334155)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => DemoBookingDialog.show(context),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.admin_panel_settings, size: 18, color: Color(0xFFA855F7)),
                    label: const Text('Admin Console', style: TextStyle(color: Color(0xFFA855F7), fontWeight: FontWeight.bold)),
                    onPressed: () => Navigator.pushNamed(context, '/admin'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statsBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border.symmetric(horizontal: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            runSpacing: 16,
            spacing: 32,
            children: [
              _statItem('100%', 'Modular Architecture', Icons.extension_outlined),
              _statItem('18% GST', 'Automatic Tax Ledger', Icons.receipt_long_outlined),
              _statItem('99.99%', 'NVMe Cloud Uptime SLA', Icons.cloud_done_outlined),
              _statItem('Multi-Tenant', 'API & ERP Sync Ready', Icons.sync_alt_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String value, String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF38BDF8), size: 24),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Widget _featuredProductsSection(BuildContext context, CatalogProvider catalog) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 12,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ENTERPRISE SOLUTIONS', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Featured Software Catalog', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('View All Solutions'),
                    style: TextButton.styleFrom(foregroundColor: const Color(0xFF38BDF8)),
                    onPressed: () => Navigator.pushNamed(context, '/services'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Product Cards
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: catalog.products.take(3).map((product) {
                  return SizedBox(
                    width: 340,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.layers, color: Color(0xFF38BDF8), size: 24),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF334155),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(product.category, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(product.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.4),
                          ),
                          const SizedBox(height: 16),

                          // Pricing
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(currencyFormatter.format(product.basePrice), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(' / ${product.billingCycle}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            ],
                          ),
                          if (product.setupCharge > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '+ ${currencyFormatter.format(product.setupCharge)} one-off setup fee',
                                style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),

                          const Divider(color: Color(0xFF334155), height: 24),

                          // Features snippet
                          ...product.features.take(3).map((f) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(f, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12), overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              )),

                          const SizedBox(height: 16),

                          // Action
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => Navigator.pushNamed(context, '/services'),
                              child: const Text('Configure & Customize'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featuresSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ARCHITECTURAL ADVANTAGES', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Built for Speed, Compliance & Scale', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _featureCard(
                    'Full Modular Customization',
                    'Pick only the modules you need — Accounting, Attendance, POS, CRM, Purchases, and API Integrations. Scale as your team expands.',
                    Icons.dashboard_customize_outlined,
                  ),
                  _featureCard(
                    'Indian GST Compliance',
                    'Pre-configured with CGST & SGST 18% tax calculations, automatic tax invoice numbering, and printable GST tax receipts.',
                    Icons.account_balance_outlined,
                  ),
                  _featureCard(
                    'ERP & Database Sync Engine',
                    'Seamlessly communicates with external ERPs (like be-app) passing X-Tenant-Domain headers for multi-tenant isolation.',
                    Icons.cloud_sync_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureCard(String title, String desc, IconData icon) {
    return SizedBox(
      width: 340,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF38BDF8), size: 28),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(desc, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _ctaSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text(
                'Ready to Transform Your Business Operations?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Deploy your enterprise ERP instance with customized modules and dedicated cloud hosting today.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 14),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/services'),
                    child: const Text('Start Configuration'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => DemoBookingDialog.show(context),
                    child: const Text('Schedule Demo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF070B14),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.bolt, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 8),
                      const Text('LogicLabz Technologies', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Text('GSTIN: 32AABCL1234F1Z0', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                ],
              ),
              const Divider(color: Color(0xFF1E293B), height: 32),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 12,
                children: [
                  const Text('© 2026 LogicLabz Technologies Corp. All rights reserved.', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _footerLink(context, 'Services', '/services'),
                      _footerLink(context, 'Dashboard', '/dashboard'),
                      _footerLink(context, 'Admin', '/admin'),
                      _footerLink(context, 'ERP Config', '/admin/erp-config'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerLink(BuildContext context, String title, String route) {
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(context, route),
      child: Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
    );
  }
}
