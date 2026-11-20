<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SubscriptionService extends Model
{
    protected $table = 'subscriptions_services';

    protected $fillable = [
        'user_id',
        'order_id',
        'product_id',
        'service_type',
        'service_name',
        'domain_name',
        'instance_url',
        'modules_json',
        'status',
        'expiry_date',
    ];

    protected function casts(): array
    {
        return [
            'modules_json' => 'array',
            'expiry_date' => 'datetime',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}

