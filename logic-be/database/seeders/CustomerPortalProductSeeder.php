<?php

namespace Database\Seeders;

use App\Models\Product;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class CustomerPortalProductSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Create or ensure sample customer user
        $customer = User::firstOrCreate(
            ['email' => 'client@logiclabz.com'],
            [
                'name' => 'Jesvin Client',
                'password' => Hash::make('password123'),
                'company_name' => 'Logic Enterprise Solutions Ltd',
                'phone' => '+91 9876543210',
                'gstin' => '29ABCDE1234F1Z5',
                'billing_address' => 'Suite 402, Cyber Tower, Infopark, Kochi, Kerala, India - 682042',
                'role' => 'customer',
                'api_token' => Str::random(60),
            ]
        );

        // 1.1 Create or ensure administrator user
        User::updateOrCreate(
            ['email' => 'admin@logiclabz.com'],
            [
                'name' => 'System Administrator',
                'password' => Hash::make('admin123'),
                'company_name' => 'LogicLabz Operations HQ',
                'phone' => '+91 9999900000',
                'role' => 'admin',
                'api_token' => Str::random(60),
            ]
        );

        // 2. Enterprise ERP (Modular)
        Product::updateOrCreate(
            ['slug' => 'enterprise-erp'],
            [
                'title' => 'Enterprise ERP',
                'category' => 'Enterprise Software',
                'type' => 'modular',
                'icon' => 'Building2',
                'description' => 'Comprehensive enterprise resource planning platform engineered for scalable business operations, financial control, and unified reporting.',
                'base_price' => 15000.00,
                'setup_charge' => 5000.00,
                'currency' => 'INR',
                'billing_cycle' => 'annual',
                'api_endpoint_url' => '/api/v1/modules?product=enterprise-erp',
                'image' => '/products/erp.png',
                'features' => [
                    'Unified Multi-entity Accounting',
                    'Real-time Dashboards & Financial Reports',
                    'Automated Role-based Permissions & Audit Trail',
                    'RESTful API Integrations'
                ],
                'modules_schema' => [
                    [
                        'code' => 'ACCOUNTING',
                        'name' => 'Accounting',
                        'description' => 'Complete financial ledger, journal entries & balance sheet (Flat rate)',
                        'price' => 2500.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 250.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'META_CONFIG',
                        'name' => 'Api Integrations Meta, Google, Website and SMTP',
                        'description' => 'Multi-channel CRM integration, Meta lead webhooks & SMTP gateways',
                        'price' => 5000.00,
                        'is_mandatory' => false,
                        'license_type' => 'per_user',
                        'renewal_charge' => 500.00,
                        'per_user_charges' => [
                            '1_3' => 12000.00,
                            '4_10' => 36000.00,
                            '11_50' => 60000.00,
                            '51_plus' => 120000.00,
                        ],
                    ],
                    [
                        'code' => 'ATTENDANCE',
                        'name' => 'Attendance',
                        'description' => 'Biometric attendance tracking and staff leave management (Per user)',
                        'price' => 300.00,
                        'is_mandatory' => false,
                        'license_type' => 'per_user',
                        'renewal_charge' => 30.00,
                        'per_user_charges' => [
                            '1_3' => 300.00,
                            '4_10' => 800.00,
                            '11_50' => 3000.00,
                            '51_plus' => 6000.00,
                        ],
                    ],
                    [
                        'code' => 'BATCH',
                        'name' => 'BATCH Management',
                        'description' => 'Production batch number tracking, expiry alerts and lot control',
                        'price' => 2500.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 250.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'BRANCHES',
                        'name' => 'Branches & Multi-Location',
                        'description' => 'Multi-warehouse branch separation, inter-branch stock transfers',
                        'price' => 1000.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 100.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'CUSTOMER',
                        'name' => 'Customer Portal & CRM',
                        'description' => 'Client records, outstanding statement ledger and credit limits',
                        'price' => 1000.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 100.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'FINANCIAL_YEARS',
                        'name' => 'Financial Years',
                        'description' => 'Multi-year books closure, automated opening balances and roll-over',
                        'price' => 250.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 100.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'LEAD',
                        'name' => 'Lead Automation',
                        'description' => 'Inbound pipeline routing, conversion funnel and salesperson tagging',
                        'price' => 2500.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 250.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'POS',
                        'name' => 'POS (Point of Sale)',
                        'description' => 'Fast checkout billing, barcode scanner interface and thermal receipts',
                        'price' => 1000.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 100.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'PRODUCT',
                        'name' => 'Products & Catalog',
                        'description' => 'SKU management, variant matrix, unit of measures and pricing tiers',
                        'price' => 1000.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 100.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'PROJECTS',
                        'name' => 'Projects & Costing',
                        'description' => 'Milestone tracking, timesheets and project profit-and-loss calculation',
                        'price' => 1000.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 100.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'PURCHASES',
                        'name' => 'Purchases & Vendor POs',
                        'description' => 'Purchase requisition, GRN (Goods Receipt Note) and vendor payables',
                        'price' => 2500.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 250.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'QUOTES',
                        'name' => 'Quotes & Estimations',
                        'description' => 'Professional quotation generation with PDF exports and discount rules',
                        'price' => 100.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 100.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'SALES',
                        'name' => 'Sales & Invoicing',
                        'description' => 'Tax invoices, sales delivery challans and customer receipts',
                        'price' => 2500.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 250.00,
                        'per_user_charges' => null,
                    ]
                ],
                'is_featured' => true,
                'sort_order' => 1,
            ]
        );

        // 3. Travel CRM (Modular)
        Product::updateOrCreate(
            ['slug' => 'travel-crm'],
            [
                'title' => 'Travel CRM Pro',
                'category' => 'Industry Solutions',
                'type' => 'modular',
                'icon' => 'PlaneTakeoff',
                'description' => 'High-conversion travel agency and tour operator management system with intelligent itinerary generation and supplier management.',
                'base_price' => 12000.00,
                'setup_charge' => 3000.00,
                'currency' => 'INR',
                'billing_cycle' => 'annual',
                'api_endpoint_url' => '/api/v1/modules?product=travel-crm',
                'image' => '/products/travel-crm.png',
                'features' => [
                    'Customer & Corporate Profile Management',
                    'Interactive Quotation Builder',
                    'Voucher & Ticket Dispatch Engine',
                    'Payment Follow-up Automation'
                ],
                'modules_schema' => [
                    [
                        'code' => 'MOD_LEAD',
                        'name' => 'Lead Automation & WhatsApp Bot',
                        'description' => 'Instant Facebook/Google lead ingestion, automatic WhatsApp greetings, and agent routing.',
                        'price' => 3500.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 350.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'MOD_VISA',
                        'name' => 'Visa Tracking & Embassy Checklist',
                        'description' => 'Country-wise document checklist, applicant dossier tracking, and status alerts.',
                        'price' => 3000.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 300.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'MOD_ITIN',
                        'name' => 'AI Day-wise Itinerary Generator',
                        'description' => 'Pre-built destination day-wise itineraries, rich photos, hotel catalogs, and PDF exports.',
                        'price' => 4000.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 400.00,
                        'per_user_charges' => null,
                    ],
                    [
                        'code' => 'MOD_MULTI',
                        'name' => 'Multi-Branch & Agent Access',
                        'description' => 'Branch separation, sub-agent commission ledgers, and team incentive tracking.',
                        'price' => 5000.00,
                        'is_mandatory' => false,
                        'license_type' => 'per_user',
                        'renewal_charge' => 500.00,
                        'per_user_charges' => [
                            '1_3' => 5000.00,
                            '4_10' => 12000.00,
                            '11_50' => 25000.00,
                            '51_plus' => 45000.00,
                        ],
                    ],
                    [
                        'code' => 'MOD_B2B',
                        'name' => 'B2B Partner Booking Engine',
                        'description' => 'Dedicated branded portal for reseller travel agents with customized markup rules.',
                        'price' => 4500.00,
                        'is_mandatory' => false,
                        'license_type' => 'flat_rate',
                        'renewal_charge' => 450.00,
                        'per_user_charges' => null,
                    ]
                ],
                'is_featured' => true,
                'sort_order' => 2,
            ]
        );

        // 4. Pump Management Software (Standalone)
        Product::updateOrCreate(
            ['slug' => 'pump-mgmt'],
            [
                'title' => 'Pump Management Suite',
                'category' => 'Industrial Automation',
                'type' => 'standalone',
                'icon' => 'Cpu',
                'description' => 'Specialized standalone operating software for agricultural, submersible, and industrial pump manufacturers and field service networks.',
                'base_price' => 18000.00,
                'setup_charge' => 2500.00,
                'currency' => 'INR',
                'billing_cycle' => 'annual',
                'api_endpoint_url' => null,
                'image' => '/products/pump.png',
                'features' => [
                    'Pump Serial Number & QR Code Tracking',
                    'Motor & Telemetry Calibration Profiles',
                    'Field Technician Mobile Dispatch & Geo-tagging',
                    'Warranty Validation & Replacement Claims',
                    'Spare Parts Inventory & Service History Ledger',
                    'Preventive Maintenance Scheduling'
                ],
                'modules_schema' => [],
                'is_featured' => true,
                'sort_order' => 3,
            ]
        );

        // 5. Domain Services (Infrastructure)
        Product::updateOrCreate(
            ['slug' => 'domain-service'],
            [
                'title' => 'Managed Domain Registration',
                'category' => 'Infrastructure',
                'type' => 'infrastructure',
                'icon' => 'Globe',
                'description' => 'Enterprise DNS provisioning with free SSL certification, WHOIS privacy protection, and DDoS mitigations.',
                'base_price' => 999.00,
                'setup_charge' => 0.00,
                'currency' => 'INR',
                'billing_cycle' => 'annual',
                'api_endpoint_url' => null,
                'image' => '/products/domain.png',
                'features' => [
                    'Top-Level Domains (.com, .in, .co.in, .org, .net)',
                    'Anycast Ultra-Fast Cloud DNS',
                    'Free Automated Wildcard SSL Certificate',
                    'DNSSEC & Spam Filtering Records (SPF, DKIM, DMARC)'
                ],
                'modules_schema' => [],
                'is_featured' => false,
                'sort_order' => 4,
            ]
        );

        // 6. Cloud Server & Hosting Plans (Infrastructure)
        Product::updateOrCreate(
            ['slug' => 'cloud-server-hosting'],
            [
                'title' => 'Cloud Server & Managed Hosting',
                'category' => 'Infrastructure',
                'type' => 'infrastructure',
                'icon' => 'Server',
                'description' => 'Dedicated NVMe SSD cloud hosting optimized for high concurrency ERP/CRM workloads with automated daily off-site backups.',
                'base_price' => 8000.00,
                'setup_charge' => 1500.00,
                'currency' => 'INR',
                'billing_cycle' => 'annual',
                'api_endpoint_url' => null,
                'image' => '/products/hosting.png',
                'features' => [
                    'Dedicated vCPU with NVMe High-speed Storage',
                    'Automatic Nightly Off-site Encrypted Backups',
                    '99.9% Uptime Guarantee with SLA Protection',
                    'Proactive 24/7 Server Health Monitoring & Patching'
                ],
                'modules_schema' => [],
                'is_featured' => false,
                'sort_order' => 5,
            ]
        );
    }
}

