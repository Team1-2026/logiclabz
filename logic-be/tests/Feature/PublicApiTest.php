<?php

use App\Models\Project;
use App\Models\Service;

test('public api projects works and returns CORS headers', function () {
    Project::create([
        'slug' => 'test-project',
        'title' => 'Test Project',
        'pillar' => 'ERP',
        'icon' => 'Building2',
        'summary' => 'This is a test ERP.',
    ]);

    $response = $this->get('/api/projects');

    $response->assertStatus(200);
    $response->assertHeader('Access-Control-Allow-Origin', '*');
    $response->assertJsonFragment([
        'title' => 'Test Project',
    ]);
});

test('public api services works and returns CORS headers', function () {
    Service::create([
        'title' => 'Test Service',
        'icon' => 'Code2',
        'desc' => 'This is a test service.',
    ]);

    $response = $this->get('/api/services');

    $response->assertStatus(200);
    $response->assertHeader('Access-Control-Allow-Origin', '*');
    $response->assertJsonFragment([
        'title' => 'Test Service',
    ]);
});
