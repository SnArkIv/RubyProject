'use client';

import Link from 'next/link';
import { useAuth } from '@/lib/auth';

export function Navbar() {
  const { user, logout } = useAuth();

  return (
    <header className="bg-dark text-white">
      <div className="max-w-6xl mx-auto px-4 py-3 flex items-center justify-between">
        <Link href="/" className="font-bold text-lg tracking-wide">
          МАГАЗИН
        </Link>
        <nav className="flex items-center gap-4 text-sm">
          <Link href="/catalog" className="hover:underline">Каталог</Link>
          <Link href="/cart" className="hover:underline">Корзина</Link>
          {user ? (
            <>
              <Link href="/profile" className="hover:underline">{user.email}</Link>
              <button onClick={logout} className="hover:underline">Выйти</button>
            </>
          ) : (
            <>
              <Link href="/login" className="hover:underline">Вход</Link>
              <Link href="/register" className="hover:underline">Регистрация</Link>
            </>
          )}
        </nav>
      </div>
    </header>
  );
}
