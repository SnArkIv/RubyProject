'use client';

import { useEffect, useState, useCallback } from 'react';
import Link from 'next/link';
import { api } from '@/lib/api';
import { useAuth } from '@/lib/auth';

interface OrderItem {
  id: number;
  quantity: number;
  price: number;
  size: string;
  product: {
    id: number;
    name: string;
    image_url: string | null;
  };
}

interface Order {
  id: number;
  status: string;
  total_amount: number;
  shipping_address: string;
  delivery_method: string;
  payment_method: string;
  created_at: string;
  order_items: OrderItem[];
}

export default function ProfilePage() {
  const { user } = useAuth();
  const [orders, setOrders] = useState<Order[]>([]);
  const [unreviewed, setUnreviewed] = useState<{ product_id: number; name: string; image_url: string | null }[]>([]);
  const [profile, setProfile] = useState<any>(null);
  const [defaultAddress, setDefaultAddress] = useState<any>(null);

  const fetchUnreviewed = useCallback(async () => {
    try {
      const data = await api.get('/orders');
      const delivered = (data.orders || []).filter((o: Order) => o.status === 'delivered');
      const reviewsData = await api.get('/profile');
      const reviewedProductIds: number[] = [];

      for (const order of delivered) {
        for (const item of order.order_items) {
          reviewedProductIds.push(item.product.id);
        }
      }

      const allReviewed = await Promise.all(
        delivered.flatMap(o => o.order_items.map(async (item) => {
          try {
            await api.get(`/products/${item.product.id}/reviews`);
          } catch { /* no reviews */ }
        }))
      );

      const unreviewedItems = delivered.flatMap(o =>
        o.order_items.filter(item => {
          return true;
        })
      );

      const unique = new Map();
      for (const order of delivered) {
        for (const item of order.order_items) {
          if (!unique.has(item.product.id)) {
            unique.set(item.product.id, { product_id: item.product.id, name: item.product.name, image_url: item.product.image_url });
          }
        }
      }
      setUnreviewed(Array.from(unique.values()));
    } catch { /* ignore */ }
  }, []);

  useEffect(() => {
    api.get('/orders').then((data) => setOrders(data.orders));
    api.get('/profile').then((data) => {
      setProfile(data.user);
    }).catch(() => {});
    api.get('/addresses').then((data) => {
      const def = (data.addresses || []).find((a: any) => a.is_default);
      setDefaultAddress(def || null);
    }).catch(() => {});
    fetchUnreviewed();
  }, [fetchUnreviewed]);

  if (!user) return <p>Загрузка...</p>;

  const statusLabels: Record<string, string> = {
    pending: 'Ожидает',
    confirmed: 'Подтверждён',
    shipped: 'Отправлен',
    delivered: 'Доставлен',
    cancelled: 'Отменён',
  };

  const deliveryLabels: Record<string, string> = {
    courier: 'Курьер',
    post: 'Почта',
    pickup: 'Самовывоз',
  };

  const paymentLabels: Record<string, string> = {
    card_on_delivery: 'Картой при получении',
    cash: 'Наличные',
  };

  return (
    <div className="max-w-3xl mx-auto space-y-6 px-4">
      <div className="bg-white rounded-lg p-5 shadow">
        <h2 className="text-lg font-bold mb-2">Профиль</h2>
        <p className="text-sm text-gray-600">Email: {user.email}</p>
        {profile?.first_name && <p className="text-sm text-gray-600">Имя: {profile.first_name}</p>}
        {profile?.last_name && <p className="text-sm text-gray-600">Фамилия: {profile.last_name}</p>}
        {profile?.phone && <p className="text-sm text-gray-600">Телефон: {profile.phone}</p>}
        {defaultAddress && (
          <div className="text-sm text-gray-600 mt-2">
            <p className="font-medium">Адрес по умолчанию:</p>
            <p>{defaultAddress.city}, {defaultAddress.street} {defaultAddress.house}{defaultAddress.apartment ? `, кв. ${defaultAddress.apartment}` : ''}</p>
            <p>{defaultAddress.full_name}, {defaultAddress.phone}</p>
          </div>
        )}
        <Link href="/profile/edit" className="text-accent text-sm hover:underline mt-2 inline-block">Редактировать профиль</Link>
      </div>

      {unreviewed.length > 0 && (
        <div className="bg-white rounded-lg p-5 shadow">
          <h2 className="text-lg font-bold mb-4">Товары для отзыва</h2>
          <div className="space-y-2">
            {unreviewed.map((item) => (
              <div key={item.product_id} className="flex items-center gap-3 bg-gray-50 rounded p-2">
                {item.image_url ? (
                  <img src={item.image_url} alt={item.name} className="w-10 h-10 object-cover rounded" />
                ) : (
                  <div className="w-10 h-10 bg-gray-200 rounded" />
                )}
                <div className="flex-1 text-sm">
                  <Link href={`/products/${item.product_id}`} className="font-medium text-accent hover:underline">
                    {item.name}
                  </Link>
                </div>
                <Link href={`/products/${item.product_id}`} className="text-xs bg-accent text-white px-3 py-1 rounded hover:brightness-105">
                  Оставить отзыв
                </Link>
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="bg-white rounded-lg p-5 shadow">
        <h2 className="text-lg font-bold mb-4">История заказов</h2>
        {orders.length === 0 ? (
          <p className="text-gray-500">У вас пока нет заказов.</p>
        ) : (
          <div className="space-y-4">
            {orders.map((order) => (
              <div key={order.id} className="border rounded-lg overflow-hidden">
                <div className="bg-gray-50 px-4 py-3 flex flex-wrap items-center justify-between border-b gap-2">
                  <div>
                    <span className="font-bold">Заказ №{order.id}</span>
                    <span className="text-sm text-gray-500 ml-2">{new Date(order.created_at).toLocaleDateString()}</span>
                  </div>
                  <div className="flex items-center gap-3">
                    <span className="text-sm px-2 py-0.5 bg-gray-200 rounded">{statusLabels[order.status] || order.status}</span>
                    <span className="font-bold">{Math.round(order.total_amount)} ₽</span>
                  </div>
                </div>
                <div className="px-4 py-3 space-y-2 text-sm text-gray-600">
                  <p className="m-0"><strong>Доставка:</strong> {deliveryLabels[order.delivery_method] || order.delivery_method} | <strong>Оплата:</strong> {paymentLabels[order.payment_method] || order.payment_method}</p>
                  <p className="m-0"><strong>Адрес:</strong> {order.shipping_address}</p>
                  {order.order_items && order.order_items.length > 0 && (
                    <div className="mt-2">
                      <strong className="text-sm">Товары:</strong>
                      {order.order_items.map((item) => (
                        <div key={item.id} className="flex items-center gap-3 mt-2 bg-gray-50 rounded p-2">
                          {item.product.image_url ? (
                            <img src={item.product.image_url} alt={item.product.name} className="w-10 h-10 object-cover rounded" />
                          ) : (
                            <div className="w-10 h-10 bg-gray-200 rounded" />
                          )}
                          <div className="flex-1 text-sm min-w-0">
                            <Link href={`/products/${item.product.id}`} className="m-0 font-medium text-accent hover:underline truncate block">
                              {item.product.name}
                            </Link>
                            <p className="m-0 text-xs text-gray-500">{item.size} × {item.quantity} = {Math.round(item.price * item.quantity)} ₽</p>
                          </div>
                          {order.status === 'delivered' && (
                            <Link
                              href={`/products/${item.product.id}`}
                              className="text-xs text-accent hover:underline shrink-0"
                            >
                              Оставить отзыв
                            </Link>
                          )}
                        </div>
                      ))}
                    </div>
                  )}
                </div>
                <div className="px-4 py-2 border-t bg-gray-50 flex gap-3">
                  <Link href={`/orders/${order.id}`} className="text-[#e63946] text-sm hover:underline">Подробнее →</Link>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}