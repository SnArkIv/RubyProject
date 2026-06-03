'use client';

import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import Link from 'next/link';
import { api } from '@/lib/api';
import { useAuth } from '@/lib/auth';
import { useCart } from '@/lib/cart';

interface Product {
  id: number;
  name: string;
  description: string;
  price: number;
  final_price: number;
  discount: number;
  sku: string;
  in_stock: boolean;
  stock_quantity: number;
  stock_by_size: Record<string, number>;
  color: string;
  material: string;
  care_instructions: string;
  sizes: string[];
  gender_label: string;
  average_rating: number;
  category: string;
  brand: string;
  images: string[];
  similar_products: { id: number; name: string; final_price: number; image_url: string | null }[];
  reviews: { id: number; rating: number; comment: string; user_email: string; created_at: string }[];
  is_favorited?: boolean;
}

export default function ProductPage() {
  const params = useParams();
  const { user } = useAuth();
  const { refreshCart } = useCart();
  const [product, setProduct] = useState<Product | null>(null);
  const [selectedSize, setSelectedSize] = useState('');
  const [rating, setRating] = useState(5);
  const [comment, setComment] = useState('');
  const [isFavorited, setIsFavorited] = useState(false);
  const [activeImage, setActiveImage] = useState(0);

  useEffect(() => {
    api.get(`/products/${params.id}`).then(setProduct);
    if (user) {
      api.get('/favorites').then((data) => {
        const favs: { id: number }[] = data.favorites || [];
        setIsFavorited(favs.some((f: any) => f.id === Number(params.id) || f.product_id === Number(params.id)));
      }).catch(() => {});
    }
  }, [params.id, user]);

  const addToCart = async () => {
    if (!selectedSize) return alert('Выберите размер');
    if (!product?.in_stock || (product?.stock_quantity ?? 0) <= 0) return alert('Товара нет в наличии');
    await api.post('/cart/items', { product_id: product?.id, size: selectedSize });
    await refreshCart();
    alert('Товар добавлен в корзину');
  };

  const toggleFavorite = async () => {
    if (!user) return alert('Войдите, чтобы добавить в избранное');
    try {
      if (isFavorited) {
        const data = await api.get('/favorites');
        const favs: any[] = data.favorites || [];
        const fav = favs.find((f: any) => f.id === product?.id || f.product_id === product?.id);
        if (fav) await api.del(`/favorites/${fav.id}`);
        setIsFavorited(false);
      } else {
        await api.post('/favorites', { product_id: product?.id });
        setIsFavorited(true);
      }
    } catch { /* ignore */ }
  };

  const submitReview = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await api.post(`/products/${product?.id}/reviews`, { review: { rating, comment } });
      const updated = await api.get(`/products/${params.id}`);
      setProduct(updated);
      setComment('');
    } catch (err: any) {
      alert(err.message || 'Ошибка при отправке отзыва');
    }
  };

  if (!product) return <p>Загрузка...</p>;

  return (
    <div className="space-y-8">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <div className="aspect-square bg-gray-200 rounded-lg overflow-hidden mb-3">
            {product.images[activeImage] ? (
              <img src={product.images[activeImage]} alt={product.name} className="w-full h-full object-cover" />
            ) : (
              <div className="w-full h-full flex items-center justify-center text-gray-400">Нет фото</div>
            )}
          </div>
          {product.images.length > 1 && (
            <div className="flex gap-2 overflow-x-auto pb-1">
              {product.images.map((img, i) => (
                <button key={i} onClick={() => setActiveImage(i)} className={`w-16 h-16 shrink-0 rounded overflow-hidden border-2 ${activeImage === i ? 'border-accent' : 'border-transparent'}`}>
                  <img src={img} alt="" className="w-full h-full object-cover" />
                </button>
              ))}
            </div>
          )}
        </div>

        <div>
          <p className="text-sm text-gray-500 mb-1">Артикул: {product.sku}</p>
          <h1 className="text-2xl font-bold mb-2">{product.name}</h1>
          <div className="flex items-center gap-2 mb-3 text-sm text-gray-600">
            <span>{product.category}</span><span>•</span><span>{product.brand}</span>
          </div>

          <div className="flex items-center gap-3 mb-4">
            {product.discount > 0 && <span className="line-through text-gray-400 text-lg">{Math.round(product.price)} ₽</span>}
            <span className="text-2xl font-bold text-accent">{Math.round(product.final_price)} ₽</span>
            {product.discount > 0 && <span className="bg-black text-white text-sm px-2 py-0.5 rounded">-{product.discount}%</span>}
            {product.average_rating > 0 && <span className="text-sm">★ {product.average_rating}</span>}
          </div>

          <div className="space-y-1 text-sm text-gray-600 mb-4">
            {product.description && <p><strong>Описание:</strong> {product.description}</p>}
            <p><strong>Цвет:</strong> {product.color}</p>
            <p><strong>Материал:</strong> {product.material}</p>
            <p><strong>Уход:</strong> {product.care_instructions}</p>
            <p><strong>Пол:</strong> {product.gender_label}</p>
            <p><strong>Размеры:</strong> {product.sizes.join(', ')}</p>
            <p><strong>Наличие:</strong> {product.stock_quantity > 0 && product.stock_quantity < 50
              ? `В наличии — осталось ${product.stock_quantity} шт.`
              : product.stock_quantity > 0
                ? 'В наличии'
                : <span className="text-red-600 font-semibold">Нет в наличии</span>}</p>
          </div>

          <div className="mb-4">
            <label className="block text-sm font-medium mb-1">Размер <span className="text-red-500">*</span></label>
            <div className="flex flex-wrap gap-2">
              {product.sizes.map((sz) => {
                const inStock = product.stock_by_size ? (product.stock_by_size[sz] || 0) > 0 : product.in_stock;
                return (
                  <button
                    key={sz}
                    onClick={() => inStock && setSelectedSize(sz)}
                    disabled={!inStock}
                    className={`px-3 py-1 border rounded text-sm transition ${selectedSize === sz ? 'bg-accent text-white border-accent' : inStock ? 'bg-white border-gray-300 hover:border-accent hover:text-accent' : 'bg-gray-100 border-gray-200 text-gray-400 cursor-not-allowed line-through'}`}
                    title={inStock ? `В наличии: ${product.stock_by_size?.[sz] || '?'} шт.` : 'Нет в наличии'}
                  >
                    {sz}
                  </button>
                );
              })}
            </div>
            <details className="mt-2">
              <summary className="text-xs text-gray-500 cursor-pointer hover:text-accent">Таблица размеров</summary>
              <div className="mt-2 text-xs text-gray-600 bg-gray-50 rounded p-2">
                <table className="w-full text-left">
                  <thead><tr className="border-b"><th className="pr-2">Размер</th><th className="pr-2">Обхват груди</th><th className="pr-2">Обхват талии</th><th>Обхват бёдер</th></tr></thead>
                  <tbody>
                    <tr><td className="pr-2">XS</td><td className="pr-2">82-86</td><td className="pr-2">62-66</td><td>88-92</td></tr>
                    <tr><td className="pr-2">S</td><td className="pr-2">86-90</td><td className="pr-2">66-70</td><td>92-96</td></tr>
                    <tr><td className="pr-2">M</td><td className="pr-2">90-94</td><td className="pr-2">70-74</td><td>96-100</td></tr>
                    <tr><td className="pr-2">L</td><td className="pr-2">94-100</td><td className="pr-2">74-80</td><td>100-106</td></tr>
                    <tr><td className="pr-2">XL</td><td className="pr-2">100-106</td><td className="pr-2">80-86</td><td>106-112</td></tr>
                  </tbody>
                </table>
              </div>
            </details>
          </div>

          <div className="flex gap-2">
            {product.in_stock && product.stock_quantity > 0 ? (
              <button onClick={addToCart} className="flex-1 bg-accent text-white py-3 rounded-md font-semibold hover:brightness-105">
                Добавить в корзину
              </button>
            ) : (
              <button disabled className="flex-1 bg-gray-300 text-gray-500 py-3 rounded-md font-semibold cursor-not-allowed">
                Нет в наличии
              </button>
            )}
            <button
              onClick={toggleFavorite}
              className={`px-4 py-3 rounded-md font-semibold border transition ${isFavorited ? 'bg-red-50 border-red-300 text-red-600' : 'bg-white border-gray-300 text-gray-600 hover:border-red-300'}`}
            >
              {isFavorited ? '♥' : '♡'}
            </button>
          </div>
        </div>
      </div>

      <div>
        <h2 className="text-xl font-bold mb-4">Отзывы</h2>
        {product.reviews.length === 0 && <p className="text-gray-500">Пока нет отзывов.</p>}
        <div className="space-y-3">
          {product.reviews.map((review) => (
            <div key={review.id} className="bg-white rounded-lg p-4 shadow">
              <div className="flex items-center justify-between mb-1">
                <span className="font-medium text-sm">{review.user_email}</span>
                <span className="text-xs text-gray-400">{new Date(review.created_at).toLocaleDateString()}</span>
              </div>
              <div className="text-accent text-sm mb-1">{'★'.repeat(review.rating)}{'☆'.repeat(5 - review.rating)}</div>
              <p className="text-sm text-gray-600">{review.comment}</p>
            </div>
          ))}
        </div>

        {user && (
          <form onSubmit={submitReview} className="mt-4 bg-white rounded-lg p-4 shadow">
            <h3 className="font-semibold mb-2">Оставить отзыв</h3>
            <div className="mb-2">
              <label className="text-sm">Оценка <span className="text-red-500">*</span>:</label>
              <select value={rating} onChange={(e) => setRating(Number(e.target.value))} className="ml-2 border rounded px-2 py-1">
                {[1,2,3,4,5].map((r) => <option key={r} value={r}>{r}</option>)}
              </select>
            </div>
            <textarea value={comment} onChange={(e) => setComment(e.target.value)} rows={3} className="w-full border rounded px-3 py-2 mb-2" placeholder="Ваш отзыв" />
            <button type="submit" className="bg-accent text-white px-4 py-2 rounded font-semibold">Отправить</button>
          </form>
        )}
      </div>

      {product.similar_products.length > 0 && (
        <div>
          <h2 className="text-xl font-bold mb-4">Может быть интересно</h2>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {product.similar_products.map((p) => (
              <Link key={p.id} href={`/products/${p.id}`} className="bg-white rounded-lg overflow-hidden shadow hover:shadow-md transition block">
                <div className="aspect-square bg-gray-200">
                  {p.image_url ? <img src={p.image_url} alt={p.name} className="w-full h-full object-cover" /> : <div className="w-full h-full flex items-center justify-center text-gray-400">Нет фото</div>}
                </div>
                <div className="p-3">
                  <h3 className="text-sm font-medium truncate">{p.name}</h3>
                  <span className="text-accent font-bold">{Math.round(p.final_price)} ₽</span>
                </div>
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}