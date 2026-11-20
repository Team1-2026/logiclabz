<?php

use App\Models\Product;
use App\Models\Project;
use App\Models\Service;
use App\Models\User;

test('guests are redirected to the login page', function () {
    $response = $this->get(route('dashboard'));
    $response->assertRedirect(route('login'));
});

test('authenticated users can visit the dashboard', function () {
    $user = User::factory()->create();
    $this->actingAs($user);

    $response = $this->get(route('dashboard'));
    $response->assertOk();
});

test('dashboard includes manage project counts and links', function () {
    $user = User::factory()->create();

    Project::query()->create([
        'slug' => 'demo-project',
        'title' => 'Demo Project',
        'pillar' => 'ERP',
        'icon' => 'Building2',
        'summary' => 'A demo portfolio project.',
        'image' => null,
        'metrics' => [],
        'tech' => ['Laravel'],
        'screenshots' => [],
    ]);

    Service::query()->create([
        'title' => 'Enterprise Web',
        'icon' => 'Code2',
        'desc' => 'Custom enterprise platforms.',
        'tags' => ['Laravel'],
    ]);

    Product::query()->create([
        'title' => 'Demo Product',
        'slug' => 'demo-product',
        'category' => 'ERP',
        'icon' => 'Building2',
        'description' => 'A demo product.',
        'features' => ['Finance'],
        'is_featured' => true,
        'sort_order' => 1,
    ]);

    $this->actingAs($user)
        ->get(route('dashboard'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->component('dashboard')
            ->where('projectCount', 1)
            ->where('serviceCount', 1)
            ->where('productCount', 1)
            ->where('courseCount', 0));
});

test('authenticated users can open manage projects page', function () {
    $user = User::factory()->create();

    $this->actingAs($user)
        ->get(route('projects.index'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->component('projects/index')
            ->has('projects'));
});

test('authenticated users can open manage products page from dashboard flow', function () {
    $user = User::factory()->create();

    $this->actingAs($user)
        ->get(route('products.index'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->component('products/index')
            ->has('products'));
});
