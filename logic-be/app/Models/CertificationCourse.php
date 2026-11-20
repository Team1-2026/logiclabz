<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class CertificationCourse extends Model
{
    protected $fillable = [
        'title',
        'slug',
        'category',
        'duration',
        'icon',
        'description',
        'image',
        'highlights',
        'is_featured',
        'sort_order',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'highlights' => 'array',
            'is_featured' => 'boolean',
            'sort_order' => 'integer',
        ];
    }

    /**
     * @return HasMany<CourseEnquiry, $this>
     */
    public function enquiries(): HasMany
    {
        return $this->hasMany(CourseEnquiry::class);
    }
}
