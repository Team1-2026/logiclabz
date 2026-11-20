<?php

namespace App\Http\Controllers;

use App\Models\CertificationCourse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;
use Inertia\Response;

class CertificationCourseController extends Controller
{
    /**
     * Display a listing of certification courses.
     */
    public function index(): Response
    {
        return Inertia::render('courses/index', [
            'courses' => CertificationCourse::query()
                ->withCount('enquiries')
                ->orderBy('sort_order')
                ->orderBy('id')
                ->get(),
        ]);
    }

    /**
     * Store a newly created certification course.
     */
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'category' => 'required|string|max:255',
            'duration' => 'required|string|max:255',
            'icon' => 'required|string|max:255',
            'description' => 'required|string',
            'image' => 'nullable|string|max:2048',
            'highlights' => 'nullable|array',
            'highlights.*' => 'required|string|max:255',
            'is_featured' => 'boolean',
            'sort_order' => 'nullable|integer|min:0',
        ]);

        CertificationCourse::create([
            ...$validated,
            'slug' => $this->uniqueSlug($validated['title']),
            'is_featured' => $validated['is_featured'] ?? false,
            'sort_order' => $validated['sort_order'] ?? 0,
            'highlights' => $validated['highlights'] ?? [],
        ]);

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Course created successfully.')]);

        return redirect()->route('courses.index');
    }

    /**
     * Update the specified certification course.
     */
    public function update(Request $request, CertificationCourse $certificationCourse): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'category' => 'required|string|max:255',
            'duration' => 'required|string|max:255',
            'icon' => 'required|string|max:255',
            'description' => 'required|string',
            'image' => 'nullable|string|max:2048',
            'highlights' => 'nullable|array',
            'highlights.*' => 'required|string|max:255',
            'is_featured' => 'boolean',
            'sort_order' => 'nullable|integer|min:0',
        ]);

        if ($certificationCourse->title !== $validated['title']) {
            $certificationCourse->slug = $this->uniqueSlug($validated['title'], $certificationCourse->id);
        }

        $certificationCourse->update([
            ...$validated,
            'is_featured' => $validated['is_featured'] ?? false,
            'sort_order' => $validated['sort_order'] ?? 0,
            'highlights' => $validated['highlights'] ?? [],
        ]);

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Course updated successfully.')]);

        return redirect()->route('courses.index');
    }

    /**
     * Remove the specified certification course.
     */
    public function destroy(CertificationCourse $certificationCourse): RedirectResponse
    {
        $certificationCourse->delete();

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Course deleted successfully.')]);

        return redirect()->route('courses.index');
    }

    private function uniqueSlug(string $title, ?int $ignoreId = null): string
    {
        $slug = Str::slug($title);
        $originalSlug = $slug;
        $count = 1;

        while (
            CertificationCourse::query()
                ->where('slug', $slug)
                ->when($ignoreId, fn ($query) => $query->where('id', '!=', $ignoreId))
                ->exists()
        ) {
            $slug = $originalSlug.'-'.$count++;
        }

        return $slug;
    }
}
