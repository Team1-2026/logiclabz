<?php

namespace Database\Seeders;

use App\Models\CertificationCourse;
use App\Models\Product;
use App\Models\Project;
use App\Models\Service;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Seed Admin User
        User::updateOrCreate(
            ['email' => 'test@example.com'],
            [
                'name' => 'Test User',
                'password' => bcrypt('password'),
            ]
        );

        // 2. Seed Projects
        $projects = [
            [
                'slug' => 'logic-erp',
                'title' => 'Logic ERP',
                'pillar' => 'ERP Solutions',
                'icon' => 'Building2',
                'summary' => 'An end-to-end ERP suite consolidating finance, inventory and HR — built on a Docker-based modular architecture serving 12k+ daily users.',
                'image' => 'https://static.prod-images.emergentagent.com/jobs/ab47ab39-9ae3-4f62-903a-fabf5bc57ffb/images/45be161bcc51a044c5702a318c198d20c44fc4b1b78f6db7bf2706edff118dac.png',
                'metrics' => [
                    ['k' => 'Daily users', 'v' => '12k+'],
                    ['k' => 'Modules', 'v' => '18'],
                    ['k' => 'Uptime', 'v' => '99.97%'],
                ],
                'tech' => ['Laravel', 'React', 'Postgres', 'Docker'],
                'screenshots' => null,
            ],
            [
                'slug' => 'fuel-management',
                'title' => 'Petrol Pump Management',
                'pillar' => 'Fuel Management',
                'icon' => 'Fuel',
                'summary' => 'End-to-end petrol pump software for daily opening and closing readings, multi-nozzle sales (HSD, MS, XP, XG), and payment reconciliation across cash, UPI, card, and wallet.',
                'image' => null,
                'metrics' => [
                    ['k' => 'Pumps', 'v' => '4+'],
                    ['k' => 'Payments', 'v' => 'Cash · UPI · Card'],
                    ['k' => 'Workflow', 'v' => 'Open → Close'],
                ],
                'tech' => ['React', 'Laravel', 'PostgreSQL'],
                'screenshots' => [
                    [
                        'src' => '/portfolio/fuel-management/login.png',
                        'label' => 'Login',
                        'alt' => 'Petrol Pump Management login screen — secure staff access',
                    ],
                    [
                        'src' => '/portfolio/fuel-management/dashboard.png',
                        'label' => 'Pump dashboard',
                        'alt' => 'Petrol pump dashboard showing pumps A, B, C, and D with diesel nozzles',
                    ],
                    [
                        'src' => '/portfolio/fuel-management/opening-reading.png',
                        'label' => 'Opening reading',
                        'alt' => 'Opening meter reading entry for HSD diesel and petrol pumps',
                    ],
                    [
                        'src' => '/portfolio/fuel-management/closing.png',
                        'label' => 'Closing & payments',
                        'alt' => 'Daily closing screen with sales summary and cash, UPI, and card collections',
                    ],
                ],
            ],
            [
                'slug' => 'accounting',
                'title' => 'Accounting Module',
                'pillar' => 'Specialized Modules',
                'icon' => 'Calculator',
                'summary' => 'GAAP-compliant accounting engine plugged into the Logic ERP — handling multi-entity consolidations and audit trails.',
                'image' => 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?crop=entropy&cs=srgb&fm=jpg&ixid=M3w4NjAzMzJ8MHwxfHNlYXJjaHwzfHxkYXJrJTIwbW9kZSUyMGRhc2hib2FyZCUyMHNvZnR3YXJlfGVufDB8fHx8MTc3OTI4Nzc3N3ww&ixlib=rb-4.1.0&q=85',
                'metrics' => [
                    ['k' => 'Entities', 'v' => 'Multi'],
                    ['k' => 'Reports', 'v' => 'GAAP'],
                    ['k' => 'Audit', 'v' => 'Full trail'],
                ],
                'tech' => ['Laravel', 'Vue', 'Postgres'],
                'screenshots' => null,
            ],
            [
                'slug' => 'student-scheduling',
                'title' => 'Student / Faculty Scheduling',
                'pillar' => 'Education Tech',
                'icon' => 'BookOpen',
                'summary' => 'Constraint-solver-backed scheduling for higher-ed institutions — automating timetables across faculty, rooms, and electives.',
                'image' => 'https://images.unsplash.com/photo-1771923082503-0a3381c46cef?crop=entropy&cs=srgb&fm=jpg&ixid=M3w4NjAzMzJ8MHwxfHNlYXJjaHwxfHxkYXJrJTIwbW9kZSUyMGRhc2hib2FyZCUyMHNvZnR3YXJlfGVufDB8fHx8MTc3OTI4Nzc3N3ww&ixlib=rb-4.1.0&q=85',
                'metrics' => [
                    ['k' => 'Institutions', 'v' => '12'],
                    ['k' => 'Time saved', 'v' => '85%'],
                    ['k' => 'Conflicts', 'v' => 'Auto-resolved'],
                ],
                'tech' => ['Next.js', 'Python', 'OR-Tools'],
                'screenshots' => null,
            ],
        ];

        foreach ($projects as $proj) {
            Project::updateOrCreate(['slug' => $proj['slug']], $proj);
        }

        // 3. Seed Services
        $services = [
            [
                'title' => 'Enterprise Web Platforms',
                'icon' => 'Code2',
                'desc' => 'Laravel + Next.js stacks engineered for transactional scale, type-safe APIs, and edge-cached delivery.',
                'tags' => ['Laravel', 'Next.js', 'tRPC', 'Postgres'],
            ],
            [
                'title' => 'Cross-Platform Mobile',
                'icon' => 'Smartphone',
                'desc' => 'Flutter applications with native performance, fluid motion and offline-first design.',
                'tags' => ['Flutter', 'Dart', 'Firebase'],
            ],
            [
                'title' => 'Docker Architecture',
                'icon' => 'Container',
                'desc' => 'Combined container architectures that consolidate services without sacrificing isolation.',
                'tags' => ['Docker', 'Compose', 'K8s', 'CI/CD'],
            ],
            [
                'title' => 'Data & APIs',
                'icon' => 'Database',
                'desc' => 'Polyglot persistence, event-driven systems, and APIs designed to evolve gracefully.',
                'tags' => ['PostgreSQL', 'MongoDB', 'Redis', 'Kafka'],
            ],
            [
                'title' => 'AI Integrations',
                'icon' => 'Cpu',
                'desc' => 'Embeddings, agents and classification flows woven directly into your product pipeline.',
                'tags' => ['OpenAI', 'Claude', 'Gemini'],
            ],
            [
                'title' => 'Security & Compliance',
                'icon' => 'Shield',
                'desc' => 'Hardened auth, audit logging, and infrastructure baselines for regulated industries.',
                'tags' => ['OAuth', 'SOC2', 'GDPR'],
            ],
            [
                'title' => 'IT Outsourcing Services',
                'icon' => 'Briefcase',
                'desc' => 'Complete end-to-end outsourcing for custom product engineering, system integrations, and dedicated lifecycle support.',
                'tags' => ['Product Dev', 'Outsourcing', 'QA Testing', 'Managed Delivery'],
            ],
            [
                'title' => 'Resource Provisioning',
                'icon' => 'Users',
                'desc' => 'Deploy highly skilled, senior developers, DevOps specialists, and UI/UX designers directly into your active squads.',
                'tags' => ['Staff Augmentation', 'Embedded Devs', 'React & Laravel', 'On-Demand scale'],
            ],
            [
                'title' => 'Corporate Technical Training',
                'icon' => 'GraduationCap',
                'desc' => 'Tailored architectural workshops, intensive modern framework bootcamps, and best practices training for engineering teams.',
                'tags' => ['Laravel Training', 'Next.js Masterclass', 'System Design', 'Workshops'],
            ],
            [
                'title' => 'Modernization',
                'icon' => 'Layers',
                'desc' => 'Strangler-fig migrations from legacy CMS / monoliths to clean, headless platforms.',
                'tags' => ['Headless', 'API-first'],
            ],
        ];

        foreach ($services as $srv) {
            Service::updateOrCreate(['title' => $srv['title']], $srv);
        }

        // Clean up old services that are no longer in the seed array
        $seededTitles = collect($services)->pluck('title')->toArray();
        Service::whereNotIn('title', $seededTitles)->delete();

        // 4. Seed Products
        $products = [
            [
                'title' => 'Logic ERP',
                'slug' => 'logic-erp',
                'category' => 'ERP Solutions',
                'icon' => 'Building2',
                'description' => 'An end-to-end ERP suite consolidating finance, inventory and HR — modular architecture for growing enterprises.',
                'image' => 'https://static.prod-images.emergentagent.com/jobs/ab47ab39-9ae3-4f62-903a-fabf5bc57ffb/images/45be161bcc51a044c5702a318c198d20c44fc4b1b78f6db7bf2706edff118dac.png',
                'features' => ['Finance', 'Inventory', 'HR', 'Multi-branch'],
                'is_featured' => true,
                'sort_order' => 1,
            ],
            [
                'title' => 'Fuel Management Suite',
                'slug' => 'fuel-management-suite',
                'category' => 'Fuel Management',
                'icon' => 'Fuel',
                'description' => 'Petrol pump software for opening/closing readings, multi-nozzle sales, and payment reconciliation.',
                'image' => null,
                'features' => ['Nozzle tracking', 'Cash · UPI · Card', 'Daily close'],
                'is_featured' => true,
                'sort_order' => 2,
            ],
            [
                'title' => 'Accounting Modules',
                'slug' => 'accounting-modules',
                'category' => 'Accounting',
                'icon' => 'Calculator',
                'description' => 'Ledger, GST, invoicing and reporting modules built for Indian compliance and day-to-day ops.',
                'image' => null,
                'features' => ['GST ready', 'Invoicing', 'Ledgers'],
                'is_featured' => false,
                'sort_order' => 3,
            ],
            [
                'title' => 'Scheduling System',
                'slug' => 'scheduling-system',
                'category' => 'Operations',
                'icon' => 'CalendarDays',
                'description' => 'Conflict-aware scheduling for institutions and teams — auto-resolve overlaps and save admin hours.',
                'image' => null,
                'features' => ['Auto conflict resolve', 'Multi-role', 'Reports'],
                'is_featured' => false,
                'sort_order' => 4,
            ],
        ];

        foreach ($products as $product) {
            Product::updateOrCreate(['slug' => $product['slug']], $product);
        }

        $courses = [
            [
                'title' => 'Laravel Certification',
                'slug' => 'laravel-certification',
                'category' => 'Backend',
                'duration' => '6 weeks',
                'icon' => 'GraduationCap',
                'description' => 'A hands-on certification covering Laravel application structure, Eloquent, authentication, queues, and production deployment.',
                'image' => null,
                'highlights' => ['Routing & Eloquent', 'Auth & policies', 'Queues & testing', 'Deployment'],
                'is_featured' => true,
                'sort_order' => 1,
            ],
            [
                'title' => 'React & Next.js Certification',
                'slug' => 'react-nextjs-certification',
                'category' => 'Frontend',
                'duration' => '5 weeks',
                'icon' => 'Code2',
                'description' => 'Build production React and Next.js interfaces — component design, data fetching, and performance for real product teams.',
                'image' => null,
                'highlights' => ['React components', 'Next.js routing', 'Data fetching', 'Performance'],
                'is_featured' => true,
                'sort_order' => 2,
            ],
            [
                'title' => 'Flutter App Development',
                'slug' => 'flutter-app-development',
                'category' => 'Mobile',
                'duration' => '6 weeks',
                'icon' => 'Smartphone',
                'description' => 'Ship cross-platform mobile apps with Flutter, covering UI, state, APIs, and release-ready builds.',
                'image' => null,
                'highlights' => ['Widget layout', 'State management', 'API integration', 'Store release'],
                'is_featured' => false,
                'sort_order' => 3,
            ],
        ];

        foreach ($courses as $course) {
            CertificationCourse::updateOrCreate(['slug' => $course['slug']], $course);
        }
    }
}
