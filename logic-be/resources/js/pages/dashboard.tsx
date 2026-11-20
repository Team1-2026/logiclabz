import { Head, Link } from '@inertiajs/react';
import { ArrowRight, Briefcase, GraduationCap, Package, Wrench } from 'lucide-react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { dashboard } from '@/routes';

interface Props {
    projectCount: number;
    serviceCount: number;
    productCount: number;
    courseCount: number;
}

export default function Dashboard({ projectCount, serviceCount, productCount, courseCount }: Props) {
    return (
        <>
            <Head title="Dashboard" />
            <div className="flex h-full flex-1 flex-col gap-6 overflow-x-auto p-4 sm:p-6">
                <div>
                    <h1 className="text-2xl font-bold tracking-tight sm:text-3xl">Dashboard</h1>
                    <p className="mt-1 text-muted-foreground">
                        Manage portfolio projects, products, services, and certification courses shown on the LogicLabz website.
                    </p>
                </div>

                <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
                    <Link href="/admin/projects" prefetch className="group block">
                        <Card className="h-full border-sidebar-border transition-all hover:border-[#007AFF]/50 hover:shadow-md">
                            <CardHeader className="flex flex-row items-start justify-between gap-4 space-y-0">
                                <div className="space-y-1.5">
                                    <CardTitle className="text-xl">Manage Projects</CardTitle>
                                    <CardDescription>
                                        Create, edit, and remove portfolio projects for the public site.
                                    </CardDescription>
                                </div>
                                <div className="grid size-11 place-items-center rounded-xl bg-[#007AFF]/10 text-[#007AFF]">
                                    <Briefcase className="size-5" />
                                </div>
                            </CardHeader>
                            <CardContent className="flex items-center justify-between">
                                <div>
                                    <div className="text-3xl font-bold tracking-tight">{projectCount}</div>
                                    <div className="text-xs uppercase tracking-wider text-muted-foreground">
                                        {projectCount === 1 ? 'Project' : 'Projects'}
                                    </div>
                                </div>
                                <span className="inline-flex items-center gap-1 text-sm font-semibold text-[#007AFF] transition-all group-hover:gap-2">
                                    Open <ArrowRight className="size-4" />
                                </span>
                            </CardContent>
                        </Card>
                    </Link>

                    <Link href="/admin/products" prefetch className="group block">
                        <Card className="h-full border-sidebar-border transition-all hover:border-[#007AFF]/50 hover:shadow-md">
                            <CardHeader className="flex flex-row items-start justify-between gap-4 space-y-0">
                                <div className="space-y-1.5">
                                    <CardTitle className="text-xl">Manage Products</CardTitle>
                                    <CardDescription>
                                        Maintain the product catalog shown on the public Products page.
                                    </CardDescription>
                                </div>
                                <div className="grid size-11 place-items-center rounded-xl bg-violet-500/10 text-violet-500">
                                    <Package className="size-5" />
                                </div>
                            </CardHeader>
                            <CardContent className="flex items-center justify-between">
                                <div>
                                    <div className="text-3xl font-bold tracking-tight">{productCount}</div>
                                    <div className="text-xs uppercase tracking-wider text-muted-foreground">
                                        {productCount === 1 ? 'Product' : 'Products'}
                                    </div>
                                </div>
                                <span className="inline-flex items-center gap-1 text-sm font-semibold text-[#007AFF] transition-all group-hover:gap-2">
                                    Open <ArrowRight className="size-4" />
                                </span>
                            </CardContent>
                        </Card>
                    </Link>

                    <Link href="/admin/courses" prefetch className="group block">
                        <Card className="h-full border-sidebar-border transition-all hover:border-[#007AFF]/50 hover:shadow-md">
                            <CardHeader className="flex flex-row items-start justify-between gap-4 space-y-0">
                                <div className="space-y-1.5">
                                    <CardTitle className="text-xl">Manage Courses</CardTitle>
                                    <CardDescription>
                                        Publish certification courses and review enquiries from the public site.
                                    </CardDescription>
                                </div>
                                <div className="grid size-11 place-items-center rounded-xl bg-amber-500/10 text-amber-500">
                                    <GraduationCap className="size-5" />
                                </div>
                            </CardHeader>
                            <CardContent className="flex items-center justify-between">
                                <div>
                                    <div className="text-3xl font-bold tracking-tight">{courseCount}</div>
                                    <div className="text-xs uppercase tracking-wider text-muted-foreground">
                                        {courseCount === 1 ? 'Course' : 'Courses'}
                                    </div>
                                </div>
                                <span className="inline-flex items-center gap-1 text-sm font-semibold text-[#007AFF] transition-all group-hover:gap-2">
                                    Open <ArrowRight className="size-4" />
                                </span>
                            </CardContent>
                        </Card>
                    </Link>

                    <Link href="/admin/services" prefetch className="group block">
                        <Card className="h-full border-sidebar-border transition-all hover:border-[#007AFF]/50 hover:shadow-md">
                            <CardHeader className="flex flex-row items-start justify-between gap-4 space-y-0">
                                <div className="space-y-1.5">
                                    <CardTitle className="text-xl">Manage Services</CardTitle>
                                    <CardDescription>
                                        Update service cards and capabilities shown on the website.
                                    </CardDescription>
                                </div>
                                <div className="grid size-11 place-items-center rounded-xl bg-emerald-500/10 text-emerald-500">
                                    <Wrench className="size-5" />
                                </div>
                            </CardHeader>
                            <CardContent className="flex items-center justify-between">
                                <div>
                                    <div className="text-3xl font-bold tracking-tight">{serviceCount}</div>
                                    <div className="text-xs uppercase tracking-wider text-muted-foreground">
                                        {serviceCount === 1 ? 'Service' : 'Services'}
                                    </div>
                                </div>
                                <span className="inline-flex items-center gap-1 text-sm font-semibold text-[#007AFF] transition-all group-hover:gap-2">
                                    Open <ArrowRight className="size-4" />
                                </span>
                            </CardContent>
                        </Card>
                    </Link>
                </div>
            </div>
        </>
    );
}

Dashboard.layout = {
    breadcrumbs: [
        {
            title: 'Dashboard',
            href: dashboard(),
        },
    ],
};
