'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { api } from '@/lib/api';

interface CartItem {
  id: number;
  quantity: number;
  size: string;
  product: {
    id: number;
    name: string;
    price: number;
    final_price: number;
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
  const [data, setData] = useState<CartData | null>(null);

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
    loadCart();
  };

  if (!data) return <p>Загрузка...</p>;

  const { items, total_amount } = data.cart;

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Корзина</h1>
      {items.length === 0 ? (
        <div className="bg-white rounded-lg p-8 text-center shadow">
          <p className="text-gray-500 mb-4">Ваша корзина пуста.</p>
          <Link href="/catalog" className="inline-block bg-accent text-white px-6 py-3 rounded-md font-semibold">Перейти в каталог</Link>
        </div>
      ) : (
        <div className="bg-white rounded-lg shadow overflow-hidden">
          <table className="w-full text-left">
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
                    <span className="font-medium">{item.product.name}</span>
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
          <div className="p-4 border-t flex items-center justify-between">
            <span className="text-lg font-bold">Общая сумма: {Math.round(total_amount)} ₽</span>
            <Link href="/orders/new" className="bg-accent text-white px-6 py-3 rounded-md font-semibold">Оформить заказ</Link>
          </div>
        </div>
      )}
    </div>
  );
}
