'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { api } from '@/lib/api';
import { useAuth } from '@/lib/auth';

interface Address {
  id: number;
  full_name: string;
  phone: string;
  city: string;
  street: string;
  house: string;
  apartment: string;
  zip_code: string;
}

export default function NewOrderPage() {
  const { user } = useAuth();
  const router = useRouter();
  const [addresses, setAddresses] = useState<Address[]>([]);
  const [shippingAddress, setShippingAddress] = useState('');
  const [deliveryMethod, setDeliveryMethod] = useState('courier');
  const [paymentMethod, setPaymentMethod] = useState('cash');
  const [cart, setCart] = useState<{ items: any[]; total_amount: number } | null>(null);
  const [promoCode, setPromoCode] = useState('');
  const [promoDiscount, setPromoDiscount] = useState(0);
  const [promoError, setPromoError] = useState('');
  const [submitting, setSubmitting] = useState(false);

  const finalTotal = cart ? cart.total_amount * (1 - promoDiscount / 100) : 0;

  useEffect(() => {
    if (!user) return;
    api.get('/cart').then((data) => setCart(data.cart));
    api.get('/addresses').then((data) => {
      setAddresses(data.addresses);
      const def = data.addresses.find((a: Address) => a.is_default);
      if (def) {
        setShippingAddress(`${def.city}, ${def.street} ${def.house}, кв. ${def.apartment}, ${def.zip_code}`);
      }
    });
  }, [user]);

  const applyPromo = async () => {
    if (!promoCode.trim()) return;
    setPromoError('');
    try {
      const data = await api.post('/promo_codes/validate', { code: promoCode });
      setPromoDiscount(data.discount);
    } catch (err: any) {
      setPromoError(err.message || 'Промокод не найден');
      setPromoDiscount(0);
    }
  };

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitting(true);
    try {
      const data = await api.post('/orders', {
        order: {
          shipping_address: deliveryMethod === 'pickup' ? 'Самовывоз' : shippingAddress,
          delivery_method: deliveryMethod,
          payment_method: paymentMethod
        },
        promo_code: promoCode
      });
      router.push(`/orders/${data.order.id}`);
    } catch (err: any) {
      const message = err.message || 'Ошибка при оформлении заказа';
      try {
        const parsed = JSON.parse(err.message);
        alert(parsed.error || parsed.errors?.join(', ') || message);
      } catch {
        alert(message);
      }
    } finally {
      setSubmitting(false);
    }
  };

  if (!user) return <p>Войдите, чтобы оформить заказ</p>;
  if (!cart) return <p>Загрузка...</p>;

  return (
    <div className="grid grid-cols-1 lg:grid-cols-[1fr_320px] gap-6">
      <div className="bg-white rounded-lg p-5 shadow">
        <h2 className="text-lg font-bold mb-4">Оформление заказа</h2>
        <form onSubmit={submit} className="space-y-4">
          <div style={deliveryMethod === 'pickup' ? { display: 'none' } : {}}>
            <label className="block text-sm font-medium mb-1">Адрес доставки</label>
            <textarea value={shippingAddress} onChange={(e) => setShippingAddress(e.target.value)}
              required={deliveryMethod !== 'pickup'} rows={3} className="w-full px-3 py-2 border rounded"
              placeholder={deliveryMethod === 'pickup' ? 'Адрес не требуется при самовывозе' : 'Город, улица, дом, квартира, индекс'} />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">Способ доставки</label>
            <select value={deliveryMethod} onChange={(e) => setDeliveryMethod(e.target.value)} className="w-full px-3 py-2 border rounded">
              <option value="courier">Курьер</option>
              <option value="post">Почта</option>
              <option value="pickup">Самовывоз</option>
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">Способ оплаты</label>
            <select value={paymentMethod} onChange={(e) => setPaymentMethod(e.target.value)} className="w-full px-3 py-2 border rounded">
              <option value="cash">Наличные</option>
              <option value="card_on_delivery">Картой при получении</option>
            </select>
          </div>
          <button type="submit" disabled={submitting} className="bg-accent text-white px-5 py-2 rounded-md font-semibold disabled:opacity-50">
            {submitting ? 'Оформление...' : 'Подтвердить заказ'}
          </button>
        </form>
      </div>

      <div className="space-y-4">
        <div className="bg-white rounded-lg p-5 shadow">
          <h3 className="font-bold mb-3">Промокод</h3>
          <div className="flex gap-2">
            <input value={promoCode} onChange={(e) => setPromoCode(e.target.value)} placeholder="Введите код" className="flex-1 px-3 py-2 border rounded text-sm" />
            <button onClick={applyPromo} className="bg-dark text-white px-3 py-2 rounded text-sm">Применить</button>
          </div>
          {promoError && <p className="text-red-500 text-xs mt-1">{promoError}</p>}
          {promoDiscount > 0 && <p className="text-green-600 text-xs mt-1">Скидка {promoDiscount}%</p>}
        </div>

        <div className="bg-white rounded-lg p-5 shadow">
          <h3 className="font-bold mb-3">Ваш заказ</h3>
          <ul className="space-y-2 text-sm">
            {cart.items.map((item) => (
              <li key={item.id} className="flex justify-between">
                <span>{item.product.name} ({item.size}) × {item.quantity}</span>
                <span>{Math.round(item.product.final_price * item.quantity)} ₽</span>
              </li>
            ))}
          </ul>
          <div className="border-t mt-3 pt-3 space-y-1">
            {promoDiscount > 0 && (
              <div className="flex justify-between text-sm text-green-600">
                <span>Скидка ({promoDiscount}%)</span>
                <span>-{Math.round(cart.total_amount * promoDiscount / 100)} ₽</span>
              </div>
            )}
            <div className="flex justify-between font-bold text-lg">
              <span>Итого:</span>
              <span>{Math.round(finalTotal)} ₽</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}