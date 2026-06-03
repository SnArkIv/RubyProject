'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { useCart } from '@/lib/cart';

export function Navbar() {
  const { user, logout } = useAuth();
  const { itemsCount } = useCart();
  const [menuOpen, setMenuOpen] = useState(false);

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
        <button onClick={() => setMenuOpen(!menuOpen)} className="md:hidden text-white/80 hover:text-white">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            {menuOpen ? (
              <path d="M18 6L6 18M6 6l12 12"/>
            ) : (
              <path d="M3 12h18M3 6h18M3 18h18"/>
            )}
          </svg>
        </button>
        <nav className={`${menuOpen ? 'flex' : 'hidden'} md:flex absolute md:relative top-16 md:top-auto left-0 right-0 bg-[#1a1a1a] md:bg-transparent flex-col md:flex-row items-start md:items-center gap-4 md:gap-6 text-sm p-4 md:p-0 z-50 border-t border-white/10 md:border-0`}>
          <Link href="/catalog" className="text-white/80 hover:text-white transition" onClick={() => setMenuOpen(false)}>Каталог</Link>
          <Link href="/favorites" className="text-white/80 hover:text-white transition" onClick={() => setMenuOpen(false)}>Избранное</Link>
          <Link href="/cart" className="text-white/80 hover:text-white transition relative" onClick={() => setMenuOpen(false)}>
            Корзина
            {itemsCount > 0 && (
              <span className="absolute -top-2 -right-5 bg-[#e63946] text-white text-[0.65rem] font-bold min-w-[18px] h-[18px] flex items-center justify-center rounded-full px-1">
                {itemsCount}
              </span>
            )}
          </Link>
          {user ? (
            <>
              <Link href="/profile" className="text-white/80 hover:text-white transition" onClick={() => setMenuOpen(false)}>{user.email}</Link>
              <button onClick={() => { logout(); setMenuOpen(false); }} className="text-white/80 hover:text-white transition">Выйти</button>
            </>
          ) : (
            <Link href="/login" className="bg-white text-[#1a1a1a] px-4 py-2 rounded-md font-semibold text-sm hover:bg-white/90 transition" onClick={() => setMenuOpen(false)}>Вход</Link>
          )}
        </nav>
      </div>
    </header>
  );
}