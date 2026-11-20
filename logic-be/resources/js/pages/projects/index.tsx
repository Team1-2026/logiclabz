import { useState, useRef } from 'react';
import { Head, useForm } from '@inertiajs/react';
import { Plus, Edit2, Trash2, Globe, Sparkles, PlusCircle, XCircle, Upload, Loader2, Briefcase } from 'lucide-react';
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

const getXsrfToken = () => {
    const cookies = document.cookie.split(';');
    for (const cookie of cookies) {
        const [name, value] = cookie.trim().split('=');
        if (name === 'XSRF-TOKEN') {
            return decodeURIComponent(value);
        }
    }
    return '';
};

interface Metric {
    k: string;
    v: string;
}

interface Screenshot {
    src: string;
    label: string;
    alt: string;
}

interface Project {
    id: number;
    slug: string;
    title: string;
    pillar: string;
    icon: string;
    summary: string;
    image: string | null;
    metrics: Metric[] | null;
    tech: string[] | null;
    screenshots: Screenshot[] | null;
}

interface Props {
    projects: Project[];
}

export default function ProjectsIndex({ projects }: Props) {
    const [isDialogOpen, setIsDialogOpen] = useState(false);
    const [editingProject, setEditingProject] = useState<Project | null>(null);

    // Dynamic fields states
    const [newTech, setNewTech] = useState('');
    const [newMetricKey, setNewMetricKey] = useState('');
    const [newMetricVal, setNewMetricVal] = useState('');
    const [newScreenSrc, setNewScreenSrc] = useState('');
    const [newScreenLabel, setNewScreenLabel] = useState('');
    const [newScreenAlt, setNewScreenAlt] = useState('');

    // Upload states & refs
    const [isUploadingImage, setIsUploadingImage] = useState(false);
    const [isUploadingScreenshot, setIsUploadingScreenshot] = useState(false);
    const [uploadError, setUploadError] = useState('');
    const imageInputRef = useRef<HTMLInputElement>(null);
    const screenshotInputRef = useRef<HTMLInputElement>(null);

    const handleFileUpload = async (file: File, type: 'cover' | 'screenshot') => {
        setUploadError('');
        if (type === 'cover') {
            setIsUploadingImage(true);
        } else {
            setIsUploadingScreenshot(true);
        }

        try {
            const formData = new FormData();
            formData.append('file', file);

            const response = await fetch('/admin/upload', {
                method: 'POST',
                body: formData,
                headers: {
                    'X-XSRF-TOKEN': getXsrfToken(),
                    'Accept': 'application/json',
                },
            });

            if (!response.ok) {
                const errData = await response.json();
                throw new Error(errData.message || errData.errors?.file?.[0] || 'Upload failed');
            }

            const result = await response.json();
            if (type === 'cover') {
                setData('image', result.url);
            } else {
                setNewScreenSrc(result.url);
            }
        } catch (error: any) {
            console.error('File upload error:', error);
            setUploadError(error.message || 'File upload failed. Please try again.');
        } finally {
            if (type === 'cover') {
                setIsUploadingImage(false);
            } else {
                setIsUploadingScreenshot(false);
            }
        }
    };

    const { data, setData, post, put, delete: destroy, processing, errors, reset, clearErrors } = useForm({
        title: '',
        pillar: '',
        icon: '',
        summary: '',
        image: '',
        metrics: [] as Metric[],
        tech: [] as string[],
        screenshots: [] as Screenshot[],
    });

    const openCreateDialog = () => {
        setEditingProject(null);
        clearErrors();
        reset();
        setIsDialogOpen(true);
    };

    const openEditDialog = (project: Project) => {
        setEditingProject(project);
        clearErrors();
        setData({
            title: project.title,
            pillar: project.pillar,
            icon: project.icon,
            summary: project.summary,
            image: project.image || '',
            metrics: project.metrics || [],
            tech: project.tech || [],
            screenshots: project.screenshots || [],
        });
        setIsDialogOpen(true);
    };

    const handleSave = (e: React.FormEvent) => {
        e.preventDefault();
        if (editingProject) {
            put(`/admin/projects/${editingProject.id}`, {
                onSuccess: () => {
                    setIsDialogOpen(false);
                    reset();
                },
            });
        } else {
            post('/admin/projects', {
                onSuccess: () => {
                    setIsDialogOpen(false);
                    reset();
                },
            });
        }
    };

    const handleDelete = (id: number, title: string) => {
        if (confirm(`Are you sure you want to delete "${title}"?`)) {
            destroy(`/admin/projects/${id}`);
        }
    };

    // Tech tags editor
    const addTech = () => {
        const currentTech = data.tech || [];
        if (newTech.trim() && !currentTech.includes(newTech.trim())) {
            setData('tech', [...currentTech, newTech.trim()]);
            setNewTech('');
        }
    };
    const removeTech = (tech: string) => {
        setData('tech', (data.tech || []).filter((t) => t !== tech));
    };

    // Metrics editor
    const addMetric = () => {
        const currentMetrics = data.metrics || [];
        if (newMetricKey.trim() && newMetricVal.trim()) {
            setData('metrics', [...currentMetrics, { k: newMetricKey.trim(), v: newMetricVal.trim() }]);
            setNewMetricKey('');
            setNewMetricVal('');
        }
    };
    const removeMetric = (index: number) => {
        setData('metrics', (data.metrics || []).filter((_, i) => i !== index));
    };

    // Screenshots editor
    const addScreenshot = () => {
        const currentScreenshots = data.screenshots || [];
        if (newScreenSrc.trim() && newScreenLabel.trim()) {
            setData('screenshots', [
                ...currentScreenshots,
                {
                    src: newScreenSrc.trim(),
                    label: newScreenLabel.trim(),
                    alt: newScreenAlt.trim() || newScreenLabel.trim(),
                },
            ]);
            setNewScreenSrc('');
            setNewScreenLabel('');
            setNewScreenAlt('');
        }
    };
    const removeScreenshot = (index: number) => {
        setData('screenshots', (data.screenshots || []).filter((_, i) => i !== index));
    };

    return (
        <>
            <Head title="Projects Manager" />
            <div className="flex flex-col gap-6 p-6 max-w-7xl mx-auto w-full">
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div>
                        <h1 className="text-3xl font-bold tracking-tight">Manage Projects</h1>
                        <p className="text-muted-foreground mt-1">Create and edit portfolio projects shown on the LogicLabz website.</p>
                    </div>
                    <Button onClick={openCreateDialog} className="brand-glow bg-[#007AFF] hover:bg-[#0066D9] text-white flex items-center gap-2">
                        <Plus className="w-4 h-4" /> Add Project
                    </Button>
                </div>

                {projects.length === 0 ? (
                    <Card className="border-dashed border-sidebar-border bg-card/40">
                        <CardContent className="flex flex-col items-center justify-center gap-4 py-16 text-center">
                            <div className="grid size-14 place-items-center rounded-2xl bg-[#007AFF]/10 text-[#007AFF]">
                                <Briefcase className="size-6" />
                            </div>
                            <div>
                                <h2 className="text-xl font-semibold tracking-tight">No projects yet</h2>
                                <p className="mt-1 max-w-md text-sm text-muted-foreground">
                                    Add your first portfolio project to publish it on the public website.
                                </p>
                            </div>
                            <Button onClick={openCreateDialog} className="bg-[#007AFF] hover:bg-[#0066D9] text-white">
                                <Plus className="w-4 h-4" /> Add Project
                            </Button>
                        </CardContent>
                    </Card>
                ) : (
                <div className="grid md:grid-cols-2 gap-6 mt-2">
                    {projects.map((project) => (
                        <Card key={project.id} className="overflow-hidden border-sidebar-border bg-card/50 backdrop-blur-sm hover:border-[#00A9C1]/50 transition-all flex flex-col justify-between">
                            <CardHeader className="pb-4">
                                <div className="flex justify-between items-start gap-3">
                                    <div>
                                        <Badge variant="outline" className="text-[#00A9C1] border-[#00A9C1]/20 bg-[#00A9C1]/5">
                                            {project.pillar}
                                        </Badge>
                                        <CardTitle className="text-2xl font-bold tracking-tight mt-2">{project.title}</CardTitle>
                                    </div>
                                    <Badge variant="secondary" className="font-mono text-xs">
                                        {project.icon}
                                    </Badge>
                                </div>
                                <CardDescription className="text-sm mt-3 leading-relaxed line-clamp-3">
                                    {project.summary}
                                </CardDescription>
                            </CardHeader>
                            <CardContent className="pt-0 flex-1 flex flex-col justify-end">
                                <div className="space-y-4">
                                    {/* Tech list */}
                                    <div className="flex flex-wrap gap-1.5">
                                        {project.tech?.map((t) => (
                                            <Badge key={t} variant="secondary" className="text-[10px] py-0 px-2 font-normal">
                                                {t}
                                            </Badge>
                                        ))}
                                    </div>

                                    {/* Metrics Grid */}
                                    {project.metrics && project.metrics.length > 0 && (
                                        <div className="grid grid-cols-3 gap-2 bg-muted/40 p-2.5 rounded-lg border border-sidebar-border/50">
                                            {project.metrics.map((m) => (
                                                <div key={m.k} className="text-center">
                                                    <div className="text-xs text-muted-foreground uppercase tracking-wider scale-90">{m.k}</div>
                                                    <div className="text-sm font-bold text-[#00A9C1] mt-0.5">{m.v}</div>
                                                </div>
                                            ))}
                                        </div>
                                    )}

                                    {project.screenshots && (
                                        <div className="text-xs text-muted-foreground flex items-center gap-1 bg-[#00A9C1]/5 p-2 rounded-lg border border-[#00A9C1]/10">
                                            <Sparkles className="w-3.5 h-3.5 text-[#00A9C1]" />
                                            <span>Contains <strong>{project.screenshots.length}</strong> dynamic screenshots.</span>
                                        </div>
                                    )}

                                    <div className="flex justify-end gap-2 pt-2 border-t border-sidebar-border/30">
                                        <Button size="sm" variant="outline" onClick={() => openEditDialog(project)} className="flex items-center gap-1">
                                            <Edit2 className="w-3.5 h-3.5" /> Edit
                                        </Button>
                                        <Button size="sm" variant="destructive" onClick={() => handleDelete(project.id, project.title)} className="flex items-center gap-1">
                                            <Trash2 className="w-3.5 h-3.5" /> Delete
                                        </Button>
                                    </div>
                                </div>
                            </CardContent>
                        </Card>
                    ))}
                </div>
                )}

                {/* Create/Edit Dialog */}
                <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
                    <DialogContent className="max-w-2xl max-h-[85vh] overflow-y-auto">
                        <DialogHeader>
                            <DialogTitle>{editingProject ? 'Edit Project' : 'Create New Project'}</DialogTitle>
                            <DialogDescription>
                                Fill in the details to update the dynamic portfolio display.
                            </DialogDescription>
                        </DialogHeader>
                        <form onSubmit={handleSave} className="space-y-6 py-2">
                            <div className="grid grid-cols-2 gap-4">
                                <div className="space-y-1.5">
                                    <Label htmlFor="title">Project Title</Label>
                                    <Input
                                        id="title"
                                        value={data.title}
                                        onChange={(e) => setData('title', e.target.value)}
                                        placeholder="e.g. Logic ERP"
                                        required
                                    />
                                    {errors.title && <p className="text-red-500 text-xs mt-1">{errors.title}</p>}
                                </div>
                                <div className="space-y-1.5">
                                    <Label htmlFor="pillar">Pillar / Category</Label>
                                    <Input
                                        id="pillar"
                                        value={data.pillar}
                                        onChange={(e) => setData('pillar', e.target.value)}
                                        placeholder="e.g. ERP Solutions"
                                        required
                                    />
                                    {errors.pillar && <p className="text-red-500 text-xs mt-1">{errors.pillar}</p>}
                                </div>
                            </div>

                            <div className="grid grid-cols-2 gap-4">
                                <div className="space-y-1.5">
                                    <Label htmlFor="icon">Lucide Icon Name</Label>
                                    <Input
                                        id="icon"
                                        value={data.icon}
                                        onChange={(e) => setData('icon', e.target.value)}
                                        placeholder="e.g. Building2, Fuel, Calculator"
                                        required
                                    />
                                    {errors.icon && <p className="text-red-500 text-xs mt-1">{errors.icon}</p>}
                                </div>
                                <div className="space-y-1.5">
                                    <Label htmlFor="image">Cover Image (if no screenshots)</Label>
                                    <div className="flex gap-2">
                                        <Input
                                            id="image"
                                            value={data.image || ''}
                                            onChange={(e) => setData('image', e.target.value)}
                                            placeholder="URL: https://images.unsplash.com/..."
                                            className="flex-1"
                                        />
                                        <input
                                            type="file"
                                            ref={imageInputRef}
                                            onChange={(e) => {
                                                const file = e.target.files?.[0];
                                                if (file) handleFileUpload(file, 'cover');
                                            }}
                                            accept="image/*"
                                            className="hidden"
                                        />
                                        <Button
                                            type="button"
                                            variant="outline"
                                            disabled={isUploadingImage}
                                            onClick={() => imageInputRef.current?.click()}
                                            className="flex items-center gap-1.5 shrink-0"
                                        >
                                            {isUploadingImage ? (
                                                <Loader2 className="w-4 h-4 animate-spin text-[#00A9C1]" />
                                            ) : (
                                                <Upload className="w-4 h-4 text-[#00A9C1]" />
                                            )}
                                            {isUploadingImage ? 'Uploading...' : 'Upload'}
                                        </Button>
                                    </div>
                                    {errors.image && <p className="text-red-500 text-xs mt-1">{errors.image}</p>}
                                    {uploadError && <p className="text-red-500 text-xs mt-1">{uploadError}</p>}
                                    
                                    {/* Premium Cover Image Live Preview Card */}
                                    {data.image && (
                                        <div className="relative mt-2 rounded-lg border border-sidebar-border overflow-hidden bg-muted/30 aspect-video max-h-36 flex items-center justify-center">
                                            <img
                                                src={data.image}
                                                alt="Cover Image Preview"
                                                className="w-full h-full object-cover"
                                                onError={(e) => {
                                                    e.currentTarget.style.display = 'none';
                                                }}
                                            />
                                            <button
                                                type="button"
                                                onClick={() => setData('image', '')}
                                                className="absolute top-1.5 right-1.5 bg-black/60 hover:bg-black/80 text-white rounded-full p-1 transition focus:outline-none"
                                                aria-label="Remove image"
                                            >
                                                <XCircle className="w-4 h-4" />
                                            </button>
                                        </div>
                                    )}
                                </div>
                            </div>

                            <div className="space-y-1.5">
                                <Label htmlFor="summary">Project Summary</Label>
                                <textarea
                                    id="summary"
                                    value={data.summary}
                                    onChange={(e) => setData('summary', e.target.value)}
                                    className="flex min-h-[80px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                                    placeholder="Enter descriptive copy summarizing the project scope..."
                                    required
                                />
                                {errors.summary && <p className="text-red-500 text-xs mt-1">{errors.summary}</p>}
                            </div>

                            <Separator />

                            {/* Tech Stack Dynamic list */}
                            <div className="space-y-3">
                                <Label className="text-base font-semibold flex items-center gap-1.5">
                                    <Globe className="w-4 h-4 text-[#00A9C1]" /> Technology Stack
                                </Label>
                                <div className="flex gap-2">
                                    <Input
                                        value={newTech}
                                        onChange={(e) => setNewTech(e.target.value)}
                                        placeholder="Add technology (e.g. Laravel)"
                                        onKeyDown={(e) => e.key === 'Enter' && (e.preventDefault(), addTech())}
                                    />
                                    <Button type="button" size="icon" variant="outline" onClick={addTech}>
                                        <PlusCircle className="w-4 h-4 text-[#00A9C1]" />
                                    </Button>
                                </div>
                                <div className="flex flex-wrap gap-1.5 mt-2">
                                    {(data.tech || []).map((t) => (
                                        <Badge key={t} variant="secondary" className="flex items-center gap-1.5 py-0.5 pl-2 pr-1 font-medium">
                                            {t}
                                            <button
                                                type="button"
                                                onClick={(e) => {
                                                    e.preventDefault();
                                                    e.stopPropagation();
                                                    removeTech(t);
                                                }}
                                                className="inline-flex items-center justify-center rounded-full hover:bg-muted focus-visible:outline-none p-0.5 transition-colors"
                                                aria-label={`Remove ${t}`}
                                            >
                                                <XCircle className="w-3.5 h-3.5 text-muted-foreground hover:text-red-500 transition-colors" />
                                            </button>
                                        </Badge>
                                    ))}
                                </div>
                            </div>

                            <Separator />

                            {/* Metrics Dynamic List */}
                            <div className="space-y-3">
                                <Label className="text-base font-semibold flex items-center gap-1.5">
                                    <Sparkles className="w-4 h-4 text-[#00A9C1]" /> Metrics (Up to 3 recommended)
                                </Label>
                                <div className="grid grid-cols-2 gap-2">
                                    <Input
                                        value={newMetricKey}
                                        onChange={(e) => setNewMetricKey(e.target.value)}
                                        placeholder="Label (e.g. Daily users)"
                                    />
                                    <Input
                                        value={newMetricVal}
                                        onChange={(e) => setNewMetricVal(e.target.value)}
                                        placeholder="Value (e.g. 12k+)"
                                        onKeyDown={(e) => e.key === 'Enter' && (e.preventDefault(), addMetric())}
                                    />
                                </div>
                                <Button type="button" variant="outline" size="sm" onClick={addMetric} className="flex items-center gap-1 w-full">
                                    <Plus className="w-4 h-4" /> Add Metric
                                </Button>
                                <div className="space-y-1.5 mt-2">
                                    {(data.metrics || []).map((m, index) => (
                                        <div key={index} className="flex justify-between items-center bg-muted/50 px-3 py-1.5 rounded-lg border border-sidebar-border">
                                            <span className="text-sm font-medium">{m.k}: <strong className="text-[#00A9C1]">{m.v}</strong></span>
                                            <button
                                                type="button"
                                                onClick={(e) => {
                                                    e.preventDefault();
                                                    e.stopPropagation();
                                                    removeMetric(index);
                                                }}
                                                className="inline-flex items-center justify-center p-1 rounded hover:bg-muted text-red-500 hover:text-red-600 focus-visible:outline-none transition-colors"
                                                aria-label="Remove metric"
                                            >
                                                <Trash2 className="w-4 h-4 transition hover:scale-110" />
                                            </button>
                                        </div>
                                    ))}
                                </div>
                            </div>

                            <Separator />

                            {/* Screenshots Dynamic List */}
                            <div className="space-y-3">
                                <Label className="text-base font-semibold">Screenshots Carousel (Optional)</Label>
                                <div className="grid grid-cols-3 gap-2">
                                    <div className="flex gap-1">
                                        <Input
                                            value={newScreenSrc}
                                            onChange={(e) => setNewScreenSrc(e.target.value)}
                                            placeholder="URL / Path"
                                            className="flex-1 text-xs"
                                        />
                                        <input
                                            type="file"
                                            ref={screenshotInputRef}
                                            onChange={(e) => {
                                                const file = e.target.files?.[0];
                                                if (file) handleFileUpload(file, 'screenshot');
                                            }}
                                            accept="image/*"
                                            className="hidden"
                                        />
                                        <Button
                                            type="button"
                                            variant="outline"
                                            size="icon"
                                            disabled={isUploadingScreenshot}
                                            onClick={() => screenshotInputRef.current?.click()}
                                            className="shrink-0 p-1.5 h-9 w-9 flex items-center justify-center"
                                            title="Upload file"
                                        >
                                            {isUploadingScreenshot ? (
                                                <Loader2 className="w-4 h-4 animate-spin text-[#00A9C1]" />
                                            ) : (
                                                <Upload className="w-4 h-4 text-[#00A9C1]" />
                                            )}
                                        </Button>
                                    </div>
                                    <Input
                                        value={newScreenLabel}
                                        onChange={(e) => setNewScreenLabel(e.target.value)}
                                        placeholder="Label (e.g. Dashboard)"
                                        className="text-xs"
                                    />
                                    <Input
                                        value={newScreenAlt}
                                        onChange={(e) => setNewScreenAlt(e.target.value)}
                                        placeholder="Alt description"
                                        className="text-xs"
                                        onKeyDown={(e) => e.key === 'Enter' && (e.preventDefault(), addScreenshot())}
                                    />
                                </div>
                                {newScreenSrc && (
                                    <div className="relative mt-1 rounded border border-sidebar-border overflow-hidden bg-muted/20 w-32 aspect-video flex items-center justify-center">
                                        <img
                                            src={newScreenSrc}
                                            alt="New Screenshot Preview"
                                            className="w-full h-full object-cover"
                                        />
                                    </div>
                                )}
                                <Button type="button" variant="outline" size="sm" onClick={addScreenshot} className="flex items-center gap-1 w-full">
                                    <Plus className="w-4 h-4" /> Add Screenshot
                                </Button>
                                <div className="space-y-1.5 mt-2">
                                    {(data.screenshots || []).map((s, index) => (
                                        <div key={index} className="flex justify-between items-center bg-muted/50 px-3 py-1.5 rounded-lg border border-sidebar-border text-xs">
                                            <span className="truncate max-w-[450px]"><strong>{s.label}</strong> ({s.src})</span>
                                            <button
                                                type="button"
                                                onClick={(e) => {
                                                    e.preventDefault();
                                                    e.stopPropagation();
                                                    removeScreenshot(index);
                                                }}
                                                className="inline-flex items-center justify-center p-1 rounded hover:bg-muted text-red-500 hover:text-red-600 focus-visible:outline-none transition-colors shrink-0"
                                                aria-label="Remove screenshot"
                                            >
                                                <Trash2 className="w-4 h-4 transition hover:scale-110" />
                                            </button>
                                        </div>
                                    ))}
                                </div>
                            </div>

                            <DialogFooter className="pt-4 border-t border-sidebar-border">
                                <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>
                                    Cancel
                                </Button>
                                <Button type="submit" disabled={processing} className="bg-[#00A9C1] hover:bg-[#0095AB] text-white">
                                    {processing ? 'Saving...' : 'Save Project'}
                                </Button>
                            </DialogFooter>
                        </form>
                    </DialogContent>
                </Dialog>
            </div>
        </>
    );
}

ProjectsIndex.layout = {
    breadcrumbs: [
        {
            title: 'Manage Projects',
            href: '/admin/projects',
        },
    ],
};
