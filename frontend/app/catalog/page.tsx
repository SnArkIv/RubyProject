'use client';

import { useEffect, useState, Suspense } from 'react';
import Link from 'next/link';
import { useSearchParams } from 'next/navigation';
import { api } from '@/lib/api';

interface Product {
  id: number;
  name: string;
  price: number;
  final_price: number;
  discount: number;
  stock_quantity: number;
  image_url: string | null;
  category: string;
  brand: string;
  average_rating: number;
  in_stock: boolean;
}

interface FilterData {
  categories: { id: number; name: string }[];
  brands: { id: number; name: string }[];
  colors: string[];
  sizes: string[];
}

function CatalogContent() {
  const searchParams = useSearchParams();
  const [products, setProducts] = useState<Product[]>([]);
  const [filters, setFilters] = useState<FilterData | null>(null);
  const [pagination, setPagination] = useState({ count: 0, page: 1, pages: 1 });
  const [loading, setLoading] = useState(true);

  const q = searchParams.get('q') || '';
  const categoryId = searchParams.get('category_id') || '';
  const brandId = searchParams.get('brand_id') || '';
  const sort = searchParams.get('sort') || 'newest';
  const page = searchParams.get('page') || '1';

  useEffect(() => {
    setLoading(true);
    const params = new URLSearchParams();
    if (q) params.set('q', q);
    if (categoryId) params.set('category_id', categoryId);
    if (brandId) params.set('brand_id', brandId);
    params.set('sort', sort);
    params.set('page', page);

    api.get(`/catalog?${params.toString()}`).then((data) => {
      setProducts(data.products);
      setPagination(data.pagination);
      if (!filters) setFilters(data.filters);
      setLoading(false);
    });
  }, [q, categoryId, brandId, sort, page]);

  const buildLink = (updates: Record<string, string>) => {
    const p = new URLSearchParams(searchParams.toString());
    Object.entries(updates).forEach(([k, v]) => {
      if (v) p.set(k, v);
      else p.delete(k);
    });
    p.delete('page');
    return `/catalog?${p.toString()}`;
  };

  return (
    <div className="flex flex-col lg:flex-row gap-6">
      <aside className="w-full lg:w-64 shrink-0">
        <div className="bg-white rounded-lg shadow p-4 space-y-4">
          <div>
            <label className="block font-medium mb-1 text-sm">Поиск</label>
            <input
              type="text"
              defaultValue={q}
              placeholder="Название или артикул"
              className="w-full px-3 py-2 rounded border border-gray-300 text-sm"
              onChange={(e) => {
                const val = e.target.value;
                setTimeout(() => window.location.href = buildLink({ q: val }), 500);
              }}
            />
          </div>

          {filters && (
            <>
              <div>
                <label className="block font-medium mb-1 text-sm">Категория</label>
                <div className="space-y-1 max-h-40 overflow-y-auto">
                  {filters.categories.map((cat) => (
                    <Link key={cat.id} href={buildLink({ category_id: cat.id.toString() })} className={`block text-sm px-2 py-1 rounded ${categoryId === String(cat.id) ? 'bg-accent text-white' : 'hover:bg-gray-100'}`}>
                      {cat.name}
                    </Link>
                  ))}
                </div>
              </div>

              <div>
                <label className="block font-medium mb-1 text-sm">Бренд</label>
                <div className="space-y-1 max-h-40 overflow-y-auto">
                  {filters.brands.map((br) => (
                    <Link key={br.id} href={buildLink({ brand_id: br.id.toString() })} className={`block text-sm px-2 py-1 rounded ${brandId === String(br.id) ? 'bg-accent text-white' : 'hover:bg-gray-100'}`}>
                      {br.name}
                    </Link>
                  ))}
                </div>
              </div>
            </>
          )}

          <Link href="/catalog" className="block text-center text-accent text-sm hover:underline">Сбросить</Link>
        </div>
      </aside>

      <div className="flex-1">
        <div className="flex items-center justify-between mb-4">
          <p className="text-sm text-gray-500">Найдено: {pagination.count} товаров</p>
          <select
            value={sort}
            onChange={(e) => window.location.href = buildLink({ sort: e.target.value })}
            className="px-2 py-1 rounded border border-gray-300 text-sm"
          >
            <option value="newest">По новизне</option>
            <option value="price_asc">Сначала дешевле</option>
            <option value="price_desc">Сначала дороже</option>
            <option value="discount">По скидкам</option>
          </select>
        </div>

        {loading ? (
          <p>Загрузка...</p>
        ) : (
          <>
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
              {products.map((product) => (
                <Link key={product.id} href={`/products/${product.id}`} className="bg-white rounded-lg overflow-hidden shadow hover:shadow-md transition block">
                  <div className="aspect-square bg-gray-200 relative">
                    {product.image_url ? (
                      <img src={product.image_url} alt={product.name} className="w-full h-full object-cover" />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center text-gray-400">Нет фото</div>
                    )}
                    {product.discount > 0 && (
                      <span className="absolute top-2 left-2 bg-accent text-white text-xs font-bold px-1.5 py-0.5 rounded">-{product.discount}%</span>
                    )}
                    {product.stock_quantity > 0 && product.stock_quantity < 50 && (
                      <span className="absolute top-2 right-2 bg-orange-600 text-white text-xs font-bold px-1.5 py-0.5 rounded">Осталось {product.stock_quantity} шт.</span>
                    )}
                    {(product.stock_quantity === 0 || !product.in_stock) && (
                      <span className="absolute top-2 right-2 bg-red-600 text-white text-xs font-bold px-1.5 py-0.5 rounded">Нет в наличии</span>
                    )}
                  </div>
                  <div className="p-3">
                    <h3 className="text-sm font-medium truncate">{product.name}</h3>
                    <div className="flex items-center gap-2 mt-1">
                      <span className="text-accent font-bold">{Math.round(product.final_price)} ₽</span>
                      {product.discount > 0 && <span className="text-xs text-gray-400 line-through">{Math.round(product.price)} ₽</span>}
                    </div>
                    {product.average_rating > 0 && <span className="text-xs text-gray-500">★ {product.average_rating}</span>}
                  </div>
                </Link>
              ))}
            </div>

            {pagination.pages > 1 && (
              <div className="flex justify-center gap-2 mt-6">
                {Array.from({ length: pagination.pages }, (_, i) => i + 1).map((p) => (
                  <Link key={p} href={buildLink({ page: String(p) })} className={`px-3 py-1 rounded text-sm ${p === pagination.page ? 'bg-accent text-white' : 'bg-white border hover:bg-gray-50'}`}>
                    {p}
                  </Link>
                ))}
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}

export default function CatalogPage() {
  return (
    <Suspense fallback={<p>Загрузка...</p>}>
      <CatalogContent />
    </Suspense>
  );
}
