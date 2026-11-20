<?php

use App\Models\Product;

test('public api products works and returns CORS headers', function () {
    Product::create([
        'title' => 'Test Product',
        'slug' => 'test-product',
        'category' => 'ERP',
        'icon' => 'Building2',
        'description' => 'This is a test product.',
        'features' => ['Ledger', 'Reports'],
        'is_featured' => true,
        'sort_order' => 1,
    ]);

    $response = $this->get('/api/products');

    $response->assertSuccessful();
    $response->assertHeader('Access-Control-Allow-Origin', '*');
    $response->assertJsonFragment([
        'title' => 'Test Product',
        'category' => 'ERP',
    ]);
});

test('public api products are ordered by sort_order then id', function () {
    Product::create([
        'title' => 'Second',
        'slug' => 'second',
        'category' => 'A',
        'icon' => 'Package',
        'description' => 'Second product.',
        'features' => [],
        'sort_order' => 2,
    ]);

    Product::create([
        'title' => 'First',
        'slug' => 'first',
        'category' => 'A',
        'icon' => 'Package',
        'description' => 'First product.',
        'features' => [],
        'sort_order' => 1,
    ]);

    $response = $this->get('/api/products');

    $response->assertSuccessful();
    expect($response->json()[0]['title'])->toBe('First');
    expect($response->json()[1]['title'])->toBe('Second');
});
