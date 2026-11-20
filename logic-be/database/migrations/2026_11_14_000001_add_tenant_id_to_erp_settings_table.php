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
        if (Schema::hasTable('erp_settings') && !Schema::hasColumn('erp_settings', 'tenant_id')) {
            Schema::table('erp_settings', function (Blueprint $table) {
                $table->string('tenant_id')->nullable()->after('tenant_domain');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (Schema::hasTable('erp_settings') && Schema::hasColumn('erp_settings', 'tenant_id')) {
            Schema::table('erp_settings', function (Blueprint $table) {
                $table->dropColumn('tenant_id');
            });
        }
    }
};

