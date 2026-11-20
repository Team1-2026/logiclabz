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
        // 1. Extend users table for customer profile & GSTIN
        Schema::table('users', function (Blueprint $table) {
            if (!Schema::hasColumn('users', 'company_name')) {
                $table->string('company_name')->nullable()->after('name');
            }
            if (!Schema::hasColumn('users', 'phone')) {
                $table->string('phone')->nullable()->after('email');
            }
            if (!Schema::hasColumn('users', 'gstin')) {
                $table->string('gstin')->nullable()->after('company_name');
            }
            if (!Schema::hasColumn('users', 'billing_address')) {
                $table->text('billing_address')->nullable()->after('gstin');
            }
            if (!Schema::hasColumn('users', 'role')) {
                $table->string('role')->default('customer')->after('password');
            }
            if (!Schema::hasColumn('users', 'api_token')) {
                $table->string('api_token', 80)->nullable()->unique()->after('remember_token');
            }
        });

        // 2. Extend products table with modular & pricing configurations if needed
        Schema::table('products', function (Blueprint $table) {
            if (!Schema::hasColumn('products', 'type')) {
                $table->string('type')->default('modular')->after('category'); // modular, standalone, infrastructure
            }
            if (!Schema::hasColumn('products', 'base_price')) {
                $table->decimal('base_price', 12, 2)->default(0)->after('description');
            }
            if (!Schema::hasColumn('products', 'currency')) {
                $table->string('currency', 10)->default('INR')->after('base_price');
            }
            if (!Schema::hasColumn('products', 'billing_cycle')) {
                $table->string('billing_cycle', 20)->default('annual')->after('currency');
            }
            if (!Schema::hasColumn('products', 'api_endpoint_url')) {
                $table->string('api_endpoint_url')->nullable()->after('billing_cycle');
            }
            if (!Schema::hasColumn('products', 'modules_schema')) {
                $table->json('modules_schema')->nullable()->after('features');
            }
        });

        // 3. Orders table
        if (!Schema::hasTable('orders')) {
            Schema::create('orders', function (Blueprint $table) {
                $table->id();
                $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
                $table->string('order_number')->unique();
                $table->decimal('subtotal_amount', 12, 2)->default(0);
                $table->decimal('tax_amount', 12, 2)->default(0);
                $table->decimal('total_amount', 12, 2)->default(0);
                $table->string('currency', 10)->default('INR');
                $table->string('status')->default('pending'); // pending, paid, provisioned, cancelled, failed
                $table->string('payment_method')->default('icici_pg');
                $table->string('payment_reference')->nullable();
                $table->string('payment_status')->default('pending');
                $table->text('customer_notes')->nullable();
                $table->json('metadata')->nullable();
                $table->timestamps();
            });
        }

        // 4. Order Items table
        if (!Schema::hasTable('order_items')) {
            Schema::create('order_items', function (Blueprint $table) {
                $table->id();
                $table->foreignId('order_id')->constrained('orders')->onDelete('cascade');
                $table->foreignId('product_id')->nullable()->constrained('products')->nullOnDelete();
                $table->string('item_type'); // base, module, domain, server
                $table->string('item_code');
                $table->string('item_name');
                $table->decimal('unit_price', 12, 2);
                $table->timestamps();
            });
        }

        // 5. Subscriptions / Provisioned Services
        if (!Schema::hasTable('subscriptions_services')) {
            Schema::create('subscriptions_services', function (Blueprint $table) {
                $table->id();
                $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
                $table->foreignId('order_id')->nullable()->constrained('orders')->nullOnDelete();
                $table->foreignId('product_id')->nullable()->constrained('products')->nullOnDelete();
                $table->string('service_type'); // software, hosting, domain
                $table->string('service_name');
                $table->string('domain_name')->nullable();
                $table->string('instance_url')->nullable();
                $table->json('modules_json')->nullable();
                $table->string('status')->default('pending_setup'); // active, pending_setup, suspended, demo, expired
                $table->timestamp('expiry_date')->nullable();
                $table->timestamps();
            });
        }

        // 6. Invoices table
        if (!Schema::hasTable('invoices')) {
            Schema::create('invoices', function (Blueprint $table) {
                $table->id();
                $table->foreignId('order_id')->constrained('orders')->onDelete('cascade');
                $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
                $table->string('invoice_number')->unique();
                $table->decimal('amount', 12, 2);
                $table->decimal('tax_amount', 12, 2)->default(0);
                $table->decimal('total_amount', 12, 2);
                $table->string('currency', 10)->default('INR');
                $table->string('payment_gateway_id')->nullable();
                $table->string('payment_method')->default('icici_pg');
                $table->string('status')->default('unpaid'); // unpaid, paid, refunded
                $table->string('pdf_path')->nullable();
                $table->timestamp('paid_at')->nullable();
                $table->timestamps();
            });
        }

        // 7. Interactive Demos table
        if (!Schema::hasTable('demos')) {
            Schema::create('demos', function (Blueprint $table) {
                $table->id();
                $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
                $table->foreignId('product_id')->nullable()->constrained('products')->nullOnDelete();
                $table->string('product_name');
                $table->string('demo_url');
                $table->json('access_credentials');
                $table->string('status')->default('active'); // active, expired
                $table->timestamp('expires_at');
                $table->timestamps();
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('demos');
        Schema::dropIfExists('invoices');
        Schema::dropIfExists('subscriptions_services');
        Schema::dropIfExists('order_items');
        Schema::dropIfExists('orders');

        Schema::table('products', function (Blueprint $table) {
            $table->dropColumn(['type', 'base_price', 'currency', 'billing_cycle', 'api_endpoint_url', 'modules_schema']);
        });

        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['company_name', 'phone', 'gstin', 'billing_address', 'role', 'api_token']);
        });
    }
};

