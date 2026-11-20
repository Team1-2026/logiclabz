<?php

namespace App\Http\Controllers;

use App\Models\CertificationCourse;
use App\Models\CourseEnquiry;
use App\Models\Product;
use App\Models\Project;
use App\Models\Service;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PublicApiController extends Controller
{
    /**
     * Get all projects.
     */
    public function projects(): JsonResponse
    {
        $projects = Project::query()->orderBy('id')->get();

        return $this->corsJson($projects);
    }

    /**
     * Get all services.
     */
    public function services(): JsonResponse
    {
        $services = Service::query()->orderBy('id')->get();

        return $this->corsJson($services);
    }

    /**
     * Get all products.
     */
    public function products(): JsonResponse
    {
        $products = Product::query()
            ->orderBy('sort_order')
            ->orderBy('id')
            ->get();

        return $this->corsJson($products);
    }

    /**
     * Get all certification courses.
     */
    public function courses(): JsonResponse
    {
        $courses = CertificationCourse::query()
            ->orderBy('sort_order')
            ->orderBy('id')
            ->get();

        return $this->corsJson($courses);
    }

    /**
     * Get a single certification course.
     */
    public function course(string $slug): JsonResponse
    {
        $course = CertificationCourse::query()->where('slug', $slug)->first();

        if ($course === null) {
            return $this->corsJson(['message' => 'Course not found.'], 404);
        }

        return $this->corsJson($course);
    }

    /**
     * Store an enquiry for a certification course.
     */
    public function storeCourseEnquiry(Request $request, string $slug): JsonResponse
    {
        $course = CertificationCourse::query()->where('slug', $slug)->first();

        if ($course === null) {
            return $this->corsJson(['message' => 'Course not found.'], 404);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'phone' => 'nullable|string|max:30',
            'message' => 'required|string|max:2000',
        ]);

        if ($validator->fails()) {
            return $this->corsJson([
                'message' => 'Please check the form and try again.',
                'errors' => $validator->errors(),
            ], 422);
        }

        $validated = $validator->validated();

        CourseEnquiry::create([
            'certification_course_id' => $course->id,
            'course_title' => $course->title,
            'name' => $validated['name'],
            'email' => $validated['email'],
            'phone' => $validated['phone'] ?? null,
            'message' => $validated['message'],
        ]);

        return $this->corsJson(['message' => 'Enquiry received.'], 201);
    }

    private function corsJson(mixed $data, int $status = 200): JsonResponse
    {
        return response()->json($data, $status)
            ->header('Access-Control-Allow-Origin', '*')
            ->header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
            ->header('Access-Control-Allow-Headers', 'Content-Type, Accept, X-Requested-With');
    }
}
