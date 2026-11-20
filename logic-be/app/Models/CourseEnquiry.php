<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CourseEnquiry extends Model
{
    protected $fillable = [
        'certification_course_id',
        'course_title',
        'name',
        'email',
        'phone',
        'message',
    ];

    /**
     * @return BelongsTo<CertificationCourse, $this>
     */
    public function course(): BelongsTo
    {
        return $this->belongsTo(CertificationCourse::class, 'certification_course_id');
    }
}
