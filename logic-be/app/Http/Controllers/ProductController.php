<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;
use Inertia\Response;

class ProductController extends Controller
{
    /**
     * Display a listing of products.
     */
    public function index(): Response
    {
        return Inertia::render('products/index', [
            'products' => Product::query()
                ->orderBy('sort_order')
                ->orderBy('id')
                ->get(),
        ]);
    }

    /**
     * Store a newly created product in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'category' => 'required|string|max:255',
            'icon' => 'required|string|max:255',
            'description' => 'required|string',
            'image' => 'nullable|string|max:2048',
            'features' => 'nullable|array',
            'features.*' => 'required|string|max:255',
            'is_featured' => 'boolean',
            'sort_order' => 'nullable|integer|min:0',
        ]);

        $slug = $this->uniqueSlug($validated['title']);

        Product::create([
            ...$validated,
            'slug' => $slug,
            'is_featured' => $validated['is_featured'] ?? false,
            'sort_order' => $validated['sort_order'] ?? 0,
            'features' => $validated['features'] ?? [],
        ]);

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Product created successfully.')]);

        return redirect()->route('products.index');
    }

    /**
     * Update the specified product in storage.
     */
    public function update(Request $request, Product $product): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'category' => 'required|string|max:255',
            'icon' => 'required|string|max:255',
            'description' => 'required|string',
            'image' => 'nullable|string|max:2048',
            'features' => 'nullable|array',
            'features.*' => 'required|string|max:255',
            'is_featured' => 'boolean',
            'sort_order' => 'nullable|integer|min:0',
        ]);

        if ($product->title !== $validated['title']) {
            $product->slug = $this->uniqueSlug($validated['title'], $product->id);
        }

        $product->update([
            ...$validated,
            'is_featured' => $validated['is_featured'] ?? false,
            'sort_order' => $validated['sort_order'] ?? 0,
            'features' => $validated['features'] ?? [],
        ]);

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Product updated successfully.')]);

        return redirect()->route('products.index');
    }

    /**
     * Remove the specified product from storage.
     */
    public function destroy(Product $product): RedirectResponse
    {
        $product->delete();

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Product deleted successfully.')]);

        return redirect()->route('products.index');
    }

    private function uniqueSlug(string $title, ?int $ignoreId = null): string
    {
        $slug = Str::slug($title);
        $originalSlug = $slug;
        $count = 1;

        while (
            Product::query()
                ->where('slug', $slug)
                ->when($ignoreId, fn ($query) => $query->where('id', '!=', $ignoreId))
                ->exists()
        ) {
            $slug = $originalSlug.'-'.$count++;
        }

        return $slug;
    }
}
