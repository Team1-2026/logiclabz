<?php

namespace App\Http\Controllers;

use App\Models\Project;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;
use Inertia\Response;

class ProjectController extends Controller
{
    /**
     * Display a listing of projects.
     */
    public function index(): Response
    {
        return Inertia::render('projects/index', [
            'projects' => Project::orderBy('id', 'asc')->get(),
        ]);
    }

    /**
     * Store a newly created project in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'pillar' => 'required|string|max:255',
            'icon' => 'required|string|max:255',
            'summary' => 'required|string',
            'image' => 'nullable|string|url|max:2048',
            'metrics' => 'nullable|array',
            'metrics.*.k' => 'required|string|max:255',
            'metrics.*.v' => 'required|string|max:255',
            'tech' => 'nullable|array',
            'tech.*' => 'required|string|max:255',
            'screenshots' => 'nullable|array',
            'screenshots.*.src' => 'required|string|max:255',
            'screenshots.*.label' => 'required|string|max:255',
            'screenshots.*.alt' => 'required|string|max:255',
        ]);

        // Generate slug from title
        $slug = Str::slug($validated['title']);

        // Ensure uniqueness of slug
        $originalSlug = $slug;
        $count = 1;
        while (Project::where('slug', $slug)->exists()) {
            $slug = $originalSlug.'-'.$count++;
        }

        Project::create(array_merge($validated, ['slug' => $slug]));

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Project created successfully.')]);

        return redirect()->route('projects.index');
    }

    /**
     * Update the specified project in storage.
     */
    public function update(Request $request, Project $project): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'pillar' => 'required|string|max:255',
            'icon' => 'required|string|max:255',
            'summary' => 'required|string',
            'image' => 'nullable|string|url|max:2048',
            'metrics' => 'nullable|array',
            'metrics.*.k' => 'required|string|max:255',
            'metrics.*.v' => 'required|string|max:255',
            'tech' => 'nullable|array',
            'tech.*' => 'required|string|max:255',
            'screenshots' => 'nullable|array',
            'screenshots.*.src' => 'required|string|max:255',
            'screenshots.*.label' => 'required|string|max:255',
            'screenshots.*.alt' => 'required|string|max:255',
        ]);

        // Regenerate slug if title changed
        if ($project->title !== $validated['title']) {
            $slug = Str::slug($validated['title']);
            $originalSlug = $slug;
            $count = 1;
            while (Project::where('slug', $slug)->where('id', '!=', $project->id)->exists()) {
                $slug = $originalSlug.'-'.$count++;
            }
            $project->slug = $slug;
        }

        $project->update($validated);

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Project updated successfully.')]);

        return redirect()->route('projects.index');
    }

    /**
     * Remove the specified project from storage.
     */
    public function destroy(Project $project): RedirectResponse
    {
        $project->delete();

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Project deleted successfully.')]);

        return redirect()->route('projects.index');
    }
}
