<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ErpSetting extends Model
{
    protected $fillable = [
        'erp_name',
        'tenant_domain',
        'tenant_id',
        'api_url',
        'api_token',
        'customers_endpoint',
        'invoices_endpoint',
        'accounting_endpoint',
        'modules_endpoint',
        'is_connected',
        'last_connection_test_at',
        'last_customers_sync_at',
        'last_invoices_sync_at',
        'last_accounting_sync_at',
        'accounting_summary',
        'sync_logs',
    ];

    protected function casts(): array
    {
        return [
            'is_connected' => 'boolean',
            'last_connection_test_at' => 'datetime',
            'last_customers_sync_at' => 'datetime',
            'last_invoices_sync_at' => 'datetime',
            'last_accounting_sync_at' => 'datetime',
            'accounting_summary' => 'array',
            'sync_logs' => 'array',
        ];
    }

    /**
     * Get or create singleton settings row
     */
    public static function instance(): self
    {
        return self::firstOrCreate(
            ['id' => 1],
            [
                'erp_name' => 'Sample ERP (be-app)',
                'tenant_domain' => 'default',
                'api_url' => 'https://api.erplogic.co.in',
                'api_token' => '',
                'customers_endpoint' => '/api/tenant/customers',
                'invoices_endpoint' => '/api/tenant/invoices',
                'accounting_endpoint' => '/api/tenant/accounts/chart-of-accounts',
                'modules_endpoint' => '/modules-data',
                'is_connected' => false,
                'accounting_summary' => [
                    'total_revenue' => 184500.00,
                    'paid_receivables' => 142000.00,
                    'pending_receivables' => 42500.00,
                    'gst_collected' => 28090.00,
                    'accounts_heads' => [
                        ['code' => 'ACC_REV_SAAS', 'title' => 'Software License Subscriptions', 'balance' => 125000.00, 'type' => 'income'],
                        ['code' => 'ACC_REV_SETUP', 'title' => 'Setup & Onboarding Fees', 'balance' => 32000.00, 'type' => 'income'],
                        ['code' => 'ACC_REV_INFRA', 'title' => 'Managed Cloud & Domain Hosting', 'balance' => 27500.00, 'type' => 'income'],
                        ['code' => 'ACC_TAX_GST', 'title' => 'GST Output Liability (18%)', 'balance' => 28090.00, 'type' => 'liability'],
                    ]
                ],
                'sync_logs' => [],
            ]
        );
    }
}
