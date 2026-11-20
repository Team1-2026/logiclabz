<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Project extends Model
{
    protected $fillable = [
        'slug',
        'title',
        'pillar',
        'icon',
        'summary',
        'image',
        'metrics',
        'tech',
        'screenshots',
    ];

    protected $casts = [
        'metrics' => 'array',
        'tech' => 'array',
        'screenshots' => 'array',
    ];
}
