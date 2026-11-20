<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class UploadController extends Controller
{
    /**
     * Store an uploaded image file and return its public URL.
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'file' => 'required|image|mimes:jpeg,png,jpg,gif,svg,webp|max:5120', // Max 5MB
        ]);

        if ($request->hasFile('file') && $request->file('file')->isValid()) {
            $path = $request->file('file')->store('uploads', 'public');

            return response()->json([
                'url' => Storage::url($path),
            ]);
        }

        return response()->json([
            'message' => __('No valid file uploaded.'),
        ], 400);
    }
}
