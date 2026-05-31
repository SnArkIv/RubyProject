'use client';

import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { useCart } from '@/lib/cart';

export function Navbar() {
  const { user, logout } = useAuth();
  const { itemsCount } = useCart();

  return (
    <header className="bg-[#1a1a1a] text-white">
      <div className="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-2 hover:opacity-90 transition">
          <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="32" height="32" rx="8" fill="#e63946"/>
            <path d="M16 6L10 12H13V20H10L16 26L22 20H19V12H22L16 6Z" fill="white"/>
          </svg>
          <span className="font-bold text-lg tracking-tight">МОДНИЦА</span>
        </Link>
        <nav className="flex items-center gap-6 text-sm">
          <Link href="/catalog" className="text-white/80 hover:text-white transition">Каталог</Link>
          <Link href="/cart" className="text-white/80 hover:text-white transition relative">
            Корзина
            {itemsCount > 0 && (
              <span className="absolute -top-2 -right-5 bg-[#e63946] text-white text-[0.65rem] font-bold min-w-[18px] h-[18px] flex items-center justify-center rounded-full px-1">
                {itemsCount}
              </span>
            )}
          </Link>
          {user ? (
            <>
              <Link href="/profile" className="text-white/80 hover:text-white transition">{user.email}</Link>
              <button onClick={logout} className="text-white/80 hover:text-white transition">Выйти</button>
            </>
          ) : (
            <Link href="/login" className="bg-white text-[#1a1a1a] px-4 py-2 rounded-md font-semibold text-sm hover:bg-white/90 transition">Вход</Link>
          )}
        </nav>
      </div>
    </header>
  );
}
