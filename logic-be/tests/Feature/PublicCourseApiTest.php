<?php

use App\Models\CertificationCourse;
use App\Models\CourseEnquiry;

test('public api courses works and returns CORS headers', function () {
    CertificationCourse::create([
        'title' => 'Test Course',
        'slug' => 'test-course',
        'category' => 'Backend',
        'duration' => '6 weeks',
        'icon' => 'GraduationCap',
        'description' => 'This is a test course.',
        'highlights' => ['Eloquent'],
        'is_featured' => true,
        'sort_order' => 1,
    ]);

    $response = $this->get('/api/courses');

    $response->assertSuccessful();
    $response->assertHeader('Access-Control-Allow-Origin', '*');
    $response->assertJsonFragment([
        'title' => 'Test Course',
        'duration' => '6 weeks',
    ]);
});

test('public api returns a single course and rejects an unknown slug', function () {
    CertificationCourse::create([
        'title' => 'Known Course',
        'slug' => 'known-course',
        'category' => 'Frontend',
        'duration' => '4 weeks',
        'icon' => 'Code2',
        'description' => 'A known course.',
        'highlights' => [],
    ]);

    $this->get('/api/courses/known-course')
        ->assertSuccessful()
        ->assertJsonFragment(['slug' => 'known-course']);

    $this->get('/api/courses/missing-course')
        ->assertNotFound();
});

test('public api stores a course enquiry', function () {
    $course = CertificationCourse::create([
        'title' => 'Enrolment Course',
        'slug' => 'enrolment-course',
        'category' => 'Backend',
        'duration' => '6 weeks',
        'icon' => 'GraduationCap',
        'description' => 'Enrol here.',
        'highlights' => [],
    ]);

    $response = $this->postJson('/api/courses/enrolment-course/enquiries', [
        'name' => 'Ada Lovelace',
        'email' => 'ada@example.com',
        'phone' => '9061033764',
        'message' => 'Please share the next batch dates.',
    ]);

    $response->assertCreated();
    $response->assertHeader('Access-Control-Allow-Origin', '*');

    $this->assertDatabaseHas('course_enquiries', [
        'certification_course_id' => $course->id,
        'course_title' => 'Enrolment Course',
        'email' => 'ada@example.com',
    ]);

    expect(CourseEnquiry::count())->toBe(1);
});

test('public api rejects an incomplete course enquiry', function () {
    CertificationCourse::create([
        'title' => 'Enrolment Course',
        'slug' => 'enrolment-course',
        'category' => 'Backend',
        'duration' => '6 weeks',
        'icon' => 'GraduationCap',
        'description' => 'Enrol here.',
        'highlights' => [],
    ]);

    $this->postJson('/api/courses/enrolment-course/enquiries', [
        'name' => '',
        'email' => 'not-an-email',
        'message' => '',
    ])->assertUnprocessable();

    expect(CourseEnquiry::count())->toBe(0);
});
