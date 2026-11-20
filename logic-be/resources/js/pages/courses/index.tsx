import { useRef, useState } from 'react';
import { Head, Link, useForm } from '@inertiajs/react';
import {
    Plus,
    Edit2,
    Trash2,
    PlusCircle,
    XCircle,
    GraduationCap,
    Upload,
    Loader2,
    Star,
    Inbox,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { Separator } from '@/components/ui/separator';
import { Checkbox } from '@/components/ui/checkbox';

interface Course {
    id: number;
    title: string;
    slug: string;
    category: string;
    duration: string;
    icon: string;
    description: string;
    image: string | null;
    highlights: string[] | null;
    is_featured: boolean;
    sort_order: number;
    enquiries_count: number;
}

interface Props {
    courses: Course[];
}

export default function CoursesIndex({ courses }: Props) {
    const [isDialogOpen, setIsDialogOpen] = useState(false);
    const [editingCourse, setEditingCourse] = useState<Course | null>(null);
    const [newHighlight, setNewHighlight] = useState('');
    const [isUploadingImage, setIsUploadingImage] = useState(false);
    const [uploadError, setUploadError] = useState('');
    const imageInputRef = useRef<HTMLInputElement>(null);

    const { data, setData, post, put, delete: destroy, processing, errors, reset, clearErrors } = useForm({
        title: '',
        category: '',
        duration: '',
        icon: '',
        description: '',
        image: '',
        highlights: [] as string[],
        is_featured: false,
        sort_order: 0,
    });

    const handleFileUpload = async (file: File) => {
        setUploadError('');
        setIsUploadingImage(true);

        try {
            const formData = new FormData();
            formData.append('file', file);

            const response = await fetch('/admin/upload', {
                method: 'POST',
                headers: {
                    'X-XSRF-TOKEN': decodeURIComponent(
                        document.cookie
                            .split('; ')
                            .find((row) => row.startsWith('XSRF-TOKEN='))
                            ?.split('=')[1] || '',
                    ),
                },
                body: formData,
            });

            if (!response.ok) {
                const errData = await response.json();
                throw new Error(errData.message || errData.errors?.file?.[0] || 'Upload failed');
            }

            const result = await response.json();
            setData('image', result.url);
        } catch (error: unknown) {
            setUploadError(error instanceof Error ? error.message : 'File upload failed. Please try again.');
        } finally {
            setIsUploadingImage(false);
        }
    };

    const openCreateDialog = () => {
        setEditingCourse(null);
        clearErrors();
        setUploadError('');
        reset();
        setIsDialogOpen(true);
    };

    const openEditDialog = (course: Course) => {
        setEditingCourse(course);
        clearErrors();
        setUploadError('');
        setData({
            title: course.title,
            category: course.category,
            duration: course.duration,
            icon: course.icon,
            description: course.description,
            image: course.image || '',
            highlights: course.highlights || [],
            is_featured: course.is_featured,
            sort_order: course.sort_order,
        });
        setIsDialogOpen(true);
    };

    const handleSave = (e: React.FormEvent) => {
        e.preventDefault();
        if (editingCourse) {
            put(`/admin/courses/${editingCourse.id}`, {
                onSuccess: () => {
                    setIsDialogOpen(false);
                    reset();
                },
            });
        } else {
            post('/admin/courses', {
                onSuccess: () => {
                    setIsDialogOpen(false);
                    reset();
                },
            });
        }
    };

    const handleDelete = (id: number, title: string) => {
        if (confirm(`Are you sure you want to delete "${title}"?`)) {
            destroy(`/admin/courses/${id}`);
        }
    };

    const addHighlight = () => {
        const current = data.highlights || [];
        if (newHighlight.trim() && !current.includes(newHighlight.trim())) {
            setData('highlights', [...current, newHighlight.trim()]);
            setNewHighlight('');
        }
    };

    const removeHighlight = (highlight: string) => {
        setData(
            'highlights',
            (data.highlights || []).filter((item) => item !== highlight),
        );
    };

    return (
        <>
            <Head title="Courses Manager" />
            <div className="flex flex-col gap-6 p-6 max-w-7xl mx-auto w-full">
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div>
                        <h1 className="text-3xl font-bold tracking-tight">Manage Courses</h1>
                        <p className="text-muted-foreground mt-1">
                            Certification courses shown on the public site, each with its own page and enquiry form.
                        </p>
                    </div>
                    <div className="flex items-center gap-2">
                        <Button variant="outline" asChild>
                            <Link href="/admin/course-enquiries">
                                <Inbox className="w-4 h-4" /> Enquiries
                            </Link>
                        </Button>
                        <Button
                            onClick={openCreateDialog}
                            className="brand-glow bg-[#00A9C1] hover:bg-[#0095AB] text-white flex items-center gap-2"
                        >
                            <Plus className="w-4 h-4" /> Add Course
                        </Button>
                    </div>
                </div>

                {courses.length === 0 ? (
                    <Card className="border-dashed border-sidebar-border bg-card/40">
                        <CardContent className="flex flex-col items-center justify-center gap-3 py-16 text-center">
                            <div className="grid size-12 place-items-center rounded-full bg-[#00A9C1]/10 text-[#00A9C1]">
                                <GraduationCap className="size-5" />
                            </div>
                            <div>
                                <p className="font-semibold">No courses yet</p>
                                <p className="text-sm text-muted-foreground mt-1">
                                    Create a certification course to publish it on the public site.
                                </p>
                            </div>
                            <Button onClick={openCreateDialog} variant="outline" className="mt-2">
                                <Plus className="w-4 h-4 mr-1.5" /> Add Course
                            </Button>
                        </CardContent>
                    </Card>
                ) : (
                    <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 mt-2">
                        {courses.map((course) => (
                            <Card
                                key={course.id}
                                className="overflow-hidden border-sidebar-border bg-card/50 backdrop-blur-sm hover:border-[#00A9C1]/50 transition-all flex flex-col justify-between"
                            >
                                {course.image ? (
                                    <div className="aspect-[16/9] overflow-hidden bg-muted">
                                        <img src={course.image} alt={course.title} className="h-full w-full object-cover" />
                                    </div>
                                ) : null}
                                <CardHeader className="pb-4">
                                    <div className="flex justify-between items-start gap-3">
                                        <div className="space-y-1.5 min-w-0">
                                            <div className="flex items-center gap-2 flex-wrap">
                                                <Badge variant="outline" className="text-[#00A9C1] border-[#00A9C1]/20 text-[10px]">
                                                    {course.category}
                                                </Badge>
                                                <Badge variant="secondary" className="text-[10px]">
                                                    {course.duration}
                                                </Badge>
                                                {course.is_featured ? (
                                                    <Badge className="bg-amber-500/15 text-amber-600 border-0 text-[10px] gap-1">
                                                        <Star className="w-3 h-3" /> Featured
                                                    </Badge>
                                                ) : null}
                                            </div>
                                            <CardTitle className="text-xl font-bold tracking-tight">{course.title}</CardTitle>
                                        </div>
                                    </div>
                                    <CardDescription className="text-sm mt-3 leading-relaxed line-clamp-3">
                                        {course.description}
                                    </CardDescription>
                                </CardHeader>
                                <CardContent className="pt-0 flex flex-col justify-end">
                                    <div className="space-y-4">
                                        <div className="flex flex-wrap gap-1.5">
                                            {course.highlights?.map((item) => (
                                                <Badge key={item} variant="secondary" className="text-[10px] py-0 px-2 font-normal">
                                                    {item}
                                                </Badge>
                                            ))}
                                        </div>
                                        <p className="text-xs text-muted-foreground">
                                            {course.enquiries_count} {course.enquiries_count === 1 ? 'enquiry' : 'enquiries'}
                                        </p>
                                        <div className="flex justify-end gap-2 pt-2 border-t border-sidebar-border/30">
                                            <Button size="sm" variant="outline" onClick={() => openEditDialog(course)} className="flex items-center gap-1">
                                                <Edit2 className="w-3.5 h-3.5" /> Edit
                                            </Button>
                                            <Button
                                                size="sm"
                                                variant="destructive"
                                                onClick={() => handleDelete(course.id, course.title)}
                                                className="flex items-center gap-1"
                                            >
                                                <Trash2 className="w-3.5 h-3.5" /> Delete
                                            </Button>
                                        </div>
                                    </div>
                                </CardContent>
                            </Card>
                        ))}
                    </div>
                )}

                <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
                    <DialogContent className="max-w-lg max-h-[85vh] overflow-y-auto">
                        <DialogHeader>
                            <DialogTitle>{editingCourse ? 'Edit Course' : 'Create New Course'}</DialogTitle>
                            <DialogDescription>
                                This course gets its own public page with an enquiry form.
                            </DialogDescription>
                        </DialogHeader>
                        <form onSubmit={handleSave} className="space-y-5 py-2">
                            <div className="space-y-1.5">
                                <Label htmlFor="title">Course Title</Label>
                                <Input
                                    id="title"
                                    value={data.title}
                                    onChange={(e) => setData('title', e.target.value)}
                                    placeholder="e.g. Laravel Certification"
                                    required
                                />
                                {errors.title && <p className="text-red-500 text-xs mt-1">{errors.title}</p>}
                            </div>

                            <div className="grid grid-cols-2 gap-3">
                                <div className="space-y-1.5">
                                    <Label htmlFor="category">Category</Label>
                                    <Input
                                        id="category"
                                        value={data.category}
                                        onChange={(e) => setData('category', e.target.value)}
                                        placeholder="e.g. Backend"
                                        required
                                    />
                                    {errors.category && <p className="text-red-500 text-xs mt-1">{errors.category}</p>}
                                </div>
                                <div className="space-y-1.5">
                                    <Label htmlFor="duration">Duration</Label>
                                    <Input
                                        id="duration"
                                        value={data.duration}
                                        onChange={(e) => setData('duration', e.target.value)}
                                        placeholder="e.g. 6 weeks"
                                        required
                                    />
                                    {errors.duration && <p className="text-red-500 text-xs mt-1">{errors.duration}</p>}
                                </div>
                            </div>

                            <div className="space-y-1.5">
                                <Label htmlFor="icon">Lucide Icon Name</Label>
                                <Input
                                    id="icon"
                                    value={data.icon}
                                    onChange={(e) => setData('icon', e.target.value)}
                                    placeholder="e.g. GraduationCap"
                                    required
                                />
                                {errors.icon && <p className="text-red-500 text-xs mt-1">{errors.icon}</p>}
                            </div>

                            <div className="space-y-1.5">
                                <Label htmlFor="description">Description</Label>
                                <textarea
                                    id="description"
                                    value={data.description}
                                    onChange={(e) => setData('description', e.target.value)}
                                    className="flex min-h-[80px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                    placeholder="What this certification covers..."
                                    required
                                />
                                {errors.description && <p className="text-red-500 text-xs mt-1">{errors.description}</p>}
                            </div>

                            <div className="space-y-1.5">
                                <Label htmlFor="image">Cover Image</Label>
                                <div className="flex gap-2">
                                    <Input
                                        id="image"
                                        value={data.image || ''}
                                        onChange={(e) => setData('image', e.target.value)}
                                        placeholder="https://..."
                                    />
                                    <input
                                        ref={imageInputRef}
                                        type="file"
                                        className="hidden"
                                        accept="image/*"
                                        onChange={(e) => {
                                            const file = e.target.files?.[0];
                                            if (file) handleFileUpload(file);
                                        }}
                                    />
                                    <Button
                                        type="button"
                                        variant="outline"
                                        disabled={isUploadingImage}
                                        onClick={() => imageInputRef.current?.click()}
                                        className="shrink-0 gap-1.5"
                                    >
                                        {isUploadingImage ? <Loader2 className="w-4 h-4 animate-spin" /> : <Upload className="w-4 h-4" />}
                                        {isUploadingImage ? 'Uploading...' : 'Upload'}
                                    </Button>
                                </div>
                                {errors.image && <p className="text-red-500 text-xs mt-1">{errors.image}</p>}
                                {uploadError && <p className="text-red-500 text-xs mt-1">{uploadError}</p>}
                            </div>

                            <Separator />

                            <div className="space-y-3">
                                <Label className="text-base font-semibold">What you will learn</Label>
                                <div className="flex gap-2">
                                    <Input
                                        value={newHighlight}
                                        onChange={(e) => setNewHighlight(e.target.value)}
                                        placeholder="Add a topic"
                                        onKeyDown={(e) => e.key === 'Enter' && (e.preventDefault(), addHighlight())}
                                    />
                                    <Button type="button" size="icon" variant="outline" onClick={addHighlight}>
                                        <PlusCircle className="w-4 h-4" />
                                    </Button>
                                </div>
                                <div className="flex flex-wrap gap-1.5">
                                    {(data.highlights || []).map((item) => (
                                        <Badge key={item} variant="secondary" className="flex items-center gap-1.5 py-0.5 pl-2 pr-1">
                                            {item}
                                            <button type="button" onClick={() => removeHighlight(item)} aria-label={`Remove ${item}`}>
                                                <XCircle className="w-3.5 h-3.5" />
                                            </button>
                                        </Badge>
                                    ))}
                                </div>
                            </div>

                            <div className="grid grid-cols-2 gap-3 items-end">
                                <div className="space-y-1.5">
                                    <Label htmlFor="sort_order">Sort Order</Label>
                                    <Input
                                        id="sort_order"
                                        type="number"
                                        min={0}
                                        value={data.sort_order}
                                        onChange={(e) => setData('sort_order', Number(e.target.value) || 0)}
                                    />
                                </div>
                                <div className="flex items-center gap-2 pb-2">
                                    <Checkbox
                                        id="is_featured"
                                        checked={data.is_featured}
                                        onCheckedChange={(checked) => setData('is_featured', checked === true)}
                                    />
                                    <Label htmlFor="is_featured" className="cursor-pointer font-normal">
                                        Featured course
                                    </Label>
                                </div>
                            </div>

                            <DialogFooter className="pt-4 border-t border-sidebar-border">
                                <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>
                                    Cancel
                                </Button>
                                <Button type="submit" disabled={processing} className="bg-[#00A9C1] hover:bg-[#0095AB] text-white">
                                    {processing ? 'Saving...' : 'Save Course'}
                                </Button>
                            </DialogFooter>
                        </form>
                    </DialogContent>
                </Dialog>
            </div>
        </>
    );
}

CoursesIndex.layout = {
    breadcrumbs: [
        {
            title: 'Courses Manager',
            href: '/admin/courses',
        },
    ],
};
