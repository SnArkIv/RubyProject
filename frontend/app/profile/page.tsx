'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { api } from '@/lib/api';
import { useAuth } from '@/lib/auth';

interface Order {
  id: number;
  status: string;
  total_amount: number;
  shipping_address: string;
  delivery_method: string;
  payment_method: string;
  created_at: string;
}

export default function ProfilePage() {
  const { user } = useAuth();
  const [orders, setOrders] = useState<Order[]>([]);

  useEffect(() => {
    api.get('/orders').then((data) => setOrders(data.orders));
  }, []);

  if (!user) return <p>Загрузка...</p>;

  const statusLabels: Record<string, string> = {
    pending: 'Ожидает',
    confirmed: 'Подтверждён',
    shipped: 'Отправлен',
    delivered: 'Доставлен',
    cancelled: 'Отменён',
  };

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-lg p-5 shadow">
        <h2 className="text-lg font-bold mb-2">Профиль</h2>
        <p className="text-sm text-gray-600">Email: {user.email}</p>
        <p className="text-sm text-gray-600">Роль: {user.role}</p>
      </div>

      <div className="bg-white rounded-lg p-5 shadow">
        <h2 className="text-lg font-bold mb-4">История заказов</h2>
        {orders.length === 0 ? (
          <p className="text-gray-500">У вас пока нет заказов.</p>
        ) : (
          <div className="space-y-3">
            {orders.map((order) => (
              <div key={order.id} className="border rounded-lg p-4">
                <div className="flex items-center justify-between mb-2">
                  <span className="font-bold">Заказ №{order.id}</span>
                  <span className="text-sm px-2 py-0.5 bg-gray-100 rounded">{statusLabels[order.status] || order.status}</span>
                </div>
                <p className="text-sm text-gray-500">{new Date(order.created_at).toLocaleDateString()}</p>
                <p className="text-sm">{order.shipping_address}</p>
                <p className="font-bold mt-1">{Math.round(order.total_amount)} ₽</p>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
