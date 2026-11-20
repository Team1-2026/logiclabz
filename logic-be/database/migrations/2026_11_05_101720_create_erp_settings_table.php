<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // 1. ERP Configuration & Credentials table
        if (!Schema::hasTable('erp_settings')) {
            Schema::create('erp_settings', function (Blueprint $table) {
                $table->id();
                $table->string('erp_name')->default('ERPLogic');
                $table->string('api_url')->default('https://api.erplogic.co.in');
                $table->text('api_token')->nullable();
                $table->string('customers_endpoint')->default('/api/v1/customers');
                $table->string('invoices_endpoint')->default('/api/v1/invoices');
                $table->string('accounting_endpoint')->default('/api/v1/accounting');
                $table->string('modules_endpoint')->default('/modules-data');
                $table->boolean('is_connected')->default(false);
                $table->timestamp('last_connection_test_at')->nullable();
                $table->timestamp('last_customers_sync_at')->nullable();
                $table->timestamp('last_invoices_sync_at')->nullable();
                $table->timestamp('last_accounting_sync_at')->nullable();
                $table->json('accounting_summary')->nullable();
                $table->json('sync_logs')->nullable();
                $table->timestamps();
            });
        }

        // 2. Extend invoices table for ERP Sync, optional order_id, due date, items data
        Schema::table('invoices', function (Blueprint $table) {
            $table->foreignId('order_id')->nullable()->change();
            if (!Schema::hasColumn('invoices', 'erp_invoice_id')) {
                $table->string('erp_invoice_id')->nullable()->after('invoice_number');
            }
            if (!Schema::hasColumn('invoices', 'erp_status')) {
                $table->string('erp_status')->default('local')->after('status'); // local, synced, pending_sync, failed
            }
            if (!Schema::hasColumn('invoices', 'due_date')) {
                $table->date('due_date')->nullable()->after('paid_at');
            }
            if (!Schema::hasColumn('invoices', 'notes')) {
                $table->text('notes')->nullable()->after('due_date');
            }
            if (!Schema::hasColumn('invoices', 'items_data')) {
                $table->json('items_data')->nullable()->after('notes');
            }
        });

        // 3. Extend users table for ERP Customer ID & Sync
        Schema::table('users', function (Blueprint $table) {
            if (!Schema::hasColumn('users', 'erp_customer_id')) {
                $table->string('erp_customer_id')->nullable()->after('gstin');
            }
            if (!Schema::hasColumn('users', 'erp_synced_at')) {
                $table->timestamp('erp_synced_at')->nullable()->after('erp_customer_id');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['erp_customer_id', 'erp_synced_at']);
        });

        Schema::table('invoices', function (Blueprint $table) {
            $table->dropColumn(['erp_invoice_id', 'erp_status', 'due_date', 'notes', 'items_data']);
        });

        Schema::dropIfExists('erp_settings');
    }
};
