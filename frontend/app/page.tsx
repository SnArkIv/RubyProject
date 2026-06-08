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
  price: number;
  final_price: number;
  discount: number;
  in_stock: boolean;
  stock_quantity: number;
  image_url: string | null;
}

export default function HomePage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [saleProducts, setSaleProducts] = useState<Product[]>([]);

  useEffect(() => {
    api.get('/categories').then((data) => setCategories(data.categories));
    api.get('/catalog?sort=discount').then((data) => setSaleProducts(data.products.slice(0, 4)));
  }, []);

  return (
    <div>
      {/* Hero */}
      <section className="relative bg-[#1a1a1a] text-white overflow-hidden">
        <div className="absolute inset-0 opacity-10">
          <svg className="w-full h-full" viewBox="0 0 1200 600" preserveAspectRatio="xMidYMid slice">
            <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
              <path d="M 40 0 L 0 0 0 40" fill="none" stroke="white" strokeWidth="0.5"/>
            </pattern>
            <rect width="100%" height="100%" fill="url(#grid)"/>
          </svg>
        </div>
        <div className="relative max-w-6xl mx-auto px-4 py-20 md:py-28 text-center">
          <div className="inline-flex items-center gap-2 bg-white/10 px-4 py-2 rounded-full text-sm mb-6">
            <span className="w-2 h-2 bg-[#e63946] rounded-full"></span>
            Новая коллекция уже в продаже
          </div>
          <h1 className="text-4xl md:text-6xl font-bold mb-6 leading-tight">
            Одежда, которая<br/>
            <span className="text-[#e63946]">говорит за вас</span>
          </h1>
          <p className="text-lg md:text-xl text-white/70 mb-8 max-w-2xl mx-auto">
            Натуральные ткани, современный крой, честные цены.
          </p>
          <div className="flex flex-wrap items-center justify-center gap-4">
            <Link href="/catalog" className="bg-[#e63946] text-white px-8 py-3 rounded-md font-semibold hover:brightness-110 transition">
              Смотреть каталог
            </Link>
            <a href="#about" className="border border-white/30 text-white px-8 py-3 rounded-md font-semibold hover:bg-white/10 transition">
              О бренде
            </a>
          </div>
        </div>
      </section>

      {/* Features */}
      <section className="py-16 bg-white">
        <div className="max-w-6xl mx-auto px-4 grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="text-center">
            <div className="w-14 h-14 bg-gray-100 rounded-xl flex items-center justify-center mx-auto mb-4 text-2xl">🌿</div>
            <h3 className="font-bold text-lg mb-2">Натуральные ткани</h3>
            <p className="text-gray-500 text-sm">Хлопок, лён, шёлк — только качественные материалы.</p>
          </div>
          <div className="text-center">
            <div className="w-14 h-14 bg-gray-100 rounded-xl flex items-center justify-center mx-auto mb-4 text-2xl">✂️</div>
            <h3 className="font-bold text-lg mb-2">Идеальный крой</h3>
            <p className="text-gray-500 text-sm">Садится идеально с первой примерки.</p>
          </div>
          <div className="text-center">
            <div className="w-14 h-14 bg-gray-100 rounded-xl flex items-center justify-center mx-auto mb-4 text-2xl">🚚</div>
            <h3 className="font-bold text-lg mb-2">Быстрая доставка</h3>
            <p className="text-gray-500 text-sm">2-5 дней по всей России. Бесплатно от 5000 ₽.</p>
          </div>
        </div>
      </section>

      {/* Categories */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-6xl mx-auto px-4">
          <h2 className="text-2xl font-bold mb-8 text-center">Популярные категории</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {categories.map((cat) => {
                const icons: Record<string, string> = {
                  'платья': 'M12 2L8 6v4l-4 4v8h16v-8l-4-4V6l-4-4z',
                  'рубашки': 'M6 2h12l2 6-4 4v10H8V12L4 8l2-6z',
                  'брюки': 'M6 2h12v8l-4 12h-4L6 10V2z',
                  'куртки': 'M4 4h16v6l-2 12H6L4 10V4z',
                  'аксессуары': 'M12 2a4 4 0 00-4 4v2H4v12h16V8h-4V6a4 4 0 00-4-4z',
                  'юбки': 'M8 2h8l4 8H4l4-8zM4 10h16v12H4V10z',
                  'обувь': 'M4 12h16l-2 10H6L4 12z',
                };
                const iconPath = Object.entries(icons).find(([key]) =>
                  cat.name.toLowerCase().includes(key)
                )?.[1] || 'M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5';
                return (
              <Link key={cat.id} href={`/catalog?category_id=${cat.id}`} 
                className="group relative rounded-2xl overflow-hidden transition-all duration-300 block aspect-[4/3] hover:scale-[1.02]"
                style={{
                  backgroundColor: ['#1a1a1a', '#2d1b1b', '#1b2d1b', '#1b1b2d', '#2d2d1b', '#1b2d2d'][cat.id % 6],
                }}>
                <div className="absolute inset-0 bg-gradient-to-br from-white/5 to-transparent"></div>
                <div className="absolute inset-0 opacity-[0.07] flex items-center justify-center p-8">
                  <svg viewBox="0 0 24 24" fill="white" className="w-full h-full">
                    <path d={iconPath}/>
                  </svg>
                </div>
                <div className="absolute inset-0 opacity-[0.04]">
                  <div className="w-full h-full" style={{
                    backgroundImage: `radial-gradient(circle at ${20 + (cat.id * 30) % 60}% ${30 + (cat.id * 20) % 50}%, white 1px, transparent 1px)`,
                    backgroundSize: '30px 30px'
                  }}/>
                </div>
                <div className="relative h-full flex flex-col items-center justify-center text-white p-6">
                  <h3 className="text-2xl font-bold mb-2">{cat.name}</h3>
                  <p className="text-white/70 text-sm">{cat.products_count} товаров</p>
                  <span className="mt-4 inline-flex items-center text-sm font-medium">
                    Смотреть →
                  </span>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* Sale */}
      {saleProducts.length > 0 && (
        <section className="py-16 bg-white">
          <div className="max-w-6xl mx-auto px-4">
            <div className="flex items-center justify-between mb-8">
              <h2 className="text-2xl font-bold">Акции и скидки</h2>
              <Link href="/catalog?sort=discount" className="text-[#e63946] hover:underline font-medium">Все скидки →</Link>
            </div>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {saleProducts.map((product) => (
                <Link key={product.id} href={`/products/${product.id}`} className={`group block ${(!product.in_stock || product.stock_quantity === 0) ? 'opacity-50 grayscale' : ''}`}>
                  <div className="bg-gray-100 rounded-xl overflow-hidden aspect-square mb-3 relative">
                    {product.image_url ? (
                      <img src={product.image_url} alt={product.name} className="w-full h-full object-cover group-hover:scale-105 transition duration-300" />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center text-gray-400 text-sm">Нет фото</div>
                    )}
                    <span className="absolute top-3 left-3 bg-[#e63946] text-white text-xs font-bold px-2 py-1 rounded">-{product.discount}%</span>
                    {product.stock_quantity > 0 && product.stock_quantity < 50 && (
                      <span className="absolute top-3 right-3 bg-orange-600 text-white text-xs font-bold px-2 py-1 rounded">Осталось {product.stock_quantity} шт.</span>
                    )}
                    {(product.stock_quantity === 0 || !product.in_stock) && (
                      <span className="absolute top-3 right-3 bg-red-600 text-white text-xs font-bold px-2 py-1 rounded">Нет в наличии</span>
                    )}
                  </div>
                  <h3 className="text-sm font-medium text-[#1a1a1a] truncate group-hover:text-[#e63946] transition">{product.name}</h3>
                  <div className="flex items-center gap-2 mt-1">
                    <span className="font-bold text-[#1a1a1a]">{Math.round(product.final_price)} ₽</span>
                    <span className="text-xs text-gray-400 line-through">{Math.round(product.price)} ₽</span>
                  </div>
                </Link>
              ))}
            </div>
          </div>
        </section>
      )}

      {/* About */}
      <section id="about" className="py-16 bg-[#1a1a1a] text-white">
        <div className="max-w-6xl mx-auto px-4 grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
          <div>
            <h2 className="text-3xl font-bold mb-4">О бренде Модница</h2>
            <p className="text-white/70 mb-4 leading-relaxed">
              Мы создаём одежду для тех, кто ценит качество и стиль. Каждая вещь проходит тщательный контроль.
            </p>
            <ul className="space-y-2 text-white/70">
              <li className="flex items-center gap-2"><span className="text-[#e63946]">✓</span> Только натуральные ткани</li>
              <li className="flex items-center gap-2"><span className="text-[#e63946]">✓</span> Возврат 14 дней</li>
              <li className="flex items-center gap-2"><span className="text-[#e63946]">✓</span> Собственное производство</li>
            </ul>
          </div>
          <div className="bg-[#252525] rounded-2xl p-8">
            <div className="grid grid-cols-2 gap-6">
              <div className="text-center"><div className="text-3xl font-bold text-[#e63946]">12K+</div><div className="text-white/60 text-sm mt-1">Клиентов</div></div>
              <div className="text-center"><div className="text-3xl font-bold text-[#e63946]">500+</div><div className="text-white/60 text-sm mt-1">Моделей</div></div>
              <div className="text-center"><div className="text-3xl font-bold text-[#e63946]">4.8</div><div className="text-white/60 text-sm mt-1">Рейтинг</div></div>
              <div className="text-center"><div className="text-3xl font-bold text-[#e63946]">2-5</div><div className="text-white/60 text-sm mt-1">Дней доставка</div></div>
            </div>
          </div>
        </div>
      </section>

    </div>
  );
}
