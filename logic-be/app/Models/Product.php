<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Product extends Model
{
    protected $fillable = [
        'title',
        'slug',
        'category',
        'type',
        'icon',
        'description',
        'base_price',
        'setup_charge',
        'currency',
        'billing_cycle',
        'api_endpoint_url',
        'image',
        'features',
        'modules_schema',
        'is_featured',
        'sort_order',
    ];

    protected $appends = [
        'setup_cost',
    ];

    public function getSetupCostAttribute(): float
    {
        return (float) ($this->attributes['setup_charge'] ?? 0);
    }

    protected function casts(): array
    {
        return [
            'features' => 'array',
            'modules_schema' => 'array',
            'base_price' => 'decimal:2',
            'setup_charge' => 'decimal:2',
            'is_featured' => 'boolean',
            'sort_order' => 'integer',
        ];
    }

    public function orderItems(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }

    public function subscriptions(): HasMany
    {
        return $this->hasMany(SubscriptionService::class);
    }
}
