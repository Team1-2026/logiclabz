import { useRef, useState } from 'react';
import { Head, useForm } from '@inertiajs/react';
import {
    Plus,
    Edit2,
    Trash2,
    PlusCircle,
    XCircle,
    Package,
    Upload,
    Loader2,
    Star,
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

interface Product {
    id: number;
    title: string;
    slug: string;
    category: string;
    icon: string;
    description: string;
    image: string | null;
    features: string[] | null;
    is_featured: boolean;
    sort_order: number;
}

interface Props {
    products: Product[];
}

export default function ProductsIndex({ products }: Props) {
    const [isDialogOpen, setIsDialogOpen] = useState(false);
    const [editingProduct, setEditingProduct] = useState<Product | null>(null);
    const [newFeature, setNewFeature] = useState('');
    const [isUploadingImage, setIsUploadingImage] = useState(false);
    const [uploadError, setUploadError] = useState('');
    const imageInputRef = useRef<HTMLInputElement>(null);

    const { data, setData, post, put, delete: destroy, processing, errors, reset, clearErrors } = useForm({
        title: '',
        category: '',
        icon: '',
        description: '',
        image: '',
        features: [] as string[],
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
            console.error('File upload error:', error);
            setUploadError(error instanceof Error ? error.message : 'File upload failed. Please try again.');
        } finally {
            setIsUploadingImage(false);
        }
    };

    const openCreateDialog = () => {
        setEditingProduct(null);
        clearErrors();
        setUploadError('');
        reset();
        setIsDialogOpen(true);
    };

    const openEditDialog = (product: Product) => {
        setEditingProduct(product);
        clearErrors();
        setUploadError('');
        setData({
            title: product.title,
            category: product.category,
            icon: product.icon,
            description: product.description,
            image: product.image || '',
            features: product.features || [],
            is_featured: product.is_featured,
            sort_order: product.sort_order,
        });
        setIsDialogOpen(true);
    };

    const handleSave = (e: React.FormEvent) => {
        e.preventDefault();
        if (editingProduct) {
            put(`/admin/products/${editingProduct.id}`, {
                onSuccess: () => {
                    setIsDialogOpen(false);
                    reset();
                },
            });
        } else {
            post('/admin/products', {
                onSuccess: () => {
                    setIsDialogOpen(false);
                    reset();
                },
            });
        }
    };

    const handleDelete = (id: number, title: string) => {
        if (confirm(`Are you sure you want to delete "${title}"?`)) {
            destroy(`/admin/products/${id}`);
        }
    };

    const addFeature = () => {
        const current = data.features || [];
        if (newFeature.trim() && !current.includes(newFeature.trim())) {
            setData('features', [...current, newFeature.trim()]);
            setNewFeature('');
        }
    };

    const removeFeature = (feature: string) => {
        setData(
            'features',
            (data.features || []).filter((f) => f !== feature),
        );
    };

    return (
        <>
            <Head title="Products Manager" />
            <div className="flex flex-col gap-6 p-6 max-w-7xl mx-auto w-full">
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div>
                        <h1 className="text-3xl font-bold tracking-tight">Manage Products</h1>
                        <p className="text-muted-foreground mt-1">
                            Manage product catalog cards shown on the Products page of logic-app.
                        </p>
                    </div>
                    <Button
                        onClick={openCreateDialog}
                        className="brand-glow bg-[#00A9C1] hover:bg-[#0095AB] text-white flex items-center gap-2"
                    >
                        <Plus className="w-4 h-4" /> Add Product
                    </Button>
                </div>

                {products.length === 0 ? (
                    <Card className="border-dashed border-sidebar-border bg-card/40">
                        <CardContent className="flex flex-col items-center justify-center gap-3 py-16 text-center">
                            <div className="grid size-12 place-items-center rounded-full bg-[#00A9C1]/10 text-[#00A9C1]">
                                <Package className="size-5" />
                            </div>
                            <div>
                                <p className="font-semibold">No products yet</p>
                                <p className="text-sm text-muted-foreground mt-1">
                                    Create your first product to show it on the public site.
                                </p>
                            </div>
                            <Button onClick={openCreateDialog} variant="outline" className="mt-2">
                                <Plus className="w-4 h-4 mr-1.5" /> Add Product
                            </Button>
                        </CardContent>
                    </Card>
                ) : (
                    <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 mt-2">
                        {products.map((product) => (
                            <Card
                                key={product.id}
                                className="overflow-hidden border-sidebar-border bg-card/50 backdrop-blur-sm hover:border-[#00A9C1]/50 transition-all flex flex-col justify-between"
                            >
                                {product.image ? (
                                    <div className="aspect-[16/9] overflow-hidden bg-muted">
                                        <img
                                            src={product.image}
                                            alt={product.title}
                                            className="h-full w-full object-cover"
                                        />
                                    </div>
                                ) : null}
                                <CardHeader className="pb-4">
                                    <div className="flex justify-between items-start gap-3">
                                        <div className="space-y-1.5 min-w-0">
                                            <div className="flex items-center gap-2 flex-wrap">
                                                <Badge
                                                    variant="outline"
                                                    className="text-[#00A9C1] border-[#00A9C1]/20 text-[10px]"
                                                >
                                                    {product.category}
                                                </Badge>
                                                {product.is_featured ? (
                                                    <Badge className="bg-amber-500/15 text-amber-600 border-0 text-[10px] gap-1">
                                                        <Star className="w-3 h-3" /> Featured
                                                    </Badge>
                                                ) : null}
                                            </div>
                                            <CardTitle className="text-xl font-bold tracking-tight">
                                                {product.title}
                                            </CardTitle>
                                        </div>
                                        <Badge
                                            variant="outline"
                                            className="text-[#00A9C1] border-[#00A9C1]/20 font-mono text-[10px] shrink-0"
                                        >
                                            {product.icon}
                                        </Badge>
                                    </div>
                                    <CardDescription className="text-sm mt-3 leading-relaxed line-clamp-3">
                                        {product.description}
                                    </CardDescription>
                                </CardHeader>
                                <CardContent className="pt-0 flex flex-col justify-end">
                                    <div className="space-y-4">
                                        <div className="flex flex-wrap gap-1.5">
                                            {product.features?.map((f) => (
                                                <Badge
                                                    key={f}
                                                    variant="secondary"
                                                    className="text-[10px] py-0 px-2 font-normal"
                                                >
                                                    {f}
                                                </Badge>
                                            ))}
                                        </div>

                                        <div className="flex justify-end gap-2 pt-2 border-t border-sidebar-border/30">
                                            <Button
                                                size="sm"
                                                variant="outline"
                                                onClick={() => openEditDialog(product)}
                                                className="flex items-center gap-1"
                                            >
                                                <Edit2 className="w-3.5 h-3.5" /> Edit
                                            </Button>
                                            <Button
                                                size="sm"
                                                variant="destructive"
                                                onClick={() => handleDelete(product.id, product.title)}
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
                            <DialogTitle>
                                {editingProduct ? 'Edit Product' : 'Create New Product'}
                            </DialogTitle>
                            <DialogDescription>
                                Fill in the details to update the product catalog on the public site.
                            </DialogDescription>
                        </DialogHeader>
                        <form onSubmit={handleSave} className="space-y-5 py-2">
                            <div className="space-y-1.5">
                                <Label htmlFor="title">Product Title</Label>
                                <Input
                                    id="title"
                                    value={data.title}
                                    onChange={(e) => setData('title', e.target.value)}
                                    placeholder="e.g. Logic ERP"
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
                                        placeholder="e.g. ERP Solutions"
                                        required
                                    />
                                    {errors.category && (
                                        <p className="text-red-500 text-xs mt-1">{errors.category}</p>
                                    )}
                                </div>
                                <div className="space-y-1.5">
                                    <Label htmlFor="icon">Lucide Icon Name</Label>
                                    <Input
                                        id="icon"
                                        value={data.icon}
                                        onChange={(e) => setData('icon', e.target.value)}
                                        placeholder="e.g. Building2, Fuel"
                                        required
                                    />
                                    {errors.icon && <p className="text-red-500 text-xs mt-1">{errors.icon}</p>}
                                </div>
                            </div>

                            <div className="space-y-1.5">
                                <Label htmlFor="description">Description</Label>
                                <textarea
                                    id="description"
                                    value={data.description}
                                    onChange={(e) => setData('description', e.target.value)}
                                    className="flex min-h-[80px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                                    placeholder="Enter descriptive copy summarizing the product..."
                                    required
                                />
                                {errors.description && (
                                    <p className="text-red-500 text-xs mt-1">{errors.description}</p>
                                )}
                            </div>

                            <div className="space-y-1.5">
                                <Label htmlFor="image">Cover Image</Label>
                                <div className="flex gap-2">
                                    <Input
                                        id="image"
                                        value={data.image || ''}
                                        onChange={(e) => setData('image', e.target.value)}
                                        placeholder="URL: https://images.unsplash.com/..."
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
                                {data.image ? (
                                    <div className="relative mt-2 aspect-[16/9] overflow-hidden rounded-md border border-sidebar-border">
                                        <img
                                            src={data.image}
                                            alt="Product preview"
                                            className="h-full w-full object-cover"
                                        />
                                        <button
                                            type="button"
                                            className="absolute right-2 top-2 rounded-full bg-black/60 p-1 text-white hover:bg-black/80"
                                            onClick={() => setData('image', '')}
                                            aria-label="Remove image"
                                        >
                                            <XCircle className="w-4 h-4" />
                                        </button>
                                    </div>
                                ) : null}
                            </div>

                            <Separator />

                            <div className="space-y-3">
                                <Label className="text-base font-semibold flex items-center gap-1.5">
                                    <Package className="w-4 h-4 text-[#00A9C1]" /> Features
                                </Label>
                                <div className="flex gap-2">
                                    <Input
                                        value={newFeature}
                                        onChange={(e) => setNewFeature(e.target.value)}
                                        placeholder="Add feature (e.g. Multi-tenant)"
                                        onKeyDown={(e) => e.key === 'Enter' && (e.preventDefault(), addFeature())}
                                    />
                                    <Button type="button" size="icon" variant="outline" onClick={addFeature}>
                                        <PlusCircle className="w-4 h-4 text-[#00A9C1]" />
                                    </Button>
                                </div>
                                <div className="flex flex-wrap gap-1.5 mt-2">
                                    {(data.features || []).map((f) => (
                                        <Badge
                                            key={f}
                                            variant="secondary"
                                            className="flex items-center gap-1.5 py-0.5 pl-2 pr-1 font-medium"
                                        >
                                            {f}
                                            <button
                                                type="button"
                                                onClick={(e) => {
                                                    e.preventDefault();
                                                    e.stopPropagation();
                                                    removeFeature(f);
                                                }}
                                                className="inline-flex items-center justify-center rounded-full hover:bg-muted focus-visible:outline-none p-0.5 transition-colors"
                                                aria-label={`Remove ${f}`}
                                            >
                                                <XCircle className="w-3.5 h-3.5 text-muted-foreground hover:text-red-500 transition-colors" />
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
                                    {errors.sort_order && (
                                        <p className="text-red-500 text-xs mt-1">{errors.sort_order}</p>
                                    )}
                                </div>
                                <div className="flex items-center gap-2 pb-2">
                                    <Checkbox
                                        id="is_featured"
                                        checked={data.is_featured}
                                        onCheckedChange={(checked) => setData('is_featured', checked === true)}
                                    />
                                    <Label htmlFor="is_featured" className="cursor-pointer font-normal">
                                        Featured product
                                    </Label>
                                </div>
                            </div>

                            <DialogFooter className="pt-4 border-t border-sidebar-border">
                                <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>
                                    Cancel
                                </Button>
                                <Button
                                    type="submit"
                                    disabled={processing}
                                    className="bg-[#00A9C1] hover:bg-[#0095AB] text-white"
                                >
                                    {processing ? 'Saving...' : 'Save Product'}
                                </Button>
                            </DialogFooter>
                        </form>
                    </DialogContent>
                </Dialog>
            </div>
        </>
    );
}

ProductsIndex.layout = {
    breadcrumbs: [
        {
            title: 'Products Manager',
            href: '/admin/products',
        },
    ],
};
