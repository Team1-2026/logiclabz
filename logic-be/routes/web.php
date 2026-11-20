<?php

use App\Http\Controllers\CertificationCourseController;
use App\Http\Controllers\CourseEnquiryController;
use App\Http\Controllers\CustomerPortalApiController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ProjectController;
use App\Http\Controllers\PublicApiController;
use App\Http\Controllers\ServiceController;
use App\Http\Controllers\UploadController;
use App\Models\CertificationCourse;
use App\Models\Product;
use App\Models\Project;
use App\Models\Service;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return redirect()->route('login');
})->name('home');

// Public Dynamic API Endpoints for logic-app (CORS-enabled via controllers)
Route::prefix('api/v1')->group(function () {
    Route::options('{any}', function () {
        return response('', 204)
            ->header('Access-Control-Allow-Origin', '*')
            ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
            ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Accept, X-Requested-With');
    })->where('any', '.*');

    Route::get('modules', [CustomerPortalApiController::class, 'modules']);
    Route::get('catalog', [CustomerPortalApiController::class, 'catalog']);
    Route::get('products', [CustomerPortalApiController::class, 'catalog']);
    Route::post('auth/register', [CustomerPortalApiController::class, 'register']);
    Route::post('auth/login', [CustomerPortalApiController::class, 'login']);
    Route::get('auth/me', [CustomerPortalApiController::class, 'me']);
    Route::put('customer/profile', [CustomerPortalApiController::class, 'updateProfile']);
    Route::post('checkout/initiate', [CustomerPortalApiController::class, 'checkout']);
    Route::any('payment/callback', [CustomerPortalApiController::class, 'paymentCallback']);
    Route::any('payment/webhook', [CustomerPortalApiController::class, 'paymentCallback']);
    Route::get('customer/dashboard', [CustomerPortalApiController::class, 'dashboard']);
    Route::get('customer/services', [CustomerPortalApiController::class, 'services']);
    Route::get('customer/invoices', [CustomerPortalApiController::class, 'invoices']);
    Route::get('customer/demos', [CustomerPortalApiController::class, 'demos']);
    Route::post('customer/demos', [CustomerPortalApiController::class, 'createDemo']);
    Route::get('customer/tenant-key', [CustomerPortalApiController::class, 'customerGetTenantKey']);
    Route::put('customer/tenant-key', [CustomerPortalApiController::class, 'customerSetTenantKey']);
    Route::post('customer/tenant-key/generate', [CustomerPortalApiController::class, 'customerGenerateTenantKey']);

    // Admin Operations Console
    Route::get('admin/orders', [CustomerPortalApiController::class, 'adminOrders']);
    Route::post('admin/orders', [CustomerPortalApiController::class, 'adminCreateOrder']);
    Route::post('admin/orders/{order}/provision', [CustomerPortalApiController::class, 'adminProvision']);
    Route::get('admin/stats', [CustomerPortalApiController::class, 'adminStats']);
    Route::post('admin/products', [CustomerPortalApiController::class, 'adminCreateProduct']);
    Route::put('admin/products/{product}', [CustomerPortalApiController::class, 'adminUpdateProduct']);
    Route::delete('admin/products/{product}', [CustomerPortalApiController::class, 'adminDeleteProduct']);
    Route::post('admin/products/{product}/sync', [CustomerPortalApiController::class, 'adminSyncProductFromApi']);

    // Admin ERP Integration & Configuration
    Route::get('admin/erp/config', [CustomerPortalApiController::class, 'erpGetConfig']);
    Route::post('admin/erp/config', [CustomerPortalApiController::class, 'erpSaveConfig']);
    Route::post('admin/erp/generate-token', [CustomerPortalApiController::class, 'erpGenerateToken']);
    Route::post('admin/erp/login-token', [CustomerPortalApiController::class, 'erpLoginToken']);
    Route::post('admin/erp/test-connection', [CustomerPortalApiController::class, 'erpTestConnection']);
    Route::post('admin/erp/sync-customers', [CustomerPortalApiController::class, 'erpSyncCustomers']);
    Route::post('admin/erp/sync-invoices', [CustomerPortalApiController::class, 'erpSyncInvoices']);
    Route::post('admin/erp/sync-orders', [CustomerPortalApiController::class, 'erpSyncOrders']);
    Route::get('admin/erp/products', [CustomerPortalApiController::class, 'erpGetProducts']);
    Route::post('admin/erp/sync-accounting', [CustomerPortalApiController::class, 'erpSyncAccounting']);

    // Admin Invoices Management
    Route::get('admin/invoices', [CustomerPortalApiController::class, 'adminInvoices']);
    Route::post('admin/invoices', [CustomerPortalApiController::class, 'adminCreateInvoice']);
    Route::get('admin/invoices/{id}', [CustomerPortalApiController::class, 'adminShowInvoice']);
    Route::put('admin/invoices/{id}', [CustomerPortalApiController::class, 'adminUpdateInvoice']);
    Route::delete('admin/invoices/{id}', [CustomerPortalApiController::class, 'adminDeleteInvoice']);
    Route::post('admin/invoices/{id}/sync-erp', [CustomerPortalApiController::class, 'adminSyncInvoiceToErp']);

    // Admin Customers & Accounting
    Route::get('admin/customers', [CustomerPortalApiController::class, 'adminCustomers']);
    Route::post('admin/customers/{id}/tenant-key', [CustomerPortalApiController::class, 'adminSetCustomerTenantKey']);
    Route::get('admin/accounting', [CustomerPortalApiController::class, 'adminAccountingOverview']);
});

Route::get('api/projects', [PublicApiController::class, 'projects']);
Route::get('api/services', [PublicApiController::class, 'services']);
Route::get('api/products', [PublicApiController::class, 'products']);
Route::get('api/courses', [PublicApiController::class, 'courses']);
Route::get('api/courses/{slug}', [PublicApiController::class, 'course']);
Route::options('api/courses/{slug}/enquiries', function () {
    return response('', 204)
        ->header('Access-Control-Allow-Origin', '*')
        ->header('Access-Control-Allow-Methods', 'POST, OPTIONS')
        ->header('Access-Control-Allow-Headers', 'Content-Type, Accept, X-Requested-With');
});
Route::post('api/courses/{slug}/enquiries', [PublicApiController::class, 'storeCourseEnquiry'])
    ->middleware('throttle:10,1');

Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('dashboard', function () {
        return Inertia::render('dashboard', [
            'projectCount' => Project::query()->count(),
            'serviceCount' => Service::query()->count(),
            'productCount' => Product::query()->count(),
            'courseCount' => CertificationCourse::query()->count(),
        ]);
    })->name('dashboard');

    // Secure Background File Uploader
    Route::post('admin/upload', [UploadController::class, 'store'])->name('upload.store');

    // Projects Admin CRUD Panel
    Route::get('admin/projects', [ProjectController::class, 'index'])->name('projects.index');
    Route::post('admin/projects', [ProjectController::class, 'store'])->name('projects.store');
    Route::put('admin/projects/{project}', [ProjectController::class, 'update'])->name('projects.update');
    Route::delete('admin/projects/{project}', [ProjectController::class, 'destroy'])->name('projects.destroy');

    // Services Admin CRUD Panel
    Route::get('admin/services', [ServiceController::class, 'index'])->name('services.index');
    Route::post('admin/services', [ServiceController::class, 'store'])->name('services.store');
    Route::put('admin/services/{service}', [ServiceController::class, 'update'])->name('services.update');
    Route::delete('admin/services/{service}', [ServiceController::class, 'destroy'])->name('services.destroy');

    // Products Admin CRUD Panel
    Route::get('admin/products', [ProductController::class, 'index'])->name('products.index');
    Route::post('admin/products', [ProductController::class, 'store'])->name('products.store');
    Route::put('admin/products/{product}', [ProductController::class, 'update'])->name('products.update');
    Route::delete('admin/products/{product}', [ProductController::class, 'destroy'])->name('products.destroy');

    Route::get('admin/courses', [CertificationCourseController::class, 'index'])->name('courses.index');
    Route::post('admin/courses', [CertificationCourseController::class, 'store'])->name('courses.store');
    Route::put('admin/courses/{certificationCourse}', [CertificationCourseController::class, 'update'])->name('courses.update');
    Route::delete('admin/courses/{certificationCourse}', [CertificationCourseController::class, 'destroy'])->name('courses.destroy');

    Route::get('admin/course-enquiries', [CourseEnquiryController::class, 'index'])->name('courses.enquiries.index');
    Route::delete('admin/course-enquiries/{courseEnquiry}', [CourseEnquiryController::class, 'destroy'])->name('courses.enquiries.destroy');
});

require __DIR__.'/settings.php';
