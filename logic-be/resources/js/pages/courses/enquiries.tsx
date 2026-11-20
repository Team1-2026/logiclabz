import { Head, Link, router } from '@inertiajs/react';
import { Inbox, Trash2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';

interface Enquiry {
    id: number;
    course_title: string;
    name: string;
    email: string;
    phone: string | null;
    message: string;
    created_at: string;
}

interface Props {
    enquiries: Enquiry[];
}

export default function CourseEnquiries({ enquiries }: Props) {
    const handleDelete = (id: number, name: string) => {
        if (confirm(`Delete the enquiry from ${name}?`)) {
            router.delete(`/admin/course-enquiries/${id}`);
        }
    };

    return (
        <>
            <Head title="Course Enquiries" />
            <div className="flex flex-col gap-6 p-6 max-w-7xl mx-auto w-full">
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div>
                        <h1 className="text-3xl font-bold tracking-tight">Course Enquiries</h1>
                        <p className="text-muted-foreground mt-1">
                            Messages submitted from individual certification course pages.
                        </p>
                    </div>
                    <Button variant="outline" asChild>
                        <Link href="/admin/courses">Back to courses</Link>
                    </Button>
                </div>

                {enquiries.length === 0 ? (
                    <Card className="border-dashed border-sidebar-border bg-card/40">
                        <CardContent className="flex flex-col items-center justify-center gap-3 py-16 text-center">
                            <div className="grid size-12 place-items-center rounded-full bg-[#00A9C1]/10 text-[#00A9C1]">
                                <Inbox className="size-5" />
                            </div>
                            <p className="font-semibold">No enquiries yet</p>
                            <p className="text-sm text-muted-foreground">
                                Enquiries from course pages will appear here.
                            </p>
                        </CardContent>
                    </Card>
                ) : (
                    <div className="overflow-x-auto rounded-xl border border-sidebar-border">
                        <table className="w-full text-sm">
                            <thead className="bg-muted/40 text-left">
                                <tr>
                                    <th className="px-4 py-3 font-medium">Course</th>
                                    <th className="px-4 py-3 font-medium">Name</th>
                                    <th className="px-4 py-3 font-medium">Contact</th>
                                    <th className="px-4 py-3 font-medium">Message</th>
                                    <th className="px-4 py-3 font-medium">Received</th>
                                    <th className="px-4 py-3" />
                                </tr>
                            </thead>
                            <tbody>
                                {enquiries.map((enquiry) => (
                                    <tr key={enquiry.id} className="border-t border-sidebar-border align-top">
                                        <td className="px-4 py-3 font-medium">{enquiry.course_title}</td>
                                        <td className="px-4 py-3">{enquiry.name}</td>
                                        <td className="px-4 py-3">
                                            <div>{enquiry.email}</div>
                                            {enquiry.phone ? <div className="text-muted-foreground">{enquiry.phone}</div> : null}
                                        </td>
                                        <td className="px-4 py-3 max-w-sm whitespace-pre-wrap">{enquiry.message}</td>
                                        <td className="px-4 py-3 whitespace-nowrap text-muted-foreground">
                                            {new Date(enquiry.created_at).toLocaleString()}
                                        </td>
                                        <td className="px-4 py-3">
                                            <Button
                                                size="sm"
                                                variant="destructive"
                                                onClick={() => handleDelete(enquiry.id, enquiry.name)}
                                            >
                                                <Trash2 className="w-3.5 h-3.5" />
                                            </Button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                )}
            </div>
        </>
    );
}

CourseEnquiries.layout = {
    breadcrumbs: [
        {
            title: 'Courses Manager',
            href: '/admin/courses',
        },
        {
            title: 'Enquiries',
            href: '/admin/course-enquiries',
        },
    ],
};
