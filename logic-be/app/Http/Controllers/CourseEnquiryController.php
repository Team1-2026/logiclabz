<?php

namespace App\Http\Controllers;

use App\Models\CourseEnquiry;
use Illuminate\Http\RedirectResponse;
use Inertia\Inertia;
use Inertia\Response;

class CourseEnquiryController extends Controller
{
    /**
     * Display course enquiries submitted from the public site.
     */
    public function index(): Response
    {
        return Inertia::render('courses/enquiries', [
            'enquiries' => CourseEnquiry::query()
                ->latest()
                ->get(),
        ]);
    }

    /**
     * Remove a course enquiry.
     */
    public function destroy(CourseEnquiry $courseEnquiry): RedirectResponse
    {
        $courseEnquiry->delete();

        Inertia::flash('toast', ['type' => 'success', 'message' => __('Enquiry deleted successfully.')]);

        return redirect()->route('courses.enquiries.index');
    }
}
