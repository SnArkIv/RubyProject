'use client';

import { useEffect, useState } from 'react';
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
    <div className="max-w-3xl mx-auto space-y-6">
      <div className="bg-white rounded-lg p-5 shadow">
        <h2 className="text-lg font-bold mb-2">Профиль</h2>
        <p className="text-sm text-gray-600">Email: {user.email}</p>
      </div>

      <div className="bg-white rounded-lg p-5 shadow">
        <h2 className="text-lg font-bold mb-4">История заказов</h2>
        {orders.length === 0 ? (
          <p className="text-gray-500">У вас пока нет заказов.</p>
        ) : (
          <div className="space-y-4">
            {orders.map((order) => (
              <div key={order.id} className="border rounded-lg overflow-hidden">
                <div className="bg-gray-50 px-4 py-3 flex items-center justify-between border-b">
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
                          <div className="flex-1 text-sm">
                            <p className="m-0 font-medium">{item.product.name}</p>
                            <p className="m-0 text-xs text-gray-500">{item.size} × {item.quantity} = {Math.round(item.price * item.quantity)} ₽</p>
                          </div>
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
