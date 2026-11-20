<?php

namespace App\Http\Controllers;

use App\Models\Service;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class ServiceController extends Controller
{
    /**
     * Display a listing of services.
     */
    public function index(): Response
    {
        return Inertia::render('services/index', [
            'services' => Service::orderBy('id', 'asc')->get(),
        ]);
    }

    /**
     * Store a newly created service in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'icon' => 'required|string|max:255',
            'desc' => 'required|string',
            'tags' => 'nullable|array',
            'tags.*' => 'required|string|max:255',
        ]);

        Service::create($validated);

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Service created successfully.')]);

        return redirect()->route('services.index');
    }

    /**
     * Update the specified service in storage.
     */
    public function update(Request $request, Service $service): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'icon' => 'required|string|max:255',
            'desc' => 'required|string',
            'tags' => 'nullable|array',
            'tags.*' => 'required|string|max:255',
        ]);

        $service->update($validated);

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Service updated successfully.')]);

        return redirect()->route('services.index');
    }

    /**
     * Remove the specified service from storage.
     */
    public function destroy(Service $service): RedirectResponse
    {
        $service->delete();

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Service deleted successfully.')]);

        return redirect()->route('services.index');
    }
}
