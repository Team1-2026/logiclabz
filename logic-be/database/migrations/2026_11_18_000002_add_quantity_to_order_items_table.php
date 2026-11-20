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
        if (Schema::hasTable('order_items')) {
            Schema::table('order_items', function (Blueprint $table) {
                if (!Schema::hasColumn('order_items', 'quantity')) {
                    $table->integer('quantity')->default(1)->after('unit_price');
                }
                if (!Schema::hasColumn('order_items', 'total_price')) {
                    $table->decimal('total_price', 12, 2)->nullable()->after('quantity');
                }
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (Schema::hasTable('order_items')) {
            Schema::table('order_items', function (Blueprint $table) {
                if (Schema::hasColumn('order_items', 'total_price')) {
                    $table->dropColumn('total_price');
                }
                if (Schema::hasColumn('order_items', 'quantity')) {
                    $table->dropColumn('quantity');
                }
            });
        }
    }
};
