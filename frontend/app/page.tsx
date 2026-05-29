'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { api } from '@/lib/api';

interface Category {
  id: number;
  name: string;
  products_count: number;
}

interface Product {
  id: number;
  name: string;
  final_price: number;
  discount: number;
  image_url: string | null;
  category: string;
  brand: string;
}

export default function HomePage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [saleProducts, setSaleProducts] = useState<Product[]>([]);

  useEffect(() => {
    api.get('/categories').then((data) => setCategories(data.categories));
    api.get('/catalog?sort=discount').then((data) => setSaleProducts(data.products.slice(0, 8)));
  }, []);

  return (
    <div className="space-y-10">
      <section className="bg-dark text-white rounded-lg p-10 text-center">
        <h1 className="text-3xl font-bold mb-4">Стильная одежда на каждый день</h1>
        <p className="text-lg text-white/80 mb-6">Качественные материалы, актуальные модели, честные цены</p>
        <Link href="/catalog" className="inline-block bg-accent text-white px-8 py-3 rounded-md font-semibold hover:brightness-105">
          Смотреть каталог
        </Link>
      </section>

      <section>
        <h2 className="text-xl font-bold mb-4">Популярные категории</h2>
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          {categories.map((cat) => (
            <Link key={cat.id} href={`/catalog?category_id=${cat.id}`} className="bg-white rounded-lg p-6 text-center shadow hover:shadow-md transition">
              <h3 className="font-semibold">{cat.name}</h3>
              <p className="text-sm text-gray-500">{cat.products_count} товаров</p>
            </Link>
          ))}
        </div>
      </section>

      {saleProducts.length > 0 && (
        <section>
          <h2 className="text-xl font-bold mb-4">Акции и скидки</h2>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {saleProducts.map((product) => (
              <Link key={product.id} href={`/products/${product.id}`} className="bg-white rounded-lg overflow-hidden shadow hover:shadow-md transition block">
                <div className="aspect-square bg-gray-200">
                  {product.image_url ? (
                    <img src={product.image_url} alt={product.name} className="w-full h-full object-cover" />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center text-gray-400">Нет фото</div>
                  )}
                </div>
                <div className="p-3">
                  <h3 className="text-sm font-medium truncate">{product.name}</h3>
                  <div className="flex items-center gap-2 mt-1">
                    <span className="text-accent font-bold">{Math.round(product.final_price)} ₽</span>
                    {product.discount > 0 && <span className="text-xs bg-black text-white px-1 rounded">-{product.discount}%</span>}
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </section>
      )}
    </div>
  );
}
