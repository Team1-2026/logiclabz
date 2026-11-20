<?php

use App\Models\Project;
use App\Models\User;

test('authenticated user can store a project', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)->post(route('projects.store'), [
        'title' => 'New Project',
        'pillar' => 'Web App',
        'icon' => 'Code',
        'summary' => 'A wonderful project summary.',
        'image' => 'https://images.unsplash.com/photo-1531403009284-440f080d1e12',
        'tech' => ['React', 'Laravel'],
        'metrics' => [
            ['k' => 'Users', 'v' => '5k'],
        ],
        'screenshots' => [
            ['src' => '/path/to/img.png', 'label' => 'Dashboard', 'alt' => 'Dashboard View'],
        ],
    ]);

    $response->assertRedirect(route('projects.index'));
    $this->assertDatabaseHas('projects', [
        'title' => 'New Project',
        'slug' => 'new-project',
    ]);

    $project = Project::first();
    expect($project->tech)->toBe(['React', 'Laravel']);
    expect($project->metrics)->toBe([['k' => 'Users', 'v' => '5k']]);
});

test('authenticated user can update a project and clear its tech stack', function () {
    $user = User::factory()->create();

    $project = Project::create([
        'title' => 'Existing Project',
        'slug' => 'existing-project',
        'pillar' => 'Web App',
        'icon' => 'Code',
        'summary' => 'A wonderful project summary.',
        'tech' => ['React', 'Laravel'],
        'metrics' => [
            ['k' => 'Users', 'v' => '5k'],
        ],
        'screenshots' => [
            ['src' => '/path/to/img.png', 'label' => 'Dashboard', 'alt' => 'Dashboard View'],
        ],
    ]);

    // Send empty tech array to simulate removing the entire technology stack
    $response = $this->actingAs($user)->put(route('projects.update', $project), [
        'title' => 'Existing Project',
        'pillar' => 'Web App',
        'icon' => 'Code',
        'summary' => 'A wonderful project summary.',
        'image' => null,
        'tech' => [], // Empty array
        'metrics' => [],
        'screenshots' => [],
    ]);

    $response->assertRedirect(route('projects.index'));

    $project->refresh();
    expect($project->tech)->toBe([]);
    expect($project->metrics)->toBe([]);
    expect($project->screenshots)->toBe([]);
});
