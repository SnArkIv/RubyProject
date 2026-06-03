'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { api } from '@/lib/api';
import { useAuth } from '@/lib/auth';

interface FavoriteProduct {
  id: number;
  name: string;
  price: number;
  final_price: number;
  discount: number;
  image_url: string | null;
}

export default function FavoritesPage() {
  const { user } = useAuth();
  const [favorites, setFavorites] = useState<FavoriteProduct[]>([]);
  const [loading, setLoading] = useState(true);

  const loadFavorites = () => {
    api.get('/favorites').then((data) => {
      setFavorites(data.favorites || []);
      setLoading(false);
    }).catch(() => setLoading(false));
  };

  useEffect(() => {
    loadFavorites();
  }, []);

  const removeFavorite = async (productId: number) => {
    await api.del(`/favorites/${productId}`);
    loadFavorites();
  };

  if (!user) return <p className="text-center py-10">Войдите, чтобы просмотреть избранное</p>;
  if (loading) return <p>Загрузка...</p>;

  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">Избранное</h1>
      {favorites.length === 0 ? (
        <div className="bg-white rounded-lg p-8 text-center shadow">
          <p className="text-gray-500 mb-4">В избранном пока нет товаров.</p>
          <Link href="/catalog" className="inline-block bg-accent text-white px-6 py-3 rounded-md font-semibold">Перейти в каталог</Link>
        </div>
      ) : (
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          {favorites.map((product) => (
            <div key={product.id} className="bg-white rounded-lg overflow-hidden shadow hover:shadow-md transition">
              <Link href={`/products/${product.id}`} className="block">
                <div className="aspect-square bg-gray-200 relative">
                  {product.image_url ? (
                    <img src={product.image_url} alt={product.name} className="w-full h-full object-cover" />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center text-gray-400">Нет фото</div>
                  )}
                  {product.discount > 0 && (
                    <span className="absolute top-2 left-2 bg-accent text-white text-xs font-bold px-1.5 py-0.5 rounded">-{product.discount}%</span>
                  )}
                </div>
                <div className="p-3">
                  <h3 className="text-sm font-medium truncate">{product.name}</h3>
                  <div className="flex items-center gap-2 mt-1">
                    <span className="text-accent font-bold">{Math.round(product.final_price)} ₽</span>
                    {product.discount > 0 && <span className="text-xs text-gray-400 line-through">{Math.round(product.price)} ₽</span>}
                  </div>
                </div>
              </Link>
              <div className="px-3 pb-3">
                <button
                  onClick={() => removeFavorite(product.id)}
                  className="w-full text-sm text-red-600 border border-red-300 rounded py-1 hover:bg-red-50 transition"
                >
                  Удалить из избранного
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}