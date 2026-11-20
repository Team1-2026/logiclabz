<?php

use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

test('guest users cannot upload files', function () {
    Storage::fake('public');

    $file = UploadedFile::fake()->image('cover.jpg');

    $response = $this->postJson(route('upload.store'), [
        'file' => $file,
    ]);

    $response->assertStatus(401);
});

test('authenticated users can upload a valid image file', function () {
    Storage::fake('public');

    $user = User::factory()->create();
    $file = UploadedFile::fake()->image('project-cover.png', 800, 600);

    $response = $this->actingAs($user)->postJson(route('upload.store'), [
        'file' => $file,
    ]);

    $response->assertOk();
    $response->assertJsonStructure(['url']);

    $url = $response->json('url');
    expect($url)->toStartWith('/storage/uploads/');

    $path = str_replace('/storage/', '', $url);
    Storage::disk('public')->assertExists($path);
});

test('upload validation rejects non-image files', function () {
    Storage::fake('public');

    $user = User::factory()->create();
    $file = UploadedFile::fake()->create('document.pdf', 100);

    $response = $this->actingAs($user)->postJson(route('upload.store'), [
        'file' => $file,
    ]);

    $response->assertStatus(422);
    $response->assertJsonValidationErrors(['file']);
});

test('upload validation rejects files exceeding 5MB', function () {
    Storage::fake('public');

    $user = User::factory()->create();
    // 6000 KB is ~5.8 MB (exceeds 5120 KB rule)
    $file = UploadedFile::fake()->create('large-image.jpg', 6000, 'image/jpeg');

    $response = $this->actingAs($user)->postJson(route('upload.store'), [
        'file' => $file,
    ]);

    $response->assertStatus(422);
    $response->assertJsonValidationErrors(['file']);
});
