<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Service extends Model
{
    protected $fillable = [
        'title',
        'icon',
        'desc',
        'tags',
    ];

    protected $casts = [
        'tags' => 'array',
    ];
}
