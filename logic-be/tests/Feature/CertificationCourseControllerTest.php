<?php

use App\Models\CertificationCourse;
use App\Models\CourseEnquiry;
use App\Models\User;

test('authenticated user can store a certification course', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)->post(route('courses.store'), [
        'title' => 'Laravel Certification',
        'category' => 'Backend',
        'duration' => '6 weeks',
        'icon' => 'GraduationCap',
        'description' => 'Hands-on Laravel certification.',
        'highlights' => ['Eloquent', 'Testing'],
        'is_featured' => true,
        'sort_order' => 1,
    ]);

    $response->assertRedirect(route('courses.index'));
    $this->assertDatabaseHas('certification_courses', [
        'title' => 'Laravel Certification',
        'slug' => 'laravel-certification',
        'duration' => '6 weeks',
    ]);

    $course = CertificationCourse::first();
    expect($course->highlights)->toBe(['Eloquent', 'Testing']);
    expect($course->is_featured)->toBeTrue();
});

test('authenticated user can update a course and clear its highlights', function () {
    $user = User::factory()->create();

    $course = CertificationCourse::create([
        'title' => 'Existing Course',
        'slug' => 'existing-course',
        'category' => 'Frontend',
        'duration' => '4 weeks',
        'icon' => 'Code2',
        'description' => 'A course description.',
        'highlights' => ['Topic A'],
        'is_featured' => false,
        'sort_order' => 0,
    ]);

    $response = $this->actingAs($user)->put(route('courses.update', $course), [
        'title' => 'Updated Course',
        'category' => 'Frontend',
        'duration' => '5 weeks',
        'icon' => 'Code2',
        'description' => 'Updated description.',
        'highlights' => [],
        'is_featured' => true,
        'sort_order' => 2,
    ]);

    $response->assertRedirect(route('courses.index'));

    $course->refresh();
    expect($course->title)->toBe('Updated Course');
    expect($course->slug)->toBe('updated-course');
    expect($course->highlights)->toBe([]);
    expect($course->duration)->toBe('5 weeks');
});

test('authenticated user can delete a course', function () {
    $user = User::factory()->create();

    $course = CertificationCourse::create([
        'title' => 'Disposable Course',
        'slug' => 'disposable-course',
        'category' => 'Mobile',
        'duration' => '2 weeks',
        'icon' => 'Smartphone',
        'description' => 'Will be deleted.',
        'highlights' => [],
    ]);

    $response = $this->actingAs($user)->delete(route('courses.destroy', $course));

    $response->assertRedirect(route('courses.index'));
    $this->assertDatabaseMissing('certification_courses', ['id' => $course->id]);
});

test('authenticated users can open manage courses and enquiries pages', function () {
    $user = User::factory()->create();

    $course = CertificationCourse::create([
        'title' => 'Visible Course',
        'slug' => 'visible-course',
        'category' => 'Backend',
        'duration' => '3 weeks',
        'icon' => 'GraduationCap',
        'description' => 'Shown in admin.',
        'highlights' => [],
    ]);

    CourseEnquiry::create([
        'certification_course_id' => $course->id,
        'course_title' => $course->title,
        'name' => 'Ada Lovelace',
        'email' => 'ada@example.com',
        'phone' => '9061033764',
        'message' => 'I want to enrol.',
    ]);

    $this->actingAs($user)
        ->get(route('courses.index'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->component('courses/index')
            ->has('courses', 1));

    $this->actingAs($user)
        ->get(route('courses.enquiries.index'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->component('courses/enquiries')
            ->has('enquiries', 1)
            ->where('enquiries.0.email', 'ada@example.com'));
});

test('guests cannot manage courses', function () {
    $this->get(route('courses.index'))->assertRedirect(route('login'));
});
