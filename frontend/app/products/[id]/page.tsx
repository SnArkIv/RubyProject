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
  color: string;
  material: string;
  care_instructions: string;
  sizes: string[];
  average_rating: number;
  category: string;
  brand: string;
  images: string[];
  similar_products: { id: number; name: string; final_price: number; image_url: string | null }[];
  reviews: { id: number; rating: number; comment: string; user_email: string; created_at: string }[];
}

export default function ProductPage() {
  const params = useParams();
  const { user } = useAuth();
  const { refreshCart } = useCart();
  const [product, setProduct] = useState<Product | null>(null);
  const [selectedSize, setSelectedSize] = useState('');
  const [rating, setRating] = useState(5);
  const [comment, setComment] = useState('');

  useEffect(() => {
    api.get(`/products/${params.id}`).then(setProduct);
  }, [params.id]);

  const addToCart = async () => {
    if (!selectedSize) return alert('Выберите размер');
    await api.post('/cart/items', { product_id: product?.id, size: selectedSize });
    await refreshCart();
    alert('Товар добавлен в корзину');
  };

  const submitReview = async (e: React.FormEvent) => {
    e.preventDefault();
    await api.post(`/products/${product?.id}/reviews`, { review: { rating, comment } });
    const updated = await api.get(`/products/${params.id}`);
    setProduct(updated);
    setComment('');
  };

  if (!product) return <p>Загрузка...</p>;

  return (
    <div className="space-y-8">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <div className="aspect-square bg-gray-200 rounded-lg overflow-hidden mb-3">
            {product.images[0] ? (
              <img src={product.images[0]} alt={product.name} className="w-full h-full object-cover" />
            ) : (
              <div className="w-full h-full flex items-center justify-center text-gray-400">Нет фото</div>
            )}
          </div>
          {product.images.length > 1 && (
            <div className="flex gap-2">
              {product.images.map((img, i) => (
                <img key={i} src={img} alt="" className="w-16 h-16 object-cover rounded cursor-pointer" />
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
            <p><strong>Цвет:</strong> {product.color}</p>
            <p><strong>Материал:</strong> {product.material}</p>
            <p><strong>Уход:</strong> {product.care_instructions}</p>
            <p><strong>Наличие:</strong> {product.in_stock
              ? product.stock_quantity > 0 && product.stock_quantity < 50
                ? `В наличии — осталось ${product.stock_quantity} шт.`
                : 'В наличии'
              : 'Нет в наличии'}</p>
          </div>

          <div className="mb-4">
            <label className="block text-sm font-medium mb-1">Размер</label>
            <div className="flex flex-wrap gap-2">
              {product.sizes.map((sz) => (
                <button
                  key={sz}
                  onClick={() => setSelectedSize(sz)}
                  className={`px-3 py-1 border rounded text-sm ${selectedSize === sz ? 'bg-accent text-white border-accent' : 'bg-white border-gray-300'}`}
                >
                  {sz}
                </button>
              ))}
            </div>
          </div>

          <button
            onClick={addToCart}
            className="w-full bg-accent text-white py-3 rounded-md font-semibold hover:brightness-105"
          >
            Добавить в корзину
          </button>
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
              <label className="text-sm">Оценка:</label>
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
          <h2 className="text-xl font-bold mb-4">Похожие товары</h2>
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
