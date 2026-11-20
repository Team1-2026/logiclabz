import { useState } from 'react';
import { Head, useForm } from '@inertiajs/react';
import { Plus, Edit2, Trash2, PlusCircle, XCircle, Settings } from 'lucide-react';
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

interface Service {
    id: number;
    title: string;
    icon: string;
    desc: string;
    tags: string[] | null;
}

interface Props {
    services: Service[];
}

export default function ServicesIndex({ services }: Props) {
    const [isDialogOpen, setIsDialogOpen] = useState(false);
    const [editingService, setEditingService] = useState<Service | null>(null);

    // Tags field states
    const [newTag, setNewTag] = useState('');

    const { data, setData, post, put, delete: destroy, processing, errors, reset, clearErrors } = useForm({
        title: '',
        icon: '',
        desc: '',
        tags: [] as string[],
    });

    const openCreateDialog = () => {
        setEditingService(null);
        clearErrors();
        reset();
        setIsDialogOpen(true);
    };

    const openEditDialog = (service: Service) => {
        setEditingService(service);
        clearErrors();
        setData({
            title: service.title,
            icon: service.icon,
            desc: service.desc,
            tags: service.tags || [],
        });
        setIsDialogOpen(true);
    };

    const handleSave = (e: React.FormEvent) => {
        e.preventDefault();
        if (editingService) {
            put(`/admin/services/${editingService.id}`, {
                onSuccess: () => {
                    setIsDialogOpen(false);
                    reset();
                },
            });
        } else {
            post('/admin/services', {
                onSuccess: () => {
                    setIsDialogOpen(false);
                    reset();
                },
            });
        }
    };

    const handleDelete = (id: number, title: string) => {
        if (confirm(`Are you sure you want to delete "${title}"?`)) {
            destroy(`/admin/services/${id}`);
        }
    };

    // Tags editor
    const addTag = () => {
        const currentTags = data.tags || [];
        if (newTag.trim() && !currentTags.includes(newTag.trim())) {
            setData('tags', [...currentTags, newTag.trim()]);
            setNewTag('');
        }
    };
    const removeTag = (tag: string) => {
        setData('tags', (data.tags || []).filter((t) => t !== tag));
    };

    return (
        <>
            <Head title="Services Manager" />
            <div className="flex flex-col gap-6 p-6 max-w-7xl mx-auto w-full">
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div>
                        <h1 className="text-3xl font-bold tracking-tight">Services Offerings</h1>
                        <p className="text-muted-foreground mt-1">Manage the services pillars and capability details visible in the Services page of logic-app.</p>
                    </div>
                    <Button onClick={openCreateDialog} className="brand-glow bg-[#00A9C1] hover:bg-[#0095AB] text-white flex items-center gap-2">
                        <Plus className="w-4 h-4" /> Add Service
                    </Button>
                </div>

                <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 mt-2">
                    {services.map((service) => (
                        <Card key={service.id} className="overflow-hidden border-sidebar-border bg-card/50 backdrop-blur-sm hover:border-[#00A9C1]/50 transition-all flex flex-col justify-between">
                            <CardHeader className="pb-4">
                                <div className="flex justify-between items-start gap-3">
                                    <CardTitle className="text-xl font-bold tracking-tight">{service.title}</CardTitle>
                                    <Badge variant="outline" className="text-[#00A9C1] border-[#00A9C1]/20 font-mono text-[10px]">
                                        {service.icon}
                                    </Badge>
                                </div>
                                <CardDescription className="text-sm mt-3 leading-relaxed line-clamp-3">
                                    {service.desc}
                                </CardDescription>
                            </CardHeader>
                            <CardContent className="pt-0 flex flex-col justify-end">
                                <div className="space-y-4">
                                    {/* Tags list */}
                                    <div className="flex flex-wrap gap-1.5">
                                        {service.tags?.map((t) => (
                                            <Badge key={t} variant="secondary" className="text-[10px] py-0 px-2 font-normal">
                                                {t}
                                            </Badge>
                                        ))}
                                    </div>

                                    <div className="flex justify-end gap-2 pt-2 border-t border-sidebar-border/30">
                                        <Button size="sm" variant="outline" onClick={() => openEditDialog(service)} className="flex items-center gap-1">
                                            <Edit2 className="w-3.5 h-3.5" /> Edit
                                        </Button>
                                        <Button size="sm" variant="destructive" onClick={() => handleDelete(service.id, service.title)} className="flex items-center gap-1">
                                            <Trash2 className="w-3.5 h-3.5" /> Delete
                                        </Button>
                                    </div>
                                </div>
                            </CardContent>
                        </Card>
                    ))}
                </div>

                {/* Create/Edit Dialog */}
                <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
                    <DialogContent className="max-w-lg max-h-[85vh] overflow-y-auto">
                        <DialogHeader>
                            <DialogTitle>{editingService ? 'Edit Service' : 'Create New Service'}</DialogTitle>
                            <DialogDescription>
                                Fill in the details to update the dynamic services capabilities.
                            </DialogDescription>
                        </DialogHeader>
                        <form onSubmit={handleSave} className="space-y-6 py-2">
                            <div className="space-y-1.5">
                                <Label htmlFor="title">Service Title</Label>
                                <Input
                                    id="title"
                                    value={data.title}
                                    onChange={(e) => setData('title', e.target.value)}
                                    placeholder="e.g. Enterprise Web Platforms"
                                    required
                                />
                                {errors.title && <p className="text-red-500 text-xs mt-1">{errors.title}</p>}
                            </div>

                            <div className="space-y-1.5">
                                <Label htmlFor="icon">Lucide Icon Name</Label>
                                <Input
                                    id="icon"
                                    value={data.icon}
                                    onChange={(e) => setData('icon', e.target.value)}
                                    placeholder="e.g. Code2, Smartphone, Container, Cpu"
                                    required
                                />
                                {errors.icon && <p className="text-red-500 text-xs mt-1">{errors.icon}</p>}
                            </div>

                            <div className="space-y-1.5">
                                <Label htmlFor="desc">Service Description</Label>
                                <textarea
                                    id="desc"
                                    value={data.desc}
                                    onChange={(e) => setData('desc', e.target.value)}
                                    className="flex min-h-[80px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                                    placeholder="Enter descriptive copy summarizing the service offering..."
                                    required
                                />
                                {errors.desc && <p className="text-red-500 text-xs mt-1">{errors.desc}</p>}
                            </div>

                            <Separator />

                            {/* Tags list editor */}
                            <div className="space-y-3">
                                <Label className="text-base font-semibold flex items-center gap-1.5">
                                    <Settings className="w-4 h-4 text-[#00A9C1]" /> Capability Tags
                                </Label>
                                <div className="flex gap-2">
                                    <Input
                                        value={newTag}
                                        onChange={(e) => setNewTag(e.target.value)}
                                        placeholder="Add tag (e.g. Next.js)"
                                        onKeyDown={(e) => e.key === 'Enter' && (e.preventDefault(), addTag())}
                                    />
                                    <Button type="button" size="icon" variant="outline" onClick={addTag}>
                                        <PlusCircle className="w-4 h-4 text-[#00A9C1]" />
                                    </Button>
                                </div>
                                <div className="flex flex-wrap gap-1.5 mt-2">
                                    {(data.tags || []).map((t) => (
                                        <Badge key={t} variant="secondary" className="flex items-center gap-1.5 py-0.5 pl-2 pr-1 font-medium">
                                            {t}
                                            <button
                                                type="button"
                                                onClick={(e) => {
                                                    e.preventDefault();
                                                    e.stopPropagation();
                                                    removeTag(t);
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

                            <DialogFooter className="pt-4 border-t border-sidebar-border">
                                <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>
                                    Cancel
                                </Button>
                                <Button type="submit" disabled={processing} className="bg-[#00A9C1] hover:bg-[#0095AB] text-white">
                                    {processing ? 'Saving...' : 'Save Service'}
                                </Button>
                            </DialogFooter>
                        </form>
                    </DialogContent>
                </Dialog>
            </div>
        </>
    );
}

ServicesIndex.layout = {
    breadcrumbs: [
        {
            title: 'Services Manager',
            href: '/admin/services',
        },
    ],
};
