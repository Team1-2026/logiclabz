import '../models/product_model.dart';
import 'api_service.dart';

class CatalogService {
  static Future<List<ProductCatalogItem>> getCatalog() async {
    try {
      final res = await ApiService.get('catalog');
      List rawList = [];
      if (res is List) {
        rawList = res;
      } else if (res is Map && res['data'] is List) {
        rawList = res['data'];
      } else if (res is Map && res['products'] is List) {
        rawList = res['products'];
      }

      if (rawList.isNotEmpty) {
        return rawList
            .whereType<Map>()
            .map((item) => ProductCatalogItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    } catch (_) {}

    return getDefaultCatalog();
  }

  static Future<List<ModuleItem>> getExternalModules() async {
    try {
      final res = await ApiService.get('modules');
      List rawList = [];
      if (res is List) {
        rawList = res;
      } else if (res is Map && res['data'] is List) {
        rawList = res['data'];
      }

      if (rawList.isNotEmpty) {
        return rawList
            .whereType<Map>()
            .map((m) => ModuleItem.fromJson(Map<String, dynamic>.from(m)))
            .toList();
      }
    } catch (_) {}

    return [];
  }

  static List<ProductCatalogItem> getDefaultCatalog() {
    return [
      ProductCatalogItem(
        id: 1,
        slug: 'enterprise-erp',
        title: 'Enterprise ERP',
        category: 'Enterprise Software',
        type: 'modular',
        icon: 'building',
        description:
            'Full-stack enterprise resource planning system with multi-entity financial accounting, inventory controls, GST compliance, and HR payroll.',
        basePrice: 15000.0,
        setupCharge: 5000.0,
        currency: 'INR',
        billingCycle: 'annual',
        features: [
          'Unified Multi-branch Ledger & Cash Flow',
          'Real-time Financial Dashboards & Audit Trail',
          'Automated Role Permissions & Security Matrix',
          'Comprehensive RESTful Integration API',
        ],
        modulesSchema: [
          ModuleItem(
            code: 'ACCOUNTING',
            name: 'Accounting',
            description: 'Complete financial ledger, journal entries & balance sheet (Flat rate)',
            price: 2500.0,
            renewalCharge: 250.0,
            licenseType: 'flat_rate',
          ),
          ModuleItem(
            code: 'META_CONFIG',
            name: 'Api Integrations Meta, Google, Website and SMTP',
            description: 'Multi-channel CRM integration, Meta lead webhooks & SMTP gateways',
            price: 5000.0,
            renewalCharge: 500.0,
            licenseType: 'per_user',
            perUserCharges: PerUserCharges(
              tier1To3: 12000.0,
              tier4To10: 36000.0,
              tier11To50: 60000.0,
              tier51Plus: 120000.0,
            ),
          ),
          ModuleItem(
            code: 'ATTENDANCE',
            name: 'Attendance',
            description: 'Biometric, geolocation check-in, shift rosters, overtime & leave requests',
            price: 300.0,
            renewalCharge: 30.0,
            licenseType: 'per_user',
            perUserCharges: PerUserCharges(
              tier1To3: 300.0,
              tier4To10: 800.0,
              tier11To50: 3000.0,
              tier51Plus: 6000.0,
            ),
          ),
          ModuleItem(
            code: 'BATCH',
            name: 'BATCH',
            description: 'Manufacturing batch traceability, expiry dates, lot barcodes & QC testing',
            price: 2500.0,
            renewalCharge: 250.0,
            licenseType: 'flat_rate',
          ),
          ModuleItem(
            code: 'BRANCHES',
            name: 'Branches',
            description: 'Multi-location inventory tracking, inter-branch transfers & cost centers',
            price: 1000.0,
            renewalCharge: 100.0,
            licenseType: 'flat_rate',
          ),
          ModuleItem(
            code: 'CUSTOMER',
            name: 'Customer',
            description: 'Customer directory, credit terms, statement downloads & communication history',
            price: 1000.0,
            renewalCharge: 100.0,
            licenseType: 'flat_rate',
          ),
          ModuleItem(
            code: 'FINANCIAL_YEARS',
            name: 'Financial Years',
            description: 'Fiscal period creation, year-end closeouts & archival locks',
            price: 250.0,
            renewalCharge: 100.0,
            licenseType: 'flat_rate',
          ),
          ModuleItem(
            code: 'LEAD',
            name: 'Lead',
            description: 'Lead capture pipelines, stages, follow-up reminders & conversion tracking',
            price: 2500.0,
            renewalCharge: 250.0,
            licenseType: 'flat_rate',
          ),
          ModuleItem(
            code: 'POS',
            name: 'POS',
            description: 'Fast barcode scanning point of sale, register receipts & daily cash shifts',
            price: 1000.0,
            renewalCharge: 100.0,
            licenseType: 'flat_rate',
          ),
          ModuleItem(
            code: 'PRODUCT',
            name: 'Products',
            description: 'Item master catalog, SKU barcodes, multi-unit conversions & minimum stock alerts',
            price: 1000.0,
            renewalCharge: 100.0,
            licenseType: 'flat_rate',
          ),
          ModuleItem(
            code: 'PROJECTS',
            name: 'Projects',
            description: 'Project milestones, billable work orders, progress tracking & time billing',
            price: 1000.0,
            renewalCharge: 100.0,
            licenseType: 'flat_rate',
          ),
          ModuleItem(
            code: 'PURCHASES',
            name: 'Purchases',
            description: 'Vendor purchase orders, goods receipt notes (GRN), invoice matching & debit notes',
            price: 2500.0,
            renewalCharge: 250.0,
            licenseType: 'flat_rate',
          ),
          ModuleItem(
            code: 'QUOTES',
            name: 'Quotes',
            description: 'Custom client quotation templates, revisions & one-click sales conversion',
            price: 100.0,
            renewalCharge: 100.0,
            licenseType: 'flat_rate',
          ),
          ModuleItem(
            code: 'SALES',
            name: 'Sales',
            description: 'Tax sales invoicing, delivery challans, credit notes & GST compliance',
            price: 2500.0,
            renewalCharge: 250.0,
            licenseType: 'flat_rate',
          ),
        ],
      ),
      ProductCatalogItem(
        id: 2,
        slug: 'nvme-cloud-hosting',
        title: 'Managed Enterprise Cloud Server',
        category: 'Cloud Infrastructure',
        type: 'standalone',
        icon: 'server',
        description:
            'Dedicated high-performance NVMe cloud instance optimized for ERP workloads with automated hourly backups, 99.99% SLA, and free SSL.',
        basePrice: 8000.0,
        setupCharge: 2000.0,
        currency: 'INR',
        billingCycle: 'annual',
        features: [
          'High IOPS PCIe 4.0 NVMe Storage Array',
          'Automated Snapshot Backups & Point-in-time Recovery',
          'Enterprise DDoS Mitigation & Web Application Firewall',
          '24/7 Managed SRE Monitoring & Kernel Updates',
        ],
      ),
      ProductCatalogItem(
        id: 3,
        slug: 'custom-web-portal',
        title: 'B2B Client Portal & E-Commerce',
        category: 'Custom Applications',
        type: 'standalone',
        icon: 'globe',
        description:
            'Bespoke Next.js & Flutter frontends integrated directly with your ERP database for seamless customer self-ordering and document downloads.',
        basePrice: 25000.0,
        setupCharge: 10000.0,
        currency: 'INR',
        billingCycle: 'one-time',
        features: [
          'Branded Self-Service Customer & Vendor Portal',
          'Real-time Stock Inquiries & Instant B2B Ordering',
          'ICICI Bank UPI & Payment Gateway Integration',
          'Automated WhatsApp & Email Notifications',
        ],
      ),
    ];
  }
}
