'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { api } from '@/lib/api';
import { useCart } from '@/lib/cart';

interface CartItem {
  id: number;
  quantity: number;
  size: string;
  product: {
    id: number;
    name: string;
    price: number;
    final_price: number;
    in_stock: boolean;
    stock_quantity: number;
    image_url: string | null;
  };
}

interface CartData {
  cart: {
    items: CartItem[];
    total_amount: number;
    items_count: number;
  };
}

export default function CartPage() {
  const router = useRouter();
  const [data, setData] = useState<CartData | null>(null);
  const [promoCode, setPromoCode] = useState('');
  const [promoDiscount, setPromoDiscount] = useState(0);
  const [promoError, setPromoError] = useState('');
  const { refreshCart } = useCart();

  const loadCart = () => api.get('/cart').then(setData);

  useEffect(() => {
    loadCart();
  }, []);

  const updateQty = async (id: number, qty: number) => {
    if (qty < 1) {
      await api.del(`/cart/items/${id}`);
    } else {
      await api.patch(`/cart/items/${id}`, { quantity: qty });
    }
    await Promise.all([loadCart(), refreshCart()]);
  };

  const buyNow = async (item: CartItem) => {
    if (!item.product.in_stock || item.product.stock_quantity <= 0) {
      alert('Товара нет в наличии');
      return;
    }
    try {
      await api.post('/orders', {
        order: { shipping_address: '', delivery_method: 'courier', payment_method: 'cash' },
        single_item_id: item.id
      });
      await refreshCart();
      router.push('/orders');
    } catch (err: any) {
      alert(err.message || 'Ошибка при оформлении');
    }
  };

  const applyPromo = async () => {
    if (!promoCode.trim()) return;
    setPromoError('');
    try {
      const result = await api.post('/promo_codes/validate', { code: promoCode });
      setPromoDiscount(result.discount);
    } catch (err: any) {
      setPromoError(err.message || 'Промокод не найден');
      setPromoDiscount(0);
    }
  };

  if (!data) return <p>Загрузка...</p>;

  const { items, total_amount } = data.cart;
  const finalTotal = total_amount * (1 - promoDiscount / 100);

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Корзина</h1>
      {items.length === 0 ? (
        <div className="bg-white rounded-lg p-8 text-center shadow">
          <p className="text-gray-500 mb-4">Ваша корзина пуста.</p>
          <Link href="/catalog" className="inline-block bg-accent text-white px-6 py-3 rounded-md font-semibold">Перейти в каталог</Link>
        </div>
      ) : (
        <>
          <div className="bg-white rounded-lg shadow overflow-hidden overflow-x-auto">
            <table className="w-full text-left min-w-[650px]">
              <thead className="bg-gray-50">
                <tr>
                  <th className="p-4">Товар</th>
                  <th className="p-4">Размер</th>
                  <th className="p-4">Цена</th>
                  <th className="p-4">Количество</th>
                  <th className="p-4">Итого</th>
                  <th className="p-4"></th>
                </tr>
              </thead>
              <tbody>
                {items.map((item) => (
                  <tr key={item.id} className="border-t">
                    <td className="p-4 flex items-center gap-3">
                      {item.product.image_url ? (
                        <img src={item.product.image_url} alt={item.product.name} className="w-12 h-12 object-cover rounded" />
                      ) : <div className="w-12 h-12 bg-gray-200 rounded" />}
                      <Link href={`/products/${item.product.id}`} className="font-medium text-accent hover:underline">{item.product.name}</Link>
                    </td>
                    <td className="p-4">{item.size}</td>
                    <td className="p-4">{Math.round(item.product.final_price)} ₽</td>
                    <td className="p-4">
                      <div className="flex items-center gap-2">
                        <button onClick={() => updateQty(item.id, item.quantity - 1)} className="w-8 h-8 border rounded">-</button>
                        <span>{item.quantity}</span>
                        <button onClick={() => updateQty(item.id, item.quantity + 1)} className="w-8 h-8 border rounded">+</button>
                      </div>
                    </td>
                    <td className="p-4 font-bold">{Math.round(item.product.final_price * item.quantity)} ₽</td>
                    <td className="p-4">
                      <button onClick={() => updateQty(item.id, 0)} className="text-accent text-sm">Удалить</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="mt-4 grid grid-cols-1 md:grid-cols-[1fr_300px] gap-4">
            <div className="bg-white rounded-lg p-4 shadow">
              <h3 className="font-semibold mb-2">Промокод</h3>
              <div className="flex gap-2">
                <input value={promoCode} onChange={(e) => setPromoCode(e.target.value)} placeholder="Введите код" className="flex-1 px-3 py-2 border rounded text-sm" />
                <button onClick={applyPromo} className="bg-dark text-white px-3 py-2 rounded text-sm">Применить</button>
              </div>
              {promoError && <p className="text-red-500 text-xs mt-1">{promoError}</p>}
              {promoDiscount > 0 && <p className="text-green-600 text-xs mt-1">Скидка {promoDiscount}%</p>}
            </div>

            <div className="bg-white rounded-lg p-4 shadow">
              <div className="space-y-1">
                {promoDiscount > 0 && (
                  <div className="flex justify-between text-sm text-green-600">
                    <span>Скидка ({promoDiscount}%)</span>
                    <span>-{Math.round(total_amount * promoDiscount / 100)} ₽</span>
                  </div>
                )}
                <div className="flex justify-between text-lg font-bold">
                  <span>Итого:</span>
                  <span>{Math.round(finalTotal)} ₽</span>
                </div>
              </div>
              <Link href="/orders/new" className="mt-3 block text-center bg-accent text-white px-6 py-3 rounded-md font-semibold">Оформить заказ</Link>
            </div>
          </div>
        </>
      )}
    </div>
  );
}