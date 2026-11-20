<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Demo extends Model
{
    protected $fillable = [
        'user_id',
        'product_id',
        'product_name',
        'demo_url',
        'access_credentials',
        'status',
        'expires_at',
    ];

    protected function casts(): array
    {
        return [
            'access_credentials' => 'array',
            'expires_at' => 'datetime',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}

