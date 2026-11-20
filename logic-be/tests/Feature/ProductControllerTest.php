<?php

use App\Models\Product;
use App\Models\User;

test('authenticated user can store a product', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)->post(route('products.store'), [
        'title' => 'Logic ERP',
        'category' => 'ERP Solutions',
        'icon' => 'Building2',
        'description' => 'End-to-end ERP for growing enterprises.',
        'image' => 'https://images.unsplash.com/photo-1531403009284-440f080d1e12',
        'features' => ['Finance', 'Inventory'],
        'is_featured' => true,
        'sort_order' => 1,
    ]);

    $response->assertRedirect(route('products.index'));
    $this->assertDatabaseHas('products', [
        'title' => 'Logic ERP',
        'slug' => 'logic-erp',
        'category' => 'ERP Solutions',
    ]);

    $product = Product::first();
    expect($product->features)->toBe(['Finance', 'Inventory']);
    expect($product->is_featured)->toBeTrue();
});

test('authenticated user can update a product and clear its features', function () {
    $user = User::factory()->create();

    $product = Product::create([
        'title' => 'Existing Product',
        'slug' => 'existing-product',
        'category' => 'Operations',
        'icon' => 'Package',
        'description' => 'A wonderful product description.',
        'image' => null,
        'features' => ['Feature A', 'Feature B'],
        'is_featured' => false,
        'sort_order' => 0,
    ]);

    $response = $this->actingAs($user)->put(route('products.update', $product), [
        'title' => 'Updated Product',
        'category' => 'Operations',
        'icon' => 'Package',
        'description' => 'Updated description.',
        'image' => null,
        'features' => [],
        'is_featured' => true,
        'sort_order' => 2,
    ]);

    $response->assertRedirect(route('products.index'));

    $product->refresh();
    expect($product->title)->toBe('Updated Product');
    expect($product->slug)->toBe('updated-product');
    expect($product->features)->toBe([]);
    expect($product->is_featured)->toBeTrue();
    expect($product->sort_order)->toBe(2);
});

test('authenticated user can delete a product', function () {
    $user = User::factory()->create();

    $product = Product::create([
        'title' => 'Disposable Product',
        'slug' => 'disposable-product',
        'category' => 'Ops',
        'icon' => 'Package',
        'description' => 'Will be deleted.',
        'features' => [],
    ]);

    $response = $this->actingAs($user)->delete(route('products.destroy', $product));

    $response->assertRedirect(route('products.index'));
    $this->assertDatabaseMissing('products', ['id' => $product->id]);
});

test('authenticated users can open manage products page', function () {
    $user = User::factory()->create();

    $this->actingAs($user)
        ->get(route('products.index'))
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->component('products/index')
            ->has('products'));
});
