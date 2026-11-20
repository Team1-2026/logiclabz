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
        if (Schema::hasTable('orders')) {
            Schema::table('orders', function (Blueprint $table) {
                if (!Schema::hasColumn('orders', 'erp_order_id')) {
                    $table->string('erp_order_id')->nullable()->after('metadata');
                }
                if (!Schema::hasColumn('orders', 'erp_status')) {
                    $table->string('erp_status')->default('local')->after('erp_order_id');
                }
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (Schema::hasTable('orders')) {
            Schema::table('orders', function (Blueprint $table) {
                if (Schema::hasColumn('orders', 'erp_status')) {
                    $table->dropColumn('erp_status');
                }
                if (Schema::hasColumn('orders', 'erp_order_id')) {
                    $table->dropColumn('erp_order_id');
                }
            });
        }
    }
};
