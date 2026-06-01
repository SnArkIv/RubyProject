'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const { login } = useAuth();
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await login(email, password);
      router.push('/');
    } catch (err: any) {
      setError(err.message || 'Ошибка входа');
    }
  };

  return (
    <div className="min-h-[60vh] flex items-center justify-center px-4">
      <div className="w-full max-w-[400px] p-8 bg-white rounded-2xl shadow-lg">
        <div className="text-center mb-6">
          <svg className="mx-auto mb-3" width="40" height="40" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="32" height="32" rx="8" fill="#e63946"/>
            <path d="M16 6L10 12H13V20H10L16 26L22 20H19V12H22L16 6Z" fill="white"/>
          </svg>
          <h1 className="text-xl font-bold">Вход в аккаунт</h1>
        </div>
        {error && <div className="bg-red-100 text-red-700 px-4 py-2 rounded mb-4 text-sm">{error}</div>}
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-1.5 text-gray-700">Email</label>
            <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} required
              className="w-full px-3 py-2.5 border border-gray-200 rounded-lg bg-gray-50 focus:bg-white focus:border-[#e63946] focus:outline-none transition" />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1.5 text-gray-700">Пароль</label>
            <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} required
              className="w-full px-3 py-2.5 border border-gray-200 rounded-lg bg-gray-50 focus:bg-white focus:border-[#e63946] focus:outline-none transition" />
          </div>
          <button type="submit" className="w-full bg-[#1a1a1a] text-white py-2.5 rounded-lg font-semibold hover:bg-[#333] transition">
            Войти
          </button>
        </form>
        <p className="mt-6 text-center text-sm text-gray-500">
          Нет аккаунта? <Link href="/register" className="text-[#e63946] font-medium hover:underline">Зарегистрироваться</Link>
        </p>
      </div>
    </div>
  );
}
